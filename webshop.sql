
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
    product_price       REAL,
    product_stock       INTEGER,
    PRIMARY KEY (product_pk)
) WITHOUT ROWID;

-- Inserting data into the products table
INSERT INTO products (product_pk, product_name, product_description, product_price, product_stock) VALUES
    ('1', 'Product 1', 'Description of product 1', 10.0, 100),
    ('2', 'Product 2', 'Description of product 2', 20.0, 200),
    ('3', 'Product 3', 'Description of product 3', 30.0, 300),
    ('4', 'Product 4', 'Description of product 4', 40.0, 400),
    ('5', 'Product 5', 'Description of product 5', 50.0, 500);

-- Creating the categories table
CREATE TABLE categories(
    category_pk     TEXT UNIQUE,
    category_name   TEXT,
    PRIMARY KEY (category_pk)
) WITHOUT ROWID;

-- Creating the orders table
CREATE TABLE orders(
    order_pk        TEXT UNIQUE,
    customer_fk     TEXT,
    order_date      TEXT,
    order_amount    REAL,
    order_status    TEXT,
    PRIMARY KEY (order_pk),
    FOREIGN KEY (customer_fk) REFERENCES customers(customer_pk)
) WITHOUT ROWID;

-- Creating the ordered_products table
CREATE TABLE ordered_products(
    order_item_pk   TEXT UNIQUE,
    order_fk        TEXT,
    product_fk      TEXT,
    order_quantity  INTEGER,
    unit_price      REAL,
    PRIMARY KEY (order_item_pk),
    FOREIGN KEY (order_fk) REFERENCES orders(order_pk),
    FOREIGN KEY (product_fk) REFERENCES products(product_pk)
) WITHOUT ROWID;

-- Creating the customers table
CREATE TABLE customers(
    customer_pk         TEXT UNIQUE,
    customer_name       TEXT,
    customer_email      TEXT,
    customer_address    TEXT,
    customer_phone      TEXT,
    PRIMARY KEY (customer_pk)
) WITHOUT ROWID;

INSERT INTO customers(customer_pk, customer_name, customer_email, customer_address, customer_phone) VALUES
    ('1', 'customerName1', 'customer1@email.com', 'adress1', '111'),
    ('2', 'customerName2', 'customer2@email.com', 'adress2', '111'),
    ('3', 'customerName3', 'customer3@email.com', 'adress3', '111'),
    ('4', 'customerName4', 'customer4@email.com', 'adress4', '111'),
    ('5', 'customerName5', 'customer5@email.com', 'adress5', '111'),
    ('6', 'customerName6', 'customer6@email.com', 'adress6', '111'),
    ('7', 'customerName7', 'customer7@email.com', 'adress7', '111'),
    ('8', 'customerName8', 'customer8@email.com', 'adress8', '111'),
    ('9', 'customerName9', 'customer9@email.com', 'adress9', '111');

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

-- Creating the shippings table
CREATE TABLE shippings(
    shipping_pk         TEXT UNIQUE,
    order_fk            TEXT,
    shipping_date       TEXT,
    shipping_address    TEXT,
    shipping_status     TEXT,
    PRIMARY KEY (shipping_pk),
    FOREIGN KEY (order_fk) REFERENCES orders(order_pk)
) WITHOUT ROWID;

-- Query to display products after insertion
SELECT * FROM products;
SELECT * FROM customers;




-- TRIGGERS
CREATE TRIGGER IF NOT EXISTS after_order_insert
AFTER INSERT ON orders
BEGIN
    -- Assuming you want to set default values for these fields
    INSERT INTO shippings (shipping_pk, order_fk, shipping_date, shipping_address, shipping_status)
    VALUES ('SH' || NEW.order_pk, NEW.order_pk, 'Not yet shipped', 'Address not set', 'Pending');
END;

INSERT INTO orders (order_pk, customer_fk, order_date, order_amount, order_status)
VALUES ('1005', '1', '2024-05-01', 2500, 'Processing');

SELECT * FROM after_order_insert;