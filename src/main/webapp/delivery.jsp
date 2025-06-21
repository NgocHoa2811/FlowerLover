<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mongodb.client.*, org.bson.Document, org.bson.types.ObjectId, com.mongodb.client.model.Filters, com.mongodb.client.model.Sorts" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="com.flowershop.util.MongoUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Theo dõi đơn hàng - FlowerLover</title>
    <link rel="stylesheet" href="css/shopping.css"> <!-- Dùng chung với favorite.jsp -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<!-- Banner giống favorite.jsp -->
<section class="gallery-banner">
    <div class="overlay"></div>
    <h1>Theo dõi đơn hàng</h1>
    <p>Xem trạng thái đơn hàng mới nhất của bạn</p>
</section>

<section class="product-gallery">
    <div class="container">
        <%
            if (session.getAttribute("user") != null) {
                try {
                    String userIdStr = (String) session.getAttribute("user");
                    ObjectId userId = new ObjectId(userIdStr);
                    MongoDatabase db = MongoUtil.getDatabase();
                    MongoCollection<Document> orders = db.getCollection("orders");

                    Document latestOrder = orders.find(Filters.eq("userId", userId))
                                                 .sort(Sorts.descending("orderDate")).first();

                    if (latestOrder != null) {
                        String status = latestOrder.getString("status");
                        String product = latestOrder.getString("productNames");
                        Date orderDate = latestOrder.getDate("orderDate");
                        String dateStr = new SimpleDateFormat("dd/MM/yyyy HH:mm").format(orderDate);

                        // Xử lý trạng thái
                        String step1 = "completed";
                        String step2 = (status.equals("Đã xác nhận") || status.equals("Đang chuẩn bị") || status.equals("Đã giao")) ? "completed" : "";
                        String step3 = (status.equals("Đang chuẩn bị") || status.equals("Đã giao")) ? "active" : "";
                        String step4 = status.equals("Đã giao") ? "completed" : "";
        %>
            <div class="order-status-box">
                <h3>Đơn hàng: <%= product %></h3>
                <p>Ngày đặt: <%= dateStr %></p>
                <div class="status-bar">
                    <div class="step <%= step1 %>">
                        <div class="step-circle">✔</div>
                        <p>Đặt hàng</p>
                    </div>
                    <div class="step <%= step2 %>">
                        <div class="step-circle">✔</div>
                        <p>Xác nhận</p>
                    </div>
                    <div class="step <%= step3 %>">
                        <div class="step-circle">●</div>
                        <p>Chuẩn bị</p>
                    </div>
                    <div class="step <%= step4 %>">
                        <div class="step-circle">○</div>
                        <p>Giao hàng</p>
                    </div>
                </div>
            </div>
        <%
                    } else {
        %>
            <p style="text-align:center; font-size:18px;">Bạn chưa có đơn hàng nào.</p>
        <%
                    }
                } catch (Exception e) {
        %>
            <p style="text-align:center; font-size:18px; color:red;">Lỗi khi truy xuất đơn hàng: <%= e.getMessage() %></p>
        <%
                }
            } else {
        %>
            <p style="text-align:center; font-size:18px;">Vui lòng <a href="login.jsp">đăng nhập</a> để xem đơn hàng.</p>
        <%
            }
        %>
    </div>
</section>

<%@ include file="footer.jsp" %>
</body>
</html>
