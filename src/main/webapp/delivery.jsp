
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.mongodb.client.MongoClients"%>
<%@page import="com.mongodb.client.MongoClient"%>
<%@page import="com.mongodb.client.MongoDatabase"%>
<%@page import="com.mongodb.client.MongoCollection"%>
<%@page import="com.mongodb.client.model.Filters"%>
<%@page import="org.bson.Document"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dịch vụ giao hàng - FlowerLover</title>
    <link rel="stylesheet" href="css/delivery.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>

    <!-- Delivery Hero Section -->
    <section class="delivery-hero">
        <div class="container">
            <div class="delivery-hero-content">
                <h1>Dịch vụ giao hàng tận tâm</h1>
                <p>Chúng tôi cam kết giao hoa tươi đến tận nhà bạn trong vòng 2 giờ tại Hà Nội với đội ngũ nhân viên chuyên nghiệp.</p>
            </div>
            <div class="delivery-hero-image">
                <img src="images/baner.jpg" alt="Dịch vụ giao hàng">
            </div>
        </div>
    </section>

    <!-- Delivery Info Section -->
    <% if (session.getAttribute("user") == null) { %>
    <section class="delivery-info">
        <div class="container">
            <h2>Thông tin giao hàng</h2>
            <div class="info-grid">
                <div class="info-card">
                    <div class="info-icon">🚚</div>
                    <h3>Khu vực giao hàng</h3>
                    <p>Chúng tôi giao hàng tận nơi trong phạm vi toàn thành phố Hà Nội và các khu vực lân cận.</p>
                </div>
                <div class="info-card">
                    <div class="info-icon">⏱️</div>
                    <h3>Thời gian giao hàng</h3>
                    <p>Giao hàng nhanh trong vòng 2 giờ cho các đơn hàng trong nội thành, và 3-4 giờ cho khu vực ngoại thành.</p>
                </div>
                <div class="info-card">
                    <div class="info-icon">💰</div>
                    <h3>Phí giao hàng</h3>
                    <p>Miễn phí giao hàng cho đơn hàng trên 500.000 VNĐ. Đơn hàng dưới 500.000 VNĐ, phí giao hàng từ 20.000 - 50.000 VNĐ tùy khu vực.</p>
                </div>
            </div>
        </div>
    </section>
    <% } %>

    <!-- Delivery Process Section -->
    <section class="delivery-process">
        <div class="container">
            <h2>Quy trình giao hàng</h2>
            <% if (session.getAttribute("user") != null) { 
                MongoClient mongoClient = null;
                try {
                    mongoClient = MongoClients.create("mongodb://localhost:27017");
                    MongoDatabase database = mongoClient.getDatabase("flowerlover");
                    MongoCollection<Document> users = database.getCollection("users");
                    MongoCollection<Document> orders = database.getCollection("orders");
                    String userId = (String) session.getAttribute("user");
                    if (userId == null) {
                        out.println("<div class='no-orders'><p>Không tìm thấy thông tin người dùng.</p></div>");
                    } else {
                        Document user = users.find(Filters.eq("_id", userId)).first();
                        long orderCount = 0;
                        if (user != null) {
                            orderCount = orders.countDocuments(Filters.eq("userId", user.getString("userId")));
                        }
                        if (orderCount == 0) { %>
                            <div class="no-orders">
                                <p>Bạn không có đơn hàng nào.</p>
                            </div>
                        <% } else { 
                            // Example logic: Assume the latest order status determines the step
                            Document latestOrder = orders.find(Filters.eq("userId", user.getString("userId")))
                                    .sort(Filters.eq("orderDate", -1)).first();
                            String status = latestOrder != null ? latestOrder.getString("status") : "pending";
                            String step1Class = "completed";
                            String step2Class = status.equals("confirmed") || status.equals("preparing") || status.equals("delivered") ? "completed" : "";
                            String step3Class = status.equals("preparing") || status.equals("delivered") ? "active" : "";
                            String step4Class = status.equals("delivered") ? "completed" : ""; %>
                            <div class="status-bar">
                                <div class="step <%= step1Class %>">
                                    <div class="step-circle">✔</div>
                                    <p>Đặt hàng</p>
                                </div>
                                <div class="step <%= step2Class %>">
                                    <div class="step-circle">✔</div>
                                    <p>Xác nhận</p>
                                </div>
                                <div class="step <%= step3Class %>">
                                    <div class="step-circle">●</div>
                                    <p>Chuẩn bị</p>
                                </div>
                                <div class="step <%= step4Class %>">
                                    <div class="step-circle">○</div>
                                    <p>Giao hàng</p>
                                </div>
                            </div>
                        <% }
                    }
                } catch (Exception e) {
                    out.println("<div class='no-orders'><p>Lỗi kết nối database: " + e.getMessage() + "</p></div>");
                } finally {
                    if (mongoClient != null) mongoClient.close();
                }
            } else { %>
                <div class="process-steps">
                    <div class="step">
                        <div class="step-number">1</div>
                        <h3>Đặt hàng</h3>
                        <p>Bạn đặt hàng qua website hoặc gọi điện trực tiếp cho chúng tôi.</p>
                    </div>
                    <div class="step">
                        <div class="step-number">2</div>
                        <h3>Xác nhận</h3>
                        <p>Chúng tôi sẽ liên hệ để xác nhận đơn hàng và thời gian giao hàng.</p>
                    </div>
                    <div class="step">
                        <div class="step-number">3</div>
                        <h3>Chuẩn bị</h3>
                        <p>Đội ngũ florist của chúng tôi chuẩn bị bó hoa tươi theo yêu cầu.</p>
                    </div>
                    <div class="step">
                        <div class="step-number">4</div>
                        <h3>Giao hàng</h3>
                        <p>Nhân viên giao hàng sẽ đưa hoa đến địa chỉ của bạn đúng hẹn.</p>
                    </div>
                </div>
            <% } %>
        </div>
    </section>

    <!-- Delivery FAQs Section -->
    <% if (session.getAttribute("user") == null) { %>
    <section class="delivery-faqs">
        <div class="container">
            <h2>Câu hỏi thường gặp</h2>
            <div class="faq-grid">
                <div class="faq-item">
                    <h3>Làm thế nào để theo dõi đơn hàng?</h3>
                    <p>Sau khi đặt hàng, bạn sẽ nhận được mã đơn hàng. Bạn có thể theo dõi trạng thái đơn hàng bằng cách nhập mã này vào trang theo dõi đơn hàng hoặc liên hệ trực tiếp với chúng tôi.</p>
                </div>
                <div class="faq-item">
                    <h3>Tôi có thể thay đổi địa chỉ giao hàng sau khi đã đặt không?</h3>
                    <p>Có, bạn có thể thay đổi địa chỉ giao hàng bằng cách liên hệ với chúng tôi ít nhất 2 giờ trước thời gian giao hàng dự kiến.</p>
                </div>
                <div class="faq-item">
                    <h3>Nếu người nhận không có nhà thì sao?</h3>
                    <p>Nếu người nhận không có nhà, nhân viên giao hàng sẽ gọi điện trước khi đến. Trong trường hợp không liên lạc được, chúng tôi sẽ giữ hoa tại cửa hàng và sắp xếp giao hàng lại vào thời gian khác.</p>
                </div>
                <div class="faq-item">
                    <h3>Có thể đặt giao hàng vào ngày lễ không?</h3>
                    <p>Có, chúng tôi vẫn giao hàng vào các ngày lễ, tuy nhiên có thể phát sinh phụ phí từ 30.000 - 50.000 VNĐ tùy vào ngày lễ cụ thể.</p>
                </div>
            </div>
        </div>
    </section>
    <% } %>



    <!-- Footer -->
    <%@ include file="footer.jsp" %>
</body>
</html>