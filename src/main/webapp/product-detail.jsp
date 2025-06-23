<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mongodb.client.*, org.bson.Document, org.bson.types.ObjectId" %>
<%@ page import="com.flowershop.util.MongoUtil" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chi Tiết Sản Phẩm</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-detail.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<%
    String productId = request.getParameter("id");
    Document product = null;
    List<String> images = new ArrayList<>();
    if (productId != null && !productId.isEmpty()) {
        try {
            MongoCollection<Document> collection = MongoUtil.getDatabase().getCollection("products");
            product = collection.find(new Document("_id", new ObjectId(productId))).first();
            if (product != null && product.containsKey("images")) {
                images = (List<String>) product.get("images");
            }
        } catch (Exception e) {
            out.println("<!-- Lỗi khi truy vấn sản phẩm: " + e.getMessage() + " -->");
        }
    }

    String name = product != null ? product.getString("name") : "Không tìm thấy sản phẩm";
    String description = product != null ? product.getString("description") : "";
    double price = product != null && product.getDouble("price") != null ? product.getDouble("price") : 0;
    String rawImage = (!images.isEmpty()) ? images.get(0) : "default.jpg";
    String imageUrl = rawImage.startsWith("/uploads/") ? rawImage : "/uploads/" + rawImage;
%>
<body data-context="<%=request.getContextPath()%>" data-product-id="<%=productId%>">
<%@ include file="header.jsp" %>

<div class="container">
  <div class="product-detail">
    <div class="product-image">
      <img id="mainImage" src="<%=request.getContextPath() + imageUrl%>" alt="<%=name%>" class="main-image">
      <% if (!images.isEmpty()) { %>
        <div class="image-thumbnails">
          <% for (int i = 0; i < images.size(); i++) {
               String img = images.get(i);
               String fullPath = img.startsWith("/uploads/") ? img : "/uploads/" + img;
               String selected = (i == 0) ? "selected" : "";
          %>
            <img class="thumbnail <%=selected%>" src="<%=request.getContextPath() + fullPath%>" alt="ảnh sản phẩm">
          <% } %>
        </div>
      <% } %>
    </div>

    <div class="product-info">
      <h1 class="product-title"><%=name%></h1>
      <div class="product-price"><%=String.format("%,.0f", price)%> VND</div>

      <div class="quantity-section">
        <span>Số lượng</span>
        <div class="quantity-controls">
          <button id="minusBtn" class="quantity-btn"><i class="fas fa-minus"></i></button>
          <input type="number" id="quantity" value="1" min="1" class="quantity-input">
          <button id="plusBtn" class="quantity-btn"><i class="fas fa-plus"></i></button>
        </div>
      </div>

      <div class="button-group">
        <button id="addToFavorite" class="btn-favorite"><i class="far fa-heart"></i></button>
        <button id="addToCart" class="btn"><i class="fas fa-shopping-cart"></i> Thêm vào giỏ</button>
        <button id="buyNow" class="btn btn-buy"><i class="fas fa-bolt"></i> Mua ngay</button>
      </div>
    </div>
  </div>

  <div class="product-description">
    <h2>Mô tả sản phẩm</h2>
    <p><%=description%></p>
  </div>
</div>

<div id="toast" style="position: fixed; bottom: 20px; right: 20px; background-color: #22392C; color: white; padding: 10px 20px; border-radius: 8px; display: none; z-index: 1000; font-size: 14px; box-shadow: 0 2px 10px rgba(0,0,0,0.2);"></div>

    <!-- Include Chatbot -->
    <%@ include file="chatbot.jsp" %>
    
<%@ include file="footer.jsp" %>
<script src="${pageContext.request.contextPath}/js/product-detail.js"></script>
</body>
</html>
