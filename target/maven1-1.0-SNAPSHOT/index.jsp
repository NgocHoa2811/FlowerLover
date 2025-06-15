<%-- 
    Document   : index
    Created on : Mar 26, 2025, 1:17:23 PM
    Author     : PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt"%> 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hoa yêu thương - Dịch vụ giao hoa tại Kyiv</title>
    <link rel="stylesheet" href="css/styles.css">
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
                <a href="#" class="logo">Hoa yêu thương</a>
                <ul class="menu">
                    <li><a href="#features">Tính năng</a></li>
                    <li><a href="#gallery">Bộ sưu tập</a></li>
                    <li><a href="#delivery">Giao hàng</a></li>
                    <li><a href="#reviews">Đánh giá</a></li>
                    <li><a href="#form">Biểu mẫu</a></li>
                </ul>
                <a href="#contact" class="contact-btn">Liên hệ</a>
            </nav>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <div class="hero-content">
                <h1>Hoa tươi với tình yêu — Giao hàng nhanh khắp Kyiv</h1>
                <p>Hạnh phúc trong từng bó hoa. Mang đến tình yêu và sự ấm áp tận cửa nhà bạn.</p>
                <a href="#form" class="order-btn">Đặt hàng</a>
            </div>
            <div class="hero-image">
                <img src="images/baner.jpg" alt="Hoa cúc trắng">
            </div>
        </div>
    </section>

    <!-- Các phần khác như Features, Gallery, v.v. giữ nguyên -->
</body>
</html>