-- PRAGMA foreign_keys = ON;

SELECT * FROM products;
SELECT * FROM categories;
SELECT * FROM orders;
SELECT * FROM ordered_products;
SELECT * FROM customers;
SELECT * FROM payments;
SELECT * FROM shippings;
SELECT * FROM all_orders_view;

UPDATE orders
SET order_amount = (
    SELECT SUM(p.product_price * op.order_quantity)
    FROM ordered_products op
    JOIN products p ON op.product_fk = p.product_pk
    WHERE op.order_fk = orders.order_pk
);

------- Products table --- DATA TABLE
DROP TABLE IF EXISTS products;
CREATE TABLE products(
    product_pk              TEXT UNIQUE,
    product_name            TEXT,
    product_description     TEXT,
    product_price           INTEGER,
    product_stock           INTEGER,
    category_fk             TEXT,
    PRIMARY KEY (product_pk)
    FOREIGN KEY (category_fk) REFERENCES categories(category_pk)
) WITHOUT ROWID;

DROP INDEX IF EXISTS index_products;
CREATE INDEX index_products
ON products (product_name);

------ INSERT INTO products table
INSERT INTO products (product_pk, product_name, product_description, product_price, product_stock, category_fk) VALUES
    ('1', 'Product 1', 'Description of product 1', 10.99, 100, '1'),
    ('2', 'Product 2', 'Description of product 2', 20.0, 200, '2'),
    ('3', 'Product 3', 'Description of product 3', 30.0, 300, '3'),
    ('4', 'Product 4', 'Description of product 4', 40.0, 400, '4'),
    ('5', 'Product 5', 'Description of product 5', 50.0, 500, '5');

SELECT * FROM products ORDER BY product_price ASC;


------ Categories table --- LOOKUP TABLE
DROP TABLE IF EXISTS categories;
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

------- Orders table ---- TRANSACTION TABLE
DROP TABLE IF EXISTS orders;    
CREATE TABLE orders(
    order_pk        TEXT UNIQUE,
    customer_fk     TEXT,
    order_amount    REAL DEFAULT 0.0,
    order_status    TEXT,
    order_date      TEXT DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (order_pk),
    FOREIGN KEY (customer_fk) REFERENCES customers(customer_pk)
) WITHOUT ROWID;

INSERT INTO orders (order_pk, customer_fk, order_status) VALUES
('1001', '1', 'Shipped'),
('1002', '2', 'Processing'),
('1003', '3', 'Delivered'),
('1004', '4', 'Pending'),
('1005', '1', 'Shipped');

SELECT * FROM orders;

------ Ordered_products table ---- JUNCTION TABLE
DROP TABLE IF EXISTS ordered_products;
CREATE TABLE ordered_products(
    order_item_pk       TEXT,
    order_fk            TEXT,
    product_fk          TEXT,
    order_quantity      INTEGER,
    PRIMARY KEY (order_item_pk),
    FOREIGN KEY (order_fk) REFERENCES orders(order_pk) ON DELETE CASCADE,
    FOREIGN KEY (product_fk) REFERENCES products(product_pk)
) WITHOUT ROWID;

INSERT INTO ordered_products (order_item_pk, order_fk, product_fk, order_quantity) VALUES
    ('20001', '1001', '1', 2),
    ('20003', '1002', '2', 1), 
    ('20005', '1003', '5', 2), 
    ('20008', '1004', '4', 2),
    ('20009', '1005', '2', 2); 


SELECT * FROM ordered_products;


DROP TABLE IF EXISTS customers;
------- Customers table --- DATA TABLE
CREATE TABLE customers(
    customer_pk         TEXT UNIQUE,
    customer_name       TEXT,
    customer_email      TEXT UNIQUE,
    customer_address    TEXT,
    customer_phones      TEXT,
    PRIMARY KEY (customer_pk)
) WITHOUT ROWID;

INSERT INTO customers(customer_pk, customer_name, customer_email, customer_address, customer_phones) VALUES
    ('1', 'customerName1', 'customer1@email.com', 'address1', '111, 222, 333'),
    ('2', 'customerName2', 'customer2@email.com', 'address1', '222'),
    ('3', 'customerName3', 'customer3@email.com', 'address3', '333'),
    ('4', 'customerName4', 'customer4@email.com', 'address4', '444'),
    ('5', 'customerName5', 'customer5@email.com', 'address5', '555'),
    ('6', 'customerName6', 'customer6@email.com', 'address6', '666'),
    ('7', 'customerName7', 'customer7@email.com', 'address7', '777'),
    ('8', 'customerName8', 'customer8@email.com', 'address8', '888'),
    ('9', 'customerName9', 'customer9@email.com', 'address9', '999');

