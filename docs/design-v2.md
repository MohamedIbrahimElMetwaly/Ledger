# Ledger - Design doc v1

## 1. Problem and Scope

- Most personal finance apps are either automate everything via bank integration and low accuracy and privacy, or a pure spreadsheets that don't enforce balance integrity.
  Ledger v1 is for users who want manual transaction entry with strict double-entry correcteness and monthly reporting.
- This system helps individuals with personal money/expenses tracking and finance, where
  user can add transactions in double-entry format mentioning money went from a specific account to another to help with tracking the money and also adding a user-defined resuable categories with each transaction so user can know what it was used for. Also providing a monthly report for all transactions at the end of each month.
- Out of scope for v1:
  - Shared accounts
  - CSV import
  - Multi-currency
  - recurring transactions
  - Bank Integration
  - Mobile UI

## 2. Users and Use cases

- User log every transaction the day it happens or backdated by a few days.
- User review monthly expenses at the end of each month to adjust next month's budget.
- User create/add new categories to be used as metadata in each transactions, to know where money goes.

## 3. API Contract

=> Base url: /api/v1
=> Server decode the jwt_token and extract userId and use it in queries to DB

- GET: /transactions?limit=20&cursor=abc123&from=2026-01-01&to=2026-01-31 <br>
  Header: Bearer <jwt_token>

  **response**: {
  data:[
  {
  "id": "xxxxxx",
  "note": "xxxxxx",
  "status": "ACTIVE",
  "date": "202x-xx-xx",
  "enteries": [
  {
  "id": "yyyyyy",
  "account": "Cash",
  "Category": null,
  "amount": -200
  },
  {
  "id": "xxyy",
  "account": {
  "name": "Expenses",
  "id": "asd123"
  },
  "category": {
  "name": "Car Wash",
  "id": "abc123"
  },
  "amount": 200
  }
  ],
  }
  , ....]
  }, 200 OK

- GET: /transactions?from=2026-01-01&to=2026-01-31 <br>
  Header: Bearer <jwt_token>

  **response**: {
  data:[
  {
  "id": "xxxxxx",
  "note": "xxxxxx",
  "status": "ACTIVE",
  "date": "202x-xx-xx",
  "enteries": [
  {
  "id": "yyyyyy",
  "account": "Cash",
  "Category": null,
  "amount": -200
  },
  {
  "id": "xxyy",
  "account": {
  "name": "Expenses",
  "id": "asd123"
  },
  "category": {
  "name": "Car Wash",
  "id": "abc123"
  },
  "amount": 200
  }
  ],
  }
  , ....]
  }, 200 OK

- GET: /transactions/{transactionId} <br>
  Header: Bearer <jwt_token>

  **response**: {
  data:
  {
  "id": "transactionId",
  "note": "xxxxxx",
  "status": "ACTIVE",
  "date": "202x-xx-xx",
  "enteries": [
  {
  "id": "yyyyyy",
  "account": "Cash",
  "Category": null,
  "amount": -200
  },
  {
  "id": "xxyy",
  "account": {
  "name": "Expenses",
  "id": "asd123"
  },
  "category": {
  "name": "Car Wash",
  "id": "abc123"
  },
  "amount": 200
  }
  ],
  }
  }, 200 OK

- POST: /transactions <br>
  Header: Bearer <jwt_token>

  **request**: {
  transaction: {
  "note": "Note",
  "date": "202x-xx-xx",
  "enteries": [
  {
  "account_id": "Cash",
  "amount": -200
  },
  {
  "account_id": "Expenses",
  "category_id": "Car Wash",
  "amount": 200
  }
  ]
  }
  }

  **response**: {
  data:
  {
  "id": "XXXXXXX",
  "note": "xxxxxx",
  "status": "ACTIVE",
  "date": "202x-xx-xx",
  "enteries": [
  {
  "id": "yyyyyy",
  "account": "Cash",
  "Category": null,
  "amount": -200
  },
  {
  "id": "xxyy",
  "account": {
  "name": "Expenses",
  "id": "asd123"
  },
  "category": {
  "name": "Car Wash",
  "id": "abc123"
  },
  "amount": 200
  }
  ],
  }
  }, 201 OK

