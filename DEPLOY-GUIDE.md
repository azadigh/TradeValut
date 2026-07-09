# TradeVault — Deployment Guide

This guide covers deploying the **Cloud Edition** (`worker.js`) to Cloudflare Workers with D1 database and KV namespace.

For the **Local Edition** (`index.html`), no deployment is needed — just open the file in a browser.

---

## Prerequisites

- A free [Cloudflare account](https://dash.cloudflare.com/sign-up)
- The `worker.js` file

---

## Step 1: Create a Worker

1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com) → **Workers & Pages**
2. Click **Create application** → **Create Worker**
3. Give it a name (e.g., `tradevault`)
4. Click **Deploy**
5. Click **Edit code**
6. Delete the default code
7. Open `worker.js` in a text editor, copy the entire contents
8. Paste it into the Worker editor
9. Click **Save and Deploy**

Your Worker is now live at `https://tradevault.<your-subdomain>.workers.dev`, but it won't work yet — we need to add the database and environment variables.

---

## Step 2: Create a D1 Database

1. Go to **Dashboard** → **Workers & Pages** → **D1** (in the left sidebar)
2. Click **Create database**
3. Name it `tradevault-db`
4. Click **Create**
5. Note the database ID — you'll need it in Step 4

The database will be empty. The Worker auto-creates all tables on the first request (no manual SQL needed).

---

## Step 3: Create a KV Namespace

1. Go to **Dashboard** → **Workers & Pages** → **KV** (in the left sidebar)
2. Click **Create a namespace**
3. Name it `tradevault-sessions`
4. Click **Add**
5. Note the namespace ID — you'll need it in Step 4

This KV namespace stores login sessions (token → user mapping with 30-day TTL).

---

## Step 4: Bind D1 and KV to Your Worker

1. Go back to your Worker → **Settings** tab
2. Under **Bindings**, click **Add binding**

### Add D1 binding:
- Type: **D1 database**
- Variable name: `DB` (must be exactly `DB`)
- D1 database: select `tradevault-db`
- Click **Save**

### Add KV binding:
- Type: **KV namespace**
- Variable name: `SESSIONS` (must be exactly `SESSIONS`)
- KV namespace: select `tradevault-sessions`
- Click **Save**

---

## Step 5: Add Environment Variables

1. In your Worker → **Settings** → **Variables**
2. Add the following variables:

### Required variables:

| Variable | Value | Type | Description |
|---|---|---|---|
| `PASSWORD` | `your-secret-password` | Text | The password users enter to log in |

### Optional variables:

| Variable | Value | Type | Description |
|---|---|---|---|
| `JWT_SECRET` | `any-random-string` | Text | Salt for token generation (optional, defaults to built-in) |
| `ALLOWED_ORIGIN` | `https://tradevault.your-subdomain.workers.dev` | Text | Restrict CORS to your domain. If unset, echoes request Origin (fine for development) |

3. For `PASSWORD`, choose a strong password. This is the only auth mechanism — anyone with the password can access all data.
4. Click **Save and Deploy**

---

## Step 6: Verify Deployment

1. Open your Worker URL in a browser: `https://tradevault.<your-subdomain>.workers.dev`
2. You should see the login screen
3. Enter your password → click **Login**
4. You should see the dashboard with the chart and trade form
5. The schema auto-initializes on the first request (creates all tables + a default "Main Account")

### If you see an error:

- **"Server error: PASSWORD env variable not set"** → You forgot Step 5
- **"D1 is not bound"** → You forgot Step 4 (D1 binding must be named `DB`)
- **"SESSIONS is not bound"** → You forgot Step 4 (KV binding must be named `SESSIONS`)
- **Blank page** → Check the Worker logs in Dashboard → Workers → your-worker → **Logs**

---

## Step 7: Add a Custom Domain (Optional)

1. Go to your Worker → **Triggers** → **Custom Domains**
2. Click **Add Custom Domain**
3. Enter your domain (e.g., `vault.yourdomain.com`)
4. Cloudflare will automatically configure DNS
5. Update `ALLOWED_ORIGIN` env var to match your custom domain

---

## Schema Auto-Initialization

The Worker creates all database tables automatically on the first request. You do **not** need to run any SQL manually.

Tables created:
- `accounts` — trading accounts
- `trades` — trade journal entries (35 columns)
- `strategies` — trading strategies
- `setups` — trade opportunities
- `custom_fields` — user-defined fields per account
- `watchlist` — watched symbols per account
- `review_notes` — weekly/monthly review notes
- `prop_firms` — prop firm challenge tracking
- `user_settings` — per-account key-value settings

