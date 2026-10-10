// Receives RevenueCat webhooks (purchases, renewals, cancellations,
// expirations, one-off packs) and applies them in the database.
//
// RevenueCat sends `Authorization: <REVENUECAT_WEBHOOK_SECRET>` (the value
// set in its dashboard) and `{ "event": { ... } }`. The rules live in
// `public.apply_store_event` (idempotent by event id); this function only
// checks the secret and forwards the event with the service role.
//
// The app logs in to RevenueCat with the Supabase user id, so
// `event.app_user_id` is the profile id.
import { createClient } from "npm:@supabase/supabase-js@2";

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const webhookSecret = Deno.env.get("REVENUECAT_WEBHOOK_SECRET") ?? "";

function json(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

function sameSecret(a: string, b: string): boolean {
  const left = new TextEncoder().encode(a);
  const right = new TextEncoder().encode(b);
  if (left.length !== right.length) return false;
  let diff = 0;
  for (let i = 0; i < left.length; i++) diff |= left[i] ^ right[i];
  return diff === 0;
}

Deno.serve(async (req) => {
  if (req.method !== "POST") return json(405, { error: "method_not_allowed" });

  const auth = (req.headers.get("Authorization") ?? "")
    .replace(/^Bearer\s+/i, "");
  if (!webhookSecret || !sameSecret(auth, webhookSecret)) {
    return json(401, { error: "unauthorized" });
  }

  let event: unknown;
  try {
    ({ event } = await req.json());
  } catch {
    return json(400, { error: "invalid_body" });
  }
  if (!event || typeof event !== "object") {
    return json(400, { error: "invalid_body" });
  }

  const admin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data, error } = await admin.rpc("apply_store_event", {
    p_event: event,
  });
  if (error) {
    // 500 makes RevenueCat retry later.
    console.error("revenuecat-webhook: apply failed", error);
    return json(500, { error: "apply_failed" });
  }
  console.log("revenuecat-webhook:", data);
  return json(200, { result: data });
});
