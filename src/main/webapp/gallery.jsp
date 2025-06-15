<%-- 
    Document   : gallery
    Created on : Apr 22, 2025, 8:20:58 PM
    Author     : PC
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bộ sưu tập - Hoa yêu thương</title>
    <link rel="stylesheet" href="css/gallery.css">
</head>
<body>
    <div class="header">
        <a href="index.jsp" class="logo">FlowerLover</a>
        <div class="nav">
            <a href="index.jsp">Trang chủ</a>
            <a href="features.jsp">Tính năng</a>
            <a href="gallery.jsp" class="active">Bộ sưu tập</a>
            <a href="delivery.jsp">Giao hàng</a>
            <a href="reviews.jsp">Đánh giá</a>
            <a href="form.jsp">Biểu mẫu</a>
            <a href="login.jsp">Đăng nhập </a>
        </div>
        <a href="#contact" class="contact-btn">Liên hệ</a>
    </div>
    
    <section class="gallery-banner">
        <h1>Bộ sưu tập hoa tươi</h1>
        <p>Khám phá những sản phẩm hoa tươi độc đáo và đẹp mắt của chúng tôi</p>
    </section>
    
    <section class="gallery-nav">
        <div class="container">
            <div class="category-buttons">
                <button class="category-btn active" data-category="all">Tất cả</button>
                <button class="category-btn" data-category="roses">Bó hoa</button>
                <button class="category-btn" data-category="tulips">Giỏ hoa</button>
                <button class="category-btn" data-category="lilies">Lẵng hoa</button>
                <button class="category-btn" data-category="orchids">Hoa để bàn</button>
                <button class="category-btn" data-category="wedding">Bó hoa cưới</button>

            </div>
        </div>
    </section>
    
    <section class="product-gallery">
        <div class="container">
            <div class="product-grid">
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/flowerlover", "root", "ngocHoa2811@");
                        String sql = "SELECT * FROM products";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        ResultSet rs = stmt.executeQuery();
                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String name = rs.getString("name");
                            double price = rs.getDouble("price");
                            String imageUrl = rs.getString("image_url");
                %>            
                            <div class="product-card">
                                <div class="product-image">
                                    <img src="<%= imageUrl %>" alt="<%= name %>">
                                    <div class="overlay">
                                        <a href="AddToCartServlet?productId=<%= id %>" class="add-to-cart">Mua ngay</a>
                                    </div>
                                </div>
                                <div class="product-info">
                                    <h3><%= name %></h3>
                                    <p class="price"><%= String.format("%,.0f", price) %> VNĐ</p>
                                    <div class="rating">
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                        <span class="star">★</span>
                                    </div>
                                </div>
                            </div>
                <%
                        }
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p>Đã xảy ra lỗi khi tải sản phẩm:" + e.getMessage()+ "</p>");
                    }
                %>
            </div>
        </div>
    </section>
    
    <section class="cta-section">
        <div class="container">
            <div class="cta-content">
                <h2>Bạn muốn tạo một bó hoa độc đáo?</h2>
                <p>Liên hệ với chúng tôi để được tư vấn và thiết kế bó hoa theo ý của bạn.</p>
                <a href="form.jsp" class="cta-btn">Liên hệ ngay</a>
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
            document.addEventListener('DOMContentLoaded', function() {
            const categoryButtons = document.querySelectorAll('.category-btn');
            const productCards = document.querySelectorAll('.product-card');

            categoryButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Remove active class from all buttons
                    categoryButtons.forEach(btn => btn.classList.remove('active'));

                    // Add active class to clicked button
                    this.classList.add('active');

                    // Get category from data attribute
                    const category = this.getAttribute('data-category');

                    // Filter products based on category
                    productCards.forEach(card => {
                        const productName = card.querySelector('h3').textContent.toLowerCase();

                        if (category === 'all') {
                            card.style.display = 'block';
                        } else if (category === 'roses' && productName.includes('bó hoa')) {
                            card.style.display = 'block';
                        } else if (category === 'tulips' && productName.includes('giỏ hoa')) {
                            card.style.display = 'block';
                        } else if (category === 'lilies' && productName.includes('lẵng hoa')) {
                            card.style.display = 'block';
                        } else if (category === 'orchids' && productName.includes('hoa để bàn')) {
                            card.style.display = 'block';
                        } else if (category === 'wedding' && productName.includes('bó hoa cưới')) {
                            card.style.display = 'block';
                        } else {
                            card.style.display = 'none';
                        }
                    });
                });
            });
        });
    </script>
</body>
</html>