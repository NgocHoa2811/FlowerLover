<%-- 
    Document   : login
    Created on : Mar 26, 2025, 1:50:25 PM
    Author     : PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - Hoa yêu thương</title>
    <link rel="stylesheet" href="css/login.css">
</head>
<body>
    <div class="header">
       <a href="#" class="logo">FlowerLover</a>
        <div class="nav">
            <a href="index.jsp">Trang chủ</a>
            <a href="features.jsp">Tính năng</a>
            <a href="gallery.jsp">Bộ sưu tập</a>
            <a href="delivery.jsp">Giao hàng</a>
            <a href="reviews.jsp">Đánh giá</a>
            <a href="form.jsp">Biểu mẫu</a>
        </div>
        <button class="contact-btn">Liên hệ</button>
    </div>
    
    <div class="login-container">
        <h1 class="login-title">Đăng nhập</h1>       
        <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="login-btn">Đăng nhập</button>
        </form>
        
        <div class="forgot-password">
            <a href="forgot-password.jsp">Bạn quên mật khẩu?</a>
        </div>
        
        <div class="register-link">
            Bạn chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a>
        </div>
    </div>
</body>
</html>
