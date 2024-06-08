
-- Drop existing tables if they exist to avoid conflicts
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS ordered_products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS shippings;

-- Creating the products table
CREATE TABLE products(
    product_pk          TEXT UNIQUE,
    product_name        TEXT,
    product_description TEXT,
    product_price       INTEGER,
    product_stock       INTEGER,
    category_fk         TEXT,
    PRIMARY KEY (product_pk)
    FOREIGN KEY (category_fk) REFERENCES categories(category_pk)
) WITHOUT ROWID;

-- Inserting data into the products table
INSERT INTO products (product_pk, product_name, product_description, product_price, product_stock) VALUES
    ('1', 'Product 1', 'Description of product 1', 10.99, 100),
    ('2', 'Product 2', 'Description of product 2', 20.0, 200),
    ('3', 'Product 3', 'Description of product 3', 30.0, 300),
    ('4', 'Product 4', 'Description of product 4', 40.0, 400),
    ('5', 'Product 5', 'Description of product 5', 50.0, 500);

SELECT * FROM products ORDER BY product_price ASC;

-- Creating the categories table
CREATE TABLE categories(
    category_pk     TEXT UNIQUE,
    category_name   TEXT,
    PRIMARY KEY (category_pk)
) WITHOUT ROWID;

INSERT INTO categories(category_pk, category_name) VALUES
('1', 'Category1'),
('2', 'Category2'),
('3', 'Category3'),
('4', 'Category4'),
('5', 'Category5'),
('6', 'Category6');

SELECT * FROM categories;

-- Orders table
CREATE TABLE orders(
    order_pk        TEXT UNIQUE,
    customer_fk     TEXT,
    order_date      TEXT,
    order_amount    REAL,
    order_status    TEXT,
    
    PRIMARY KEY (order_pk),
    FOREIGN KEY (customer_fk) REFERENCES customers(customer_pk)
) WITHOUT ROWID;

INSERT INTO orders (order_pk, customer_fk, order_date, order_amount, order_status) VALUES
    ('1001', '1', '2024-02-23', 1500, 'Shipped'),
    ('1002', '2', '2024-02-22', 800, 'Processing'),
    ('1003', '3', '2024-02-21', 3000, 'Delivered'),
    ('1004', '4', '2024-02-20', 500, 'Pending');

SELECT * FROM orders;

-- Ordered_products table
CREATE TABLE ordered_products(
    order_item_pk   TEXT,
    order_fk        TEXT,
    product_fk      TEXT,
    order_quantity  INTEGER,
    unit_price      INTEGER,
    PRIMARY KEY (order_item_pk),
    FOREIGN KEY (order_fk) REFERENCES orders(order_pk),
    FOREIGN KEY (product_fk) REFERENCES products(product_pk)
) WITHOUT ROWID;

INSERT INTO ordered_products (order_item_pk, order_fk, product_fk, order_quantity, unit_price) VALUES
    ('20001', '1001', '1', 2, 900),
    ('20002', '1001', '4', 1, 2000), 
    ('20003', '1002', '2', 1, 1200), 
    ('20004', '1002', '3', 3, 150),
    ('20005', '1003', '5', 2, 300), 
    ('20006', '1003', '8', 1, 100), 
    ('20007', '1004', '9', 1, 1000), 
    ('20008', '1004', '10', 2, 80); 

SELECT * FROM ordered_products;

-- Creating the customers table
CREATE TABLE customers(
    customer_pk         TEXT UNIQUE,
    customer_name       TEXT,
    customer_email      TEXT UNIQUE,
    customer_address    TEXT,
    customer_phone      TEXT,
    PRIMARY KEY (customer_pk)
) WITHOUT ROWID;

