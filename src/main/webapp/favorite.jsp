<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.mongodb.client.*, org.bson.Document, org.bson.types.ObjectId" %>
<%@ page import="com.flowershop.util.MongoUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Yêu thích - FlowerLover</title>
    <link rel="stylesheet" href="css/shopping.css"> <!-- Dùng chung CSS với shopping.jsp -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<section class="gallery-banner">
    <div class="overlay"></div>
    <h1>Sản phẩm yêu thích</h1>
    <p>Những sản phẩm bạn đã đánh dấu yêu thích</p>
</section>

<%
    List<String> favorites = (List<String>) session.getAttribute("favorites");
    MongoCollection<Document> collection = MongoUtil.getDatabase().getCollection("products");
%>

<section class="product-gallery">
    <div class="container">
        <div class="product-grid">
            <% if (favorites != null && !favorites.isEmpty()) {
                for (String id : favorites) {
                    try {
                        Document product = collection.find(new Document("_id", new ObjectId(id))).first();
                        if (product != null) {
                            List<String> images = product.getList("images", String.class);
                            String imageUrl = (images != null && !images.isEmpty()) ? images.get(0) : "/uploads/default.jpg";
            %>
                <div class="product-card">
                    <img src="<%=request.getContextPath() + imageUrl%>" alt="<%=product.getString("name")%>">
                    <h3><%=product.getString("name")%></h3>
                    <p><%=product.getDouble("price")%> VND</p>
                </div>
            <%
                        }
                    } catch (Exception ex) {
                        out.println("<!-- Lỗi khi lấy sản phẩm yêu thích: " + ex.getMessage() + " -->");
                    }
                }
            } else { %>
                <p style="text-align: center; font-size: 18px; color: #555;">Bạn chưa có sản phẩm yêu thích nào!</p>
            <% } %>
        </div>
    </div>
</section>
        
            <!-- Include Chatbot -->
    <%@ include file="chatbot.jsp" %>

<%@ include file="footer.jsp" %>
</body>
</html>
