
-- PostgreSQL Index Performance Lab
-- Run each section separately and save its EXPLAIN output.

-- 1. Baseline: run before creating the customer_id index.
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, order_date, amount, status
FROM index_lab_orders
WHERE customer_id = 4242;


-- 2. Create the index and refresh planner statistics.
CREATE INDEX idx_orders_customer_id
ON index_lab_orders (customer_id);

ANALYZE index_lab_orders;


-- 3. Indexed test: run with normal planner settings.
SHOW enable_seqscan;

EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, order_date, amount, status
FROM index_lab_orders
WHERE customer_id = 4242;


-- 4. Optional diagnostic.
-- This is NOT the normal benchmark.
-- It discourages sequential scans to inspect an alternative plan.

SET enable_seqscan = off;

EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, order_date, amount, status
FROM index_lab_orders
WHERE customer_id = 4242;

RESET enable_seqscan;
