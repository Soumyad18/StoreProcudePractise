CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  price NUMERIC(10, 2) NOT NULL,
  stock INT NOT NULL DEFAULT 0
);

TRUNCATE TABLE products RESTART IDENTITY;

INSERT INTO products (name, category, price, stock) VALUES
  ('Apple', 'Fruit', 1.20, 100),
  ('Banana', 'Fruit', 0.80, 120),
  ('Tomato', 'Vegetable', 2.00, 80);

DROP PROCEDURE IF EXISTS add_product(VARCHAR, VARCHAR, NUMERIC, INT, INT);
CREATE OR REPLACE PROCEDURE add_product(
  IN p_name VARCHAR(100),
  IN p_category VARCHAR(50),
  IN p_price NUMERIC(10,2),
  IN p_stock INT,
  INOUT p_new_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO products(name, category, price, stock)
  VALUES (p_name, p_category, p_price, p_stock)
  RETURNING id INTO p_new_id;
END;
$$;

DROP PROCEDURE IF EXISTS get_product_count_by_category(VARCHAR, INT);
CREATE OR REPLACE PROCEDURE get_product_count_by_category(
  IN p_category VARCHAR(50),
  INOUT p_count INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  SELECT COUNT(*) INTO p_count
  FROM products
  WHERE category = p_category;
END;
$$;

DROP FUNCTION IF EXISTS list_products_by_category(VARCHAR);
CREATE OR REPLACE FUNCTION list_products_by_category(
  p_category VARCHAR(50)
)
RETURNS TABLE (
  id INT,
  name VARCHAR(100),
  category VARCHAR(50),
  price NUMERIC(10,2),
  stock INT
)
LANGUAGE sql
AS $$
  SELECT p.id, p.name, p.category, p.price, p.stock
  FROM products p
  WHERE p.category = p_category
  ORDER BY p.id;
$$;
