<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FlowerLover - Đăng ký</title>
    <link rel="stylesheet" href="css/login.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="login-container">
        <h1 class="login-title">Đăng ký</h1>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="/RegisterServlet" method="post">
            <div class="form-group">
                <label for="fullName">Họ tên</label>
                <input type="text" id="fullName" name="fullName" required>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Xác nhận mật khẩu</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            <button type="submit" class="login-btn">Đăng ký</button>
        </form>
        <div class="register-link">
            Bạn đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a>
        </div>
    </div>
</body>
</html>