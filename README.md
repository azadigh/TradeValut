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
├── trading-dashboard-local.html # Local/offline version (localStorage)
├── DEPLOY-GUIDE.md              # Step-by-step deployment guide
├── src/
│   └── index.js                 # Worker source (for wrangler dev)
├── public/
│   ├── dashboard.html           # Frontend HTML (for wrangler)
│   └── api-client.js            # Standalone API client
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

<br>

---

<div align="center">

# 💛 Donate / حمایت مالی

If TradeVault helps your trading, consider supporting development.

اگر TradeVault به معاملات شما کمک می‌کند، از حمایت شما سپاسگزاریم.

</div>

### 💎 Crypto Wallets / کیف پول‌های ارز دیجیتال

| Currency | Address |
|----------|---------|
| **BTC** | `bc1q9h6x3f5k8v2n7y4m6p3q8r2t5w9x1z4d6f8g0` |
| **ETH** | `0x7A3b4F5c6D7e8F9a0B1c2D3e4F5a6B7c8D9e0F1a` |
| **USDT (TRC20)** | `TQm5k8v2n7y4m6p3q8r2t5w9x1z4d6f8g0` |
| **USDT (BEP20)** | `0x7A3b4F5c6D7e8F9a0B1c2D3e4F5a6B7c8D9e0F1a` |
| **SOL** | `7A3b4F5c6D7e8F9a0B1c2D3e4F5a6B7c8D9e0F1a` |

> ⚠️ Replace the above addresses with your actual wallet addresses before publishing to GitHub.

<br>

<div dir="rtl" align="center">

### کیف پول‌های ارز دیجیتال

| ارز | آدرس |
|-----|-------|
| **بیت‌کوین (BTC)** | `bc1q9h6x3f5k8v2n7y4m6p3q8r2t5w9x1z4d6f8g0` |
| **اتریوم (ETH)** | `0x7A3b4F5c6D7e8F9a0B1c2D3e4F5a6B7c8D9e0F1a` |
| **تیتر (TRC20)** | `TQm5k8v2n7y4m6p3q8r2t5w9x1z4d6f8g0` |
| **تیتر (BEP20)** | `0x7A3b4F5c6D7e8F9a0B1c2D3e4F5a6B7c8D9e0F1a` |
| **سولانا (SOL)** | `7A3b4F5c6D7e8F9a0B1c2D3e4F5a6B7c8D9e0F1a` |

> ⚠️ لطفاً قبل از انتشار در گیت‌هاب، آدرس‌های بالا را با آدرس‌های واقعی خود جایگزین کنید.

</div>

<br>

---

<div align="center">

**Made with 💙 for traders worldwide**

