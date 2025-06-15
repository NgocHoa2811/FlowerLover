
CREATE DATABASE IF NOT EXISTS flowerlover;
USE flowerlover;
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL
);
INSERT IGNORE INTO users (email, password, role) VALUES
('admin@flowerlover.com', 'admin123', 'admin'),
('customer@flowerlover.com', 'customer123', 'customer');
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    image_url VARCHAR(255) NOT NULL
);
INSERT IGNORE INTO products (name, price, image_url) VALUES
('Bó hoa hồng đỏ', 500000, 'images/product_1.jpg'),
('Bó hoa cúc trắng', 300000, 'images/product_2.jpg'),
('Bó hoa tulip vàng', 450000, 'images/product_3.jpg'),
('Bó hoa lan tím', 600000, 'images/product_4.jpg'),
('Bó hoa lan vàng', 600000, 'images/product_5.jpg');
CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    author VARCHAR(255) NOT NULL
);
INSERT IGNORE INTO reviews (content, author) VALUES
('Dịch vụ giao hoa rất nhanh, hoa tươi và đẹp. Tôi rất hài lòng!', 'Nguyễn An'),
('Hoa được gói rất đẹp, giao đúng giờ. Sẽ tiếp tục ủng hộ!', 'Trần Bình'),
('Nhân viên rất nhiệt tình, hỗ trợ tôi chọn hoa phù hợp. Cảm ơn nhiều!', 'Lê Minh');

-- Tạo bảng orders (đơn hàng)
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    address TEXT NOT NULL,
    message TEXT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Kiểm tra dữ liệu
SELECT * FROM users;
SELECT * FROM products;
SELECT * FROM reviews;
SELECT * FROM orders;