- POST: /transactions/{transactionId}/correct <br>
  Header: <jwt_token>

  NOTE: Since edit/update is not allowed in financial system, we make a reverse then add new corrected transactions, so will have columns(status:ACTIVE/REVERSED/REVERSAL, reversal_id: (for original which points to reversal record id), corrects_id: (for new record which points to original record)) which can help with this process

  **request**: {
  transaction: {
  "note": "Note",
  "date": "202x-xx-xx",
  "enteries": [
  {
  "account_id": "Cash",
  "amount": -200
  },
  {
  "account_id": "Expenses",
  "category_id": "Car Wash",
  "amount": 200
  }
  ]
  }
  }

  **response**: {
  data:
  {
  "id": "XXXXXXX",
  "note": "xxxxxx",
  "status": "ACTIVE",
  "date": "202x-xx-xx",
  corrects_id: "transactionId",
  "enteries": [
  {
  "id": "yyyyyy",
  "account": "Cash",
  "Category": null,
  "amount": -200
  },
  {
  "id": "xxyy",
  "account": {
  "name": "Expenses",
  "id": "asd123"
  },
  "category": {
  "name": "Car Wash",
  "id": "abc123"
  },
  "amount": 200
  }
  ],
  }
  }, 201 OK

- DELETE: /transactions/{transactionId} <br>
  Header: <jwt_token>

- GET: /categories?limit=20&cursor=abc123 <br>
  Header: <jwt_token>

  **response**:{
  data: [
  {categoryName: "xxxxxx", categoryId: "xx"},
  {categoryName: "xxxxxx", categoryId: "xx"},
  {categoryName: "xxxxxx", categoryId: "xx"},
  {categoryName: "xxxxxx", categoryId: "xx"},
  .....]
  }

- POST: /categories <br>
  Header: <jwt_token>

  **request**: {
  category: {
  categoryName: "XXXXXX",
  }
  }

  **response**: {
  data: {
  categoryName: "xxxxxx",
  categoryId: "xxx"
  }
  }, 201 created

- PUT: /categories/{categoryId} <br>
  Header: <jwt_token>

  **request**: {
  category: {
  categoryName: "yyyyyyy",
  categoryId: "xxx"
  }
  }

  **response**: {
  data: {
  categoryName: "yyyyyy",
  categoryId: "xxx"
  }
  }, 200 ok

- DELETE: /categories/{categoryId} <br>
  Header: <jwt_token>

- GET: /accounts?limit=20&cursor=abc123 <br>
  Header: <jwt_token>

  **response**: {
  data: [
  {accountId: 12313,
  acountName: "xxxxx",
  accountType: "xxxx",
  balance: 121312313
  },
  ......]
  }

- POST: /accounts <br>
  Header: <jwt_token>

  **request**: {
  account: {
  accountName: "xxyy",
  accountType: "xxyy",
  }
  }

  **request**: {
  account: {
  accountId: 12342,
  accountName: "xxyy",
  accountType: "xxyy",
  balance: 0.0
  }
  }, 201 created

## 4. Data Model

- User: [id: BIGINT NOTNULL PK, first_name: varchar, last_name: varchar]
- Category: [id: BIGINT NOTNULL PK, name: varchar UNIQUE, user_id: INT FK]
- Transaction: [id: BIGINT NOTNULL PK, date: Date, note: varchar, user_id: INT FK, status: varchar NOT NULL DEFAULT 'ACTIVE', reversal_id: BIGINT NULL FK, corrects_id: BIGINT NULL FK, created_at: Timestamp NOT NULL, updated_at: Timestamp NOT NULL ]
- Transaction_Entry: [id: BIGINT NOTNULL PK, transaction_id: BIGINT FK, account_id: BIGINT FK, category_id: BIGINT FK, amount: Big decimal]
- Account: [id: BIGINT NOTNULL PK, name: varchar UNIQUE, type: varchar, balance: Big decimal, user_id: INT FK]

