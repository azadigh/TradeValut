-- D1 Schema for Trading Dashboard
-- Run: wrangler d1 execute trading-dashboard-db --file=./schema.sql

-- Users
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  created INTEGER NOT NULL DEFAULT (strftime('%s','now') * 1000)
);

-- Accounts (each user can have multiple trading accounts)
CREATE TABLE IF NOT EXISTS accounts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  created INTEGER NOT NULL DEFAULT (strftime('%s','now') * 1000),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Trades (the main journal entries)
CREATE TABLE IF NOT EXISTS trades (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id INTEGER NOT NULL,
  symbol TEXT NOT NULL,
  direction TEXT NOT NULL DEFAULT 'long',
  setup TEXT DEFAULT '',
  entry REAL DEFAULT 0,
  exit REAL DEFAULT 0,
  sl REAL DEFAULT 0,
  tp REAL DEFAULT 0,
  size REAL DEFAULT 0,
  pnl REAL DEFAULT 0,
  r_multiple REAL DEFAULT 0,
  status TEXT DEFAULT 'open',
  mae REAL DEFAULT 0,
  mfe REAL DEFAULT 0,
  mtf4h TEXT DEFAULT '',
  mtf1h TEXT DEFAULT '',
  mtf15m TEXT DEFAULT '',
  notes TEXT DEFAULT '',
  lessons TEXT DEFAULT '',
  emotion TEXT DEFAULT '',
  entry_pic TEXT DEFAULT '',
  exit_pic TEXT DEFAULT '',
  rating INTEGER DEFAULT 0,
  tags TEXT DEFAULT '[]',          -- JSON array
  custom TEXT DEFAULT '{}',        -- JSON object
  session TEXT DEFAULT 'london',
  timestamp INTEGER NOT NULL,
  date TEXT DEFAULT '',
  time TEXT DEFAULT '',
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_trades_account ON trades(account_id);
CREATE INDEX IF NOT EXISTS idx_trades_timestamp ON trades(timestamp);

-- Strategies
CREATE TABLE IF NOT EXISTS strategies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  checklist TEXT DEFAULT '',
  notes TEXT DEFAULT '',
  video TEXT DEFAULT '',
  created INTEGER NOT NULL DEFAULT (strftime('%s','now') * 1000),
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);

-- Setups (opportunities)
CREATE TABLE IF NOT EXISTS setups (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id INTEGER NOT NULL,
  symbol TEXT NOT NULL,
  note TEXT DEFAULT '',
  pic_url TEXT DEFAULT '',
  tag TEXT DEFAULT 'long',
  timestamp INTEGER NOT NULL,
  date TEXT DEFAULT '',
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);

-- Custom field definitions
CREATE TABLE IF NOT EXISTS custom_fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
  UNIQUE(account_id, name)
);

-- Watchlist
CREATE TABLE IF NOT EXISTS watchlist (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id INTEGER NOT NULL,
  symbol TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
  UNIQUE(account_id, symbol)
);

-- Review notes (weekly/monthly)
CREATE TABLE IF NOT EXISTS review_notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id INTEGER NOT NULL,
  label TEXT NOT NULL,    -- 'This_Week' or 'This_Month'
  notes TEXT DEFAULT '',
  updated INTEGER NOT NULL DEFAULT (strftime('%s','now') * 1000),
  UNIQUE(account_id, label),
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);
