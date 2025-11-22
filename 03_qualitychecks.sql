SET search_path TO dq_ecommerce;

WITH parsed AS (
    SELECT
        row_id,
        order_id,

        -- safely parse order_date
        CASE
            WHEN order_date ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(order_date, 'YYYY-MM-DD')
            WHEN order_date ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(order_date, 'DD/MM/YYYY')
            ELSE NULL
        END AS order_dt,

        -- safely parse ship_date
        CASE
            WHEN ship_date ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(ship_date, 'YYYY-MM-DD')
            WHEN ship_date ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(ship_date, 'DD/MM/YYYY')
            ELSE NULL
        END AS ship_dt,

        sales,
        customer_id,
        product_id
    FROM stg_orders_raw
)

-- 1) count of rows that fail the basic date parsing
SELECT 'bad_dates' AS check_name,
       COUNT(*)    AS issue_count
FROM parsed
WHERE order_dt IS NULL
   OR ship_dt IS NULL
UNION ALL

-- 2) ship date before order date
SELECT 'ship_before_order' AS check_name,
       COUNT(*) AS issue_count
FROM parsed
WHERE order_dt IS NOT NULL
  AND ship_dt  IS NOT NULL
  AND ship_dt < order_dt
UNION ALL

-- 3) missing key fields (order_id, customer_id, product_id)
SELECT 'missing_keys' AS check_name,
       COUNT(*) AS issue_count
FROM stg_orders_raw
WHERE order_id IS NULL
   OR order_id = ''
   OR customer_id IS NULL
   OR customer_id = ''
   OR product_id IS NULL
   OR product_id = ''
UNION ALL

-- 4) non-numeric or negative sales
SELECT 'bad_sales' AS check_name,
       COUNT(*) AS issue_count
FROM stg_orders_raw
WHERE sales IS NULL
   OR sales = ''
   OR sales !~ '^[0-9]+(\.[0-9]+)?$'
   OR sales::NUMERIC < 0
UNION ALL

-- 5) duplicate order_ids in raw
SELECT 'duplicate_order_ids' AS check_name,
       COUNT(*) AS issue_count
FROM (
    SELECT order_id
    FROM stg_orders_raw
    GROUP BY order_id
    HAVING COUNT(*) > 1
) d;
