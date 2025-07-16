# README

This application shows how we can develop a simple web application to perform some ledger operations.

## Some assumptions
- Since we don't have authentication for now, I'm assuming that we always manage the same account. All calls might have whatever id you want, but internally we'll be using "dummy".
- We're assuming that a transaction just have the type of operation, amount (always positive values) and timestamp.

Requisites
- Ruby 3.4.4 must be installed. Use ```rbenv``` and set Ruby 3.4.4 as default. It can be installed using the OS package manager (eg. Mac OS ```brew```).

## How to run the application
```bash
/bin/run
```

This script will handle dependencies, migrations and the startup procedure on any environment. There is a SQLite file being created but it won't be used in any circumstance for now.

## Available operations/endpoints
- `GET /accounts/:id/balance`  
  Returns the current balance of the account with the given `id`.

- `POST /accounts/:id/deposit`  
  Deposits a specified amount into the account with the given `id`.  
  **Parameters (JSON body):**  
    - `amount`: The amount to deposit.

- `POST /accounts/:id/withdraw`  
  Withdraws a specified amount from the account with the given `id`.  
  **Parameters (JSON body):**  
    - `amount`: The amount to withdraw.

- `GET /accounts/:id/transactions`  
  Returns a list of transactions for the account with the given `id`.

You can find stub requests for these endpoints in the following Postman collection:  
https://gist.github.com/jrrbarros/128430040ea8fa138081251f6ded8765

## Run examples

Here are some example scenarios showing both successful operations and error cases:

### Run 1: Basic Account Operations Flow
```bash
# 1. Check initial balance
GET /accounts/dummy/balance
# Response: 200 OK - 0

# 2. Make first deposit
POST /accounts/dummy/deposit
Content-Type: application/json
{
  "amount": 100
}
# Response: 200 OK

# 3. Check updated balance
GET /accounts/dummy/balance
# Response: 200 OK - 100

# 4. Make a withdrawal
POST /accounts/dummy/withdraw
Content-Type: application/json
{
  "amount": 30
}
# Response: 200 OK

# 5. Check final balance
GET /accounts/dummy/balance
# Response: 200 OK - 70

# 6. View transaction history
GET /accounts/dummy/transactions
# Response: 200 OK - [{"type":"deposit","amount":100,"timestamp":"..."},{"type":"withdrawal","amount":30,"timestamp":"..."}]
```

### Run 2: Error Handling and Recovery
```bash
# 1. Check current balance
GET /accounts/dummy/balance
# Response: 200 OK - 70

# 2. Try to withdraw more than available (should fail)
POST /accounts/dummy/withdraw
Content-Type: application/json
{
  "amount": 100
}
# Response: 400 Bad Request - {"error":"Withdrawal amount must be up to current balance"}

# 3. Try invalid deposit amount (should fail)
POST /accounts/dummy/deposit
Content-Type: application/json
{
  "amount": -10
}
# Response: 400 Bad Request - {"error":"Deposit amount must be greater than 0"}

# 4. Make valid deposit to recover
POST /accounts/dummy/deposit
Content-Type: application/json
{
  "amount": 50
}
# Response: 200 OK

# 5. Verify balance is updated
GET /accounts/dummy/balance
# Response: 200 OK - 120
```

### Run 3: Multiple Operations and Balance Tracking
```bash
# 1. Start with current balance
GET /accounts/dummy/balance
# Response: 200 OK - 120

# 2. Series of deposits
POST /accounts/dummy/deposit
Content-Type: application/json
{
  "amount": 25
}
# Response: 200 OK

POST /accounts/dummy/deposit
Content-Type: application/json
{
  "amount": 15
}
# Response: 200 OK

# 3. Check intermediate balance
GET /accounts/dummy/balance
# Response: 200 OK - 160

# 4. Series of withdrawals
POST /accounts/dummy/withdraw
Content-Type: application/json
{
  "amount": 40
}
# Response: 200 OK

POST /accounts/dummy/withdraw
Content-Type: application/json
{
  "amount": 20
}
# Response: 200 OK

# 5. Final balance check
GET /accounts/dummy/balance
# Response: 200 OK - 100

# 6. Complete transaction history
GET /accounts/dummy/transactions
# Response: 200 OK - [{"type":"deposit","amount":100,"timestamp":"..."},{"type":"withdrawal","amount":30,"timestamp":"..."},{"type":"deposit","amount":50,"timestamp":"..."},{"type":"deposit","amount":25,"timestamp":"..."},{"type":"deposit","amount":15,"timestamp":"..."},{"type":"withdrawal","amount":40,"timestamp":"..."},{"type":"withdrawal","amount":20,"timestamp":"..."}]
```

### Run 4: Edge Cases and Validation
```bash
# 1. Check current state
GET /accounts/dummy/balance
# Response: 200 OK - 100

# 2. Try deposit with zero amount (should fail)
POST /accounts/dummy/deposit
Content-Type: application/json
{
  "amount": 0
}
# Response: 400 Bad Request - {"error":"Deposit amount must be greater than 0"}

# 3. Try withdrawal with zero amount (should fail)
POST /accounts/dummy/withdraw
Content-Type: application/json
{
  "amount": 0
}
# Response: 400 Bad Request - {"error":"Withdrawal amount must be greater than 0"}

# 4. Try deposit without amount parameter (should fail)
POST /accounts/dummy/deposit
Content-Type: application/json
{
  "description": "Missing amount"
}
# Response: 400 Bad Request - {"error":"Amount parameter is required"}

# 5. Successful operations after errors
POST /accounts/dummy/deposit
Content-Type: application/json
{
  "amount": 200
}
# Response: 200 OK

POST /accounts/dummy/withdraw
Content-Type: application/json
{
  "amount": 150
}
# Response: 200 OK

# 6. Final verification
GET /accounts/dummy/balance
# Response: 200 OK - 150

GET /accounts/dummy/transactions
# Response: 200 OK - [Previous transactions + {"type":"deposit","amount":200,"timestamp":"..."},{"type":"withdrawal","amount":150,"timestamp":"..."}]
```