-> Indexes:<br>

- Transaction(user_id, created_at) for Time range queries <br>
- Transaction(user_id, category_id) for category rollups <br>
- Transaction(user_id, account_id) for account rollups <br>

-> For deletion, the column status is marked with DELETED instead of ACTIVE

## 5. Key Flows

- Create a transaction:<br>
  1.User login <br>
  2.User send POST request (with request body contain data)<br>
  3.Request is validated in backend:<br> - Data matches schema <br> - Balance can cover the transaction <br> - Since it's double entry, some of all entried inside the transaction must sum to zero <br>
  4.Transaction request sent to DB to insert new data <br>
  5.Return Transaction created successfully

- Get all transactions:<br>
  1.User login <br>
  2.User make GET request all transactions for this month until now <br>
  3.Request is sent to DB to get all transaction within this month <br>
  4.Data is returned to the User <br>

- Edit a transaction<br>
  1.User login <br>
  2.User gell all transactions within this month (or all transaction for a specific month)<br>
  3.User select a specific transaction to edit<br>
  4.User update the fields that need modifications<br>
  5.User send a POST request with transaction id as path variable and content as body<br>
  6.Request is validated that balance is correct and data matches schema<br>
  7.Wrap the following inside a DB Transaction <br> - In Backend we don't update already existing transaction, we create new one as reversal to the original one <br> - Create new transaction with the updated value <br> - Update status column for original record to REVERSED <br> - Add reversal_id: value in the reversal_id column for the original record points to reversal record <br> - Add original record id as corrects_id: value for column for the reversal record <br>
  8.Send response to User that the update was successfull<br>

- Crone Job for Monthly generated report<br>
  1. At the end of each month, a crone job is triggered<br>
  2. For each user, get all transactions done in the current month<br>
  3. Group by category<br>
  4. when user login, we send a notification that monthly report is ready and provide a link to download it<br>

## 6. Non-Functional requirements

- Consistency vs Scalabilty:
  1. In Money systems, Consistency is more important than scalability, because if value is inconsistent this means system is broken whatever number of clients it serves.
  2. For around 10K transactions/day this can be handled comfortably within one DB Postgres instance.
  3. Scalability concerns (Sharding, read replicas) should be deferred until number of transactions exceed what a single DB instance can handle.
- Availability, System should be highly available (99%).
- Latency target - How fast each operation should respond
  1. For commit/write transaction in a simple table without complex join it should be within 200 ms for 99% of requests (p99).
  2. For read transactions list it should be within 100 ms p99.
- Data Durability - What is the cost of losing data
  1. In Money systems, Durability should have zero tolerance for committed transaction loss, a committed transaction should survive any single hardware failure.
  2. This drives decisions like Postgres synchronous commit (not async), DB backups, not using in-memory only storage for financial data
- RPO and RTO - How you recove for disaster
  1. Recovery Point Objective (RPO), How much data we can afford to lose in case of disaster? for money systems this should be very little.
  - RPO of 1 hour, this means we can accept loss of at most last 1 hour transactions.
  - We can restore from DB backups that is at most 1 hour old.
  - This tell us how frequently we should do DB backups.
  2. Recovery Time Objective (RTO), If disaster strikes, how long should it take the system to be online?
  - RTO of 4 hours, clients can tolerate 4 hours of downtime.
  - Since it's a personal finance tool, RTO of 4 hours can be tolerated since there is no critical payment is done through our APIs.

  ==> For Banking systems, RPO should be zero and RTO should be minutes.

## 7. Failure Modes

1. Mid-transaction crash during balance update:
   - All balance affecting operations are wrapped in a single DB transaction, if the application crashes before commit DB rolls back all changes, No partial state is possible, The user sees failed request and can safely retry.
