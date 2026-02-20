CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  stock INT NOT NULL DEFAULT 0
);

TRUNCATE TABLE products;

INSERT INTO products (name, category, price, stock) VALUES
  ('Apple', 'Fruit', 1.20, 100),
  ('Banana', 'Fruit', 0.80, 120),
  ('Tomato', 'Vegetable', 2.00, 80);

DROP PROCEDURE IF EXISTS add_product;
DELIMITER $$
CREATE PROCEDURE add_product(
  IN p_name VARCHAR(100),
  IN p_category VARCHAR(50),
  IN p_price DECIMAL(10,2),
  IN p_stock INT,
  OUT p_new_id INT
)
BEGIN
  INSERT INTO products(name, category, price, stock)
  VALUES (p_name, p_category, p_price, p_stock);

  SET p_new_id = LAST_INSERT_ID();
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS get_product_count_by_category;
DELIMITER $$
CREATE PROCEDURE get_product_count_by_category(
  IN p_category VARCHAR(50),
  OUT p_count INT
)
BEGIN
  SELECT COUNT(*) INTO p_count
  FROM products
  WHERE category = p_category;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS list_products_by_category;
DELIMITER $$
CREATE PROCEDURE list_products_by_category(
  IN p_category VARCHAR(50)
)
BEGIN
  SELECT id, name, category, price, stock
  FROM products
  WHERE category = p_category
  ORDER BY id;
END$$
DELIMITER ;
