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
</head>
<script src="js/dash-order.js"></script>

<body>
    <div class="sidebar">
        <div class="logo"><img src="https://i.pinimg.com/736x/57/1d/61/571d612946ec0c51d55d9b7b6700afc2.jpg" alt="alt"/></div>
        <button onclick="window.location.href='dashboard.jsp'"><span class="material-symbols-outlined">local_florist</span></button>
        <button onclick="showTab('order')"><span class="material-symbols-outlined">receipt_long</span></button>
        <button onclick="window.location.href='client.jsp'"><span class="material-symbols-outlined">person</span></button>
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
            <div class="table-container">
                <table class="order-table">
                    <thead>
                        <tr>
                            <th style="width: 80px; min-width: 80px;">STT</th>
                            <th style="width: 150px; min-width: 150px;">Order ID</th>
                            <th style="width: 150px; min-width: 150px;">Tên khách hàng</th>
                            <th style="width: 120px; min-width: 120px;">Số điện thoại</th>
                            <th style="width: 150px; min-width: 150px;">Email</th>
                            <th style="width: 200px; min-width: 200px;">Địa chỉ giao hàng</th>
                            <th style="width: 200px; min-width: 200px;">Tên sản phẩm</th>
                            <th style="width: 80px; min-width: 80px;">Số lượng</th>
                            <th style="width: 120px; min-width: 120px;">Tổng tiền</th>
                            <th style="width: 150px; min-width: 150px;">Ngày đặt hàng</th>
                            <th style="width: 150px; min-width: 150px;">Phương thức thanh toán</th>
                            <th style="width: 120px; min-width: 120px;">Trạng thái đơn hàng</th>
                            <th style="width: 150px; min-width: 150px;">Ghi chú</th>
                            <th style="width: 150px; min-width: 150px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}" varStatus="loop">
                            <tr>
                                <td>#${String.format("%05d", loop.count)}</td>
                                <td>${order.orderId}</td>
                                <td>${order.customerName}</td>
                                <td>${order.phone}</td>
                                <td>${order.email}</td>
                                <td>${order.address}</td>
                                <td>${order.productNames}</td>
                                <td>${order.quantity}</td>
                                <td>${order.totalAmount} VNĐ</td>
                                <td>${order.orderDate}</td>
                                <td>${order.paymentMethod}</td>
                                <td>
                                    <select onchange="updateStatus('${order.orderId}', this.value)">
                                        <option value="Đang xử lý" ${order.status == 'Đang xử lý' ? 'selected' : ''}>Đang xử lý</option>
                                        <option value="Đã xác nhận" ${order.status == 'Đã xác nhận' ? 'selected' : ''}>Đã xác nhận</option>
                                        <option value="Đã giao" ${order.status == 'Đã giao' ? 'selected' : ''}>Đã giao</option>
                                        <option value="Đã hủy" ${order.status == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                                    </select>
                                </td>
                                <td>${order.note}</td>
                                <td>
                                    <button onclick="viewDetails('${order.orderId}')">Xem chi tiết</button>
                                    <button onclick="updateOrder('${order.orderId}')">Cập nhật</button>
                                    <button onclick="printOrder('${order.orderId}')">In đơn</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="add-form" id="addForm">
                <form id="orderForm" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="customerName">Tên khách hàng:</label>
                        <input type="text" id="customerName" name="customerName" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Số điện thoại:</label>
                        <input type="tel" id="phone" name="phone" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email">
                    </div>
                    <div class="form-group">
                        <label for="address">Địa chỉ giao hàng:</label>
                        <input type="text" id="address" name="address" required>
                    </div>
                    <div class="form-group">
                        <label for="productNames">Tên sản phẩm:</label>
                        <input type="text" id="productNames" name="productNames" required>
                    </div>
                    <div class="form-group">
                        <label for="quantity">Số lượng:</label>
                        <input type="number" id="quantity" name="quantity" min="1" required>
                    </div>
                    <div class="form-group">
                        <label for="totalAmount">Tổng tiền:</label>
                        <input type="number" id="totalAmount" name="totalAmount" step="0.01" required>
                    </div>
                    <div class="form-group">
                        <label for="orderDate">Ngày đặt hàng:</label>
                        <input type="datetime-local" id="orderDate" name="orderDate" required>
                    </div>
                    <div class="form-group">
                        <label for="paymentMethod">Phương thức thanh toán:</label>
                        <select id="paymentMethod" name="paymentMethod" required>
                            <option value="Thanh toán khi nhận hàng">Thanh toán khi nhận hàng</option>
                            <option value="Chuyển khoản">Chuyển khoản</option>
                            <option value="COD">COD</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="status">Trạng thái đơn hàng:</label>
                        <select id="status" name="status" required>
                            <option value="Đang xử lý">Đang xử lý</option>
                            <option value="Đã xác nhận">Đã xác nhận</option>
                            <option value="Đã giao">Đã giao</option>
                            <option value="Đã hủy">Đã hủy</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="note">Ghi chú:</label>
                        <textarea id="note" name="note" rows="3"></textarea>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="save-btn">Lưu</button>
                        <button type="button" class="cancel-btn" onclick="toggleForm()">Hủy</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

<!-- Popup hóa đơn -->
<div id="invoicePopup" class="popup-overlay" style="display:none;">
  <div class="popup-content">
    <span class="close-btn" onclick="closeInvoicePopup()">&times;</span>
    <div id="invoiceContent"></div>
  </div>
</div>
</body>
</html>
