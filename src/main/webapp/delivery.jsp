<%@page import="java.text.SimpleDateFormat"%>
<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, com.mongodb.client.*, org.bson.Document, org.bson.types.ObjectId" %>
<%@ page import="com.flowershop.util.MongoUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Theo dõi đơn hàng - FlowerLover</title>
    <link rel="stylesheet" href="css/shopping.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
    <style>
        .order-box {
            border: 1px solid #ccc;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
        .order-details p {
            margin: 6px 0;
            font-size: 16px;
        }
        .status-bar {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .step {
            text-align: center;
            flex: 1;
            position: relative;
        }
        .step::after {
            content: "";
            position: absolute;
            top: 12px;
            right: -50%;
            width: 100%;
            height: 2px;
            background: #ccc;
            z-index: 0;
        }
        .step:last-child::after {
            display: none;
        }
        .step-circle {
            width: 24px;
            height: 24px;
            background: #ccc;
            border-radius: 50%;
            line-height: 24px;
            text-align: center;
            margin: 0 auto;
            z-index: 1;
            position: relative;
            font-size: 14px;
        }
        .completed .step-circle {
            background: green;
            color: white;
        }
        .active .step-circle {
            background: orange;
            color: white;
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

<section class="gallery-banner">
    <div class="overlay"></div>
    <h1>Theo dõi đơn hàng</h1>
    <p>Xem trạng thái đơn hàng mới nhất của bạn</p>
</section>

<%
    String userIdStr = (String) session.getAttribute("user");
    if (userIdStr == null) {
%>
    <p style="text-align:center; font-size:18px;">Vui lòng <a href="login.jsp">đăng nhập</a> để xem đơn hàng.</p>
<%
    } else {
        MongoDatabase db = MongoUtil.getDatabase();
        ObjectId userId = new ObjectId(userIdStr);

        MongoCollection<Document> orders = db.getCollection("orders");
        List<Document> orderList = orders.find(new Document("userId", userId)).into(new ArrayList<>());

        MongoCollection<Document> customOrders = db.getCollection("custom_orders");
        List<Document> customOrderList = customOrders.find(new Document("userId", userId)).into(new ArrayList<>());

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

        if (orderList.isEmpty() && customOrderList.isEmpty()) {
%>
    <p style="text-align:center; font-size:18px;">Bạn chưa có đơn hàng nào.</p>
<%
        } else {
%>
    <% if (!orderList.isEmpty()) { %>
        <h3 style="text-align: center;">Đơn đặt hàng thường</h3>
        <% for (Document order : orderList) {
            String productName = order.getString("productNames");
            String status = order.getString("status");
            String step2 = "step";
            String step3 = "step";
            String step4 = "step";

            if ("Đã xác nhận".equals(status)) step2 += " completed";
            else if ("Đang xử lý".equals(status)) step2 += " active";

            if ("Đã giao".equals(status)) step3 += " completed";
            else if ("Đã xác nhận".equals(status)) step3 += " active";

            if ("Đã giao".equals(status)) step4 += " completed";
        %>
        <section class="product-gallery">
            <div class="container">
                <div class="order-box">
                    <div class="order-details">
                        <p><strong>Sản phẩm:</strong> <%=productName%></p>
                        <p><strong>Số lượng:</strong> <%=order.getInteger("quantity")%></p>
                        <p><strong>Tổng tiền:</strong> <%=String.format("%,d", order.getDouble("totalAmount").intValue())%> VNĐ</p>
                        <p><strong>Ngày đặt:</strong> <%=sdf.format(order.getDate("orderDate"))%></p>
                        <p><strong>Trạng thái hiện tại:</strong> <%=status%></p>
                    </div>
                    <div class="status-bar">
                        <div class="step completed"><div class="step-circle">✔</div><p>Đặt hàng</p></div>
                        <div class="<%=step2%>"><div class="step-circle">✔</div><p>Xác nhận</p></div>
                        <div class="<%=step3%>"><div class="step-circle">●</div><p>Đang giao</p></div>
                        <div class="<%=step4%>"><div class="step-circle">○</div><p>Đã giao</p></div>
                    </div>
                </div>
            </div>
        </section>
        <% } %>
    <% } %>

    <% if (!customOrderList.isEmpty()) { %>
        <h3 style="text-align:center;">Đơn đặt hàng theo yêu cầu</h3>
        <% for (Document order : customOrderList) {
            String flower = order.getString("main_flower");
            String status = order.getString("status") != null ? order.getString("status") : "Đang xử lý";
            String recipientName = order.getString("recipient_name");
            String deliveryDate = order.getString("delivery_date");
            int budget = order.get("budget") != null ? ((Number) order.get("budget")).intValue() : 0;
            int quantity = order.get("quantity") != null ? ((Number) order.get("quantity")).intValue() : 0;

            String step2 = "step";
            String step3 = "step";
            String step4 = "step";

            if ("Đã xác nhận".equals(status)) step2 += " completed";
            else if ("Đang xử lý".equals(status)) step2 += " active";

            if ("Đã giao".equals(status)) step3 += " completed";
            else if ("Đã xác nhận".equals(status)) step3 += " active";

            if ("Đã giao".equals(status)) step4 += " completed";
        %>
        <section class="product-gallery">
            <div class="container">
                <div class="order-box">
                    <div class="order-details">
                        <p><strong>Hoa chính:</strong> <%=flower%></p>
                        <p><strong>Số lượng:</strong> <%=quantity%></p>
                        <p><strong>Ngân sách:</strong> <%=String.format("%,d", budget)%> VNĐ</p>
                        <p><strong>Người nhận:</strong> <%=recipientName%></p>
                        <p><strong>Ngày giao:</strong> <%=deliveryDate != null ? deliveryDate : "Chưa xác định"%></p>
                        <p><strong>Trạng thái hiện tại:</strong> <%=status%></p>
                    </div>
                    <div class="status-bar">
                        <div class="step completed"><div class="step-circle">✔</div><p>Đặt hàng</p></div>
                        <div class="<%=step2%>"><div class="step-circle">✔</div><p>Xác nhận</p></div>
                        <div class="<%=step3%>"><div class="step-circle">●</div><p>Đang giao</p></div>
                        <div class="<%=step4%>"><div class="step-circle">○</div><p>Đã giao</p></div>
                    </div>
                </div>
            </div>
        </section>
        <% } %>
    <% } %>
<%
        }
    }
%>

<%@ include file="footer.jsp" %>
</body>
</html>