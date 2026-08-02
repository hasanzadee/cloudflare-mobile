# OAuth callback bridge

Cloudflare's OAuth client form requires an `https://` redirect URL and rejects
custom schemes like `io.cfmgr.app://oauth/callback`. A phone app has no https
origin of its own, so something has to sit in between.

This Worker is that something. It costs nothing, needs no domain and no server —
the free `*.workers.dev` subdomain is enough.

## Deploy from the dashboard, no CLI

1. Cloudflare dashboard → **Workers & Pages** → **Create** → **Start with Hello
   World** → **Deploy**.
2. Open the new Worker → **Edit code**, paste `worker.js`, **Deploy** again.
3. Note the URL, e.g. `https://cfmgr-oauth.yourname.workers.dev`.
4. In the OAuth client form, set **Redirect (Callback) URLs** to:

   ```
   https://cfmgr-oauth.yourname.workers.dev/oauth/callback
   ```

That is the whole setup.

## What it does

Cloudflare sends the browser to `/oauth/callback?code=…&state=…`. The Worker
returns a page that immediately redirects to `io.cfmgr.app://oauth/callback`
with the same parameters, and Android hands that to the app — the custom-scheme
intent filter is already in the manifest and needs no verification.

The authorization code passes through this page. That is safe because the app
uses PKCE: without the `code_verifier`, which never leaves the phone, the code
cannot be exchanged for anything. The page sets `no-store`, `no-referrer`, and
keeps nothing.

## Later: skipping the bounce

Once a release keystore exists, put its SHA-256 fingerprint into `ASSET_LINKS`
in `worker.js` and rebuild the app with:

```bash
flutter build apk -Poauth-host=cfmgr-oauth.yourname.workers.dev
```

Android will then verify the App Link and open the app directly, without showing
this page at all. The bounce keeps working as the fallback either way.

Get the fingerprint with:

```bash
keytool -list -v -keystore release.jks -alias upload
```

## Making the client usable by other people

A **private** OAuth client works immediately for members of the account that
created it — that is all you need for your own phone.

Turning it **public**, so anyone who installs the APK can sign in with their own
Cloudflare account, requires Cloudflare to verify ownership of the Client URL
domain. `workers.dev` is Cloudflare's domain, not yours, so that step will need
a real domain eventually — roughly $10/year. Until then the app also lets a user
paste their own client ID in Settings.
