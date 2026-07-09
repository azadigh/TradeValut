<div align="center">

# 📊 TradeVault

### Your Trading Edge, Quantified

**A professional trading journal with P&L tracking, strategy analytics, equity curve, calendar heatmap, TradingView chart integration, and prop firm challenge tracking.**

[![Cloudflare Workers](https://img.shields.io/badge/Cloudflare-Workers-F38020?logo=cloudflare&logoColor=white)](https://workers.cloudflare.com/)
[![D1 Database](https://img.shields.io/badge/D1-Database-0052CC?logo=cloudflare&logoColor=white)](https://developers.cloudflare.com/d1/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
<br>
**[فارسی](README_FA.md) | [English](README.md)**
</div>

---

Available in two editions:
- **Cloud** (`worker.js`) — Cloudflare Worker + D1 + KV, multi-device sync
- **Local** (`local.html`) — standalone HTML, browser localStorage, zero setup

---

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Two Editions](#two-editions)
- [Architecture](#architecture)
- [Data Model](#data-model)
- [API Reference](#api-reference)
- [Security](#security)
- [Testing](#testing)
- [Backup & Restore](#backup--restore)
- [Files](#files)

---

## Features

### Trade Journal
- Log trades with symbol, direction (long/short), entry, exit, SL, TP, size
- Auto-calculate P&L and R-multiple based on instrument type (forex, crypto, metals, indices)
- Entry time & session picker (defaults to current time, auto-detects session)
- Partial profits tracking (TP1, TP2, TP3 with hit checkboxes)
- MAE/MFE (Maximum Adverse/Favorable Excursion)
- Trade rating (1-5 stars)
- Tags system (add custom tags, filter by tag)
- Custom fields (define your own fields per account)
- Up to 4 images per trade, each with a note (TradingView snapshots, MQL5 charts, or any URL)
- 48-hour trade lock (server-side enforced — trades become read-only after 48h)

### Analytics
- Equity curve (SVG, green above starting balance, red below)
- Calendar heatmap (daily P&L visualization)
- Win rate, profit factor, Sharpe ratio, expectancy, payoff ratio
- Max drawdown calculation
- Consecutive win/loss streaks
- Monthly P&L bar chart
- Weekday performance analysis
- Symbol breakdown table
- Best/worst trade tracking

### Prop Firm Tracker
- Track FTMO, FundedNext, and other prop firm challenges
- 1-step, 2-step, and funded account types
- Daily loss limit and overall loss limit tracking
- Step target progress bar
- Auto-detect step 1 pass
- **MT5-style report modal** with:
  - Equity curve (starting from balance, green/red split)
  - 12 performance stat cards (P&L, profit factor, win rate, Sharpe, drawdown, etc.)
  - Account status (balance, growth, consecutive streaks, loss limits used)
  - Monthly P&L chart
  - Weekday performance chart + table
  - Symbol breakdown table
  - Trade history table (sticky header, scrollable)

### Strategy Management
- Create strategies with checklist, notes, and video URL
- Link trades to strategies via dropdown
- Strategy analytics (win rate, P&L per strategy)

### Opportunities (Setups)
- Log potential trade setups with symbol, note, and chart image
- Tag as long/short
- Slideshow lightbox for chart images

### Chart Integration
- TradingView Advanced Chart widget (15min default interval)
- RSI study included
- Watchlist sidebar synced with your watchlist
- Symbol auto-resolution (OANDA, BINANCE, TVC, INDEX prefixes)
- Dark/light theme synced

### Economic Calendar
- Server-side proxy fetches weekly economic calendar CSV
- Fallback: manual CSV upload (with BOM stripping)
- Filter by impact level (High, Medium, Low, All)
- Timezone conversion (EST, GMT, local)

### Watchlist
- Add/remove symbols
- Category presets (Forex majors, Crypto, Indices, Metals, etc.)
- Reorderable via drag-and-drop
- Synced with TradingView chart sidebar

### Review Notes
- Weekly and monthly auto-summary cards
- Editable reflection notes per period
- Persists per account

### Backup & Restore
- Full backup (all accounts, all data) to JSON file
- Restore from JSON (wipes current data, inserts backup)
- Cross-edition compatible (cloud backup → local, and vice versa)
- IDs preserved across backup/restore cycles
- Sample backup included (`sample-backup.json`)

---

## Quick Start

### Option 1: Local Edition (zero setup)

1. Download `index.html`
2. Open it in any modern browser
3. Start logging trades — all data saves to browser localStorage

No backend, no signup, no network required. Data stays in your browser.

### Option 2: Cloud Edition (multi-device)

1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com) → Workers & Pages
2. Create a new Worker
3. Paste the contents of `TradeVault-worker.js`
4. Add environment variables (see [Deploy Guide](DEPLOY_GUIDE.md))
5. Create D1 database and KV namespace
6. Save and Deploy
7. Open your Worker URL, enter your password

See [DEPLOY_GUIDE.md](DEPLOY_GUIDE.md) for detailed instructions.

---

## Two Editions

| Feature | Cloud Edition | Local Edition |
|---|---|---|
| File | `TradeVault-worker.js` | `index.html` |
| Backend | Cloudflare Worker + D1 | Browser localStorage |
| Auth | Password (KV sessions) | None (skipped) |
| Multi-device | Yes | No |
| Offline | No (needs network) | Yes |
| Storage limit | D1 free tier (5M reads/day) | ~5-10 MB localStorage |
| Backup format | Cloud JSON (v4) | Local JSON (tv_* keys) |
| Cross-compatible | Yes (both formats accepted) | Yes |

### Migration between editions

**Local → Cloud:**
1. Open local edition → Backup → downloads JSON
2. Deploy cloud edition
3. Open cloud app → Backup → Restore → pick file

**Cloud → Local:**
1. Open cloud app → Backup → downloads JSON
2. Open local edition → Backup → Restore → pick file

Both editions auto-detect the backup format and convert if needed.

---

## Architecture

### Cloud Edition

```
┌─────────────────────────────────────────┐
│           Cloudflare Worker              │
│  ┌─────────────────────────────────┐    │
│  │     Worker Script (JS/ESM)      │    │
│  │  - API routes (/api/*)          │    │
│  │  - Auth (password + KV session) │    │
│  │  - D1 queries (parameterized)   │    │
│  │  - HTML served from base64      │    │
│  └──────────┬──────────┬───────────┘    │
│             │          │                 │
│        ┌────▼────┐ ┌───▼────┐           │
│        │ D1 (DB) │ │ KV     │           │
│        │ SQLite  │ │Session │           │
│        └─────────┘ └────────┘           │
└─────────────────────────────────────────┘
```

### Local Edition

```
┌─────────────────────────────────────────┐
│            Browser (HTML file)           │
│  ┌─────────────────────────────────┐    │
│  │     Inline JavaScript            │    │
│  │  - API adapter (localStorage)    │    │
│  │  - Same UI as cloud edition      │    │
│  │  - No network calls (except      │    │
│  │    economic calendar CSV fetch)  │    │
│  └──────────┬───────────────────────┘    │
│             │                             │
│        ┌────▼────┐                       │
│        │localStorage│                     │
│        │ (tv_* keys)│                    │
│        └───────────┘                     │
└─────────────────────────────────────────┘
```

---

## Data Model

### Tables

| Table | Purpose | Key Columns |
|---|---|---|
| `accounts` | Trading accounts | id, name, created |
| `trades` | Trade journal entries | id, account_id, symbol, direction, entry, exit, sl, tp, size, pnl, r_multiple, status, mae, mfe, mtf4h (analytics), notes, lessons, emotion, entry_pic (JSON image array), rating, tags (JSON), custom (JSON), session, propfirm_id, tp1/2/3, tp1/2/3_hit, timestamp, date, time |
| `strategies` | Trading strategies | id, account_id, name, checklist, notes, video, created |
| `setups` | Trade opportunities | id, account_id, symbol, note, pic_url, tag, timestamp, date |
| `custom_fields` | User-defined fields | id, account_id, name (UNIQUE per account) |
| `watchlist` | Watched symbols | id, account_id, symbol (UNIQUE per account) |
| `review_notes` | Weekly/monthly notes | id, account_id, label, notes, updated (UNIQUE account+label) |
| `prop_firms` | Prop firm challenges | id, account_id, name, type, balance, target, target2, max_daily, max_overall, time_limit, start_date, current_step, step1_passed, step1_pnl |
| `user_settings` | Per-account settings | id, account_id, key, value (UNIQUE account+key) |

### Note on legacy columns

The `trades` table still has `mtf1h`, `mtf15m`, and `exit_pic` columns in the schema for backward compatibility, but they are no longer written to or read from. All MTF data is stored in `mtf4h` (renamed "Analytics" in the UI), and all images are stored as a JSON array in `entry_pic`.

---

## API Reference

All endpoints require `Authorization: Bearer <token>` (except `/api/auth/login`).
Account-scoped endpoints accept `X-Account-Id` header or `?accountId=` query param.

### Auth

| Method | Path | Description |
|---|---|---|
| POST | `/api/auth/login` | Login with password, returns token + accountId |
| POST | `/api/auth/logout` | Invalidate session |
| GET | `/api/auth/me` | Check if session is valid |

### Accounts

| Method | Path | Description |
|---|---|---|
| GET | `/api/accounts` | List all accounts (with trade count + P&L) |
| POST | `/api/accounts` | Create account |
| DELETE | `/api/accounts/:id?mode=reassign&target=:id` | Delete account, move data to target |
| DELETE | `/api/accounts/:id?mode=hard` | Delete account and all its data |

### Trades

| Method | Path | Description |
|---|---|---|
| GET | `/api/trades?limit=500` | List trades (max 5000) |
| POST | `/api/trades` | Create trade |
| PUT | `/api/trades/:id` | Update trade (48h lock enforced) |
| DELETE | `/api/trades/:id` | Delete trade (48h lock enforced) |

### Strategies

| Method | Path | Description |
|---|---|---|
| GET | `/api/strategies` | List strategies |
| POST | `/api/strategies` | Create strategy |
| PUT | `/api/strategies/:id` | Update strategy |
| DELETE | `/api/strategies/:id` | Delete strategy |

### Setups (Opportunities)

| Method | Path | Description |
|---|---|---|
| GET | `/api/setups` | List setups |
| POST | `/api/setups` | Create setup |
| PUT | `/api/setups/:id` | Update setup |
| DELETE | `/api/setups/:id` | Delete setup |

### Custom Fields

| Method | Path | Description |
|---|---|---|
| GET | `/api/custom-fields` | List custom field names |
| POST | `/api/custom-fields` | Add custom field |
| DELETE | `/api/custom-fields/:name` | Remove custom field |

### Watchlist

| Method | Path | Description |
|---|---|---|
| GET | `/api/watchlist` | List symbols |
| POST | `/api/watchlist` | Add symbol |
| DELETE | `/api/watchlist/:symbol` | Remove symbol |

### Review Notes

| Method | Path | Description |
|---|---|---|
| GET | `/api/review-notes` | Get all notes (object: {label: notes}) |
| POST | `/api/review-notes` | Save/update note (upsert) |

### Prop Firms

| Method | Path | Description |
|---|---|---|
| GET | `/api/propfirms` | List prop firms |
| POST | `/api/propfirms` | Create prop firm |
| PUT | `/api/propfirms/:id` | Update prop firm |
| DELETE | `/api/propfirms/:id` | Delete prop firm |

### Settings

| Method | Path | Description |
|---|---|---|
| GET | `/api/settings` | Get all settings (object: {key: value}) |
| POST | `/api/settings` | Save/update setting (upsert) |

### Backup & Restore

| Method | Path | Description |
|---|---|---|
| GET | `/api/backup` | Full database dump (JSON) |
| POST | `/api/restore` | Wipe DB + restore from JSON backup |

### Other

| Method | Path | Description |
|---|---|---|
| GET | `/api/calendar` | Economic calendar proxy (fetches CSV from nfs.faireconomy.media) |
| GET | `/` | Serve the dashboard HTML |

---

## Security

- **Auth:** Password-based with KV session tokens (30-day TTL, auto-refreshed on each request)
- **Rate limiting:** 10 failed login attempts per IP per 5 minutes (KV-based)
- **SQL injection:** All queries use parameterized bindings; symbol inputs are sanitized
- **IDOR protection:** Every UPDATE/DELETE is scoped by `account_id` — users can only modify their own account's data
- **48h trade lock:** Server-side enforced — trades older than 48 hours cannot be edited or deleted
- **XSS:** All user input is escaped via `escapeHtml()` before rendering; notes support markdown via a sanitized renderer
- **CORS:** Configurable via `ALLOWED_ORIGIN` env var (defaults to echoing request Origin)

---

## Testing

The codebase has been extensively tested with **74,727+ assertions across 11 test suites**:

| Test Suite | What it covers |
|---|---|
| `test_1000iter_db_verified` | 1000 iterations of every CRUD operation, DB verified after each |
| `stress_test` (cloud) | 300 iterations × 31 operations per iteration |
| `stress_test_local` | 300 iterations × 31 operations (local edition) |
| `test_edge_cases` | SQL injection, missing auth, malformed JSON, large payloads, rate limiting |
| `test_strategy_persistence` | Create → logout → login → verify (both editions) |
| `test_full_persistence` | All entity types survive logout/login (both editions) |
| `test_trade_edit` | P&L recalculation on edit, 48h lock enforcement |
| `test_backup_restore` | Full backup → wipe → restore roundtrip, cross-format |
| `test_id_preservation` | IDs stable across multiple backup/restore cycles |
| `test_chart_auth_calendar` | Logout cache clearing, BOM stripping, password clearing |
| `verify_sample_backup` | Sample backup file loads cleanly |

---

## Backup & Restore

### Creating a backup

1. Click the **Backup** button in the app
2. A JSON file downloads with all your data (accounts, trades, strategies, etc.)

### Restoring a backup

1. Click **Restore** in the app
2. Select your backup JSON file
3. Confirm — this **wipes all current data** and replaces it with the backup
4. Page reloads with restored data

### Cross-edition migration

Backups from either edition can be restored into either edition:
- Cloud backup → Local app: auto-converts to tv_* localStorage keys
- Local backup → Cloud app: auto-converts to cloud format, POSTs to `/api/restore`

### Migrating old-format backups

If you have a backup from before v4.7 (old `entryPic` string URLs, separate `mtf1h`/`mtf15m` fields), use the migration script:

```bash
python3 scripts/migrate_backup.py old-backup.json new-backup.json
```

This converts:
- Old `entryPic` (string URL) → new JSON array `[{"url":"...","note":"Entry"}]`
- Old `exitPic` (string URL) → merged into `entryPic` array
- TradingView snapshot page URLs → direct S3 image URLs
- Old `mtf1h`/`mtf15m` → merged into `mtf4h` (Analytics)

---

## Files

| File | Description |
|---|---|
| `TradeVault-worker.js` | Cloud edition — single Cloudflare Worker file (546 KB) |
| `index.html` | Local edition — standalone HTML file (388 KB) |
| `sample-backup.json` | Sample backup with 2 accounts, 150 trades, 10 strategies |
| `CHANGELOG.md` | Full changelog (v4.0 → v4.8) |
| `DEPLOY_GUIDE.md` | Step-by-step deployment guide |
| `README_FA.md` | Persian/Farsi documentation |

---

## Tech Stack

- **Backend:** Cloudflare Workers (ESM), D1 (SQLite), KV (session storage)
- **Frontend:** Vanilla HTML/CSS/JS (no framework, no build step)
- **Charts:** TradingView Advanced Chart widget, inline SVG for equity curves
- **Storage:** D1 (cloud) or localStorage (local)
- **Auth:** Password + KV session tokens with TTL refresh
- **Testing:** Node.js + node:sqlite (D1 mock), 74,727+ assertions

---

## 💛 Donate / Support

If TradeVault helps your trading, consider supporting development.

### 💎 Crypto Wallets

| Currency | Address |
|----------|---------|
| **BTC** | `bc1q580tzk2h9277mk6waepl4unuvpdwlzlj9cvx6c` |
| **ETH** | `0x59947E23B37778722efC7afF7D5f19D71B4FE703` |
| **USDT (TRC20)** | `TRBMdyWNfDja5NMcKQQTK5nFRjjV5tRDXE` |
| **USDT (BEP20)** | `0x59947E23B37778722efC7afF7D5f19D71B4FE703` |
| **SOL** | `7CUoigTM2nfzFXchzmwWZ53xgdKMS29HzUQqwpj8vNBg` |

---

## License

Personal use. See Cloudflare Workers and D1 terms of service for platform usage.