Indexes created:
- `idx_trades_account` on `trades(account_id)`
- `idx_trades_timestamp` on `trades(timestamp)`

A default account named "Main Account" is created automatically if the table is empty.

---

## Optional Migrations (for older databases)

If you deployed an older version of the Worker and are upgrading, the Worker automatically runs optional `ALTER TABLE` migrations on startup to add new columns:

```sql
ALTER TABLE trades ADD COLUMN propfirm_id TEXT DEFAULT '';
ALTER TABLE trades ADD COLUMN tp1 REAL DEFAULT 0;
ALTER TABLE trades ADD COLUMN tp2 REAL DEFAULT 0;
ALTER TABLE trades ADD COLUMN tp3 REAL DEFAULT 0;
ALTER TABLE trades ADD COLUMN tp1_hit INTEGER DEFAULT 0;
ALTER TABLE trades ADD COLUMN tp2_hit INTEGER DEFAULT 0;
ALTER TABLE trades ADD COLUMN tp3_hit INTEGER DEFAULT 0;
```

"Duplicate column name" errors are silently ignored (the column already exists). No action needed.

---

## Backup & Restore

### Create a backup

1. Open your deployed app
2. Click **Backup** (top-right toolbar or Settings page)
3. A JSON file downloads with all your data

### Restore a backup

1. Open your deployed app
2. Click **Restore**
3. Select your backup JSON file
4. Confirm — this **wipes all current data** and replaces it with the backup
5. The page reloads with restored data

### Migrating from old format

If you have a backup from before v4.7 (old image URL format, separate MTF fields):

```bash
python3 scripts/migrate_backup.py old-backup.json new-backup.json
```

Then restore the `new-backup.json` file.

---

## Updating the Worker

To update to a new version:

1. Go to your Worker → **Edit code**
2. Delete all existing code
3. Paste the new `worker.js` contents
4. Click **Save and Deploy**

Your data is safe — D1 and KV data persist across code updates. The schema auto-migrates any new columns.

---

## Free Tier Limits

Cloudflare's free tier is generous:

| Resource | Free Tier Limit | TradeVault Usage |
|---|---|---|
| Worker requests | 100,000/day | Each page load = 1 request + API calls |
| D1 reads | 5,000,000/day | Each trade list = 1 read |
| D1 writes | 100,000/day | Each trade create/update = 1 write |
| KV reads | 100,000/day | Each API call = 1 session check |
| KV writes | 1,000/day | Each login = 1 write, each TTL refresh = 1 write |
| D1 storage | 5 GB | 10,000 trades ≈ 5-10 MB |

**Note:** KV TTL refresh on every request can consume writes. If you hit the 1,000/day KV write limit, consider commenting out the TTL refresh in `getSession()` (the session will still work, just expire after 30 days instead of auto-renewing).

---

## Troubleshooting

### "Unauthorized" on every request after login

The KV namespace is not bound or named incorrectly. Verify:
- Binding type: KV namespace
- Variable name: `SESSIONS` (case-sensitive)

### "D1 error: no such table"

The schema hasn't initialized. The schema runs on the first request after the Worker deploys. Try:
1. Open the Worker URL in a new incognito window
2. If still failing, go to Dashboard → D1 → your database → **Console** and run:
   ```sql
   SELECT name FROM sqlite_master WHERE type='table';
   ```
   If no tables appear, the schema init failed — check Worker logs.

### CORS errors in browser console

Set `ALLOWED_ORIGIN` to your exact domain (including `https://`). If using a custom domain, update this variable.

### Trades can't be edited after 48 hours

This is intentional — the 48-hour trade lock is enforced server-side. Trades older than 48 hours return HTTP 403 on PUT/DELETE. This prevents accidental modification of historical records.

### Login rate limit

After 10 failed login attempts from the same IP, you'll get HTTP 429 for 5 minutes. Wait 5 minutes and try again, or clear the `rl:login:<ip>` key in KV.

---

## Local Edition (No Deployment Needed)

If you don't want to deploy to Cloudflare:

1. Download `index.html`
2. Open it in any modern browser
3. Start using it immediately

All data saves to `localStorage` under `tv_*` keys. No backend, no auth, no network required (except for the optional economic calendar fetch and TradingView chart widget).

You can migrate to the Cloud edition later by creating a backup from the local edition and restoring it in the cloud app.
