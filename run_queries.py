import os
import sqlite3
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "task3_ecommerce.db"
OUTPUT_DIR = BASE_DIR / "outputs"

SELECT_QUERIES = [
    (
        "01_completed_orders",
        "Completed Orders",
        """
        SELECT order_id, customer_id, order_date, status
        FROM orders
        WHERE status = 'Completed';
        """,
    ),
    (
        "02_products_by_price",
        "Products Sorted By Price",
        """
        SELECT product_name, category, price
        FROM products
        ORDER BY price DESC;
        """,
    ),
    (
        "03_revenue_by_category",
        "Revenue By Category",
        """
        SELECT
            p.category,
            ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
        FROM order_items AS oi
        INNER JOIN products AS p ON oi.product_id = p.product_id
        INNER JOIN orders AS o ON oi.order_id = o.order_id
        WHERE o.status = 'Completed'
        GROUP BY p.category
        ORDER BY total_revenue DESC;
        """,
    ),
    (
        "04_inner_join_customer_orders",
        "Inner Join: Customer Orders",
        """
        SELECT
            c.customer_name,
            c.city,
            o.order_id,
            o.order_date,
            p.amount
        FROM customers AS c
        INNER JOIN orders AS o ON c.customer_id = o.customer_id
        INNER JOIN payments AS p ON o.order_id = p.order_id
        WHERE o.status = 'Completed'
        ORDER BY o.order_date;
        """,
    ),
    (
        "05_left_join_completed_orders",
        "Left Join: Completed Orders Per Customer",
        """
        SELECT
            c.customer_name,
            COUNT(o.order_id) AS completed_orders
        FROM customers AS c
        LEFT JOIN orders AS o
            ON c.customer_id = o.customer_id
            AND o.status = 'Completed'
        GROUP BY c.customer_id, c.customer_name
        ORDER BY completed_orders DESC;
        """,
    ),
    (
        "06_right_join_product_sales",
        "Right Join: Product Sales Quantity",
        """
        SELECT
            p.product_name,
            COALESCE(SUM(oi.quantity), 0) AS total_quantity_sold
        FROM order_items AS oi
        RIGHT JOIN products AS p
            ON oi.product_id = p.product_id
        GROUP BY p.product_id, p.product_name
        ORDER BY total_quantity_sold DESC;
        """,
    ),
    (
        "07_subquery_customers_above_average",
        "Subquery: Customers Above Average Order Amount",
        """
        SELECT
            c.customer_name,
            ROUND(SUM(pay.amount), 2) AS total_spent
        FROM customers AS c
        INNER JOIN orders AS o ON c.customer_id = o.customer_id
        INNER JOIN payments AS pay ON o.order_id = pay.order_id
        WHERE o.status = 'Completed'
        GROUP BY c.customer_id, c.customer_name
        HAVING SUM(pay.amount) > (
            SELECT AVG(amount)
            FROM payments
        );
        """,
    ),
    (
        "08_average_revenue_per_user",
        "Average Revenue Per User",
        """
        SELECT
            ROUND(SUM(pay.amount) * 1.0 / COUNT(DISTINCT o.customer_id), 2)
                AS average_revenue_per_user
        FROM orders AS o
        INNER JOIN payments AS pay ON o.order_id = pay.order_id
        WHERE o.status = 'Completed';
        """,
    ),
    (
        "09_having_categories_above_100",
        "Having: Categories With Revenue Above $100",
        """
        SELECT
            p.category,
            ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
        FROM order_items AS oi
        INNER JOIN products AS p ON oi.product_id = p.product_id
        INNER JOIN orders AS o ON oi.order_id = o.order_id
        WHERE o.status = 'Completed'
        GROUP BY p.category
        HAVING SUM(oi.quantity * oi.unit_price) > 100
        ORDER BY revenue DESC;
        """,
    ),
    (
        "10_customer_order_summary_view",
        "View: Customer Order Summary",
        """
        SELECT customer_name, city, completed_orders, total_spent
        FROM customer_order_summary
        ORDER BY total_spent DESC;
        """,
    ),
]


def run_sql_script(connection, script_path):
    with open(script_path, "r", encoding="utf-8") as file:
        connection.executescript(file.read())


def format_table(columns, rows):
    text_rows = [[str(value) for value in row] for row in rows]
    widths = [
        max(len(str(column)), *(len(row[index]) for row in text_rows))
        for index, column in enumerate(columns)
    ]
    header = " | ".join(str(column).ljust(widths[index]) for index, column in enumerate(columns))
    divider = "-+-".join("-" * width for width in widths)
    body = [
        " | ".join(row[index].ljust(widths[index]) for index in range(len(columns)))
        for row in text_rows
    ]
    return "\n".join([header, divider, *body])


def save_output_image(title, table_text, output_path):
    font_path = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf"
    title_font_path = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf"
    font = ImageFont.truetype(font_path, 22)
    title_font = ImageFont.truetype(title_font_path, 26)
    lines = [title, "", table_text]
    split_lines = []
    for block in lines:
        split_lines.extend(block.splitlines() or [""])

    padding = 32
    line_height = 32
    text_widths = [
        ImageDraw.Draw(Image.new("RGB", (1, 1))).textbbox(
            (0, 0),
            line,
            font=title_font if index == 0 else font,
        )[2]
        for index, line in enumerate(split_lines)
    ]
    width = max(1000, min(1800, max(text_widths) + padding * 2))
    height = padding * 2 + len(split_lines) * line_height

    image = Image.new("RGB", (width, height), "#ffffff")
    draw = ImageDraw.Draw(image)
    y = padding
    for index, line in enumerate(split_lines):
        fill = "#111111" if index == 0 else "#222222"
        draw.text((padding, y), line, fill=fill, font=title_font if index == 0 else font)
        y += line_height
    image.save(output_path)


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    if DB_PATH.exists():
        DB_PATH.unlink()

    connection = sqlite3.connect(DB_PATH)
    connection.row_factory = sqlite3.Row
    run_sql_script(connection, BASE_DIR / "schema_and_data.sql")
    run_sql_script(connection, BASE_DIR / "queries.sql")

    for file_stem, title, sql in SELECT_QUERIES:
        cursor = connection.execute(sql)
        rows = cursor.fetchall()
        columns = [description[0] for description in cursor.description]
        table_text = format_table(columns, rows)
        print(f"\n{title}\n{table_text}")
        save_output_image(title, table_text, OUTPUT_DIR / f"{file_stem}.png")

    connection.close()


if __name__ == "__main__":
    main()
