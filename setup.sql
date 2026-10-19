
-- PostgreSQL Index Performance Lab
-- Creates a synthetic e-commerce orders table with 1 million rows.

DROP TABLE IF EXISTS index_lab_orders;

CREATE TABLE index_lab_orders (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    status TEXT NOT NULL
);

INSERT INTO index_lab_orders (
    customer_id,
    order_date,
    amount,
    status
)
SELECT
    ((gs - 1) % 10000 + 1)::INTEGER,
    DATE '2024-01-01' + ((gs - 1) % 730)::INTEGER,
    ROUND(
        10 + ((gs - 1) % 50000)::NUMERIC / 100,
        2
    ),
    CASE (gs - 1) % 4
        WHEN 0 THEN 'pending'
        WHEN 1 THEN 'shipped'
        WHEN 2 THEN 'delivered'
        ELSE 'cancelled'
    END
FROM generate_series(1, 1000000) AS gs;

ANALYZE index_lab_orders;

-- Verify row count and customer distribution.
SELECT COUNT(*) AS total_orders
FROM index_lab_orders;

SELECT customer_id, COUNT(*) AS orders
FROM index_lab_orders
WHERE customer_id = 4242
GROUP BY customer_id;
