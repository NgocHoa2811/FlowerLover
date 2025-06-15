-- Tạo cơ sở dữ liệu
CREATE DATABASE flower_shop;
USE flower_shop;

-- Tạo bảng sản phẩm (products)
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    image VARCHAR(255),
    description TEXT
);

-- Tạo bảng đơn hàng (orders) để lưu thông tin bán hàng
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Thêm dữ liệu mẫu vào bảng products
INSERT INTO products (name, price, image, description) VALUES
('Hoa hồng đỏ', 150000, 'images/baner.jpg', 'Hoa hồng đỏ tươi, biểu tượng của tình yêu.'),
('Hoa cúc trắng', 100000, 'images/baner.jpg', 'Hoa cúc trắng tinh khôi, phù hợp cho tang lễ.'),
('Hoa hướng dương', 120000, 'images/baner.jpg', 'Hoa hướng dương rực rỡ, mang lại năng lượng tích cực.');

-- Thêm dữ liệu mẫu vào bảng orders
INSERT INTO orders (product_id, quantity) VALUES
(1, 5),  -- 5 bó hoa hồng đỏ
(2, 3),  -- 3 bó hoa cúc trắng
(3, 2);  -- 2 bó hoa hướng dương