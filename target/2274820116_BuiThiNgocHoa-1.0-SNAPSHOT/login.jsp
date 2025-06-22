<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - Hoa yêu thương</title>
    <link rel="stylesheet" href="css/login.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="login-container">
        <h1 class="login-title">Đăng nhập</h1>       
        <% if (request.getParameter("register") != null && request.getParameter("register").equals("success")) { %>
            <div class="error-message" style="color: green;">Đăng ký thành công! Vui lòng đăng nhập.</div>
        <% } else if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <form action="<%=request.getContextPath()%>/LoginServlet" method="post">
            <input type="hidden" name="redirect" value="<%= request.getParameter("redirect") != null ? request.getParameter("redirect") : "" %>">
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