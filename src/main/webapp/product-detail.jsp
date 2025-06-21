<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Sản Phẩm</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-detail.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container">
        <div class="product-detail">
            <div class="product-main">
                <!-- Product Image -->
                <div class="product-image">
                    <img id="images" src="${product.imageUrl != null ? product.imageUrl : 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=500&h=500&fit=crop'}" 
                         alt="${product.name}" class="main-image">
                </div>

                <!-- Product Info -->
                <div class="product-info">
                    <h1 id="name" class="product-title">${product.name != null ? product.name : 'Bó Hoa Hồng Đỏ Tình Yêu'}</h1>
                    <div id="price" class="product-price">
                        <c:choose>
                            <c:when test="${product.price != null}">
                                ${product.price} VNĐ
                            </c:when>
                            <c:otherwise>
                                450,000 VNĐ
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="quantity-section">
                        <span class="quantity-label">Số lượng:</span>
                        <div class="quantity-controls">
                            <button class="quantity-btn" onclick="decreaseQuantity()">
                                <i class="fas fa-minus"></i>
                            </button>
                            <input type="number" id="quantity" class="quantity-input" value="1" min="1" 
                                   max="${product.quantity != null ? product.quantity : 50}">
                            <button class="quantity-btn" onclick="increaseQuantity()">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                        <span class="quantity-available">
                            (Còn lại: ${product.quantity != null ? product.quantity : 50} sản phẩm)
                        </span>
                    </div>

                    <div class="button-group">
                        <button id="addToFavorite" class="btn btn-favorite" onclick="toggleFavorite()">
                            <i class="far fa-heart"></i>
                        </button>
                        <button id="addToCart" class="btn btn-cart" onclick="addToCart()">
                            <i class="fas fa-shopping-cart"></i>
                        </button>
                        <button id="buyNow" class="btn btn-buy" onclick="buyNow()">
                            <i class="fas fa-bolt"></i> Mua ngay
                        </button>
                    </div>

                    <!-- Additional Product Metadata -->
                    <div class="product-meta">
                        <div class="meta-item">
                            <div class="meta-label">Phân loại:</div>
                            <div id="category" class="meta-value">${product.category != null ? product.category : 'Hoa bó'}</div>
                        </div>
                        <div class="meta-item">
                            <div class="meta-label">Màu sắc:</div>
                            <div id="color" class="meta-value">${product.color != null ? product.color : 'Đỏ'}</div>
                        </div>
                        <div class="meta-item">
                            <div class="meta-label">Loại hoa:</div>
                            <div id="flowerType" class="meta-value">${product.flowerType != null ? product.flowerType : 'Hoa hồng'}</div>
                        </div>
                        <div class="meta-item">
                            <div class="meta-label">Kích thước:</div>
                            <div id="size" class="meta-value">${product.size != null ? product.size : 'Trung bình'}</div>
                        </div>
                        <div class="meta-item">
                            <div class="meta-label">Trạng thái:</div>
                            <span id="status" class="status-badge 
                                <c:choose>
                                    <c:when test='${product.status == "Còn hàng"}'>status-available</c:when>
                                    <c:when test='${product.status == "Hết hàng"}'>status-out-of-stock</c:when>
                                    <c:when test='${product.status == "Ngừng kinh doanh"}'>status-discontinued</c:when>
                                    <c:otherwise>status-available</c:otherwise>
                                </c:choose>">
                                ${product.status != null ? product.status : 'Còn hàng'}
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Product Description -->
            <div class="product-description">
                <h2 class="description-title">Mô tả sản phẩm</h2>
                <div id="description" class="description-content">
                    <c:choose>
                        <c:when test="${product.description != null && !empty product.description}">
                            ${product.description}
                        </c:when>
                        <c:otherwise>
                            <p>Bó hoa hồng đỏ tình yêu là món quà hoàn hảo để thể hiện tình cảm chân thành và sâu sắc của bạn. Được chọn lọc từ những bông hoa hồng đỏ tươi thắm nhất, mỗi bông hoa đều mang trong mình vẻ đẹp quyến rũ và hương thơm ngọt ngào.</p>
                            
                            <p>Sản phẩm được thiết kế tinh tế với phong cách hiện đại, phù hợp cho nhiều dịp đặc biệt như:</p>
                            <ul>
                                <li>Ngày Valentine</li>
                                <li>Sinh nhật người yêu</li>
                                <li>Kỷ niệm ngày cưới</li>
                                <li>Lời cầu hôn</li>
                                <li>Xin lỗi và hòa giải</li>
                            </ul>
                            
                            <p>Chúng tôi cam kết mang đến cho bạn những sản phẩm hoa tươi chất lượng cao, được bảo quản cẩn thận và giao hàng nhanh chóng trong vòng 2-4 giờ tại khu vực nội thành.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Loading Animation -->
    <div class="loading" id="loading">
        <div class="spinner"></div>
    </div>
    <%@ include file="footer.jsp" %>
    <script src="${pageContext.request.contextPath}/js/product-detail.js"></script>
</body>
</html>