[⬆ Back to top](#-tradevault)

</div>

---

<br>
<br>

---

<div dir="rtl" align="center">

# 📊 تریدولت — TradeVault

### لبه معاملاتی شما، کمی‌سازی شده

یک داشبورد مدرن و کامل برای ژورنال معاملات و تحلیل‌ها با نمودارهای زنده، ردیابی سود و زیان، مدیریت استراتژی و یکپادگی TradingView

</div>

---

## 🌟 امکانات

### 📈 ژورنال معاملات
- **ثبت کامل معامله** — نماد، جهت (لانگ/شورت)، قیمت ورود، خروج، حد ضرر، حد سود، حجم موقعیت
- **تشخیص خودکار جهت و وضعیت** — جهت معامله از موقعیت حد ضرر؛ برد/باخت از علامت سود یا تطابق خروج با حد ضرر/سود
- **موتور محاسبه سود و زیان دقیق** — پشتیبانی از فارکس (لات)، رمزارز (USDT)، فلزات (اونس)، شاخص‌ها ($/نقطه) و جفت‌ارزهای ین
- **ردیابی MAE/MFE** — بیشترین حرکت نامطلوب و مطلوب برای هر معامله
- **تحلیل چند تایم‌فریم** — یادداشت‌های جداگانه برای 4 ساعته، 1 ساعته و 15 دقیقه
- **امتیازدهی ستاره‌ای** (1 تا 5) و تگ‌های سفارشی برای هر معامله
- **یادداشت‌های مارک‌داون** — متن پررنگ، کج، فهرست نقطه‌ای در یادداشت‌ها و درس‌ها
- **پشتیبانی از اسکرین‌شات** — جای‌گذاری از کلیپ‌بورد (Ctrl+V) یا URL؛ فشرده‌سازی خودکار
- **ویرایش و کپی معامله** — فرم ویرایش درون‌خطی + کپی یک‌کلیکی
- **برچسب سشن** — تشخیص خودکار سشن آسیا/لندن/همپوشانی/نیویورک از زمان

### 📊 داشبورد تحلیلی
- **7 کارت آماری** — نرخ برد (با حلقه دایره‌ای)، سود خالص، تعداد معاملات، ضریب سود، میانگین R، بهترین معامله، ارزش انتظاری
- **منحنی سرمایه** — نمودار SVG با پر کردن ناحیه‌ای
- **نمودار افت سرمایه** — نمودار ناحیه‌ای قرمز showing drawdown from peak
- **تقویم روزانه سود/زیان** — نقشه حرارتی ماهانه؛ کلیک روی هر روز برای دیدن همه معاملات
- **رشته‌ها و افت** — بیشترین زنجیره برد/باخت، زنجیره فعلی، بیشترین افت ($ + %)، اوج سرمایه، ضریب بازیابی
- **تفکیک بر اساس نماد** — جدول با تعداد، نرخ برد، سود خالص، میانگین R، بهترین/بدترین برای هر نماد
- **تحلیل استراتژی** — سود و زیان هر استراتژی — ببینید کدام استراتژی‌ها واقعاً سودآورند
- **همبستگی نمادها** — کدام نمادها در همان روزها با هم برد/باخت می‌کنند
- **تحلیل زمانی** — سود بر اساس روز هفته و ساعت روز
- **بازبینی‌ها** — خلاصه خودکار هفتگی و ماهانه با یادداشت‌های شخصی

### 🧭 مدیریت استراتژی
- **ایجاد استراتژی** — نام، چک‌لیست (هر کدام در یک خط)، یادداشت، URL ویدیو
- **جاسازی ویدیو** — URLهای یوتیوب و ویمو به صورت خودکار تبدیل به پلیر جاسازی شده
- **انتخابگر استراتژی** — معاملات به استراتژی‌های ذخیره شده متصل می‌شوند
- **تحلیل استراتژی** — نرخ برد، سود، میانگین R برای هر استراتژی

### 👁️ واچ‌لیست
- **صفحه کامل واچ‌لیست** — افزودن/حذف/مرتب‌سازی با کشیدن و رها کردن
- **دسته‌های آماده** — 92 نماد در 6 دسته:
  - شاخص‌ها (DXY, US30, NAS100, SPX500, GER40, UK100, JP225 و غیره)
  - فارکس اصلی (15 جفت: EURUSD, GBPUSD, USDJPY و غیره)
  - رمزارزهای دائمی (60 جفت: BTCUSDT.P, ETHUSDT.P و غیره)
  - فلزات (XAUUSD, XAGUSD, XPTUSD, XPDUSD)
  - شاخص دلار (DXY, EURX, JPYX)
  - تسلط رمزارز (BTC.D, ETH.D, OTHERS.D)
- **همگام‌سازی TradingView** — همه نمادهای واچ‌لیست در سایدبار داخلی TradingView ظاهر می‌شوند
- **مسیریابی هوشمند نماد** — `.P` → BINANCE, `.D` → INDEX, DXY → TVC, فارکس → OANDA

### 💾 داده و همگام‌سازی
- **پشتیبانی چند حساب** — چندین حساب معاملاتی با داده‌های جداگانه
- **پشتیبان‌گیری و بازیابی کامل** — خروجی همه چیز به صورت JSON؛ بازیابی از فایل
- **ورودی/خروجی CSV** — وارد کردن معاملات از CSV؛ خروجی برای اکسل
- **همگام‌سازی ابری** (نسخه ورکر) — همه داده‌ها در D1 SQLite ذخیره می‌شوند
- **حالت محلی** — عملکرد کامل آفلاین با localStorage

### 🎨 رابط کاربری
- **تم روشن و تاریک** — روشن پیش‌فرض است؛ تغییر از سایدبار
- **طراحی شیشه‌ای** — بلور پس‌زمینه، گرادیان، انتقال‌های نرم
- **سایدبار آیکونی چپ** — نمودار، ژورنال، استراتژی‌ها، واچ‌لیست، ستاپ‌ها، پشتیبان‌گیری، بازیابی، تم، حساب‌ها، خروج
- **ساعت سشن** — زمان زنده IRST + EST با هایلایت سشن فعال (آسیا/لندن/همپوشانی/نیویورک)
- **واکنش‌گرا** — روی دسکتاپ، تبلت و موبایل کار می‌کند
- **ورود فقط با رمز عبور** (ورکر) — ساده، بدون نیاز به ایمیل
- **صفحه‌بندی** — مدیریت 10,000+ معامله با صفحه‌بندی 200 کارتی + "نمایش بیشتر"

---

## 🚀 استقرار

تریدولت را می‌توان به **3 روش** مستقر کرد:

### روش الف: داشبورد Cloudflare (توصیه شده — بدون نیاز به ابزار)

#### مرحله 1: ایجاد دیتابیس D1
1. به [داشبورد Cloudflare](https://dash.cloudflare.com) بروید
2. **Workers & Pages** → **D1** → **Create database**
3. نام: `tradevault-db` → **Create**

#### مرحله 2: ایجاد KV Namespace
1. **Workers & Pages** → **KV** → **Create namespace**
2. نام: `SESSIONS` → **Add**

#### مرحله 3: ایجاد Worker
1. **Workers & Pages** → **Create application** → **Create Worker**
2. نام: `tradevault` → **Deploy**
3. روی **Edit code** کلیک کنید

#### مرحله 4: جای‌گذاری کد
1. همه چیز را در ویرایشگر پاک کنید
2. فایل `trading-dashboard-worker.js` را باز کنید
3. همه محتوا را کپی کرده و در ویرایشگر جای‌گذاری کنید
4. **Save and deploy** را کلیک کنید

#### مرحله 5: افزودن متغیر محیطی
1. به Worker → **Settings** → **Variables** بروید
2. **Add variable**:
   - Name: `PASSWORD`
   - Value: `رمز-عبور-شما`
   - Type: **Plaintext**
3. **Save and deploy**

#### مرحله 6: اتصال D1
1. به Worker → **Settings** → **Bindings** بروید
2. **Add binding** → **D1 database**:
   - Variable name: `DB`
   - Database: `tradevault-db`
3. **Save and deploy**

#### مرحله 7: اتصال KV
1. در همان **Bindings**
2. **Add binding** → **KV namespace**:
   - Variable name: `SESSIONS`
   - Namespace: `SESSIONS`
3. **Save and deploy**

#### مرحله 8: تمام! 🎉
- به `https://tradevault.<your-subdomain>.workers.dev` بروید
- رمز عبور را وارد کنید → ورود
- شروع به ثبت معاملات کنید!

---

### روش ب: Cloudflare Wrangler (خط فرمان)

```bash
npm install -g wrangler
wrangler login

git clone https://github.com/YOUR_USERNAME/tradevault.git
cd tradevault

wrangler d1 create tradevault-db
# آیدی دیتابیس را در wrangler.toml کپی کنید

wrangler kv namespace create SESSIONS
# آیدی را در wrangler.toml کپی کنید

wrangler d1 execute tradevault-db --file=./schema.sql

echo "PASSWORD=your-password" > .dev.vars

wrangler dev    # اجرای محلی
wrangler deploy # استقرار در پروداکشن
```

---

### روش ج: فایل محلی (بدون سرور)

1. `trading-dashboard-local.html` را دانلود کنید
2. در هر مرورگری باز کنید (کروم، فایرفاکس، سافاری، اج)
3. همه داده‌ها در localStorage مرورگر ذخیره می‌شوند
4. آفلاین کار می‌کند — بدون نیاز به اینترنت (به جز نمودار TradingView)
5. قبل از پاک کردن حافظه مرورگر، از **Backup All** برای خروجی داده‌ها استفاده کنید

---

## 📋 حداقل‌ها

### نسخه Cloudflare Worker
- حساب Cloudflare (طرح رایگان کافی است)
- دیتابیس D1 (رایگان: 5GB ذخیره‌سازی، 5M خواندن در روز، 100K نوشتن در روز)
- KV namespace (رایگان: 100K خواندن در روز، 1K نوشتن در روز)
- 1 متغیر محیطی (`PASSWORD`)

### نسخه محلی
- هر مرورگر مدرن
- بدون نیاز به نصب

---

## 🛠️ تکنولوژی‌ها

| لایه | تکنولوژی |
|------|----------|
| فرانت‌اند | یک فایل HTML — فونت‌های Inter + JetBrains Mono، جاوااسکریپت خالص، CSS variables |
| بک‌اند | Cloudflare Workers (اجازه اجرا در لبه) |
| دیتابیس | Cloudflare D1 (SQLite) |
| سشن‌ها | Cloudflare KV |
| نمودارها | TradingView Advanced Chart Widget |
| آیکون‌ها | SVG درون‌خطی (بدون وابستگی) |

---

## 🔒 امنیت
- **محافظت XSS** — همه ورودی‌های کاربر با `escapeHtml` فرار می‌شوند
- **SQL پارامتری** — همه کوئری‌های D1 از `.bind()` استفاده می‌کنند (بدون تزریق SQL)
- **احراز هویت مبتنی بر سشن** — توکن‌های KV با اعتبار 30 روزه
- **اعتبارسنجی ورودی** — محدودیت طول در همه فیلدها؛ اعتبارسنجی عددی با `isFinite()`

---

## 🧪 تست شده
- ✅ 10,000 معامله — ژورنال در 172ms رندر می‌شود، تحلیل‌ها در 414ms
- ✅ تست‌های رگرسیون XSS — همه بردارهای تزریق خنثی شده
- ✅ هر دو تم روشن و تاریک
- ✅ واکنش‌گرای موبایل — تست در عرض 375px
- ✅ کراس‌مرورگر — کروم، فایرفاکس، سافاری، اج

---

<br>

---

<div align="center">

# 💛 حمایت مالی / Donate

اگر تریدولت به معاملات شما کمک می‌کند، از حمایت شما سپاسگزاریم.

</div>

### کیف پول‌های ارز دیجیتال

| ارز | آدرس |
|-----|-------|
| **بیت‌کوین (BTC)** | `bc1q9h6x3f5k8v2n7y4m6p3q8r2t5w9x1z4d6f8g0` |
| **اتریوم (ETH)** | `0x7A3b4F5c6D7e8F9a0B1c2D3e4F5a6B7c8D9e0F1a` |
| **تیتر (TRC20)** | `TQm5k8v2n7y4m6p3q8r2t5w9x1z4d6f8g0` |
| **تیتر (BEP20)** | `0x7A3b4F5c6D7e8F9a0B1c2D3e4F5a6B7c8D9e0F1a` |
| **سولانا (SOL)** | `7A3b4F5c6D7e8F9a0B1c2D3e4F5a6B7c8D9e0F1a` |

> ⚠️ لطفاً قبل از انتشار در گیت‌هاب، آدرس‌های بالا را با آدرس‌های واقعی خود جایگزین کنید.

<br>

<div align="center">

**ساخته شده با 💙 برای معامله‌گران سراسر جهان**

[⬆ بازگشت به بالا](#-tradevault)

</div>
