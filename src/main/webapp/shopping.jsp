<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Bộ sưu tập - Hoa yêu thương</title>
        <link rel="stylesheet" href="css/shopping.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
        <script>
        var contextPath = "<%=request.getContextPath()%>";
        </script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="js/shopping.js"></script>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <section class="gallery-banner">
            <div class="overlay"></div>
            <h1>Bộ sưu tập hoa tươi</h1>
            <p>Khám phá những sản phẩm hoa tươi độc đáo và đẹp mắt của chúng tôi</p>
        </section>

        <section class="gallery-nav">
            <div class="container">
                <div class="category-buttons">
                    <button class="category-btn active" data-category="all">Tất cả</button>
                    <button class="category-btn" data-category="Hoa bó">Hoa bó</button>
                    <button class="category-btn" data-category="Hoa chậu">Hoa chậu</button>
                    <button class="category-btn" data-category="Lẵng hoa">Lẵng hoa</button>
                    <button class="category-btn" data-category="Hoa lẻ">Hoa lẻ</button>
                    <button class="category-btn" data-category="Hoa sự kiện">Hoa sự kiện</button>
                </div>

            </div>
        </section>

        <section class="product-gallery">
            <div class="container">
                <div class="product-grid" id="productGrid">
                    <!-- Dữ liệu sản phẩm sẽ được render bởi JavaScript -->
                </div>
            </div>
        </section>

        <section class="cta-section">
            <div class="container">
                <div class="cta-content">
                    <h2>Bạn muốn tạo một bó hoa độc đáo?</h2>
                    <p>Liên hệ với chúng tôi để được tư vấn và thiết kế bó hoa theo ý của bạn.</p>
                    <a href="custom-order.jsp" class="cta-btn">Liên hệ ngay</a>
                </div>
            </div>
        </section>

        <%@ include file="footer.jsp" %>
        <div id="toast" style="
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #22392C;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            display: none;
            z-index: 1000;
            font-size: 14px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        ">Đã thêm vào giỏ hàng!</div>

    </body>
    
</html>