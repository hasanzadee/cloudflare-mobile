/**
 * OAuth callback bridge for Cloudflare Mobile.
 *
 * Cloudflare's OAuth client form rejects custom-scheme redirect URLs and
 * requires https, but a phone app cannot own an https origin. This Worker is
 * the missing hop: Cloudflare redirects here, and this page immediately bounces
 * to the app's private scheme.
 *
 * Deploy it on the free *.workers.dev subdomain — no domain and no server
 * needed. Register the redirect URL as:
 *
 *     https://<worker-name>.<your-subdomain>.workers.dev/oauth/callback
 *
 * Security note: the authorization code does briefly pass through this page.
 * That is safe here because the app uses PKCE — the code cannot be exchanged
 * for a token without the code_verifier, which never leaves the device. The
 * page also sends no referrer and stores nothing.
 */

const APP_SCHEME = 'io.cfmgr.app://oauth/callback';

// Filled in once a release keystore exists; until then the file is served with
// an empty list, which simply means Android does not auto-verify the link and
// the bounce page below does the work instead.
const ASSET_LINKS = [
  {
    relation: ['delegate_permission/common.handle_all_urls'],
    target: {
      namespace: 'android_app',
      package_name: 'io.cfmgr.app',
      sha256_cert_fingerprints: [],
    },
  },
];

export default {
  async fetch(request) {
    const url = new URL(request.url);

    // Android App Links verification looks for exactly this path.
    if (url.pathname === '/.well-known/assetlinks.json') {
      return new Response(JSON.stringify(ASSET_LINKS, null, 2), {
        headers: {
          'content-type': 'application/json',
          'cache-control': 'public, max-age=300',
        },
      });
    }

    if (url.pathname !== '/oauth/callback') {
      return new Response('Not found', { status: 404 });
    }

    // Pass every parameter through untouched: code, state, and any error
    // Cloudflare reports. The app validates state, not this page.
    const target = `${APP_SCHEME}?${url.searchParams.toString()}`;

    const html = `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="referrer" content="no-referrer">
<title>Returning to Cloudflare Mobile…</title>
<style>
  body { font-family: system-ui, sans-serif; display: grid; place-items: center;
         min-height: 100vh; margin: 0; background: #111; color: #eee; }
  main { text-align: center; padding: 2rem; }
  a { color: #f6821f; }
</style>
</head>
<body>
<main>
  <p>Returning to the app…</p>
  <p><a id="fallback" href="${escapeHtml(target)}">Tap here if nothing happens</a></p>
</main>
<script>
  // replace() so the browser back button does not land on this page again.
  location.replace(document.getElementById('fallback').href);
</script>
</body>
</html>`;

    return new Response(html, {
      headers: {
        'content-type': 'text/html; charset=utf-8',
        // The response embeds a one-time code; never let anything cache it.
        'cache-control': 'no-store',
        'referrer-policy': 'no-referrer',
      },
    });
  },
};

function escapeHtml(value) {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}
