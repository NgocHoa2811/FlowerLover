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
    <!-- Back Button - Fixed Version -->
    <a href="shopping.jsp">
        <button class="back-button" onclick="goBack()" title="Quay lại" type="button">
            <i class="fas fa-arrow-left"></i>
        </button>
    </a>

    <div class="product-detail">
        <div class="product-main">
            <!-- Product Image - Fixed Position -->
            <div class="product-image">
                <img id="images" src="" alt="" class="main-image">
            </div>

            <!-- Product Info Container -->
            <div class="product-info">
                <!-- Product Header - Tách tên và giá -->
                <div class="product-header">
                    <div class="product-name">
                        <h1 id="name" class="product-title">sddddddddddddddddddddddddddddddddddddddddddddddddddddddddd</h1>
                    </div>
                    <div class="product-price-container">
                        <div id="price" class="product-price">188</div>
                    </div>
                </div>

                <!-- Product Actions - Tách số lượng và nút mua -->
                <div class="product-actions">
                    <div class="quantity-buy-section">
                        <div class="quantity-section">
                            <span class="quantity-label">Số lượng:</span>
                            <div class="quantity-controls">
                                <button class="quantity-btn" onclick="decreaseQuantity()" type="button">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <input type="number" id="quantity" class="quantity-input" value="1" min="1">
                                <button class="quantity-btn" onclick="increaseQuantity()" type="button">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                        </div>

                        <div class="button-group">
                            <button id="addToFavorite" class="btn btn-favorite" onclick="toggleFavorite()" type="button">
                                <i class="far fa-heart"></i>
                            </button>
                            <button id="addToCart" class="btn btn-cart" onclick="addToCart()" type="button">
                                <i class="fas fa-shopping-cart"></i>
                            </button>
                            <button id="buyNow" class="btn btn-buy" onclick="buyNow()" type="button">
                                <i class="fas fa-bolt"></i> Mua ngay
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Product Metadata Section -->
        <div id="product-metadata" class="product-metadata">
            <div class="meta-item">
                <div class="meta-label">Phân loại:</div>
                <div id="category" class="meta-value"></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Màu sắc:</div>
                <div id="color" class="meta-value"></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Loại hoa:</div>
                <div id="flowerType" class="meta-value"></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Kích thước:</div>
                <div id="size" class="meta-value"></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Trạng thái:</div>
                <span id="status" class="status-badge"></span>
            </div>
        </div>

        <!-- Product Description -->
        <div class="product-description">
            <h2 class="description-title">Mô tả sản phẩm</h2>
            <div id="description" class="description-content"> cccccvvvvvvvvvvvvvvvvvaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaddddddddddddddddddddddddddddddddddddddddddddccccccccccccccccccccccccccccccc</div>
        </div>
    </div>

    <!-- Loading Animation -->
    <div class="loading" id="loading">
        <div class="spinner"></div>
    </div>

    <%@ include file="footer.jsp" %>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const quantityInput = document.getElementById('quantity');
            const maxQuantity = parseInt(quantityInput.getAttribute('max')) || 50;
            const favoriteBtn = document.getElementById('addToFavorite');
            const favoriteIcon = favoriteBtn.querySelector('i');

            function updateQuantity(value) {
                let currentValue = parseInt(quantityInput.value);
                currentValue = Math.max(1, Math.min(maxQuantity, currentValue + value));
                quantityInput.value = currentValue;
            }

            window.increaseQuantity = function() {
                updateQuantity(1);
            };

            window.decreaseQuantity = function() {
                updateQuantity(-1);
            };

            quantityInput.addEventListener('change', function() {
                let value = parseInt(this.value);
                if (value < 1) this.value = 1;
                if (value > maxQuantity) this.value = maxQuantity;
            });

            window.toggleFavorite = function() {
                favoriteBtn.classList.toggle('favorited');

                // Thay đổi icon giữa trái tim rỗng và trái tim đầy
                if (favoriteBtn.classList.contains('favorited')) {
                    favoriteIcon.className = 'fas fa-heart'; // Trái tim đầy
                } else {
                    favoriteIcon.className = 'far fa-heart'; // Trái tim rỗng
                }
            };

            // Back button function - Fixed version
            window.goBack = function() {
                // Kiểm tra nếu có history để quay lại
                if (window.history.length > 1) {
                    window.history.back();
                } else {
                    // Nếu không có history, chuyển về trang chủ
                    window.location.href = '${pageContext.request.contextPath}/';
                }
            };

            // Đảm bảo nút back luôn hiển thị
            const backButton = document.querySelector('.back-button');
            if (backButton) {
                backButton.style.display = 'flex';
                backButton.style.visibility = 'visible';
            }
        });

        // Alternative functions for cart and buy actions
        window.addToCart = function() {
            const quantity = document.getElementById('quantity').value;
            console.log('Thêm vào giỏ hàng:', quantity);
            // Thêm logic xử lý thêm vào giỏ hàng
        };

        window.buyNow = function() {
            const quantity = document.getElementById('quantity').value;
            console.log('Mua ngay:', quantity);
            // Thêm logic xử lý mua ngay
        };
    </script>
</body>
</html>