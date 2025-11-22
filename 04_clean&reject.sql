SET search_path TO dq_ecommerce;

--  parsed/typed staging
DROP TABLE IF EXISTS stg_orders_typed;
CREATE TABLE stg_orders_typed AS
SELECT
    row_id,
    order_id,

    -- order_date parsed safely
    CASE
        WHEN order_date ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(order_date, 'YYYY-MM-DD')
        WHEN order_date ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(order_date, 'DD/MM/YYYY')
        ELSE NULL
    END AS order_date,

    -- ship_date parsed safely
    CASE
        WHEN ship_date ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(ship_date, 'YYYY-MM-DD')
        WHEN ship_date ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(ship_date, 'DD/MM/YYYY')
        ELSE NULL
    END AS ship_date,

    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    CASE
        WHEN sales ~ '^[0-9]+(\.[0-9]+)?$' THEN sales::NUMERIC(12,2)
        ELSE NULL
    END AS sales
FROM stg_orders_raw;


--  reject table: rows that break any rule
DROP TABLE IF EXISTS orders_rejects;
CREATE TABLE orders_rejects AS
SELECT *
FROM stg_orders_typed
WHERE
    order_id IS NULL OR order_id = ''
 OR customer_id IS NULL OR customer_id = ''
 OR product_id IS NULL OR product_id = ''
 OR order_date IS NULL
 OR ship_date IS NULL
 OR ship_date < order_date
 OR sales IS NULL
 OR sales < 0;

--  clean table: everything else
DROP TABLE IF EXISTS orders_clean;
CREATE TABLE orders_clean AS
SELECT *
FROM stg_orders_typed t
WHERE NOT EXISTS (
    SELECT 1
    FROM orders_rejects r
    WHERE r.row_id = t.row_id
);

--  add a simple primary key to the clean table (optional, for later usage)
ALTER TABLE orders_clean
    ADD PRIMARY KEY (row_id);