2. Concurrent writes to the same account
   - The solution is using SELECT FOR UPDATE on the account row when updating it's balance. This locks the row for the duration of the DB transaction. The second request waits until first request commits.
   - Concurrent transactions on the same account serialize, while concurrent transactions on different accounts proceed in parallel.
3. DB unreachable
   - We should return 503 which means a dependent is unavailable while 500 means our code is broken and this is not the case.
   - Load balancer can redirect to a different instance
     -If Postgres is unreachable, write endpoints return 503 with retry after header, and React endpoints return 503, no stale cache read because balance accuracy is important than availability.
4. Background jobs crashes mid-report
   - Monthly report generation writes to staging table, only after the generation is completed the staged report is swaped to a live table in a single transaction.
   - If the job crashes, the staging table will contain a partial data that the next run will overwrites, The job is idemponent (running the job twice for the same month will generate the same result)
5. Authorization failures - account doesn't belong to user
   - This case wont happen, because all account lookups filter by userId and accountId
6. Self transfer - from and to account are the same
   - A transaction where both entries reference the same account. The sum is still zero, so it passes the zero-sum validation, but it's meaningless — money going from Bank to Bank accomplishes nothing and clutters the transaction history.
   - Decision: Transactions where are enteries reference same account are rejected with 400, Validated at the API layer before reach the DB.
7. Zero or negative amounts in entries
   - Zero amount in entries are meaningless and will be reject with 400, Validated at API layer
   - Negative amount for an entry is valid, negative amount means credit and positive amount means debit, the constraint is that they sum to zero.
8. Deleting an account that has transactions
   - A user tries to delete their Bank account, but it has 500 transactions referencing it. If you allow the delete, all those entries have a dangling foreign key. If you cascade delete, you lose financial history.
   - Decision:
     - Accounts with existing transaction entries can't be deleted, the API returns 409 conflict with message indicating account has associated transactions.
     - User can archive(soft-delete) accounts to hide them from active use while perserving history.

9. Clock skew
   - If your API server's clock and your database server's clock disagree, the created_at timestamp set by the application won't match the database's now(). For ordering transactions, this could mean two transactions appear in the wrong order.
   - Decision: All timestamps are generated by Postgress (Default now()) rather than application layer, ensuring consistent ordering regardless of which application instance handles the request.

## 8. Explicit Trade-offs Made

- Postgres over MySQL
  - Postgres has better query support (CTEs, window functions) needed by reporting features
  - Postgres has row-level locking(`SELECT FOR UPDATE`) for concurrent balance update patten
  - Postgres has native JSONB support if we ever need flexible metadata on transactions
  - Trade-off:
    - MySQL has larger hiring pool, more hosting options at cheap tiers
    - Postgres has slightly more operational complexity for backups and replication configuration
- Java over alternatives
  - Chose Java because the team is most productive in it and JVM ecosystem has mature financial primitives.
  - Trade-off:
    - Higher memory footprint
    - Slower cold start than GO or Rust
    - More boilerplate than Kotlin
    - Accepted because Developer productivity matters more than runtime efficiency at this scale
- Double-entry over Simplified model
  - Chose true double-entry(transaction header + enteries table, zero-sum invarient) over simiplified (from/to columns on a single table), this support split transactions and is accounting correct
  - Trade-off:
    - Slightly more complex write path (insert header + multiple entries + update multiple balances in one database transaction)
    - More complex API payload (Array of entries instead of two account fields)
    - Harder to explain to non-technical stakeholders
    - Accepted because data model is foundational (migrating from simplified to double-entry would require rewriting every transaction in DB)
- Soft delete vs Hard delete
  - Chose soft delete(status Column) over hard delete for transactions, because no financial record is ever physically removed
  - Trade-off:
    - Database grows indefinitely
    - All queries must filter by status
    - Accepted because audit trial integrity is more important than storage cost at this scale
