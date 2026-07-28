-- Enforce no zero-amount entries (Section 7 decision)
ALTER TABLE transaction_entries
ADD CONSTRAINT chk_entry_amount_not_zero CHECK (amount != 0);

-- Accounts: filtered by user, excluding soft-deleted
CREATE INDEX idx_accounts_user_id
ON accounts (user_id)
WHERE deleted_at IS NULL;

-- Categories: filtered by user, excluding soft-deleted
CREATE INDEX idx_categories_user_id
ON categories (user_id)
WHERE deleted_at IS NULL;


-- Drop the old constraint that doesn't account for soft deletes
ALTER TABLE categories
DROP CONSTRAINT uq_category_name_per_user;

-- Categories: unique name per user, only active
CREATE UNIQUE INDEX uq_category_name_per_user
ON categories (user_id, name)
WHERE deleted_at IS NULL;

-- Transactions: user's transactions by date for reports
CREATE INDEX idx_transactions_user_date
ON transactions (user_id, date);

-- Transaction entries: join on transaction
CREATE INDEX idx_entries_transaction_id
ON transaction_entries (transaction_id);

-- Transaction entries: balance computation per account
CREATE INDEX idx_entries_account_id
ON transaction_entries (account_id);

-- Transaction entries: category rollups
CREATE INDEX idx_entries_category_id
ON transaction_entries (category_id);