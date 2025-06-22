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
    <script src="js/order.js"></script>
</head>
<body>
    
        <div class="sidebar" style="justify-content: space-between;">
            <div>
                <button onclick="window.location.href='dashboard.jsp'"><span class="material-symbols-outlined">local_florist</span></button>
                <button onclick="window.location.href='OrderServlet'"><span class="material-symbols-outlined">receipt_long</span></button>
                <button onclick="window.location.href='client.jsp'"><span class="material-symbols-outlined">person</span></button>            
            </div>
            <div class="user-actions">
                <a href="#" class="user-icon"><img id="userImage" src="<%= request.getContextPath() %>/images/avatar.jpg" alt="User Icon" class="user-image"></a>
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
                            <th style="width: 80px; min-width: 80px;">ID</th>
                            <th style="width: 150px; min-width: 150px;">Thông tin người đặt</th>
                            <th style="width: 150px; min-width: 150px;">Thông tin người nhận</th>
                            <th style="width: 120px; min-width: 120px;">Yêu cầu</th>
                            <th style="width: 150px; min-width: 150px;">Các thông tin khác</th>
                            <th style="width: 200px; min-width: 200px;">Trạng thái đơn hàng</th>
                            <th style="width: 200px; min-width: 200px;">Thành tiền</th>
                            <th style="width: 80px; min-width: 80px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody id="ordersTableBody">
                        <!-- Dữ liệu sẽ được tải bằng JavaScript -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="add-form" id="addForm">
        <form id="addOrderForm">
            <div class="form-group">
                <label for="customerName">Họ tên người đặt:</label>
                <input type="text" id="customerName" name="customerName" required>
            </div>
            <div class="form-group">
                <label for="customerPhone">Số điện thoại người đặt:</label>
                <input type="text" id="customerPhone" name="customerPhone" required>
            </div>
            <div class="form-group">
                <label for="customerAddress">Địa chỉ người đặt:</label>
                <input type="text" id="customerAddress" name="customerAddress" required>
            </div>
            <div class="form-group">
                <label for="recipientName">Họ tên người nhận:</label>
                <input type="text" id="recipientName" name="recipientName" required>
            </div>
            <div class="form-group">
                <label for="recipientPhone">Số điện thoại người nhận:</label>
                <input type="text" id="recipientPhone" name="recipientPhone" required>
            </div>
            <div class="form-group">
                <label for="recipientAddress">Địa chỉ người nhận:</label>
                <input type="text" id="recipientAddress" name="recipientAddress" required>
            </div>
            <div class="form-group">
                <label for="mainFlower">Loại hoa chủ đạo:</label>
                <input type="text" id="mainFlower" name="mainFlower" required>
            </div>
            <div class="form-group">
                <label for="color">Màu:</label>
                <input type="text" id="color" name="color" required>
            </div>
            <div class="form-group">
                <label for="quantity">Số lượng:</label>
                <input type="number" id="quantity" name="quantity" min="1" required>
            </div>
            <div class="form-group">
                <label for="productType">Loại sản phẩm:</label>
                <input type="text" id="productType" name="productType" required>
            </div>
            <div class="form-group">
                <label for="description">Mô tả:</label>
                <textarea id="description" name="description" rows="3"></textarea>
            </div>
            <div class="form-group">
                <label for="sampleImage">Ảnh mẫu:</label>
                <input type="text" id="sampleImage" name="sampleImage">
            </div>
            <div class="form-group">
                <label for="cardMessage">Nội dung thiệp:</label>
                <textarea id="cardMessage" name="cardMessage" rows="2"></textarea>
            </div>
            <div class="form-group">
                <label for="deliveryDate">Ngày giao:</label>
                <input type="date" id="deliveryDate" name="deliveryDate" required>
            </div>
            <div class="form-group">
                <label for="deliveryTime">Khung giờ giao:</label>
                <input type="text" id="deliveryTime" name="deliveryTime" required>
            </div>
            <div class="form-group">
                <label for="status">Trạng thái:</label>
                <select id="status" name="status" required>
                    <option value="Chờ xử lý">Chờ xử lý</option>
                    <option value="Đang giao">Đang giao</option>
                    <option value="Đã giao">Đã giao</option>
                    <option value="Đã hủy">Đã hủy</option>
                </select>
            </div>
            <div class="form-group">
                <label for="totalPrice">Thành tiền:</label>
                <input type="number" id="totalPrice" name="totalPrice" min="0" step="0.01" required>
            </div>
            <div class="form-actions">
                <button type="submit" class="save-btn">Lưu</button>
                <button type="button" class="cancel-btn" onclick="toggleForm()">Hủy</button>
            </div>
        </form>
    </div>
</body>
</html>