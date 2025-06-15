<%-- 
    Document   : register
    Created on : Mar 26, 2025, 2:23:13 PM
    Author     : PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FlowerLover - Register</title>
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
        <h1 class="login-title">Đăng ký</h1>
        <form action="RegisterServlet" method="post">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <label for="role">Role</label>
                <select id="role" name="role" required>
                    <option value="customer">Khách hàng</option>
                    <option value="admin">Admin</option>
                </select>
            </div>
            <button type="submit" class="login-btn">Đăng ký</button>
        </form>
        <div class="register-link">
            Bạn đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a>
        </div>
    </div>
</body>
</html>