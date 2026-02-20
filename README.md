# Stored Procedure Practice with Java (Hands-on)

This repository gives you a practical path to learn stored procedures from Java using JDBC.

## What you'll practice

1. Creating a schema and sample data.
2. Writing stored procedures with:
   - input parameters
   - output parameters
   - result sets
3. Calling procedures from Java using `CallableStatement`.
4. Running simple practice tasks to reinforce learning.

## Prerequisites

- Java 17+
- Maven 3.9+
- Docker (recommended for local MySQL)

## Quick start

### 1) Start MySQL with Docker

```bash
docker compose up -d
```

This starts MySQL on `localhost:3306` with:
- database: `store_practice`
- username: `app_user`
- password: `app_pass`

### 2) Initialize tables + procedures

```bash
mysql -h 127.0.0.1 -P 3306 -u app_user -papp_pass store_practice < sql/01_schema_and_procedures.sql
```

### 3) Run Java demo

```bash
mvn -q exec:java
```

## Learning flow (recommended)

- **Step A**: Read `sql/01_schema_and_procedures.sql` and run each statement manually.
- **Step B**: Run `ProcedureDemo` and inspect output.
- **Step C**: Edit one procedure and re-run Java call.
- **Step D**: Add your own new procedure + corresponding Java method.

## Practice exercises

1. Add a procedure `get_products_by_price_range(min_price, max_price)` and call it from Java.
2. Add a procedure to update stock by product id and return updated stock as OUT parameter.
3. Add transaction logic in Java: call two procedures and rollback when second fails.
4. Add validation in SQL (e.g., do not allow negative price) and show Java error handling.

## File map

- `docker-compose.yml` → local MySQL setup
- `sql/01_schema_and_procedures.sql` → schema, data, and starter stored procedures
- `pom.xml` → Maven project config
- `src/main/java/dev/practice/ProcedureDemo.java` → JDBC stored procedure calls

If you want, we can next add a **Spring Boot version** of this same exercise using `JdbcTemplate` and integration tests.
