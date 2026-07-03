-- Task 3: SQL for Data Analysis
-- Dataset: Small Ecommerce SQLite Database

-- 1. SELECT + WHERE: completed orders only
SELECT
    order_id,
    customer_id,
    order_date,
    status
FROM orders
WHERE status = 'Completed';

-- 2. ORDER BY: products sorted by price from highest to lowest
SELECT
    product_name,
    category,
    price
FROM products
ORDER BY price DESC;

-- 3. GROUP BY + aggregate: total revenue by product category
SELECT
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
INNER JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 4. INNER JOIN: customer details with their completed orders
SELECT
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date,
    p.amount
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN payments AS p
    ON o.order_id = p.order_id
WHERE o.status = 'Completed'
ORDER BY o.order_date;

-- 5. LEFT JOIN: show all customers, including customers without completed orders
SELECT
    c.customer_name,
    COUNT(o.order_id) AS completed_orders
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
    AND o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY completed_orders DESC;

-- 6. RIGHT JOIN: show all products, including products that were not ordered
SELECT
    p.product_name,
    COALESCE(SUM(oi.quantity), 0) AS total_quantity_sold
FROM order_items AS oi
RIGHT JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC;

-- 7. Subquery: customers who spent more than the average order amount
SELECT
    c.customer_name,
    ROUND(SUM(pay.amount), 2) AS total_spent
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN payments AS pay
    ON o.order_id = pay.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name
HAVING SUM(pay.amount) > (
    SELECT AVG(amount)
    FROM payments
);

-- 8. AVG: average revenue per user for completed orders
SELECT
    ROUND(SUM(pay.amount) * 1.0 / COUNT(DISTINCT o.customer_id), 2) AS average_revenue_per_user
FROM orders AS o
INNER JOIN payments AS pay
    ON o.order_id = pay.order_id
WHERE o.status = 'Completed';

-- 9. HAVING: categories with revenue above $100
SELECT
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
INNER JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
HAVING SUM(oi.quantity * oi.unit_price) > 100
ORDER BY revenue DESC;

-- 10. Create a view for analysis
DROP VIEW IF EXISTS customer_order_summary;

CREATE VIEW customer_order_summary AS
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS completed_orders,
    ROUND(COALESCE(SUM(pay.amount), 0), 2) AS total_spent
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
    AND o.status = 'Completed'
LEFT JOIN payments AS pay
    ON o.order_id = pay.order_id
GROUP BY c.customer_id, c.customer_name, c.city;

-- 11. Query the view
SELECT
    customer_name,
    city,
    completed_orders,
    total_spent
FROM customer_order_summary
ORDER BY total_spent DESC;

-- 12. Optimize queries with indexes
CREATE INDEX IF NOT EXISTS idx_orders_customer_id
    ON orders(customer_id);

CREATE INDEX IF NOT EXISTS idx_orders_status
    ON orders(status);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
    ON order_items(product_id);

