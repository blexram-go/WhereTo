# WhereTo Backend Setup

This guide will walk you through setting up the WhereTo backend on your local machine.

## Prerequisites

Make sure you have the following installed:

- Go
- PostgreSQL 15+
- Git
- Goose Migration Tool

---

## 1. Install PostgreSQL

If PostgreSQL is not already installed:

```bash
brew install postgresql@15
```

Start the PostgreSQL service:

```bash
brew services start postgresql@15
```

Verify the installation:

```bash
psql --version
```

---

## 2. Create the Database

Open PostgreSQL:

```bash
psql postgres
```

Create the project database:

```sql
CREATE DATABASE whereto;
```

Connect to the database:

```sql
\c whereto
```

Exit PostgreSQL:

```sql
\q
```

---

## 3. Install Goose

Install Goose if you don't already have it:

```bash
go install github.com/pressly/goose/v3/cmd/goose@latest
```

If the `goose` command is not found, add your Go binaries to your PATH:

```bash
export PATH=$PATH:$(go env GOPATH)/bin
```

Verify Goose is installed:

```bash
goose -version
```

---

## 4. Run Database Migrations

From the backend directory, execute:

```bash
goose -dir db/migrations postgres "user=<YOUR_MAC_USERNAME> dbname=whereto sslmode=disable" up
```

Example:

```bash
goose -dir db/migrations postgres "user=brianramos dbname=whereto sslmode=disable" up
```

Verify the migrations were applied:

```bash
psql whereto
```

Inside PostgreSQL:

```sql
\dt
```

Expected output:

```
goose_db_version
users
```

Exit:

```sql
\q
```

---

## 5. Configure Environment Variables

Create a `.env` file in the backend root directory.

Example:

```env
PORT=8080

WEATHER_API_KEY=YOUR_WEATHER_API_KEY

GOOGLE_PLACES_API_KEY=YOUR_GOOGLE_PLACES_API_KEY

DATABASE_URL=postgres://YOUR_USERNAME@localhost/whereto?sslmode=disable
```

Example:

```env
DATABASE_URL=postgres://brianramos@localhost/whereto?sslmode=disable
```

> **Note:** Replace `YOUR_USERNAME` with your macOS username and supply your own API keys.

---

## 6. Install Go Dependencies

```bash
go mod tidy
```

---

## 7. Start the Backend

Run the server:

```bash
go run ./cmd/server/main.go
```

Expected output:

```
Connected to PostgreSQL
Starting server on port 8080
```

---

# Testing the API

## Health Check

```bash
curl localhost:8080/api/v1/health
```

---

## Register a User

```bash
curl -X POST localhost:8080/api/v1/register \
-H "Content-Type: application/json" \
-d '{
  "username":"alexis",
  "email":"alexis@example.com",
  "password":"password123"
}'
```

Expected response:

```json
{
  "message": "user registered successfully"
}
```

---

## Login

```bash
curl -X POST localhost:8080/api/v1/login \
-H "Content-Type: application/json" \
-d '{
  "email":"alexis@example.com",
  "password":"password123"
}'
```

Expected response:

```json
{
  "message": "login successful"
}
```

---

## Verify User Creation

Open PostgreSQL:

```bash
psql whereto
```

Run:

```sql
SELECT id, username, email, created_at
FROM users;
```

You should see the registered user stored in the database.

---

# Updating Your Database

Whenever new database migrations are added:

1. Pull the latest changes:

```bash
git pull
```

2. Apply any pending migrations:

```bash
goose -dir db/migrations postgres "user=<YOUR_MAC_USERNAME> dbname=whereto sslmode=disable" up
```

Goose will automatically apply only the migrations that have not already been run.

---

# Project Architecture

```
cmd/
└── server/

db/
└── migrations/

internal/
├── config/
├── database/
├── handlers/
├── middleware/
├── models/
├── repository/
└── services/
```

The backend follows a layered architecture:

```
HTTP Request
      │
      ▼
Handler
      │
      ▼
Service
      │
      ▼
Repository
      │
      ▼
PostgreSQL
```

This separation keeps business logic, persistence, and HTTP concerns isolated, making the project easier to test and maintain.
