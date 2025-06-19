<%-- 
    Document   : product-detail
    Created on : Jun 16, 2025, 1:38:39 PM
    Author     : PC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm - Hoa yêu thương</title>
    <link rel="stylesheet" href="css/product-detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <%
        String productId = request.getParameter("id");
        // Static product data for FrontEnd
        String productName = "Bó hoa hồng đỏ";
        double productPrice = 250000;
        String productImage = "images/product_01.jpg";
        String productDescription = "Bó hoa hồng đỏ rực rỡ, biểu tượng của tình yêu và sự đam mê. Phù hợp cho các dịp đặc biệt như sinh nhật, kỷ niệm.";
        String flowerTypes = "Hoa hồng đỏ, hoa baby, lá phụ";
        
        // Simulate different products based on ID
        if ("2".equals(productId)) {
            productName = "Giỏ hoa tulip";
            productPrice = 300000;
            productImage = "images/product_02.jpg";
            productDescription = "Giỏ hoa tulip tươi sáng, mang đến sự vui tươi và thanh lịch. Lý tưởng cho các buổi tiệc hoặc quà tặng.";
            flowerTypes = "Hoa tulip, hoa cẩm chướng, lá phụ";
        } else if ("3".equals(productId)) {
            productName = "Lãng hoa lily";
            productPrice = 280000;
            productImage = "images/product_03.jpg";
            productDescription = "Lãng hoa lily thanh tao, tượng trưng cho sự tinh khiết và sang trọng. Phù hợp cho các sự kiện trang trọng.";
            flowerTypes = "Hoa lily, hoa hồng trắng, lá phụ";
        } else if ("4".equals(productId)) {
            productName = "Hoa để bàn lan hồ điệp";
            productPrice = 350000;
            productImage = "images/product_04.jpg";
            productDescription = "Chậu hoa lan hồ điệp tinh tế, mang đến vẻ đẹp lâu dài và phong cách. Thích hợp để trang trí bàn làm việc hoặc phòng khách.";
            flowerTypes = "Lan hồ điệp, lá trang trí";
        }
    %>

    <div class="breadcrumb">
        <div class="container">
            <a href="index.jsp">Trang chủ</a> > 
            <a href="gallery.jsp">Bộ sưu tập</a> > 
            <span><%= productName %></span>
        </div>
    </div>

    <section class="product-detail">
        <div class="container">
            <div class="product-detail-content">
                <div class="product-images">
                    <div class="main-image">
                        <img src="<%= productImage %>" alt="<%= productName %>">
                    </div>
                </div>
                
                <div class="product-info">
                    <h1><%= productName %></h1>
                    <div class="price">
                        <span class="current-price"><%= String.format("%,.0f", productPrice) %> VNĐ</span>
                    </div>
                    
                    <div class="rating-summary">
                        <div class="stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <span class="rating-text">(5.0 - 24 đánh giá)</span>
                    </div>
                    
                    <div class="product-description">
                        <h3>Mô tả sản phẩm</h3>
                        <p><%= productDescription %></p>
                    </div>
                    
                    <div class="flower-types">
                        <h3>Loại hoa sử dụng</h3>
                        <p><%= flowerTypes %></p>
                    </div>
                    
                    <div class="quantity-selector">
                        <label for="quantity">Số lượng:</label>
                        <div class="quantity-controls">
                            <button type="button" onclick="decreaseQuantity()">-</button>
                            <input type="number" id="quantity" value="1" min="1" max="99">
                            <button type="button" onclick="increaseQuantity()">+</button>
                        </div>
                    </div>
                    
                    <div class="action-buttons">
                        <button class="add-to-cart-btn" onclick="addToCart('<%= productId %>')">
                            <i class="fas fa-shopping-cart"></i>
                            Thêm vào giỏ hàng
                        </button>
                        <button class="buy-now-btn" onclick="buyNow('<%= productId %>')">
                            <i class="fas fa-bolt"></i>
                            Mua ngay
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="related-products">
        <div class="container">
            <h2>Sản phẩm liên quan</h2>
            <div class="related-grid">
                <!-- Static Related Product 1 -->
                <div class="related-item">
                    <div class="product-image">
                        <a href="product-detail.jsp?id=2">
                            <img src="images/product_01.jpg" alt="Giỏ hoa tulip">
                        </a>
                    </div>
                    <div class="product-info">
                        <h4><a href="product-detail.jsp?id=2">Giỏ hoa tulip</a></h4>
                        <span class="price">300,000 VNĐ</span>
                        <div class="rating">
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                        </div>
                    </div>
                </div>
                <!-- Static Related Product 2 -->
                <div class="related-item">
                    <div class="product-image">
                        <a href="product-detail.jsp?id=3">
                            <img src="images/product_02.jpg" alt="Lãng hoa lily">
                        </a>
                    </div>
                    <div class="product-info">
                        <h4><a href="product-detail.jsp?id=3">Lãng hoa lily</a></h4>
                        <span class="price">280,000 VNĐ</span>
                        <div class="rating">
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                        </div>
                    </div>
                </div>
                <!-- Static Related Product 3 -->
                <div class="related-item">
                    <div class="product-image">
                        <a href="product-detail.jsp?id=4">
                            <img src="images/product_04.jpg" alt="Hoa để bàn lan hồ điệp">
                        </a>
                    </div>
                    <div class="product-info">
                        <h4><a href="product-detail.jsp?id=4">Hoa để bàn lan hồ điệp</a></h4>
                        <span class="price">350,000 VNĐ</span>
                        <div class="rating">
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <div class="footer-info">
                <h3>FlowerLover</h3>
                <p>Địa chỉ: 68 Nguyễn Chí Thanh, Phường Láng Thượng, Quận Đống Đa, TP Hà Nội</p>
                <p>Số điện thoại: (028) 1234-5678</p>       
                <p>Giờ mở cửa: 8:00 - 20:00 (Thứ 2 - Chủ Nhật)</p>
                <p>Email: contact@flowerlover.com</p>
            </div>
        </div>
        <div class="footer-copyright">
            &copy; 2025 FlowerLover. All Rights Reserved.
            <a href="#" class="scroll-top">Lên đầu trang <i class="fas fa-arrow-up"></i></a>
        </div>
    </footer>

    <script>
        function increaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const currentValue = parseInt(quantityInput.value);
            if (currentValue < 99) {
                quantityInput.value = currentValue + 1;
            }
        }
        
        function decreaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const currentValue = parseInt(quantityInput.value);
            if (currentValue > 1) {
                quantityInput.value = currentValue - 1;
            }
        }
        
        function addToCart(productId) {
            const quantity = document.getElementById('quantity').value;
            window.location.href = 'AddToCartServlet?productId=' + productId + '&quantity=' + quantity;
        }
        
        function buyNow(productId) {
            const quantity = document.getElementById('quantity').value;
            window.location.href = 'form.jsp?productId=' + productId + '&quantity=' + quantity;
        }
    </script>
</body>
</html>