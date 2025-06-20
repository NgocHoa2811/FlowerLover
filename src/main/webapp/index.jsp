<%-- 
    Document   : index
    Created on : Mar 26, 2025, 1:17:23 PM
    Author     : PC
--%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hoa yêu thương - Dịch vụ giao hoa tại Hà Nội</title>
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
    <%
        String role = (String) session.getAttribute("role");
        if ("admin".equals(role)) {
            response.sendRedirect("dashboard.jsp");
        }
    %>
    <%@ include file="header.jsp" %>

    <section class="hero">
        <div class="container">
            <div class="hero-content">
                <h1>Hoa tươi với tình yêu — Giao hàng nhanh khắp Hà Nội</h1>
                <p>Hạnh phúc trong từng bó hoa. Mang đến tình yêu và sự ấm áp tận cửa nhà bạn.</p>
                <a href="register.jsp" class="order-btn">Đặt hàng ngay</a>
            </div>
            <div class="hero-image">
                <img src="images/baner.jpg" alt="Hoa cúc trắng">
            </div>
        </div>
    </section>

    <section class="products" id="gallery">
        <div class="container1">
            <h2>Bộ sưu tập hoa</h2>
            <div class="product-grid">
                <p style="color: red; text-align: center;">Lỗi: Chưa có cơ sở dữ liệu. Vui lòng chờ kết nối với file Java sau khi có CSDL!</p>
            </div>
        </div>
    </section>

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
<%@ include file="footer.jsp" %>
</body>
</html>