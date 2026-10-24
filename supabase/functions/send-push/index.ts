// Delivers push notifications through Firebase Cloud Messaging (HTTP v1).
//
// Called only by the database (`private.send_push`, through pg_net) with
// `Authorization: Bearer <PUSH_WEBHOOK_SECRET>` and
// `{ "kind": "...", "recipients": ["<uuid>"], "data": { "route": "..." } }`.
// 1. Looks up the recipients' device tokens.
// 2. Sends a generic pt-BR text per kind: no names or message content, so
//    nothing personal shows on the lock screen or passes through Google.
// 3. Removes tokens FCM reports as gone (app uninstalled, data cleared).
//
// Secrets: PUSH_WEBHOOK_SECRET and FCM_SERVICE_ACCOUNT (the service account
// JSON from Firebase → Project settings → Service accounts).
import { createClient } from "npm:@supabase/supabase-js@2";

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const webhookSecret = Deno.env.get("PUSH_WEBHOOK_SECRET") ?? "";
const serviceAccount = parseServiceAccount(Deno.env.get("FCM_SERVICE_ACCOUNT"));

interface ServiceAccount {
  project_id: string;
  client_email: string;
  private_key: string;
}

interface PushText {
  channel: "matches" | "messages" | "crews" | "account" | "events";
  title: string;
  body: string;
}

// Interface texts in pt-BR. Kept here because the phone shows them while the
// app is closed (the Flutter ARB files are not reachable).
function textFor(kind: string, data: Record<string, unknown>): PushText | null {
  switch (kind) {
    case "match":
      return data.mode === "crew"
        ? {
          channel: "matches",
          title: "Deu match de crew! 🤝",
          body: "Tem gente nova pra colar com você no rolê.",
        }
        : {
          channel: "matches",
          title: "Deu match! 💜",
          body: "Alguém curtiu você de volta. Vem ver quem é.",
        };
    case "message":
      return {
        channel: "messages",
        title: "Nova mensagem",
        body: "Você recebeu uma mensagem. Toque para responder.",
      };
    case "crew_message":
      return {
        channel: "messages",
        title: "Nova mensagem na crew",
        body: "Sua crew está conversando. Toque para ver.",
      };
    case "crew_invite":
      return {
        channel: "crews",
        title: "Convite para uma crew",
        body: "Te chamaram para uma crew. Toque para responder.",
      };
    case "crew_request":
      return {
        channel: "crews",
        title: "Pedido para entrar na sua crew",
        body: "Alguém quer entrar na sua crew. Toque para responder.",
      };
    case "crew_request_accepted":
      return {
        channel: "crews",
        title: "Você está na crew! 🎉",
        body: "Seu pedido foi aceito. Toque para ver a crew.",
      };
    case "crew_invite_accepted":
      return {
        channel: "crews",
        title: "Convite aceito 🎉",
        body: "Alguém entrou na sua crew pelo seu convite.",
      };
    case "trial_started":
      return {
        channel: "account",
        title: "3 dias de Pulse Black por nossa conta 🎉",
        body: "Veja quem curtiu você, use o boost e o modo viagem. Sem cobrança.",
      };
    // Event names and DJs are public (listed in the app for everyone).
    case "event_dj":
      return {
        channel: "events",
        title: `${data.dj ?? "Um DJ que você curte"} vai tocar perto de você 🎧`,
        body: `${data.event ?? "Festa nova"}. Marque presença e veja quem vai.`,
      };
    case "after_party":
      return {
        channel: "events",
        title: `Você foi na ${data.event ?? "festa"}? 👀`,
        body: "Veja quem estava lá e dê match antes que acabe (48 h).",
      };
    case "checkin_reminder":
      return {
        channel: "events",
        title: `Chegou na ${data.event ?? "festa"}? 📍`,
        body: "Faça o check-in para a festa contar nas suas conquistas.",
      };
    case "venue_new":
      return {
        channel: "events",
        title: `Festa nova ${data.venue ? `na ${data.venue}` : "numa casa que você segue"} 📍`,
        body: `${data.event ?? "Tem festa nova"}. Marque presença e veja quem vai.`,
      };
    case "event_new":
      return {
        channel: "events",
        title: "Festa nova do seu estilo 🔊",
        body: `${data.event ?? "Tem festa nova"}${data.city ? ` em ${data.city}` : ""}. Veja quem vai.`,
      };
    case "event_reminder": {
      const liked = Number(data.liked ?? 0);
      return {
        channel: "events",
        title: `Tá chegando: ${data.event ?? "sua festa"} 🎉`,
        body: liked > 0
          ? `${liked} ${liked === 1 ? "pessoa que você curtiu vai" : "pessoas que você curtiu vão"}. Bora combinar?`
          : "Veja quem vai e combine o rolê com sua crew.",
      };
    }
    case "featured_on":
      return {
        channel: "account",
        title: "Sua festa está em destaque 🚀",
        body: "Ela já aparece no topo de Próximos para quem está na região.",
      };
    case "referral_reward":
      return {
        channel: "account",
        title: "Sua indicação deu match 🎉",
        body: "Seus superlikes e o boost de presente já estão na carteira.",
      };
    case "verification_approved":
      return {
        channel: "account",
        title: "Perfil verificado ✅",
        body: "Seu selo de verificado já aparece para todo mundo.",
      };
    case "verification_rejected":
      return {
        channel: "account",
        title: "Verificação não aprovada",
        body: "Veja o motivo e tente de novo com uma nova selfie.",
      };
    default:
      return null;
  }
}

