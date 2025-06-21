<%-- 
    Document   : index
    Created on : Mar 26, 2025, 1:17:23 PM
    Author     : PC
--%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hoa yêu thương - Dịch vụ giao hoa tại Hà Nội</title>
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick-theme.css" />
</head>
<body>
    <%
        String role = (String) session.getAttribute("role");
        if ("admin".equals(role)) {
            response.sendRedirect("dashboard.jsp");
        }
    %>
    <%@ include file="header.jsp" %>

    <!-- Banner Section -->
    <section class="hero">
        <div class="hero-background">
            <div class="hero-overlay">
                <div class="container">
                    <div class="hero-content">
                        <h1>Hoa tươi - Giao hàng nhanh khắp Hà Nội</h1>
                        <p>Hạnh phúc trong từng bó hoa. Mang đến tình yêu và sự ấm áp tận cửa nhà bạn.</p>
                        <a href="${pageContext.request.contextPath}/login.jsp?redirect=shopping.jsp" class="order-btn">Đặt hàng ngay</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- About Us Section -->
    <section class="about-us">
        <div class="container">
            <h2>Về Chúng Tôi</h2>
            <p>FlowerLover là thương hiệu hoa tươi hàng đầu tại Hà Nội, chuyên cung cấp các bó hoa đẹp mắt và tươi mới cho mọi dịp đặc biệt. Với đội ngũ florist giàu kinh nghiệm và dịch vụ giao hàng tận tâm, chúng tôi cam kết mang đến sự hài lòng cho khách hàng.</p>
        </div>
    </section>

    <!-- Bộ Sưu Tập Section -->
    <section class="products" id="gallery">
        <div class="container">
            <h2>Sản phẩm của chúng tôi</h2>
            <p class="section-description">Khám phá đa dạng các loại hoa tươi đẹp cho mọi dịp đặc biệt</p>
            
            <!-- Categories Grid -->
            <div class="categories-grid">
                <div class="category-card">
                    <a href="${pageContext.request.contextPath}/login.jsp?redirect=shopping.jsp">
                        <div class="category-image">
                            <img src="images/product_09.jpg" alt="Hoa bó">
                            <div class="category-overlay">
                                <div class="category-icon">
                                    <i class="fas fa-gift"></i>
                                </div>
                            </div>
                        </div>
                        <div class="category-info">
                            <h3>Hoa bó</h3>
                            <p>Những bó hoa tươi đẹp cho tình yêu và tình bạn</p>
                        </div>
                    </a>
                </div>
                
                <div class="category-card">
                    <a href="${pageContext.request.contextPath}/login.jsp?redirect=shopping.jsp">
                        <div class="category-image">
                            <img src="images/langhoa_2.jpg" alt="Lãng hoa">
                            <div class="category-overlay">
                                <div class="category-icon">
                                    <i class="fas fa-crown"></i>
                                </div>
                            </div>
                        </div>
                        <div class="category-info">
                            <h3>Lãng hoa</h3>
                            <p>Lãng hoa trang trọng cho các sự kiện quan trọng</p>
                        </div>
                    </a>
                </div>
                
                <div class="category-card">
                    <a href="${pageContext.request.contextPath}/login.jsp?redirect=shopping.jsp">
                        <div class="category-image">
                            <img src="images/hoale.jpg" alt="Hoa lẻ">
                            <div class="category-overlay">
                                <div class="category-icon">
                                    <i class="fas fa-heart"></i>
                                </div>
                            </div>
                        </div>
                        <div class="category-info">
                            <h3>Hoa lẻ</h3>
                            <p>Từng bông hoa tươi đẹp cho những món quà nhỏ xinh</p>
                        </div>
                    </a>
                </div>
                
                <div class="category-card">
                    <a href="${pageContext.request.contextPath}/login.jsp?redirect=shopping.jsp">
                        <div class="category-image">
                            <img src="images/hoachau.jpg" alt="Hoa chậu">
                            <div class="category-overlay">
                                <div class="category-icon">
                                    <i class="fas fa-seedling"></i>
                                </div>
                            </div>
                        </div>
                        <div class="category-info">
                            <h3>Hoa chậu</h3>
                            <p>Cây hoa tươi trong chậu để trang trí nhà cửa</p>
                        </div>
                    </a>
                </div>
                
                <div class="category-card">
                    <a href="${pageContext.request.contextPath}/login.jsp?redirect=shopping.jsp">
                        <div class="category-image">
                            <img src="images/hoasukien.jpg" alt="Hoa sự kiện">
                            <div class="category-overlay">
                                <div class="category-icon">
                                    <i class="fas fa-calendar-star"></i>
                                </div>
                            </div>
                        </div>
                        <div class="category-info">
                            <h3>Hoa sự kiện</h3>
                            <p>Hoa trang trí cho đám cưới, khai trương và sự kiện</p>
                        </div>
                    </a>
                </div>
            </div>
            <!-- Buy Now Button inside Products Section -->
            <div class="buy-now-container">
                <a href="${pageContext.request.contextPath}/login.jsp?redirect=shopping.jsp" class="buy-now-btn">Mua ngay</a>
            </div>
        </div>
    </section>

    <!-- Lý do và Dịch vụ nổi bật Section -->
    <section class="featured-reasons-services">
        <div class="container">
            <h2>FlowerLover có gì?</h2>
            <div class="combined-grid">
                <div class="reason-card">
                    <div class="reason-icon">
                        <i class="fas fa-seedling"></i>
                    </div>
                    <h3>Chất lượng hoa tươi</h3>
                    <p>Chúng tôi chỉ sử dụng hoa tươi nhập khẩu và địa phương đạt tiêu chuẩn cao nhất.</p>
                </div>
                <div class="reason-card">
                    <div class="reason-icon">
                        <i class="fas fa-shipping-fast"></i>
                    </div>
                    <h3>Dịch vụ giao hàng nhanh</h3>
                    <p>Giao hoa tận nơi trong vòng 2 giờ tại Hà Nội với đội ngũ chuyên nghiệp.</p>
                </div>
                <div class="reason-card">
                    <div class="reason-icon">
                        <i class="fas fa-tags"></i>
                    </div>
                    <h3>Giá cả hợp lý</h3>
                    <p>Cung cấp các gói hoa đa dạng với mức giá phù hợp cho mọi ngân sách.</p>
                </div>
                <div class="service-card">
                    <div class="service-icon">
                        <i class="fas fa-palette"></i>
                    </div>
                    <h3>Tư vấn thiết kế hoa</h3>
                    <p>Tư vấn thiết kế hoa theo yêu cầu cá nhân cho mọi dịp đặc biệt.</p>
                </div>
                <div class="service-card">
                    <div class="service-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h3>Hỗ trợ 24/7</h3>
                    <p>Hỗ trợ khách hàng 24/7 qua hotline và email để giải đáp mọi thắc mắc.</p>
                </div>
                <div class="service-card">
                    <div class="service-icon">
                        <i class="fas fa-truck"></i>
                    </div>
                    <h3>Miễn phí giao hàng</h3>
                    <p>Miễn phí giao hàng cho đơn hàng từ 800.000 VNĐ trở lên.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Review Section -->
    <section class="reviews">
        <div class="container">
            <h2>Đánh giá từ khách hàng</h2>
            <div class="reviews-grid">
                <div class="review-card">
                    <div class="review-content">
                        <div class="stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="far fa-star"></i>
                        </div>
                        <p>"Dịch vụ giao hoa rất nhanh, hoa tươi và đẹp. Tôi đặt hoa cho sinh nhật mẹ và nhận được nhiều lời khen ngợi. Sẽ tiếp tục ủng hộ!"</p>
                    </div>
                    <div class="reviewer-info">
                        <img src="images/avatar.jpg" alt="User2081" class="reviewer-avatar">
                        <div class="reviewer-details">
                            <span class="reviewer-name">Triệu Thuận</span>
                            <span class="review-date">12 ngày trước</span>
                        </div>
                    </div>
                </div>
                <div class="review-card">
                    <div class="review-content">
                        <div class="stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="far fa-star"></i>
                        </div>
                        <p>"Hoa được gói rất đẹp, giao đúng giờ. Nhận được bó hoa hồng xinh đẹp và thơm ngát. Sẽ tiếp tục ủng hộ dịch vụ này!"</p>
                    </div>
                    <div class="reviewer-info">
                        <img src="images/avatar.jpg" alt="Julia Sanina" class="reviewer-avatar">
                        <div class="reviewer-details">
                            <span class="reviewer-name">Nguyễn Anh</span>
                            <span class="review-date">5 ngày trước</span>
                        </div>
                    </div>
                </div>
                <div class="review-card">
                    <div class="review-content">
                        <div class="stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="far fa-star"></i>
                            <i class="far fa-star"></i>
                        </div>
                        <p>"Hoa tươi lâu, sau 5 ngày vẫn rất đẹp. Cách bó hoa chuyên nghiệp và thiết kế rất tinh tế. Sẽ quay lại!"</p>
                    </div>
                    <div class="reviewer-info">
                        <img src="images/avatar.jpg" alt="Jiloon" class="reviewer-avatar">
                        <div class="reviewer-details">
                            <span class="reviewer-name">Phạm Thảo</span>
                            <span class="review-date">9 ngày trước</span>
                        </div>
                    </div>
                </div>
                <div class="review-card">
                    <div class="review-content">
                        <div class="stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <p>"Tuyệt vời! Hoa rất tươi và giao hàng đúng hẹn. Dịch vụ này thật đáng tin cậy!"</p>
                    </div>
                    <div class="reviewer-info">
                        <img src="images/avatar.jpg" alt="Lan Anh" class="reviewer-avatar">
                        <div class="reviewer-details">
                            <span class="reviewer-name">Lan Anh</span>
                            <span class="review-date">7 ngày trước</span>
                        </div>
                    </div>
                </div>
                <div class="review-card">
                    <div class="review-content">
                        <div class="stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="far fa-star"></i>
                        </div>
                        <p>"Tôi đặt hoa đến muộn 15 phút so với yêu cầu, nhưng chất lượng hoa rất tốt và nhận được nhiều lời khen từ người nhận."</p>
                    </div>
                    <div class="reviewer-info">
                        <img src="images/avatar.jpg" alt="Minh Hằng" class="reviewer-avatar">
                        <div class="reviewer-details">
                            <span class="reviewer-name">Minh Hằng</span>
                            <span class="review-date">3 ngày trước</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%@ include file="footer.jsp" %>

    <script>
        $(document).ready(function(){
            $('.reviews-grid').slick({
                slidesToShow: 3,
                slidesToScroll: 1,
                autoplay: true,
                autoplaySpeed: 3000,
                dots: true,
                arrows: true,
                prevArrow: '<button type="button" class="slick-prev"><</button>',
                nextArrow: '<button type="button" class="slick-next">></button>',
                centerMode: true,
                centerPadding: '0',
                focusOnSelect: false,
                responsive: [
                    {
                        breakpoint: 768,
                        settings: {
                            slidesToShow: 1,
                            centerMode: true
                        }
                    },
                    {
                        breakpoint: 1024,
                        settings: {
                            slidesToShow: 2,
                            centerMode: true
                        }
                    }
                ]
            });

            $('.reviews-grid').on('beforeChange', function(event, slick, currentSlide, nextSlide){
                $('.review-card').removeClass('active');
                $('.review-card[data-slick-index="' + nextSlide + '"]').addClass('active');
            });

            $('.reviews-grid').on('init', function(event, slick){
                $('.review-card[data-slick-index="' + slick.currentSlide + '"]').addClass('active');
            });
        });
    </script>
</body>
</html>