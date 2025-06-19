<%-- 
    Document   : footer
    Created on : Jun 19, 2025, 8:44:57 PM
    Author     : PC
--%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        © 2025 FlowerLover. All Rights Reserved.
        <a href="#" class="scroll-top">Lên đầu trang <i class="fas fa-arrow-up"></i></a>
    </div>
</footer>

<style>
    .footer {
        background-color: #c8e6c9;
        padding: 20px 0;
        color: #333;
        text-align: left;
        margin-top: 40px;
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }

    .footer-info {
        flex: 1;
        min-width: 200px;
        text-align: left;
    }

    .footer-info h3 {
        font-family: 'Dancing Script', cursive;
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 10px;
    }

    .footer-info p {
        margin: 5px 0;
        font-size: 14px;
    }

    .footer-copyright {
        padding-top: 10px;
        border-top: 1px solid #aaa;
        font-size: 12px;
        text-align: center;
    }

    .scroll-top {
        color: #88b088;
        text-decoration: none;
        margin-left: 10px;
    }

    .scroll-top:hover {
        text-decoration: underline;
    }

    .footer i {
        font-size: 12px;
    }
</style>

<script>
    document.querySelector('.scroll-top').addEventListener('click', function(e) {
        e.preventDefault();
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
</script>