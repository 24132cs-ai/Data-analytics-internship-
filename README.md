# Task 3: SQL for Data Analysis

## Objective
This project uses SQL queries to extract and analyze data from a small ecommerce database.

## Tool Used
- SQLite

## Dataset
I created a small ecommerce dataset with five tables:
- `customers`
- `products`
- `orders`
- `order_items`
- `payments`

## Files Included
- `schema_and_data.sql` - creates the database tables and inserts sample ecommerce data
- `queries.sql` - contains the SQL analysis queries
- `outputs/` - contains screenshots of selected query outputs
- `task3_ecommerce.db` - SQLite database file generated from the SQL scripts

## SQL Concepts Covered
- `SELECT`
- `WHERE`
- `ORDER BY`
- `GROUP BY`
- `INNER JOIN`
- `LEFT JOIN`
- `RIGHT JOIN`
- Subqueries
- Aggregate functions such as `SUM` and `AVG`
- Views
- Indexes for query optimization

## Key Analysis Done
1. Retrieved completed ecommerce orders.
2. Sorted products by price.
3. Calculated total revenue by product category.
4. Joined customers, orders, and payment records.
5. Counted completed orders for each customer.
6. Checked product sales quantity, including products not ordered.
7. Found customers who spent more than the average order amount.
8. Calculated average revenue per user.
9. Created and queried a customer summary view.
10. Added indexes to improve query performance.

## Interview Questions and Answers

### 1. What is the difference between WHERE and HAVING?
`WHERE` filters rows before grouping. `HAVING` filters grouped results after `GROUP BY`.

### 2. What are the different types of joins?
Common joins include `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and `FULL OUTER JOIN`.

### 3. How do you calculate average revenue per user in SQL?
Use total revenue divided by the number of unique users:

```sql
SELECT SUM(pay.amount) / COUNT(DISTINCT o.customer_id) AS arpu
FROM orders AS o
INNER JOIN payments AS pay
    ON o.order_id = pay.order_id;
```

### 4. What are subqueries?
A subquery is a query written inside another SQL query. It is used when one query depends on the result of another query.

### 5. How do you optimize a SQL query?
You can optimize a query by creating indexes, selecting only required columns, avoiding unnecessary joins, filtering early, and checking the query execution plan.

### 6. What is a view in SQL?
A view is a saved SQL query that behaves like a virtual table. It helps simplify repeated analysis.

### 7. How would you handle null values in SQL?
You can handle null values using functions like `COALESCE()` or by filtering them with `IS NULL` and `IS NOT NULL`.

## How to Run
If you have SQLite installed, run:

```bash
sqlite3 task3_ecommerce.db < schema_and_data.sql
sqlite3 task3_ecommerce.db < queries.sql
```

You can also open the `.db` file using DB Browser for SQLite and run the queries from `queries.sql`.