- Single currency vs multi-currency
  - V1 supports single currency per user(set at account creation), Multi-currency and cross-currency transfers deferred to V2
  - Trade-off:
    - Users who deal in multiple currencies can't use the system accurately
    - Accepted because exchange rate handling, currency conversion logic and multi-currency reporting are each a significant features that would double the V1 timeline.
- Isolation level for balance updates
  - Chose READ COMMITTED isolation with explicit `SELECT FOR UPDATE` on account rows during balance updates, rather than SERIALIZABLE isolation
  - Trade-off:
    - SERIALIZABLE would prevent all anomalies automatically but would serialize all transactions touching the same account and could cause serialization failures requiring application-level retry logic
    - `SELECT FOR UPDATE` under READ COMMITTED gives us the specific guarantee we need(no lost updates on balances) without serializing unrealted operations
    - Accepted the only invariant we are protecting is `Balance equals sum of entries` and row-level locking is sufficient for that.
- Transaction immutability vs mutability
  - Transactions are immutable after creation. Corrections use a reversal-plus-new-entry pattern rahter than in-place updates.
  - Trade-off:
    - More rows in DB (three rows for one correctio instead of one updated row)
    - Slightly more complex correction flow, and client must understand the concept of linked transactions
    - Accepted because immutability guarantees a complete audit trial, eliminates the failure mode of partial in-place updates corrupting balances, and follows standard accouting practice
- Synchronous balance update vs Eventual consistency
  - Chose synchronous balance updates withing the same DB transaction as entry insert.
  - Balances are always consistent with the transaction history
  - Trade-off:
    - Write latency is higher because the database transaction includes both inserts and balance updates with row-level locks
    - Accepted because correct balances are a core promise of a money system and the write volume (under 1000/day) doesn't justify the complexity of an async consistency model

## 9. What I'm not sure about

- Concurrent balance updates - is SELECT FOR UPDATE enough?
  - Unsure how to handle deadlocks when two transactions lock accounts in opposite order. Options: always lock accounts in a deterministic order (lower ID first) to prevent deadlocks entirely, or let Postgres detect deadlocks and retry at the application level. Haven't decided which approach is simpler to implement correctly.
- Balance non-negativity - where to enforce it?
  - Unsure whether to enforce balance-non-negativity at the database level (CHECK constraint — bulletproof but poor error messages and hard to vary by account type) or application level (flexible but bypassable). Leaning toward application-level with a nightly reconciliation check as a safety net.
- What happens to balances when a transaction is reversed?
  - Unsure whether account balances should be stored and updated incrementally (faster, but a single bug can cause permanent drift) or computed on the fly from the sum of all active entries (always correct, but slower as transaction count grows). Could also store both and reconcile — but that adds complexity.
- Should the background report job lock the data it's reading?
  - Unsure whether the monthly report job needs a consistent snapshot of the month's transactions. If a user creates a transaction while the job is running, the report might include some effects but not others. Options: run the report inside a REPEATABLE READ transaction (consistent snapshot but holds resources longer), or only generate reports for the previous month and assume the current month is still in flux.
  - I think if the report job for the last month will run at the first day of next month, we should be good
- How to handle the 99% availability target on a single server?
  - Unsure if 99% availability is achievable on a single self-hosted Postgres instance without automated failover. A managed service (like AWS RDS) gives automatic failover but costs more and adds vendor dependency. Need to decide whether the v1 architecture assumes managed Postgres or self-hosted.

## 10. v1 Cut Line

- What's in v1?<br>
  1. Create account (with type: asset/liability/income/expense)
  2. List accounts with balances
  3. Create categories
  4. List categories
  5. Create transaction (with entries, zero-sum validation, atomic balance update)
  6. List transactions (with pagination, date range filter, category filter)
  7. Delete transaction (Reverse transaction)
  8. Monthly report (Background job, pre-computed spending by category and income vs expenses)
