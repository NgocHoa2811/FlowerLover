<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String userEmail = (String) session.getAttribute("user");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý đơn đặt riêng</title>
    <link rel="stylesheet" href="${contextPath}/css/dash-order.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined"
          rel="stylesheet"/>
    <script>
        const CONTEXT_PATH = "<%= contextPath %>";
    </script>
    <script src="${contextPath}/js/dash-custom-order.js" defer></script>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar" style="justify-content: space-between;">
        <div>
            <button onclick="location.href='${contextPath}/dashboard.jsp'"><span class="material-symbols-outlined">local_florist</span></button>
            <button onclick="location.href='${contextPath}/dash-order.jsp'"><span class="material-symbols-outlined">receipt_long</span></button>
            <button onclick="location.href='${contextPath}/client.jsp'"><span class="material-symbols-outlined">person</span></button>
        </div>
        <div class="user-actions">
            <a href="#" class="user-icon"><img id="userImage" src="${contextPath}/images/avatar.jpg" class="user-image"></a>
            <span class="material-symbols-outlined" onclick="showProfileModal()">account_circle</span>
            <span class="material-symbols-outlined" onclick="location.href='${contextPath}/LogoutServlet'">logout</span>
        </div>
    </div>

    <!-- Main content -->
    <div id="order" class="tab-content active">
        <div class="header-top"><a href="#" class="logo">FlowerLover</a></div>
        <div class="content">
            <div class="header"><h2>Quản lý đơn đặt riêng</h2></div>
            <div class="tab-nav">
                <button class="tab-button" onclick="location.href='dash-order.jsp'">Đơn hàng</button>
                <button class="tab-button active">Yêu cầu đặt riêng</button>
            </div>
            <div class="table-container">
                <table class="order-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>OrderID</th>
                            <th>UserID</th>
                            <th>Ngày tạo</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody id="customOrdersTableBody">
                        <!-- JS render tại đây -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Popup chi tiết đơn -->
    <div id="invoicePopup" class="popup-overlay" style="display:none;">
        <div class="popup-content">
            <span class="close-btn" onclick="closePopup()">×</span>
            <div id="invoiceContent"></div>
        </div>
    </div>

    <script>
    // Chèn thêm nếu cần JS quản lý sidebar/avatar tương tự ví dụ trước
    </script>
</body>
</html>
