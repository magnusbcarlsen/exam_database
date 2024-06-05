DROP TABLE IF EXISTS products;

CREATE TABLE products(
    product_pk          TEXT UNIQUE,
    product_name        TEXT,
    product_description TEXT,
    product_price       REAL,
    product_stock       INTEGER,
    PRIMARY KEY (product_pk)
) WITHOUT ROWID;

INSERT INTO products (product_pk, product_name, product_description, product_price, product_stock) VALUES
    ('1', 'Product 1', 'Description of product 1', 10.0, 100),
    ('2', 'Product 2', 'Description of product 2', 20.0, 200),
    ('3', 'Product 3', 'Description of product 3', 30.0, 300),
    ('4', 'Product 4', 'Description of product 4', 40.0, 400),
    ('5', 'Product 5', 'Description of product 5', 50.0, 500);

SELECT * FROM products;