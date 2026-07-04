<div align="center">

# 📊 TradeVault

### Your Trading Edge, Quantified

A modern, full-featured trading journal & analytics dashboard with real-time charts, P&L tracking, strategy management, and TradingView integration.

[![Cloudflare Workers](https://img.shields.io/badge/Cloudflare-Workers-F38020?logo=cloudflare&logoColor=white)](https://workers.cloudflare.com/)
[![D1 Database](https://img.shields.io/badge/D1-Database-0052CC?logo=cloudflare&logoColor=white)](https://developers.cloudflare.com/d1/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Single File](https://img.shields.io/badge/Deploy-Single%20File-blue.svg)](#deployment)

</div>

---

## 🌟 Features

### 📈 Trading Journal
- **Full trade logging** — Symbol, direction (long/short), entry, exit, SL, TP, position size
- **Auto-detected direction & status** — Infers long/short from SL position; win/loss from P&L sign or exit matching SL/TP
- **Accurate P&L engine** — Handles forex (lots), crypto (USDT), metals (oz), indices ($/pt), and JPY pairs
- **MAE/MFE tracking** — Maximum Adverse/Favorable Excursion for each trade
- **Multi-timeframe analysis** — Separate notes for 4H, 1H, and 15m timeframes
- **Star ratings** (1–5) and custom tags per trade
- **Markdown notes** — Bold, italic, bullet lists in trade notes and lessons
- **Screenshot support** — Paste from clipboard (Ctrl+V) or URL; auto-compressed
- **Trade editing & duplication** — Inline edit form + one-click duplicate
- **Session tagging** — Auto-detects Asia/London/Overlap/New York session from timestamp

### 📊 Analytics Dashboard
- **7 stat cards** — Win Rate (with circular ring), Net P&L, Total Trades, Profit Factor, Avg R Multiple, Best Trade, Expectancy
- **Equity curve** — SVG area chart with gradient fill
- **Drawdown chart** — Red area chart showing drawdown from peak
- **Daily P&L calendar** — Monthly heatmap; click any day to see all trades with details
- **Streaks & drawdown** — Max win/loss streak, current streak, max drawdown ($ + %), peak equity, recovery factor
- **Per-symbol breakdown** — Table with trades, win rate, net P&L, avg R, best/worst per symbol
- **Strategy analytics** — P&L per strategy — see which strategies actually make money
- **Symbol correlation** — Which symbols win/lose together on the same days
- **Time analysis** — P&L by day of week and hour of day bar charts
- **Reviews** — Auto-generated weekly and monthly summaries with personal reflection notes

### 🧭 Strategy Manager
- **Create strategies** — Name, checklist (one per line), notes, video URL
- **Video embedding** — YouTube and Vimeo URLs auto-converted to embedded players
- **Strategy selector** — Trades link to saved strategies via dropdown
- **Strategy analytics** — Win rate, P&L, avg R per strategy

### 👁️ Watchlist
- **Full watchlist page** — Add/remove/reorder with drag-and-drop
- **Prebuilt categories** — 92 symbols across 6 categories:
  - Indices (DXY, US30, NAS100, SPX500, GER40, UK100, JP225, etc.)
  - Major Forex (15 pairs: EURUSD, GBPUSD, USDJPY, etc.)
  - Crypto Perpetuals (60 pairs: BTCUSDT.P, ETHUSDT.P, etc.)
  - Metals (XAUUSD, XAGUSD, XPTUSD, XPDUSD)
  - Dollar Index (DXY, EURX, JPYX)
  - Crypto Dominance (BTC.D, ETH.D, OTHERS.D)
- **TradingView sync** — All watchlist symbols appear in TradingView's built-in sidebar
- **Smart symbol routing** — `.P` → BINANCE, `.D` → INDEX, DXY → TVC, forex → OANDA

### 💾 Data & Sync
- **Multi-account support** — Multiple trading accounts with isolated data
- **Full backup/restore** — Export everything as JSON; restore from file
- **CSV import/export** — Import trades from CSV; export for Excel
- **Cloud sync** (Worker version) — All data persisted in D1 SQLite
- **Local mode** — Full offline functionality with localStorage

### 🎨 UI/UX
- **Light & dark themes** — Light is default; toggle via sidebar
- **Glassmorphic design** — Backdrop blur, gradient accents, smooth transitions
- **Left icon sidebar** — Chart, Journal, Strategies, Watchlist, Setups, Backup, Restore, Theme, Accounts, Logout
- **Session clock** — Live IRST + EST times with active session highlighted (Asia/London/Overlap/NY)
- **Responsive** — Works on desktop, tablet, and mobile
- **Password-only login** (Worker) — Simple, no email needed
- **Pagination** — Handles 10,000+ trades with 200-card pagination + "show more"
- **Performance optimized** — Debounced search, cached analytics, safe loops (no stack overflow)

### 🔒 Security
- **XSS protection** — All user input escaped with `escapeHtml` (handles `<`, `>`, `"`, `'`, backtick, newlines)
- **Parameterized SQL** — All D1 queries use `.bind()` (no SQL injection)
- **Session-based auth** — KV-stored tokens with 30-day TTL
- **Input validation** — Length caps on all fields; numeric validation with `isFinite()`
- **Import sanitization** — `sanitizeTrade()` validates every field from external imports

---

## 🚀 Deployment

TradeVault can be deployed in **3 ways**:

### Option A: Cloudflare Workers Dashboard (Recommended — No tools needed)

#### Step 1: Create D1 Database
1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com)
2. **Workers & Pages** → **D1** → **Create database**
3. Name: `tradevault-db` → **Create**

#### Step 2: Create KV Namespace
1. **Workers & Pages** → **KV** → **Create namespace**
2. Name: `SESSIONS` → **Add**

#### Step 3: Create Worker
1. **Workers & Pages** → **Create application** → **Create Worker**
2. Name: `tradevault` → **Deploy**
3. Click **Edit code** (pencil icon)

#### Step 4: Paste Code
1. Delete everything in the editor
2. Open `trading-dashboard-worker.js`
3. Copy ALL contents → Paste into editor
4. Click **Save and deploy**

#### Step 5: Add Environment Variable
1. Go to worker → **Settings** → **Variables**
2. **Add variable**:
   - Name: `PASSWORD`
   - Value: `your-secret-password`
   - Type: **Plaintext**
3. **Save and deploy**

#### Step 6: Bind D1 Database
1. Go to worker → **Settings** → **Bindings**
2. **Add binding** → **D1 database**:
   - Variable name: `DB`
   - Database: `tradevault-db`
3. **Save and deploy**

#### Step 7: Bind KV Namespace
1. Still in **Bindings**
2. **Add binding** → **KV namespace**:
   - Variable name: `SESSIONS`
   - Namespace: `SESSIONS`
3. **Save and deploy**

#### Step 8: Done! 🎉
- Visit `https://tradevault.<your-subdomain>.workers.dev`
- Enter your password → Login
- Start logging trades!

---

### Option B: Cloudflare Wrangler (CLI)

```bash
# Install wrangler
npm install -g wrangler
wrangler login

# Clone the repo
git clone https://github.com/YOUR_USERNAME/tradevault.git
cd tradevault

# Create D1 database
wrangler d1 create tradevault-db
# Copy database_id into wrangler.toml

# Create KV namespace
wrangler kv namespace create SESSIONS
# Copy id into wrangler.toml

# Initialize database (local)
wrangler d1 execute tradevault-db --local --file=./schema.sql

# Initialize database (production)
wrangler d1 execute tradevault-db --file=./schema.sql

# Set password
echo "PASSWORD=your-secret-password" > .dev.vars

# Run locally
wrangler dev

# Deploy to production
wrangler deploy
```

---

### Option C: Local File (No server needed)

1. Download `trading-dashboard-local.html`
2. Open in any browser (Chrome, Firefox, Safari, Edge)
3. All data stored in browser localStorage
4. Works offline — no internet needed (except TradingView chart)
5. Use **Backup All** to export data before clearing browser cache

---

## 📋 Requirements

### Cloudflare Worker Version
- Cloudflare account (free tier is sufficient)
- D1 database (free: 5GB storage, 5M reads/day, 100K writes/day)
- KV namespace (free: 100K reads/day, 1K writes/day)
- 1 environment variable (`PASSWORD`)

### Local Version
- Any modern browser
- No installation needed

### Free Tier Limits (10,000 trades)
| Resource | Free Limit | 10K Trades Usage | OK? |
|----------|-----------|------------------|-----|
| D1 storage | 5 GB | ~2 MB | ✅ |
| D1 reads | 5M/day | ~10K/day | ✅ |
| D1 writes | 100K/day | ~50/day | ✅ |
| Worker requests | 100K/day | ~500/day | ✅ |
| KV reads | 100K/day | ~500/day | ✅ |
| KV writes | 1K/day | ~10/day | ✅ |

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Single HTML file — Inter + JetBrains Mono fonts, vanilla JS, CSS variables |
| Backend | Cloudflare Workers (edge runtime) |
| Database | Cloudflare D1 (SQLite) |
| Sessions | Cloudflare KV |
| Charts | TradingView Advanced Chart Widget |
| Icons | Inline SVG (no dependencies) |
| Fonts | Google Fonts (Inter, JetBrains Mono) |

---

## 📁 Project Structure

```
tradevault/
├── worker.js                    # Single-file Cloudflare Worker (paste & deploy)
├── local.html # Local/offline version (localStorage)
├── DEPLOY-GUIDE.md              # Step-by-step deployment guide
├── schema.sql                   # D1 database schema
├── wrangler.toml                # Wrangler config
└── README.md                    # This file
```

---

## 🔧 Configuration

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `PASSWORD` | ✅ | Login password |
| `JWT_SECRET` | ❌ | Reserved for future password hashing |

### D1 Bindings

| Binding | Resource |
|---------|----------|
| `DB` | D1 database (`tradevault-db`) |

### KV Bindings

| Binding | Resource |
|---------|----------|
| `SESSIONS` | KV namespace for auth tokens |

---

## 📊 Database Schema

The schema auto-creates on first request. 7 tables:

| Table | Purpose |
|-------|---------|
| `accounts` | Trading accounts (id, name, created) |
| `trades` | Journal entries (30 columns) |
| `strategies` | Trading strategies (name, checklist, notes, video) |
| `setups` | Saved opportunities |
| `custom_fields` | User-defined fields |
| `watchlist` | Watched symbols |
| `review_notes` | Weekly/monthly review notes |

---

## 🌐 API Endpoints

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` | Login with password |
| POST | `/api/auth/logout` | Logout (invalidate token) |
| GET | `/api/auth/me` | Check session |

### Trades
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/trades?limit=200&offset=0` | List trades (paginated) |
| POST | `/api/trades` | Create trade |
| PUT | `/api/trades/:id` | Update trade |
| DELETE | `/api/trades/:id` | Delete trade |

### Strategies
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/strategies` | List strategies |
| POST | `/api/strategies` | Create strategy |
| DELETE | `/api/strategies/:id` | Delete strategy |

### Accounts, Setups, Custom Fields, Watchlist, Reviews, Backup
All follow similar REST patterns. See [DEPLOY-GUIDE.md](DEPLOY-GUIDE.md) for details.

---

## 🧪 Tested

- ✅ 10,000 trades — Journal renders in 172ms, Analytics in 414ms
- ✅ XSS regression tests — All injection vectors neutralized
- ✅ Cross-theme — Both light and dark themes verified
- ✅ Mobile responsive — Tested at 375px width
- ✅ Cross-browser — Chrome, Firefox, Safari, Edge

---

## 📝 License

MIT License — free for personal and commercial use.

---

<div align="center">

# 💛 Donate / حمایت مالی

If TradeVault helps your trading, consider supporting development.

</div>

### 💎 Crypto Wallets / کیف پول‌های ارز دیجیتال

| Currency | Address |
|----------|---------|
| **BTC** | `bc1q580tzk2h9277mk6waepl4unuvpdwlzlj9cvx6c` |
| **ETH** | `0x59947E23B37778722efC7afF7D5f19D71B4FE703` |
| **USDT (TRC20)** | `TRBMdyWNfDja5NMcKQQTK5nFRjjV5tRDXE` |
| **USDT (BEP20)** | `0x59947E23B37778722efC7afF7D5f19D71B4FE703` |
| **SOL** | `7CUoigTM2nfzFXchzmwWZ53xgdKMS29HzUQqwpj8vNBg` |



[⬆ بازگشت به بالا](#-tradevault)

</div>
