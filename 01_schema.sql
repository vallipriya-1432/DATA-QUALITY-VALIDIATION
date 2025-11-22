--  data quality / validation project for e-commerce orders.
-- This script creates a schema and a raw staging table.

DROP SCHEMA IF EXISTS dq_ecommerce CASCADE;
CREATE SCHEMA dq_ecommerce;

SET search_path TO dq_ecommerce;

-- raw staging table: structure based on the train.csv dataset file.

CREATE TABLE stg_orders_raw (
    row_id        INT,
    order_id      TEXT,
    order_date    TEXT,
    ship_date     TEXT,
    ship_mode     TEXT,
    customer_id   TEXT,
    customer_name TEXT,
    segment       TEXT,
    country       TEXT,
    city          TEXT,
    state         TEXT,
    postal_code   TEXT,
    region        TEXT,
    product_id    TEXT,
    category      TEXT,
    sub_category  TEXT,
    product_name  TEXT,
    sales         TEXT
);
