<%-- 
    Document   : reviews
    Created on : Apr 22, 2025, 8:37:44 PM
    Author     : PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đánh giá - Hoa yêu thương</title>
    <link rel="stylesheet" href="css/reviews.css">
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container">
            <nav>
                <a href="index.jsp" class="logo">FlowerLover</a>
                <ul class="menu">
                    <li><a href="index.jsp">Trang chủ</a></li>
                    <li><a href="gallery.jsp">Bộ sưu tập</a></li>
                    <li><a href="features.jsp">Tính năng</a></li>
                    <li><a href="delivery.jsp">Giao hàng</a></li>
                    <li><a href="reviews.jsp">Đánh giá</a></li>
                    <li><a href="form.jsp">Biểu mẫu</a></li>
                    <li><a href="login.jsp">Đăng nhập </a></li>
                </ul>
                <a href="contact.jsp" class="contact-btn">Liên hệ</a>
            </nav>
        </div>
    </header>

    <!-- Banner Section -->
    <section class="banner">
        <div class="container">
            <h1>Khách hàng đánh giá về chúng tôi</h1>
            <p>Cảm ơn quý khách đã tin tưởng và trải nghiệm dịch vụ của Hoa yêu thương</p>
        </div>
    </section>

    <!-- Reviews Section -->
    <section class="reviews-section">
        <div class="container">
            <h2>Đánh giá nổi bật</h2>
            <div class="reviews-grid">
                <div class="review-card">
                    <div class="review-header">
                        <img src="images/avatar.jpg" alt="Avatar" class="review-avatar">
                        <div class="review-info">
                            <h3>Nguyễn An</h3>
                            <div class="rating">
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                            </div>
                        </div>
                    </div>
                    <p class="review-text">"Dịch vụ giao hoa rất nhanh, hoa tươi và đẹp. Tôi đặt hoa cho sinh nhật mẹ và nhận được nhiều lời khen ngợi. Sẽ tiếp tục ủng hộ!"</p>
                    <p class="review-date">20/03/2025</p>
                </div>
                
                <div class="review-card">
                    <div class="review-header">
                        <img src="images/avatar.jpg" alt="Avatar" class="review-avatar">
                        <div class="review-info">
                            <h3>Trần Bình</h3>
                            <div class="rating">
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                            </div>
                        </div>
                    </div>
                    <p class="review-text">"Hoa được gói rất đẹp, giao đúng giờ. Nhận được bó hoa hồng xinh đẹp và thơm ngát. Sẽ tiếp tục ủng hộ dịch vụ này!"</p>
                    <p class="review-date">15/03/2025</p>
                </div>
                
                <div class="review-card">
                    <div class="review-header">
                        <img src="images/avatar.jpg" alt="Avatar" class="review-avatar">
                        <div class="review-info">
                            <h3>Lê Minh</h3>
                            <div class="rating">
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star half">★</span>
                            </div>
                        </div>
                    </div>
                    <p class="review-text">"Nhân viên rất nhiệt tình, hỗ trợ tôi chọn hoa phù hợp cho ngày kỷ niệm. Cảm ơn nhiều!"</p>
                    <p class="review-date">10/03/2025</p>
                </div>
                
                <div class="review-card">
                    <div class="review-header">
                        <img src="images/avatar.jpg" alt="Avatar" class="review-avatar">
                        <div class="review-info">
                            <h3>Phạm Thảo</h3>
                            <div class="rating">
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                            </div>
                        </div>
                    </div>
                    <p class="review-text">"Đặt hoa online rất tiện lợi, website dễ sử dụng. Hoa đẹp, giá cả phải chăng. Sẽ giới thiệu cho bạn bè!"</p>
                    <p class="review-date">05/03/2025</p>
                </div>
                
                <div class="review-card">
                    <div class="review-header">
                        <img src="images/avatar.jpg" alt="Avatar" class="review-avatar">
                        <div class="review-info">
                            <h3>Hoàng Linh</h3>
                            <div class="rating">
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">☆</span>
                            </div>
                        </div>
                    </div>
                    <p class="review-text">"Tôi đặt hoa đến muộn 15 phút so với yêu cầu, nhưng chất lượng hoa rất tốt và nhận được nhiều lời khen từ người nhận."</p>
                    <p class="review-date">01/03/2025</p>
                </div>
                
                <div class="review-card">
                    <div class="review-header">
                        <img src="images/avatar.jpg" alt="Avatar" class="review-avatar">
                        <div class="review-info">
                            <h3>Đỗ Quỳnh</h3>
                            <div class="rating">
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star half">★</span>
                            </div>
                        </div>
                    </div>
                    <p class="review-text">"Hoa tươi lâu, sau 5 ngày vẫn rất đẹp. Cách bó hoa chuyên nghiệp và thiết kế rất tinh tế. Sẽ quay lại!"</p>
                    <p class="review-date">25/02/2025</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Add Review Section -->
    <section class="add-review-section">
        <div class="container">
            <h2>Gửi đánh giá của bạn</h2>
            <div class="form-container">
                <form action="ReviewServlet" method="POST">
                    <div class="form-group">
                        <label for="name">Họ và tên</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="rating">Đánh giá</label>
                        <div class="rating-select">
                            <input type="radio" id="star5" name="rating" value="5" checked>
                            <label for="star5">5 sao</label>
                            <input type="radio" id="star4" name="rating" value="4">
                            <label for="star4">4 sao</label>
                            <input type="radio" id="star3" name="rating" value="3">
                            <label for="star3">3 sao</label>
                            <input type="radio" id="star2" name="rating" value="2">
                            <label for="star2">2 sao</label>
                            <input type="radio" id="star1" name="rating" value="1">
                            <label for="star1">1 sao</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="review">Nội dung đánh giá</label>
                        <textarea id="review" name="review" required></textarea>
                    </div>
                    <button type="submit" class="submit-btn">Gửi đánh giá</button>
                </form>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-info">
                <h3>FlowerLover</h3>
                <p>Địa chỉ: 68 Nguyễn Chí Thanh, Phường Láng Thượng, Quận Đống Đa, TP Hà Nội</p>
                <p>Số điện thoại: (028) 1234-5678</p>       
                <p>Giờ mở cửa: 8:00 - 20:00 (Thứ 2 - Chủ Nhật)</p>
                <p>Email: contact@flowerlover.com</p>
            </div>
        </div>
        <div class="footer-copyright">
            &copy; 2025 FlowerLover. All Rights Reserved.
            <a href="#" class="scroll-top">Lên đầu trang <i class="fas fa-arrow-up"></i></a>
        </div>
    </footer>
</body>
</html>