SELECT * FROM customers;

---------- Payments table --- TRANSACTION TABLE
DROP TABLE IF EXISTS payments;
CREATE TABLE payments(
    payment_pk          TEXT UNIQUE,
    order_fk            TEXT,
    payment_date        TEXT DEFAULT CURRENT_TIMESTAMP,
    payment_amount      INTEGER,
    payment_method      TEXT,
    PRIMARY KEY (payment_pk),
    FOREIGN KEY (order_fk) REFERENCES orders(order_pk) ON DELETE CASCADE
) WITHOUT ROWID;

INSERT INTO payments (payment_pk, order_fk, payment_amount, payment_method) VALUES
('2001', '1001', (SELECT order_amount FROM orders WHERE order_pk = '1001'), 'Credit Card'),
('2002', '1002', (SELECT order_amount FROM orders WHERE order_pk = '1002'), 'PayPal'),
('2003', '1003', (SELECT order_amount FROM orders WHERE order_pk = '1003'), 'Bank Transfer'),
('2004', '1004', (SELECT order_amount FROM orders WHERE order_pk = '1004'), 'Cash'),
('2005', '1005', (SELECT order_amount FROM orders WHERE order_pk = '1005'), 'Credit Card');

SELECT * FROM payments;

DROP TABLE IF EXISTS shippings;
-- Shippings table ---- DATA TABLE
CREATE TABLE shippings(
    shipping_pk         TEXT UNIQUE,
    order_fk            TEXT,
    shipping_date       TEXT,
    shipping_address    TEXT,
    shipping_status     TEXT,
    created_at          TEXT DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (shipping_pk),
    FOREIGN KEY (order_fk) REFERENCES orders(order_pk)
) WITHOUT ROWID;

INSERT INTO shippings (shipping_pk, order_fk, shipping_date, shipping_address, shipping_status) VALUES
    ('3001', '1001', '2024-02-25', 'address1', 'Shipped'),
    ('3002', '1002', '2024-02-24', 'address2', 'Processing'),
    ('3003', '1003', '2024-02-23', 'address3', 'Delivered'),
    ('3004', '1004', '2025-02-26', 'address4', 'Pending'),
    ('3005', '1005', '2024-02-25', 'address1', 'Shipped');

SELECT * FROM shippings;


-- JOIN
-- VIEW
-- LEFT JOIN / VIEW
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
customers.customer_phones,
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

-- INNER JOIN
SELECT 
    orders.order_pk, 
    orders.order_date, 
    products.product_name, 
    customers.customer_name
FROM 
    orders
JOIN 
    customers ON orders.customer_fk = customers.customer_pk
JOIN 
    ordered_products ON orders.order_pk = ordered_products.order_fk
JOIN 
    products ON ordered_products.product_fk = products.product_pk
WHERE 
    orders.order_status = 'Delivered';

-- CROSS JOIN product ratings and customers. does not make very much sense tho 
DROP TABLE IF EXISTS product_ratings;
CREATE TABLE product_ratings (
  rating_pk             TEXT,
  customer_fk           TEXT,
  product_fk            TEXT,
  rating                INTEGER,
  comment               TEXT,
  PRIMARY KEY(rating_pk),
  FOREIGN KEY (customer_fk) REFERENCES customers(customer_pk),
  FOREIGN KEY (product_fk) REFERENCES products(product_pk)
);

INSERT INTO product_ratings (rating_pk, customer_fk, product_fk, rating, comment) VALUES
('1', '1', '1', 5, 'Loved the phone, very responsive!'),
('2', '1', '2', 4, 'Great laptop but a bit heavy.'),
('3', '2', '5', 3, 'Expected more features.'),
('4', '3', '3', 2, 'Sound quality not up to the mark.'),
('5', '4', '6', 5, 'Excellent tablet, great for my needs!');

SELECT * FROM product_ratings;

SELECT
  c.customer_name,
  c.customer_email,
  pr.product_fk,
  pr.rating,
  pr.comment
FROM
  customers c
CROSS JOIN
  product_ratings pr;


