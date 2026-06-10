# Ledger - Design doc v1

## 1. Problem and Scope

- Mostpersonal finance apps are either automate everything via bank integration and low accuracy and privacy, or a pure spreadsheets that don't enforce balance integrity.
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

- Scalability will be important than consistency, because for v1 we don't support account sharing, we should expect 100 users and on average 10 transactions/user which means around 1000 transactions/day
- Availability, System should be highly available (99%)

## 7. Failure Modes

1. DB unreachable, request failed and return 500 status code
2. Background jobs crashed, send an alert email or message
3. Request sent with wrong schema in payload, should return 400 Bad request and mention the error

## 8. Explicit Trade-offs Made

- Database: Postgresql
  - We have relational data
  - We choose Postgresql over MySQL because data integrity is someting crucial, so we need ACID of Postgresql
- Programming Language: Java, secure and scalable and good for fintech applications

## 9. What I'm not sure about

- Non-functional requirement and numbers
- How the Trade-offs is made
- How to choose the right security methods and the security requirements

## 10. v1 Cut Line

- What's in v1?<br>
  1. Add transaction
  2. Edit transaction
  3. Retrieve all transactions per month
  4. Delete a transaction
  5. Add Account
  6. Delete account
  7. Rename account
  8. Add Category
  9. Rename Category
  10. Delete Category
  11. Reconciliation for the balances at night
  12. Monthly generated report

- What's in v2?<br>
  1. Shared accounts
  2. Upload CSV file of transactions
  3. Export CSV file of transactions (per month and all)
  4. Homepage with overview dashboard of the current/selected month transactions/expenses
  5. Audit or logging mechanism
