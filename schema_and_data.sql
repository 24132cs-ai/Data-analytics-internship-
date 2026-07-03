DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    city TEXT NOT NULL,
    signup_date TEXT NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    price REAL NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    payment_method TEXT NOT NULL,
    amount REAL NOT NULL,
    payment_date TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO customers (customer_id, customer_name, city, signup_date) VALUES
(1, 'Aarav Kumar', 'Singapore', '2025-01-10'),
(2, 'Maya Tan', 'Jurong', '2025-02-14'),
(3, 'Daniel Lim', 'Tampines', '2025-03-08'),
(4, 'Priya Nair', 'Woodlands', '2025-04-22'),
(5, 'Sophia Lee', 'Singapore', '2025-05-05'),
(6, 'Hafiz Rahman', 'Bedok', '2025-06-18');

INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Wireless Mouse', 'Electronics', 25.00),
(2, 'Bluetooth Speaker', 'Electronics', 65.00),
(3, 'Notebook Set', 'Stationery', 12.00),
(4, 'Desk Lamp', 'Home', 38.00),
(5, 'Water Bottle', 'Lifestyle', 18.00),
(6, 'Laptop Stand', 'Electronics', 45.00),
(7, 'Planner 2026', 'Stationery', 16.00);

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(101, 1, '2026-01-05', 'Completed'),
(102, 2, '2026-01-07', 'Completed'),
(103, 1, '2026-01-12', 'Cancelled'),
(104, 3, '2026-01-18', 'Completed'),
(105, 4, '2026-02-01', 'Completed'),
(106, 5, '2026-02-08', 'Completed'),
(107, 2, '2026-02-14', 'Completed'),
(108, 6, '2026-02-20', 'Pending'),
(109, 3, '2026-03-02', 'Completed');

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 101, 1, 2, 25.00),
(2, 101, 3, 3, 12.00),
(3, 102, 2, 1, 65.00),
(4, 103, 5, 2, 18.00),
(5, 104, 4, 1, 38.00),
(6, 104, 6, 1, 45.00),
(7, 105, 2, 2, 65.00),
(8, 106, 5, 4, 18.00),
(9, 107, 1, 1, 25.00),
(10, 107, 6, 2, 45.00),
(11, 108, 3, 5, 12.00),
(12, 109, 4, 2, 38.00),
(13, 109, 2, 1, 65.00);

INSERT INTO payments (payment_id, order_id, payment_method, amount, payment_date) VALUES
(1, 101, 'Card', 86.00, '2026-01-05'),
(2, 102, 'PayNow', 65.00, '2026-01-07'),
(3, 103, 'Card', 36.00, '2026-01-12'),
(4, 104, 'Card', 83.00, '2026-01-18'),
(5, 105, 'PayNow', 130.00, '2026-02-01'),
(6, 106, 'Cash', 72.00, '2026-02-08'),
(7, 107, 'Card', 115.00, '2026-02-14'),
(8, 108, 'PayNow', 60.00, '2026-02-20'),
(9, 109, 'Card', 141.00, '2026-03-02');

