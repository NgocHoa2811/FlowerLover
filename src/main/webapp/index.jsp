<%-- 
    Document   : index
    Created on : Mar 26, 2025, 1:17:23 PM
    Author     : PC
--%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt"%> 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hoa yêu thương - Dịch vụ giao hoa tại Hà Nội</title>
    <link rel="stylesheet" href="css/index.css">
</head>
<body>
    <%
        // Kiểm tra vai trò người dùng
        String role = (String) session.getAttribute("role");
        if ("admin".equals(role)) {
            response.sendRedirect("admin-dashboard.jsp");
        }
    %>
    <!-- Header -->
    <header>
        <div class="container">
            <nav>
                <a href="#" class="logo">FlowerLover</a>
                <ul class="menu">
                    <a href="index.jsp">Trang chủ</a>
                    <a href="features.jsp">Tính năng</a>
                    <a href="gallery.jsp">Bộ sưu tập</a>
                    <a href="delivery.jsp">Giao hàng</a>
                    <a href="reviews.jsp">Đánh giá</a>
                    <a href="form.jsp">Biểu mẫu</a>
                    <a href="login.jsp">Đăng nhập </a>
                </ul>
                <a href="contact.jsp" class="contact-btn">Liên hệ</a>
            </nav>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <div class="hero-content">
                <h1>Hoa tươi với tình yêu — Giao hàng nhanh khắp Hà Nội</h1>
                <p>Hạnh phúc trong từng bó hoa. Mang đến tình yêu và sự ấm áp tận cửa nhà bạn.</p>
                <a href="#form" class="order-btn">Đặt hàng</a>
            
            </div>
            <div class="hero-image">
                <img src="images/baner.jpg" alt="Hoa cúc trắng">
            </div>
        </div>
    </section>
    <!-- Product Section -->
    <!-- Product Section -->
    <section class="products" id="glallery">
        <div class="container1">
            <h2>Bộ sưu tập hoa</h2>
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
                                <img src="<%= imageUrl %>" alt="<%= name %>">
                                <h3><%= name %></h3>
                                <p><%= String.format("%,.0f", price) %> VNĐ</p>
                                <a href="AddToCartServlet?productId=<%= id %>" class="add-to-cart">Mua ngay</a>
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
    <!-- Features Section -->
    <section class="features" id="features">
        <div class="container2">
            <h2>Tính năng</h2>
            <div class="features-grid">
                <div class="feature-card">
                     <div class="feature-icon">🌷</div>
                    <h3>Giao hoa nhanh</h3>
                    <p>Đảm bảo giao hoa trong vòng 2 giờ tại Hà Nội.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🚚</div>
                    <h3>Hoa tươi</h3>
                    <p>Hoa được chọn lọc kỹ càng, đảm bảo tươi mới.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🎨</div>
                    <h3>Dịch vụ tận tâm</h3>
                    <p>Hỗ trợ khách hàng 24/7 với sự tận tình.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Delivery Section -->
    <section class="delivery" id="delivery">
        <div class="container3">
            <h2>Giao hàng</h2>
            <div class="delivery-content">
                <div class="delivery-text">
                    <p>Chúng tôi cung cấp dịch vụ giao hoa nhanh chóng và đáng tin cậy tại Hà Nội. Đội ngũ giao hàng của chúng tôi đảm bảo hoa đến tay bạn trong thời gian ngắn nhất, giữ được độ tươi và đẹp.</p>
                    <p>Hãy đặt hoa ngay hôm nay để mang niềm vui đến người thân yêu của bạn!</p>
                </div>
                <div class="delivery-image">
                    <img src="images/delivery.jpg" alt="Dịch vụ giao hàng">
                </div>
            </div>
        </div>
    </section>

    <!-- Reviews Section -->
    <section class="reviews" id="reviews">
        <div class="container4">
            <h2>Đánh giá</h2>
            <div class="reviews-grid">
                <div class="review-card">
                    <p>"Dịch vụ giao hoa rất nhanh, hoa tươi và đẹp. Tôi rất hài lòng!"</p>
                    <p class="author">— Nguyễn An</p>
                </div>
                <div class="review-card">
                    <p>"Hoa được gói rất đẹp, giao đúng giờ. Sẽ tiếp tục ủng hộ!"</p>
                    <p class="author">— Trần Bình</p>
                </div>
                <div class="review-card">
                    <p>"Nhân viên rất nhiệt tình, hỗ trợ tôi chọn hoa phù hợp. Cảm ơn nhiều!"</p>
                    <p class="author">— Lê Minh</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Form Section -->
    <section class="form-section" id="form">
        <div class="container5">
            <h2>Biểu mẫu đặt hoa</h2>
            <div class="form-container">
                <form action="OrderServlet" method="POST">
                    <div class="form-group">
                        <label for="name">Họ và tên</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" required>
                    </div>
                    <div class="form-group">
                        <label for="address">Địa chỉ giao hàng</label>
                        <input type="text" id="address" name="address" required>
                    </div>
                    <div class="form-group">
                        <label for="message">Lời nhắn (nếu có)</label>
                        <textarea id="message" name="message"></textarea>
                    </div>
                    <button type="submit" class="submit-btn">Đặt hàng</button>
                </form>
            </div>
        </div>
    </section>
    <footer class="footer">
        <div class="container6">
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
</body>
</html>