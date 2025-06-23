<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.mongodb.client.*, org.bson.*, java.util.*, com.flowershop.util.MongoUtil" %>
<%@ page import="org.bson.types.ObjectId" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán đơn hàng</title>
    <link rel="stylesheet" href="css/shopping.css">
    <style>
        .invoice-container {
            max-width: 800px;
            margin: 50px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .invoice-container h2 {
            margin-bottom: 20px;
            text-align: center;
        }

        .invoice-container form input,
        .invoice-container form textarea,
        .invoice-container form select {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            margin-bottom: 15px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .invoice-container .btn-group {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .invoice-container button {
            padding: 12px 24px;
            border: none;
            background-color: #c0392b;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            transition: 0.3s;
        }

        .invoice-container button:hover {
            background-color: #a93226;
        }

        .product-summary {
            display: flex;
            gap: 20px;
            align-items: center;
            background: #f9f9f9;
            padding: 15px;
            margin-bottom: 20px;
            border-left: 5px solid #c0392b;
            border-radius: 6px;
        }

        .product-summary img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 6px;
        }

        .product-summary .info {
            flex: 1;
        }

        .product-summary .info p {
            margin: 6px 0;
        }
    </style>
    <script>
        function updateTotal(price) {
            const qty = parseInt(document.getElementById('quantity').value) || 1;
            const total = price * qty;
            document.getElementById('totalDisplay').innerText = total.toLocaleString('vi-VN') + " VND";
            document.getElementById('totalAmount').value = total;
        }
    </script>
</head>
<body>
<%@ include file="header.jsp" %>
<!-- Nút quay lại phía trên bên trái -->
<div style="margin: 20px 0 0 30px;">
    <button onclick="window.location.href='shopping.jsp'" style="
        background: none;
        border: none;
        font-size: 44px;
        cursor: pointer;
        color: #22392C;
    ">←</button>
</div>


<%
    String productId = request.getParameter("productId");
    MongoCollection<Document> collection = MongoUtil.getDatabase().getCollection("products");
    Document product = null;
    if (productId != null && !productId.isEmpty()) {
        product = collection.find(new Document("_id", new ObjectId(productId))).first();
    }
%>

<section class="invoice-container">
    <h2>Thông tin đặt hàng</h2>

    <% if (product != null) {
        List<String> images = product.getList("images", String.class);
        String imageUrl = (images != null && !images.isEmpty()) ? images.get(0) : "/uploads/default.jpg";
        double price = product.getDouble("price");
    %>
    <div class="product-summary">
        <img src="<%=request.getContextPath() + imageUrl%>" alt="<%=product.getString("name")%>">
        <div class="info">
            <p><strong>Sản phẩm:</strong> <%=product.getString("name")%></p>
            <p><strong>Giá:</strong> <%=String.format("%.0f", price)%> VND</p>
            <p><strong>Tổng tiền:</strong> <span id="totalDisplay"><%=String.format("%.0f", price)%> VND</span></p>
        </div>
    </div>

    <form action="order" method="post">
        <!-- Hidden product fields -->
        <input type="hidden" name="productId" value="<%=productId%>">
        <input type="hidden" name="productName" value="<%=product.getString("name")%>">
        <input type="hidden" name="price" value="<%=price%>">
        <input type="hidden" name="totalAmount" id="totalAmount" value="<%=price%>">
        <p><strong>Số lượng:</strong> <input type="number" name="quantity" id="quantity" min="1" value="1" onchange="updateTotal(<%=price%>)" required style="width: 80px;"></p>
        <!-- Customer info -->
        <label>Họ tên người nhận:</label>
        <input type="text" name="customerName" required>

        <label>Số điện thoại:</label>
        <input type="tel" name="phone" required>

        <label>Email:</label>
        <input type="email" name="email">

        <label>Địa chỉ giao hàng:</label>
        <input type="text" name="address" required>

        <label>Phương thức thanh toán:</label>
        <select name="paymentMethod" required>
            <option value="Thanh toán khi nhận hàng">Thanh toán khi nhận hàng</option>
            <option value="Chuyển khoản">Chuyển khoản</option>
            <option value="COD">COD</option>
        </select>

        <label>Ghi chú:</label>
        <textarea name="note" rows="3"></textarea>

        <!-- Buttons -->
        <div class="btn-group">
            <button type="submit">Xác nhận đặt hàng</button>
        </div>
    </form>
    <% } else { %>
        <p style="color: red;">Không tìm thấy sản phẩm cần mua.</p>
    <% } %>
</section>

    <!-- Include Chatbot -->
    <%@ include file="chatbot.jsp" %>

<%@ include file="footer.jsp" %>
<script>
    // Cập nhật tổng tiền lần đầu khi tải trang
    window.addEventListener('DOMContentLoaded', () => {
        updateTotal(<%=product != null ? product.getDouble("price") : 0 %>);
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
window.onload = function () {
    const urlParams = new URLSearchParams(window.location.search);
    const success = urlParams.get('success');
    const error = urlParams.get('error');

    if (success === '1') {
        Swal.fire({
            title: 'Đặt hàng thành công!',
            text: 'Bạn muốn xem trạng thái đơn hàng không?',
            icon: 'success',
            showCancelButton: true,
            confirmButtonText: 'Xem trạng thái',
            cancelButtonText: 'Ở lại trang này',
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#aaa'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'delivery.jsp';
            }
            window.history.replaceState({}, document.title, window.location.pathname);
        });
    }

    if (error) {
        Swal.fire({
            title: 'Lỗi khi đặt hàng',
            text: decodeURIComponent(error),
            icon: 'error',
            confirmButtonText: 'OK'
        });
        window.history.replaceState({}, document.title, window.location.pathname);
    }
}

document.querySelector('form').addEventListener('submit', function(event) {
    const quantity = document.getElementById('quantity').value;
    if (!quantity || parseInt(quantity) < 1) {
        event.preventDefault();
        Swal.fire({
            title: 'Lỗi',
            text: 'Vui lòng nhập số lượng hợp lệ (lớn hơn 0)',
            icon: 'error',
            confirmButtonText: 'OK'
        });
    }
});
</script>

</body>
</html>
