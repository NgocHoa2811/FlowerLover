<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/dash-order.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@400;700" rel="stylesheet" />
    <title>Quản lý đơn hàng</title>
    <script>
        // Truyền context path từ JSP
        const CONTEXT_PATH = "<%= request.getContextPath() %>";
    </script>
    <script src="js/dash-custom-order.js"></script>
</head>
<body>
    <div class="sidebar" style="justify-content: space-between;">
        <div>
            <button onclick="window.location.href='dashboard.jsp'"><span class="material-symbols-outlined">local_florist</span></button>
            <button onclick="window.location.href='OrderServlet'"><span class="material-symbols-outlined">receipt_long</span></button>
            <button onclick="window.location.href='client.jsp'"><span class="material-symbols-outlined">person</span></button>            
        </div>
        <div class="user-actions">
            <a href="#" class="user-icon"><img id="userImage" src="<%= request.getContextPath() %>/images/avatar.jpg" alt="User Icon" class="user-image" style="width: 30%"></a>
            <span class="material-symbols-outlined" onclick="showProfileModal()" title="Xem hồ sơ">account_circle</span>
            <span class="material-symbols-outlined" onclick="window.location.href='LogoutServlet'" title="Đăng xuất">logout</span>
        </div>
    </div>

    <div id="order" class="tab-content active">
        <div class="header-top">
            <a href="#" class="logo">FlowerLover</a>
        </div>
        <div class="content">
            <div class="header">
                <h2>Quản lý đơn hàng</h2>
                <button onclick="toggleForm()">+ Thêm mới</button>
            </div>
            
            <div class="tab-nav">
                <button class="tab-button" onclick="window.location.href='dash-order.jsp'">Đơn hàng</button>
                <button class="tab-button active" onclick="window.location.href='dash-custom-order.jsp'">Yêu cầu đặt riêng</button>
            </div>
            
            <div class="table-container">
                <table class="order-table">
                    <thead>
                        <tr>
                            <th style="width: 80px; min-width: 80px;">STT</th>
                            <th style="width: 150px; min-width: 150px;">OrderID</th>
                            <th style="width: 150px; min-width: 150px;">Tên người đặt hàng</th>
                            <th style="width: 120px; min-width: 120px;">Số điện thoại</th>
                            <th style="width: 150px; min-width: 150px;">Tổng tiền</th>
                            <th style="width: 200px; min-width: 200px;">Trạng thái đơn hàng</th>
                            <th style="width: 80px; min-width: 80px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody id="customOrdersTableBody">
                        <!-- Dữ liệu sẽ được JavaScript render -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Thêm popup để hiển thị chi tiết -->
    <div id="invoicePopup" class="popup-overlay" style="display:none;">
        <div class="popup-content">
            <span class="close-btn" onclick="closeInvoicePopup()">×</span>
            <div id="invoiceContent"></div>
        </div>
    </div>


</body>
</html>