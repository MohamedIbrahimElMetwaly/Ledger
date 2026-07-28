-- Create enum types first
CREATE TYPE account_type AS ENUM ('ASSET', 'LIABILITY', 'INCOME', 'EXPENSE');
CREATE TYPE transaction_status AS ENUM ('ACTIVE', 'REVERSED', 'REVERSAL');

-- Users (renamed from "user" to avoid reserved word)
CREATE TABLE users (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT now()
);

-- Accounts
CREATE TABLE accounts (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  type account_type NOT NULL,
  balance DECIMAL(19,2) NOT NULL DEFAULT 0.00,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at TIMESTAMP NULL,
  CONSTRAINT fk_accounts_user FOREIGN KEY (user_id) 
    REFERENCES users(id) ON DELETE RESTRICT
);


-- Categories
CREATE TABLE categories (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  user_id BIGINT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at TIMESTAMP NULL,
  CONSTRAINT fk_categories_user FOREIGN KEY (user_id) 
    REFERENCES users(id) ON DELETE RESTRICT,
  CONSTRAINT uq_category_name_per_user UNIQUE (user_id, name)
);


-- Transactions
CREATE TABLE transactions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  date DATE NOT NULL,
  note VARCHAR(255),
  user_id BIGINT NOT NULL,
  status transaction_status NOT NULL DEFAULT 'ACTIVE',
  reversal_id BIGINT NULL,
  corrects_id BIGINT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  CONSTRAINT fk_transactions_user FOREIGN KEY (user_id) 
    REFERENCES users(id) ON DELETE RESTRICT,
  CONSTRAINT fk_transactions_reversal FOREIGN KEY (reversal_id) 
    REFERENCES transactions(id) ON DELETE RESTRICT,
  CONSTRAINT fk_transactions_corrects FOREIGN KEY (corrects_id) 
    REFERENCES transactions(id) ON DELETE RESTRICT
);


-- Transaction entries
CREATE TABLE transaction_entries (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  transaction_id BIGINT NOT NULL,
  account_id BIGINT NOT NULL,
  category_id BIGINT,
  amount DECIMAL(19,2) NOT NULL,
  CONSTRAINT fk_entries_transaction FOREIGN KEY (transaction_id) 
    REFERENCES transactions(id) ON DELETE RESTRICT,
  CONSTRAINT fk_entries_account FOREIGN KEY (account_id) 
    REFERENCES accounts(id) ON DELETE RESTRICT,
  CONSTRAINT fk_entries_category FOREIGN KEY (category_id) 
    REFERENCES categories(id) ON DELETE RESTRICT
);