# Ledger - Design doc v1

## 1. Problem and Scope

- This system helps individuals with personal money/expenses tracking and finance, where
  user can add transactions in double-entry format mentioning money went from a specific account to another to help with tracking the money and also adding a user-defined resuable categories with each transaction so user can know what it was used for. Also providing a monthly report for all transactions at the end of each month.
- Out of scope for v1: shared accounts and CSV import

## 2. Users and Use cases

- User call adding transaction enpoint, to insert a new double-entry transaction with a category.
- User call edit transaction endpoint, to edit an already existing transaction.
- User call delete transaction endpoint, to delete an already existing transaction.
- User call view transactions endpoint, to display all existing transactions.
- User call add/edit/delete account, to create, edit or delete an account.
- User call add/edit/delete account, to create, edit or delete an account.

## 3. API Contract

=> Base url: /api/v1

- GET: /transactions <br>
  **response**: {
  data:[
  {
  "id": "xxxxxx",
  "from_account": "xxxxx",
  "to_account": "xxxxx",
  "category": "XXXXX",
  "value": xxx.xxx
  }
  , ....]
  }, 200 OK

- POST: /transactions <br>
  **request**: {
  transaction: {
  "from_account_id": "xx",
  "to_account_id": "xx",
  "category_id": "xx",
  "value": xx.xx
  }
  }

  **response**: {
  transaction: {
  "id": "xx",
  "from_account_id": "xx",
  "to_account_id": "xx",
  "category_id": "xx",
  "value": xx.xx
  }
  }, 201 created

- PUT: /transactions/{transactionId} NOTE: We can use PATCH

  **request**: {
  transaction: {
  "id": "xx",
  "from_account_id": "xx",
  "to_account_id": "xx",
  "category_id": "xx",
  "value": xxy.xx
  }
  }

  **response**: {
  transaction: {
  "id": "xx",
  "from_account_id": "xx",
  "to_account_id": "xx",
  "category_id": "xx",
  "value": xxy.xx
  }
  }, 200 ok

- DELETE: /transactions/{transactionId}

- GET: /categories

- POST: /categories

- PUT: /categories/{categoryId}

- DELETE: /categories/{categoryId}

- GET: /accounts

- POST: /accounts

## 4. Data Model

- User: [id: INT NOTNULL PK, name: varchar UNIQUE, user_id: INT FK]
- Category: [id: INT NOTNULL PK, name: varchar UNIQUE, user_id: INT FK]
- Transaction: [id: INT NOTNULL PK, from_account_id: INT FK, to_account_id: INT FK, category_id: INT FK, value: Big decimal]
- User: [id: INT NOTNULL PK, first_name: varchar, last_name: varchar]

## 5. Key Flows

- Create a transaction:<br>
  1.User login <br>
  2.User send POST request (with request body contain data)<br>
  3.Request is validated in backend, balance is correct and data matches schema<br>
  4.Transaction request sent to DB to insert new data
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
  5.User send a PUT/PATCH request with transaction id as path variable and content as body<br>
  6.Request is validated that balance is correct and data matches schema<br>
  7.DB Transaction request sent to DB to update the modified transaction<br>
  8.Send response to User that the update was successfull<br>

## 6. Non-Functional requirements

- Scalability will be important than consistency, because for v1 we don't support account sharing, we should expect 100 users and on average 10 transactions/user which means around 1000 transactions/day
- Availability, System should be highly available (99%)

## 7. Failure Modes

1. DB unreachable, request failed and return 500 status code
2. Background jobs crashed, send an alert email or message
3. Request sent with wrong schema in payload, should return 400 Bad request and mention the error

## 8. Explicit Trade-offs Made

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
