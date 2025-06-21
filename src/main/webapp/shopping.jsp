<%-- 
    Document   : gallery
    Created on : Apr 22, 2025, 8:20:58 PM
    Author     : PC
--%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bộ sưu tập - Hoa yêu thương</title>
    <link rel="stylesheet" href="css/shopping.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <section class="gallery-banner">
        <h1>Bộ sưu tập hoa tươi</h1>
        <p>Khám phá những sản phẩm hoa tươi độc đáo và đẹp mắt của chúng tôi</p>
    </section>
    
    <section class="gallery-nav">
        <div class="container">
            <div class="category-buttons">
                <button class="category-btn active" data-category="all">Tất cả</button>
                <button class="category-btn" data-category="bó hoa">Bó hoa</button>
                <button class="category-btn" data-category="giỏ hoa">Giỏ hoa</button>
                <button class="category-btn" data-category="lãng hoa">Lãng hoa</button>
                <button class="category-btn" data-category="hoa thô">Hoa thô</button>
            </div>
        </div>
    </section>
    
    <section class="product-gallery">
        <div class="container">
            <div class="product-grid">
                <p style="color: red; text-align: center;">Lỗi: Chưa có cơ sở dữ liệu. Vui lòng chờ kết nối với file Java sau khi có CSDL!</p>
            </div>
        </div>
    </section>
    
    <section class="cta-section">
        <div class="container">
            <div class="cta-content">
                <h2>Bạn muốn tạo một bó hoa độc đáo?</h2>
                <p>Liên hệ với chúng tôi để được tư vấn và thiết kế bó hoa theo ý của bạn.</p>
                <a href="form.jsp" class="cta-btn">Liên hệ ngay</a>
            </div>
        </div>
    </section>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const categoryButtons = document.querySelectorAll('.category-btn');
            const productCards = document.querySelectorAll('.product-card');

            categoryButtons.forEach(button => {
                button.addEventListener('click', function() {
                    categoryButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');

                    const category = this.getAttribute('data-category');
                    productCards.forEach(card => {
                        if (category === 'all' || card.getAttribute('data-category') === category) {
                            card.style.display = 'block';
                        } else {
                            card.style.display = 'none';
                        }
                    });
                });
            });
        });
    </script>
    <%@ include file="footer.jsp" %>
</body>
</html>