<%-- 
    Document   : form.jsp
    Created on : Apr 22, 2025, 8:42:38 PM
    Author     : PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Biểu mẫu đặt hoa - Hoa yêu thương</title>
    <link rel="stylesheet" href="css/form.css">
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container">
            <nav>
                <a href="index.jsp" class="logo">FlowerLover</a>
                <ul class="menu">
                    <li><a href="index.jsp">Trang chủ</a></li>
                    <li><a href="features.jsp">Tính năng</a></li>
                    <li><a href="gallery.jsp">Bộ sưu tập</a></li>
                    <li><a href="delivery.jsp">Giao hàng</a></li>
                    <li><a href="reviews.jsp">Đánh giá</a></li>
                    <li><a href="form.jsp">Biểu mẫu</a></li>
                    <li><a href="login.jsp">Đăng nhập </a></li>
                </ul>
                <a href="contact.jsp" class="contact-btn">Liên hệ</a>
            </nav>
        </div>
    </header>

    <!-- Form Section -->
    <section class="form-section">
        <div class="container">
            <h1 class="section-title">Biểu mẫu đặt hoa</h1>
            <div class="form-container">
                <div class="form-info">
                    <h2>Đặt hoa nhanh chóng và dễ dàng</h2>
                    <p>Hãy điền thông tin của bạn vào biểu mẫu bên cạnh để đặt hoa. Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất để xác nhận đơn hàng.</p>
                    <div class="form-benefits">
                        <div class="benefit-item">
                            <div class="benefit-icon">🚚</div>
                            <div class="benefit-text">
                                <h3>Giao hàng nhanh</h3>
                                <p>Giao hoa trong vòng 2 giờ tại Hà Nội</p>
                            </div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-icon">💐</div>
                            <div class="benefit-text">
                                <h3>Hoa tươi mỗi ngày</h3>
                                <p>Cam kết hoa tươi, chất lượng cao</p>
                            </div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-icon">💯</div>
                            <div class="benefit-text">
                                <h3>Đảm bảo chất lượng</h3>
                                <p>Hoàn tiền nếu bạn không hài lòng</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-wrapper">
                    <form action="OrderServlet" method="POST">
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
                            <label for="address">Địa chỉ giao hàng</label>
                            <input type="text" id="address" name="address" required>
                        </div>
                        <div class="form-group">
                            <label for="delivery-date">Ngày giao hàng</label>
                            <input type="date" id="delivery-date" name="delivery-date" required>
                        </div>
                        <div class="form-group">
                            <label for="delivery-time">Thời gian giao hàng</label>
                            <select id="delivery-time" name="delivery-time" required>
                                <option value="">-- Chọn thời gian --</option>
                                <option value="morning">Buổi sáng (8:00 - 12:00)</option>
                                <option value="afternoon">Buổi chiều (13:00 - 17:00)</option>
                                <option value="evening">Buổi tối (18:00 - 20:00)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="message">Lời nhắn (nếu có)</label>
                            <textarea id="message" name="message" rows="4"></textarea>
                        </div>
                        <button type="submit" class="submit-btn">Gửi đơn hàng</button>
                    </form>
                </div>
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