INSERT INTO customers(customer_pk, customer_name, customer_email, customer_address, customer_phone) VALUES
    ('1', 'customerName1', 'customer1@email.com', 'address1', '111'),
    ('2', 'customerName2', 'customer2@email.com', 'address2', '222'),
    ('3', 'customerName3', 'customer3@email.com', 'address3', '333'),
    ('4', 'customerName4', 'customer4@email.com', 'address4', '444'),
    ('5', 'customerName5', 'customer5@email.com', 'address5', '555'),
    ('6', 'customerName6', 'customer6@email.com', 'address6', '666'),
    ('7', 'customerName7', 'customer7@email.com', 'address7', '777'),
    ('8', 'customerName8', 'customer8@email.com', 'address8', '888'),
    ('9', 'customerName9', 'customer9@email.com', 'address9', '999');

-- Creating the payments table

CREATE TABLE payments(
    payment_pk      TEXT UNIQUE,
    order_fk        TEXT,
    payment_date    TEXT,
    payment_amount  REAL,
    payment_method  TEXT,
    PRIMARY KEY (payment_pk),
    FOREIGN KEY (order_fk) REFERENCES orders(order_pk)
) WITHOUT ROWID;

INSERT INTO payments (payment_pk, order_fk, payment_date, payment_amount, payment_method) VALUES
    ('2001', '1001', '2024-02-24', 1500, 'Credit Card'),
    ('2002', '1002', '2024-02-23', 800, 'PayPal'),
    ('2003', '1003', '2024-02-22', 3000, 'Bank Transfer'),
    ('2004', '1004', '2024-02-21', 500, 'Cash');

SELECT * FROM payments;

-- Creating the shippings table
CREATE TABLE shippings(
    shipping_pk         TEXT UNIQUE,
    order_fk            TEXT,
    shipping_date       TEXT CURRENT_TIMESTAMP,
    shipping_address    TEXT,
    shipping_status     TEXT,
    PRIMARY KEY (shipping_pk),
    FOREIGN KEY (order_fk) REFERENCES orders(order_pk)
) WITHOUT ROWID;

INSERT INTO shippings (shipping_pk, order_fk, shipping_date, shipping_address, shipping_status) VALUES
    ('3001', '1001', '2024-02-25', 'address1', 'Shipped'),
    ('3002', '1002', '2024-02-24', 'address2', 'Processing'),
    ('3003', '1003', '2024-02-23', 'address3', 'Delivered'),
    ('3004', '1004', NULL, 'address4', 'Pending');

SELECT * FROM shippings;


-- JOIN

DROP VIEW IF EXISTS all_orders_view;
CREATE VIEW all_orders_view AS
SELECT
orders.order_pk,
orders.customer_fk,
orders.order_date,
orders.order_amount,
orders.order_status,
customers.customer_name,
customers.customer_email,
customers.customer_address,
customers.customer_phone,
GROUP_CONCAT(products.product_name, ', ') AS product_names, -- grouping products if there is more than one
shippings.shipping_date,
shippings.shipping_address,
shippings.shipping_status
FROM
    orders
JOIN
    customers ON orders.customer_fk = customers.customer_pk
JOIN
    ordered_products ON orders.order_pk = ordered_products.order_fk
JOIN
    products ON ordered_products.product_fk = products.product_pk
LEFT JOIN
    shippings ON orders.order_pk = shippings.order_fk
GROUP BY 
    orders.order_pk;

SELECT * FROM all_orders_view;




-- TRIGGERS
z




-- DROP TRIGGER IF EXISTS update_shipping_booking_fk;
-- CREATE TRIGGER update_shipping_booking_fk
-- AFTER INSERT ON orders
-- FOR EACH ROW
-- BEGIN
--     UPDATE shippings
--     SET order_fk = NEW.shipping_pk
--     WHERE order_pk = NEW.order_fk;
-- END;

-- INSERT INTO shippings(shipping_pk, customer_fk) VALUES('111', '222');


-- CRUD operations
INSERT INTO 
products (product_pk, product_name, product_description, product_price, product_stock) 
VALUES
('80', 'Product 80', 'Description of product 80', 10.99, 100);

-- READ
SELECT * FROM products ORDER BY product_price ASC;

-- UPDATE
UPDATE products  
SET product_price = 15.99
WHERE product_pk = '1';

-- DELETE 
DELETE FROM shippings
WHERE shipping_pk = 'SH1005';