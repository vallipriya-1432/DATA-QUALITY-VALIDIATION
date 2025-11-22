SET search_path TO dq_ecommerce;

-- a few sample rows: some good, some with issues on purpose
INSERT INTO stg_orders_raw VALUES
-- good row
(1,'CA-2018-100001','2018-11-12','2018-11-14','Second Class','C-001','Alice Ray','Consumer',
 'United States','New York City','New York','10001','East','P-001','Office Supplies','Storage',
 'Stacking Shelf','250.50'),

-- ship date before order date (bad)
(2,'CA-2018-100002','2018-11-15','2018-11-14','Standard Class','C-002','Bob Chen','Corporate',
 'United States','Seattle','Washington','98101','West','P-002','Furniture','Chairs',
 'Office Chair','300.00'),

-- invalid date format (bad order date)
(3,'CA-2018-100003','15/11/2018','2018-11-20','Second Class','C-003','Cathy Li','Home Office',
 'United States','Austin','Texas','73301','Central','P-003','Technology','Phones',
 'Desk Phone','120.00'),

-- missing customer_id and negative sales
(4,'CA-2018-100004','2018-11-16','2018-11-18','First Class',NULL,'David King','Consumer',
 'United States','Chicago','Illinois','60601','Central','P-004','Office Supplies','Binders',
 'Ring Binder','-50.00'),

-- duplicate order_id with slightly different data
(5,'CA-2018-100002','2018-11-15','2018-11-16','Standard Class','C-002','Bob Chen','Corporate',
 'United States','Seattle','Washington','98101','West','P-002','Furniture','Chairs',
 'Office Chair','300.00'),

-- blank product_id and non-numeric sales
(6,'CA-2018-100005','2018-11-17','2018-11-19','Standard Class','C-005','Ella Stone','Consumer',
 'United States','Boston','Massachusetts','02108','East','','Office Supplies','Paper',
 'Copy Paper','N/A');