function json(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

function parseServiceAccount(raw: string | undefined): ServiceAccount | null {
  if (!raw) return null;
  try {
    const parsed = JSON.parse(raw);
    return parsed.project_id && parsed.client_email && parsed.private_key
      ? parsed
      : null;
  } catch {
    return null;
  }
}

function sameSecret(a: string, b: string): boolean {
  const left = new TextEncoder().encode(a);
  const right = new TextEncoder().encode(b);
  if (left.length !== right.length) return false;
  let diff = 0;
  for (let i = 0; i < left.length; i++) diff |= left[i] ^ right[i];
  return diff === 0;
}

function base64url(bytes: Uint8Array | string): string {
  const raw = typeof bytes === "string" ? bytes : String.fromCharCode(...bytes);
  return btoa(raw).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

// OAuth token for FCM, signed with the service account key and reused until
// a minute before it expires.
let cachedToken: { value: string; expiresAt: number } | null = null;

async function accessToken(account: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  if (cachedToken && cachedToken.expiresAt - 60 > now) return cachedToken.value;

  const header = base64url(JSON.stringify({ alg: "RS256", typ: "JWT" }));
  const claims = base64url(JSON.stringify({
    iss: account.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  }));
  const pem = account.private_key
    .replace(/-----(BEGIN|END) PRIVATE KEY-----/g, "")
    .replace(/\s+/g, "");
  const der = Uint8Array.from(atob(pem), (c) => c.charCodeAt(0));
  const key = await crypto.subtle.importKey(
    "pkcs8",
    der,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const signature = new Uint8Array(
    await crypto.subtle.sign(
      "RSASSA-PKCS1-v1_5",
      key,
      new TextEncoder().encode(`${header}.${claims}`),
    ),
  );

  const response = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: `${header}.${claims}.${base64url(signature)}`,
    }),
  });
  if (!response.ok) {
    throw new Error(`oauth ${response.status}: ${await response.text()}`);
  }
  const { access_token, expires_in } = await response.json();
  cachedToken = { value: access_token, expiresAt: now + Number(expires_in) };
  return access_token;
}

// FCM answers these when the token no longer reaches an installed app.
function isStaleToken(status: number, body: string): boolean {
  return status === 404 ||
    body.includes("UNREGISTERED") ||
    body.includes("SENDER_ID_MISMATCH");
}

Deno.serve(async (req) => {
  if (req.method !== "POST") return json(405, { error: "method_not_allowed" });

  const auth = req.headers.get("Authorization")?.replace(/^Bearer\s+/i, "") ?? "";
  if (!webhookSecret || !sameSecret(auth, webhookSecret)) {
    return json(401, { error: "unauthorized" });
  }
  if (!serviceAccount) {
    console.error("send-push: FCM_SERVICE_ACCOUNT is missing or invalid");
    return json(500, { error: "not_configured" });
  }

  let kind: unknown, recipients: unknown, data: unknown;
  try {
    ({ kind, recipients, data } = await req.json());
  } catch {
    return json(400, { error: "invalid_body" });
  }
  const payload = (data && typeof data === "object" ? data : {}) as Record<
    string,
    unknown
  >;
  const text = typeof kind === "string" ? textFor(kind, payload) : null;
  if (!text || !Array.isArray(recipients) || recipients.length === 0) {
    return json(400, { error: "invalid_body" });
  }

  const admin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data: rows, error } = await admin
    .from("push_tokens")
    .select("token, platform")
    .in("user_id", recipients);
  if (error) {
    console.error("send-push: token lookup failed", error);
    return json(500, { error: "lookup_failed" });
  }
  if (!rows?.length) return json(200, { sent: 0 });

  // FCM data values must be strings.
  const fcmData: Record<string, string> = { kind: kind as string };
  for (const [key, value] of Object.entries(payload)) {
    if (value !== null && value !== undefined) fcmData[key] = String(value);
  }
  // One notification per conversation (or per kind) replaces the previous.
  const tag = fcmData.conversation_id ?? fcmData.crew_id ?? (kind as string);

  const token = await accessToken(serviceAccount);
  const endpoint =
    `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`;

  const stale: string[] = [];
  let sent = 0;
  await Promise.all(rows.map(async (row) => {
    const response = await fetch(endpoint, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        message: {
          token: row.token,
          notification: { title: text.title, body: text.body },
          data: fcmData,
          android: {
            priority: "HIGH",
            notification: { channel_id: text.channel, tag },
          },
          apns: { payload: { aps: { sound: "default", "thread-id": tag } } },
        },
      }),
    });
    if (response.ok) {
      sent++;
      return;
    }
    const body = await response.text();
    if (isStaleToken(response.status, body)) {
      stale.push(row.token);
    } else {
      console.error("send-push: FCM error", response.status, body);
    }
  }));

  if (stale.length > 0) {
    await admin.from("push_tokens").delete().in("token", stale);
  }
  return json(200, { sent, removed: stale.length });
});