-- CROSS JOIN FOR PRODUCTS AND ORDERS - too see every possible combination of an order and a product
SELECT
  p.product_name,
  p.product_description,
  p.product_price,
  o.order_pk,
  o.order_date,
  o.order_amount,
  o.order_status
FROM
  products p
CROSS JOIN
  orders o;


-- SELF JOIN
DROP TABLE IF EXISTS customer_same_address;

CREATE TABLE customer_same_address AS
SELECT 
    A.customer_name AS Customer1, 
    B.customer_name AS Customer2, 
    A.customer_address
FROM 
    customers A 
JOIN 
    customers B 
ON 
    A.customer_address = B.customer_address AND A.customer_pk <> B.customer_pk;

SELECT * FROM customer_same_address;



---- TRIGGERS

-- UDATES STOCK WHEN INSERTING NEW ROW INTO ordered_products
CREATE TRIGGER IF NOT EXISTS update_product_stock
AFTER INSERT ON ordered_products
    BEGIN
        UPDATE products
        SET product_stock = product_stock - NEW.order_quantity
        WHERE product_pk = NEW.product_fk;
    END;

INSERT INTO ordered_products (order_item_pk, order_fk, product_fk, order_quantity)
VALUES ('101', '1001', '1', 5);

SELECT product_pk, product_name, product_description, product_price, product_stock
FROM products
WHERE product_pk = '1';

SELECT * FROM ordered_products;


------------STATUS LOG-----------
--Log table for order status changes
DROP TABLE IF EXISTS order_status_changes;
CREATE TABLE order_status_changes(
    log_pk              INTEGER PRIMARY KEY AUTOINCREMENT,
    order_fk            TEXT,
    old_status          TEXT,
    new_status          TEXT,
    created_at          TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_fk) REFERENCES orders(order_pk)
);


CREATE TRIGGER IF NOT EXISTS trigger_order_status_changes
AFTER UPDATE OF order_status ON orders
WHEN OLD.order_status != NEW.order_status
BEGIN
    INSERT INTO order_status_changes (order_fk, old_status, new_status)
    VALUES (NEW.order_pk, OLD.order_status, NEW.order_status);
END;

INSERT INTO orders (order_pk, customer_fk, order_date, order_status)
VALUES ('228', '1', '2024-02-23', 'Pending');

UPDATE orders
SET order_status = 'Shipped' 
WHERE order_pk = '228';

SELECT * FROM order_status_changes;




-- CRUD
INSERT INTO 
products (product_pk, product_name, product_description, product_price, product_stock, category_fk) 
VALUES
('80', 'Product 80', 'Description of product 80', 10.99, 100,);


-- UNION 
SELECT
    product_name,
    product_price AS amount, 
    'product price' AS source
FROM products
UNION ALL
SELECT 
    payment_method AS product_name,
    payment_amount AS amount, 
    'payment amount' AS source
FROM payments;

-- GROUP BY
-- count numbers of orders
SELECT customer_fk, COUNT(*) AS number_of_orders
FROM orders
GROUP BY customer_fk;
-- count total money spent by each customer
SELECT customer_fk, SUM(order_amount) AS total_spent
FROM orders
GROUP BY customer_fk;


-- HAVING 
-- customers with more than 1 order 
SELECT customer_fk, COUNT(*) AS number_of_orders
FROM orders
GROUP BY customer_fk
HAVING COUNT (*) > 1;

---- FULL TEXT SEARCH
DROP TABLE IF EXISTS products_fts;
DROP TABLE IF EXISTS customers_fts;

CREATE VIRTUAL TABLE products_fts USING FTS5(product_name, product_description);
CREATE VIRTUAL TABLE customers_fts USING FTS5(customer_name, customer_email);

INSERT INTO products_fts (product_name, product_description)
SELECT product_name, product_description FROM products;

INSERT INTO customers_fts (customer_name, customer_email)
SELECT customer_name, customer_email FROM customers;

SELECT * FROM products_fts WHERE products_fts MATCH 'Product 4'; 

SELECT * FROM products_fts WHERE products_fts MATCH 'Product 1';
SELECT * FROM customers_fts WHERE customers_fts MATCH 'customerName1';



-- READ
SELECT * FROM products ORDER BY product_price ASC;

SELECT * FROM products WHERE product_stock < 100;

-- UPDATE
UPDATE products  
SET product_price = 15.99
WHERE product_pk = '1';

-- DELETE 
DELETE FROM products
WHERE product_pk = '80';