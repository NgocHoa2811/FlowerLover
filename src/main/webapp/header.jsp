<%-- 
    Document   : header
    Created on : Jun 17, 2025, 8:40:11 PM
    Author     : PC
--%>

<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="header">
    <a href="index.jsp" class="logo">FlowerLover</a>
    <div class="nav">
        <div class="nav-links">
            <a href="index.jsp" class="<%= request.getRequestURI().endsWith("index.jsp") ? "active" : "" %>">Trang chủ</a>
            <a href="shopping.jsp" class="<%= request.getRequestURI().endsWith("shopping.jsp") ? "active" : "" %>">Mua hàng</a>
            <a href="custom-order.jsp" class="<%= request.getRequestURI().endsWith("custom-order.jsp") ? "active" : "" %>">Đặt riêng</a>
            <a href="delivery.jsp" class="<%= request.getRequestURI().endsWith("delivery.jsp") ? "active" : "" %>">Giao hàng</a>
        </div>
        <div class="nav-icons">
            <a href="cart.jsp" class="cart-icon"><i class="fas fa-shopping-cart"></i></a>
            <% if (session.getAttribute("user") != null) { %>
                <div class="user-menu">
                    <a href="#" class="user-icon"><img src="images/avatar.jpg" alt="User Icon" class="user-image"></a>
                    <div class="dropdown-menu">
                        <a href="favorite.jsp">Yêu thích</a>
                        <a href="orders.jsp">Đơn hàng</a>
                        <a href="account-settings.jsp">Thiết lập tài khoản</a>
                        <a href="LogoutServlet">Đăng xuất</a>
                    </div>
                </div>
            <% } else { %>
                <div class="user-menu">
                    <a href="#" class="user-icon"><i class="fas fa-user"></i></a>
                    <div class="dropdown-menu">
                        <a href="login.jsp">Đăng nhập</a>
                        <a href="register.jsp">Đăng ký</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const userIcon = document.querySelector('.user-icon');
        const dropdownMenu = document.querySelector('.dropdown-menu');

        userIcon.addEventListener('mouseover', function() {
            dropdownMenu.style.display = 'block';
        });

        userIcon.addEventListener('mouseout', function() {
            dropdownMenu.style.display = 'none';
        });

        dropdownMenu.addEventListener('mouseover', function() {
            this.style.display = 'block';
        });

        dropdownMenu.addEventListener('mouseout', function() {
            this.style.display = 'none';
        });
    });
</script>

<style>
    .header {
        display: flex;
        align-items: center;
        padding: 15px 50px;
        background-color: #22392C;
        border-bottom: 1px solid #22392C;
        position: sticky;
        top: 0;
        z-index: 1000;
    }

    .logo {
        font-family: 'Dancing Script', cursive;
        font-size: 28px;
        font-weight: 700;
        color: #FEF4EB;
        text-decoration: none;
    }

    .nav {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
    }

    .nav-links {
        display: flex;
        justify-content: center;
        flex-grow: 1;
        gap: 15px;
    }

    .nav-icons {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .nav a {
        text-decoration: none;
        color: #FEF4EB;
        font-weight: 500;
        padding: 8px 6px;
        transition: color 0.3s ease;
    }

    .nav a:hover {
        color: #88b088;
    }

    .nav a.active {
        color: #88b088;
        font-weight: 600;
    }

    .cart-icon {
        padding: 8px;
        color: #FEF4EB;
        text-decoration: none;
        font-size: 18px;
    }

    .cart-icon i {
        font-size: 20px;
    }

    .user-menu {
        position: relative;
        display: inline-block;
    }

    .user-icon {
        padding: 5px;
        text-decoration: none;
    }

    .user-image {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        object-fit: cover;
    }

    .dropdown-menu {
        display: none;
        position: absolute;
        top: 100%;
        right: 0;
        background-color: #fff;
        box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        z-index: 1;
        min-width: 150px;
        border-radius: 4px;
    }

    .dropdown-menu a {
        color: #171616;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
    }

    .dropdown-menu a:hover {
        background-color: #f1f1f1;
    }

    .user-greeting {
        margin-left: 20px;
        color: #666;
    }

    .user-name {
        font-weight: bold;
        color: #333;
    }
</style>