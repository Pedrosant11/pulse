// Deletes the caller's account (SPEC 5.2, required by the stores).
//
// POST with the user's access token and `{ "password": "..." }`.
// 1. Identifies the caller from the token and re-checks the password.
// 2. Removes the caller's files from Storage (profile photos, a pending
//    verification selfie and covers of
//    their unpublished suggestions); SQL can't delete Storage objects.
// 3. Deletes the Auth user. The database cascade removes the rest; the
//    `profiles_before_delete` trigger hands owned crews to a member first.
import { createClient } from "npm:@supabase/supabase-js@2";

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const clientOptions = {
  auth: { persistSession: false, autoRefreshToken: false },
};

function json(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

async function listAll(
  admin: ReturnType<typeof createClient>,
  bucket: string,
  folder: string,
): Promise<string[]> {
  const { data, error } = await admin.storage.from(bucket).list(folder, {
    limit: 1000,
  });
  if (error) throw error;
  return (data ?? []).map((file) => `${folder}/${file.name}`);
}

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return json(405, { error: "method_not_allowed" });
  }

  const token = req.headers.get("Authorization")?.replace(/^Bearer\s+/i, "");
  if (!token) return json(401, { error: "not_signed_in" });

  const admin = createClient(supabaseUrl, serviceRoleKey, clientOptions);
  const { data: userData, error: userError } = await admin.auth.getUser(token);
  const user = userData?.user;
  if (userError || !user?.email) return json(401, { error: "not_signed_in" });

  let password: unknown;
  try {
    ({ password } = await req.json());
  } catch {
    return json(400, { error: "invalid_body" });
  }
  if (typeof password !== "string" || password.length === 0) {
    return json(400, { error: "invalid_body" });
  }

  // Re-authentication: a stolen session alone can't delete the account.
  const anon = createClient(supabaseUrl, anonKey, clientOptions);
  const { error: signInError } = await anon.auth.signInWithPassword({
    email: user.email,
    password,
  });
  if (signInError) {
    const status = signInError.status === 429 ? 429 : 403;
    return json(status, {
      error: status === 429 ? "rate_limited" : "invalid_password",
    });
  }

  try {
    const paths = await listAll(admin, "profile-photos", user.id);
    if (paths.length > 0) {
      const { error } = await admin.storage.from("profile-photos").remove(paths);
      if (error) throw error;
    }

    // A selfie still waiting for review (reviewed ones are already gone).
    const selfies = await listAll(admin, "verification-selfies", user.id);
    if (selfies.length > 0) {
      const { error } = await admin.storage
        .from("verification-selfies")
        .remove(selfies);
      if (error) throw error;
    }

    // Covers of suggestions that only this person could see; the database
    // deletes those events with the profile.
    const { data: events, error: eventsError } = await admin
      .from("events")
      .select("id")
      .eq("created_by", user.id)
      .in("status", ["pending", "rejected"]);
    if (eventsError) throw eventsError;
    for (const event of events ?? []) {
      const covers = await listAll(admin, "event-covers", event.id);
      if (covers.length > 0) {
        const { error } = await admin.storage.from("event-covers").remove(covers);
        if (error) throw error;
      }
    }

    const { error: deleteError } = await admin.auth.admin.deleteUser(user.id);
    if (deleteError) throw deleteError;
  } catch (error) {
    console.error("delete-account failed", user.id, error);
    return json(500, { error: "delete_failed" });
  }

  return json(200, { deleted: true });
});
