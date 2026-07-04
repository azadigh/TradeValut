# TradeVault — Cloudflare Dashboard Deployment Guide

## Step-by-Step: Deploy via Cloudflare Dashboard (no wrangler needed)

### Step 1: Create D1 Database
1. Go to: https://dash.cloudflare.com
2. Left menu → **Workers & Pages** → **D1**
3. Click **Create database**
4. Name: `tradevault-db`
5. Click **Create**
6. Note the **Database ID** (you'll need it later)

### Step 2: Create KV Namespace
1. Left menu → **Workers & Pages** → **KV**
2. Click **Create namespace**
3. Name: `SESSIONS`
4. Click **Add**
5. Note the **Namespace ID** (you'll need it later)

### Step 3: Create Worker
1. Left menu → **Workers & Pages**
2. Click **Create application** → **Create Worker**
3. Name: `tradevault`
4. Click **Deploy** (creates a placeholder)
5. Click **Edit code** (pencil icon)

### Step 4: Paste Worker Code
1. Delete everything in the editor
2. Open the file `trading-dashboard-worker.js`
3. Copy ALL contents (Ctrl+A, Ctrl+C)
4. Paste into the Cloudflare editor (Ctrl+A, Ctrl+V)
5. Click **Save and deploy**

### Step 5: Add Environment Variable (PASSWORD)
1. Go to your worker → **Settings** → **Variables**
2. Click **Add variable**
3. Variable name: `PASSWORD`
4. Value: `your-secret-password` (choose your password)
5. Type: **Plaintext**
6. Click **Save and deploy**

### Step 6: Bind D1 Database
1. Go to your worker → **Settings** → **Bindings**
2. Click **Add binding** → **D1 database**
3. Variable name: `DB`
4. Select database: `tradevault-db`
5. Click **Save and deploy**

### Step 7: Bind KV Namespace
1. Still in **Settings** → **Bindings**
2. Click **Add binding** → **KV namespace**
3. Variable name: `SESSIONS`
4. Select namespace: `SESSIONS`
5. Click **Save and deploy**

### Step 8: Test
1. Go to your worker URL: `https://tradevault.<your-subdomain>.workers.dev`
2. You should see the TradeVault login screen
3. Enter the password you set in Step 5
4. Click **Login**
5. You should see the dashboard with chart

### Step 9: Add Your First Trade
1. Click **Journal** (sidebar icon)
2. Fill the trade form (Symbol, Entry, Exit, etc.)
3. Click **Add to Journal**
4. The trade should appear in the list

### Step 10: Add a Strategy
1. Click **Strategies** (star icon in sidebar)
2. Fill name, checklist, notes
3. Click **Save Strategy**

---

## Troubleshooting

### "Invalid password" error
- Check that the `PASSWORD` variable is set in **Settings → Variables**
- Make sure the variable name is exactly `PASSWORD` (uppercase)
- Make sure you **Save and deploy** after adding the variable

### "Server error: PASSWORD env variable not set"
- The `PASSWORD` environment variable is missing or not deployed
- Go to Settings → Variables, add it, then **Save and deploy**

### "Unauthorized" error after login
- The KV namespace `SESSIONS` is not bound
- Go to Settings → Bindings, add KV binding with name `SESSIONS`

### "Create trade failed" error
- The D1 database `DB` is not bound
- Go to Settings → Bindings, add D1 binding with name `DB`
- The schema auto-creates on first request — if it fails, check D1 dashboard

### Nothing loads (blank page)
- Check browser console (F12) for errors
- Make sure you copied the ENTIRE `worker.js` file (it's ~288KB)
- The file contains base64-encoded HTML — if truncated, nothing will load

### Can save watchlist but not trades
- This was a bug where old localStorage functions shadowed the API functions
- Make sure you're using the latest `worker.js` file
- Re-paste the code and redeploy

---

## Required Bindings Summary

| Binding | Type | Name | Resource |
|---------|------|------|----------|
| 1 | D1 Database | `DB` | `tradevault-db` |
| 2 | KV Namespace | `SESSIONS` | `SESSIONS` |
| 3 | Env Variable | `PASSWORD` | `your-password` |

That's it — 3 bindings, 1 file paste, done.
