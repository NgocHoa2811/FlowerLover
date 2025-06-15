<%-- 
    Document   : contact.jsp
    Created on : Apr 22, 2025, 8:44:37 PM
    Author     : PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liên hệ - Hoa yêu thương</title>
    <link rel="stylesheet" href="css/contact.css">
</head>
<body>
    <!-- Header -->
    <div class="header">
        <a href="index.jsp" class="logo">FlowerLover</a>
        <div class="nav">
            <a href="index.jsp">Trang chủ</a>
            <a href="features.jsp">Tính năng</a>
            <a href="gallery.jsp">Bộ sưu tập</a>
            <a href="delivery.jsp">Giao hàng</a>
            <a href="reviews.jsp">Đánh giá</a>
            <a href="form.jsp">Biểu mẫu</a>
            <a href="login.jsp">Đăng nhập</a>
        </div>
        <a href="contact.jsp" class="contact-btn">Liên hệ</a>
    </div>
    
    <!-- Contact Section -->
    <div class="contact-section">
        <div class="container">
            <h1 class="contact-title">Liên hệ với chúng tôi</h1>
            <div class="contact-content">
                <div class="contact-info">
                    <div class="info-card">
                        <div class="info-icon">📍</div>
                        <h3>Địa chỉ</h3>
                        <p>68 Nguyễn Chí Thanh, Phường Láng Thượng, Quận Đống Đa, TP Hà Nội</p>
                    </div>
                    <div class="info-card">
                        <div class="info-icon">📞</div>
                        <h3>Điện thoại</h3>
                        <p>(028) 1234-5678</p>
                    </div>
                    <div class="info-card">
                        <div class="info-icon">✉️</div>
                        <h3>Email</h3>
                        <p>contact@flowerlover.com</p>
                    </div>
                    <div class="info-card">
                        <div class="info-icon">🕒</div>
                        <h3>Giờ mở cửa</h3>
                        <p>8:00 - 20:00 (Thứ 2 - Chủ Nhật)</p>
                    </div>
                </div>
                
                <div class="contact-form-container">
                    <h2>Gửi tin nhắn cho chúng tôi</h2>
                    <form action="ContactServlet" method="POST" class="contact-form">
                        <div class="form-group">
                            <label for="name">Họ và tên</label>
                            <input type="text" id="name" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <input type="tel" id="phone" name="phone" required>
                        </div>
                        <div class="form-group">
                            <label for="subject">Chủ đề</label>
                            <input type="text" id="subject" name="subject" required>
                        </div>
                        <div class="form-group">
                            <label for="message">Lời nhắn</label>
                            <textarea id="message" name="message" required></textarea>
                        </div>
                        <button type="submit" class="submit-btn">Gửi tin nhắn</button>
                    </form>
                </div>
            </div>
            
            <div class="map-container">
                <h2>Vị trí của chúng tôi</h2>
                <div class="contact-map">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.2165166328614!2d105.8058328797231!3d21.024020930664697!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ab68b7615083%3A0x26bc6c9c3b364732!2zNjggxJAuIE5ndXnhu4VuIENow60gVGhhbmgsIEzDoW5nIFRoxrDhu6NuZywgxJDhu5FuZyDEkGEsIEjDoCBO4buZaSwgVmnhu4d0IE5hbQ!5e0!3m2!1svi!2s!4v1745378031110!5m2!1svi!2s" width="1150" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>                </div>
            </div>
        </div>
    </div>
    
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