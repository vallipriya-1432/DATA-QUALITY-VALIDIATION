SET search_path TO dq_ecommerce;

-- view to summarise basic DQ metrics
CREATE OR REPLACE VIEW v_data_quality_summary AS
SELECT
    (SELECT COUNT(*) FROM stg_orders_raw)    AS raw_rows,
    (SELECT COUNT(*) FROM orders_clean)      AS clean_rows,
    (SELECT COUNT(*) FROM orders_rejects)    AS rejected_rows,
    ROUND(
        100.0 * (SELECT COUNT(*) FROM orders_clean)
        / NULLIF((SELECT COUNT(*) FROM stg_orders_raw), 0),
        2
    ) AS acceptance_rate_pct,
    (SELECT COUNT(*) FROM (
        SELECT order_id FROM stg_orders_raw GROUP BY order_id HAVING COUNT(*) > 1
    ) d) AS duplicate_orders
;

-- view to list rejects with reason flags (simple rule indicators)
CREATE OR REPLACE VIEW v_rejects_with_flags AS
SELECT
    r.*,
    (r.order_id IS NULL OR r.order_id = '')                          AS missing_order_id,
    (r.customer_id IS NULL OR r.customer_id = '')                    AS missing_customer_id,
    (r.product_id IS NULL OR r.product_id = '')                      AS missing_product_id,
    (r.order_date IS NULL)                                           AS bad_order_date,
    (r.ship_date IS NULL OR r.ship_date < r.order_date)              AS bad_ship_date,
    (r.sales IS NULL OR r.sales < 0)                                 AS bad_sales
FROM orders_rejects r;
