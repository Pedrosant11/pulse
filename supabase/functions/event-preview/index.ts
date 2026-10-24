// Reads a ticket page for the event form's "Importar de um link".
//
// POST { "url": "https://..." } with the user's access token. Returns what
// the page itself publishes for link previews: its JSON-LD blocks
// (schema.org Event) and meta tags (Open Graph, description). The app maps
// them to the form (lib/features/events/domain/event_import.dart), where
// the person reviews everything before saving.
//
// Fetched here rather than in the app so it works the same everywhere (no
// CORS on web). Only public http(s) addresses are reachable: no IP literals
// from private ranges, no localhost, at most 3 redirects (each checked), 8 s
// and 1.5 MB per page.
import { createClient } from "npm:@supabase/supabase-js@2";

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;

const maxBytes = 1_500_000;
const maxRedirects = 3;

function json(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

function isPrivateIp(host: string): boolean {
  const v4 = host.match(/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/);
  if (v4) {
    const [a, b] = [Number(v4[1]), Number(v4[2])];
    return a === 10 || a === 127 || a === 0 ||
      (a === 169 && b === 254) ||
      (a === 172 && b >= 16 && b <= 31) ||
      (a === 192 && b === 168) ||
      (a === 100 && b >= 64 && b <= 127);
  }
  const v6 = host.replace(/^\[|\]$/g, "").toLowerCase();
  return v6.includes(":") &&
    (v6 === "::1" || v6.startsWith("fc") || v6.startsWith("fd") ||
      v6.startsWith("fe80") || v6.startsWith("::ffff:"));
}

/// Null when the address may be fetched.
async function blockedReason(url: URL): Promise<string | null> {
  if (url.protocol !== "https:" && url.protocol !== "http:") return "scheme";
  const host = url.hostname.toLowerCase();
  if (host === "localhost" || host.endsWith(".localhost") ||
    host.endsWith(".internal") || host.endsWith(".local")) return "host";
  if (isPrivateIp(host)) return "host";
  if (!host.includes(".")) return "host";
  try {
    const records = [
      ...await Deno.resolveDns(host, "A").catch(() => [] as string[]),
      ...await Deno.resolveDns(host, "AAAA").catch(() => [] as string[]),
    ];
    if (records.some(isPrivateIp)) return "host";
  } catch {
    // No DNS API here: the literal checks above still apply.
  }
  return null;
}

async function readCapped(res: Response): Promise<string> {
  const reader = res.body?.getReader();
  if (!reader) return "";
  const chunks: Uint8Array[] = [];
  let size = 0;
  while (size < maxBytes) {
    const { done, value } = await reader.read();
    if (done) break;
    chunks.push(value);
    size += value.length;
  }
  await reader.cancel().catch(() => {});
  const all = new Uint8Array(Math.min(size, maxBytes));
  let offset = 0;
  for (const chunk of chunks) {
    const part = chunk.subarray(0, all.length - offset);
    all.set(part, offset);
    offset += part.length;
    if (offset >= all.length) break;
  }
  return new TextDecoder().decode(all);
}

function extract(html: string) {
  const ldJson: string[] = [];
  for (const m of html.matchAll(
    /<script[^>]*type=["']application\/ld\+json["'][^>]*>([\s\S]*?)<\/script>/gi,
  )) {
    const block = m[1].trim();
    if (block && ldJson.length < 10) ldJson.push(block.slice(0, 200_000));
  }
  const meta: Record<string, string> = {};
  for (const m of html.matchAll(/<meta\s+[^>]*>/gi)) {
    const tag = m[0];
    const key = tag.match(/(?:property|name)\s*=\s*["']([^"']+)["']/i)?.[1]
      ?.toLowerCase();
    const content = tag.match(/content\s*=\s*["']([^"']*)["']/i)?.[1];
    if (key && content !== undefined && !(key in meta) &&
      (key.startsWith("og:") || key.startsWith("twitter:") ||
        key.startsWith("event:") || key === "description")) {
      meta[key] = content.slice(0, 4000);
    }
  }
  const title = html.match(/<title[^>]*>([\s\S]*?)<\/title>/i)?.[1]?.trim();
  return { ldJson, meta, title: title?.slice(0, 300) ?? null };
}

Deno.serve(async (req) => {
  if (req.method !== "POST") return json(405, { error: "method_not_allowed" });

  const token = req.headers.get("Authorization")?.replace(/^Bearer\s+/i, "");
  if (!token) return json(401, { error: "not_signed_in" });
  const client = createClient(supabaseUrl, anonKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data: userData } = await client.auth.getUser(token);
  if (!userData?.user) return json(401, { error: "not_signed_in" });

  let raw: unknown;
  try {
    ({ url: raw } = await req.json());
  } catch {
    return json(400, { error: "invalid_body" });
  }
  let url: URL;
  try {
    url = new URL(String(raw ?? "").trim());
  } catch {
    return json(400, { error: "invalid_url" });
  }

  try {
    for (let hop = 0; hop <= maxRedirects; hop++) {
      if (await blockedReason(url)) return json(400, { error: "invalid_url" });
      const res = await fetch(url, {
        redirect: "manual",
        signal: AbortSignal.timeout(8000),
        headers: {
          "User-Agent":
            "Mozilla/5.0 (compatible; PulseEventPreview/1.0; +https://pulse.app)",
          "Accept": "text/html,application/xhtml+xml",
          "Accept-Language": "pt-BR,pt;q=0.9",
        },
      });
      const location = res.headers.get("location");
      if (res.status >= 300 && res.status < 400 && location) {
        await res.body?.cancel();
        url = new URL(location, url);
        continue;
      }
      if (!res.ok) return json(502, { error: "page_unavailable" });
      const html = await readCapped(res);
      return json(200, { url: url.toString(), ...extract(html) });
    }
    return json(502, { error: "page_unavailable" });
  } catch {
    return json(502, { error: "page_unavailable" });
  }
});
