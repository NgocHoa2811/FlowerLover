<%-- 
    Document   : custom-order
    Created on : Jun 20, 2025, 9:19:24 PM
    Author     : hp
--%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="css/index.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Form Đặt Hoa Riêng</title>
  <!-- Thêm CDN SweetAlert2 -->
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <style>
    .order-form-container {
      background-color: #f3f4f6;
      padding: 2rem;
      margin: 2rem auto;
      max-width: 64rem;
    }
    .order-form-container .form-inner {
      background-color: #ffffff;
      padding: 2rem;
      border-radius: 0.5rem;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    .order-form-container h1 {
      font-size: 1.5rem;
      font-weight: bold;
      text-align: center;
      margin-bottom: 1.5rem;
    }
    .order-form-container form {
      display: grid;
      grid-template-columns: 1fr;
      gap: 1.5rem;
    }
    @media (min-width: 768px) {
      .order-form-container form {
        grid-template-columns: 1fr 1fr;
      }
    }
    .order-form-container h2 {
      font-size: 1.125rem;
      font-weight: 600;
      margin-bottom: 1rem;
    }
    .order-form-container .form-group {
      margin-bottom: 1rem;
    }
    .order-form-container label {
      display: block;
      font-size: 0.875rem;
      font-weight: 500;
      color: #374151;
      margin-bottom: 0.25rem;
    }
    .order-form-container input,
    .order-form-container select,
    .order-form-container textarea {
      width: 100%;
      padding: 0.5rem;
      border: 1px solid #d1d5db;
      border-radius: 0.375rem;
      box-sizing: border-box;
    }
    .order-form-container input[type="file"] {
      padding: 0.5rem 0;
    }
    .order-form-container textarea {
      resize: vertical;
    }
    .order-form-container img#preview {
      margin-top: 0.5rem;
      max-width: 100%;
      height: auto;
      display: none;
    }
    .order-form-container button {
      width: 100%;
      background-color: #3b82f6;
      color: #ffffff;
      padding: 0.5rem;
      border: none;
      border-radius: 0.375rem;
      cursor: pointer;
      font-size: 1rem;
    }
    .order-form-container button:hover {
      background-color: #2563eb;
    }
    .order-form-container .col-span-2 {
      grid-column: span 1;
    }
    @media (min-width: 768px) {
      .order-form-container .col-span-2 {
        grid-column: span 2;
      }
    }
  </style>
</head>
<body>
  <!-- Header -->
  <%@ include file="header.jsp" %>

  <!-- Form Section -->
  <section class="order-form-container">
    <div class="form-inner">
      <h1>Form Đặt Hoa Riêng</h1>
      <form id="orderForm" action="CustomOrderServlet" method="post" enctype="multipart/form-data">
        <!-- Cột 1: Thông tin người đặt -->
        <div class="form-group">
          <h2>Thông tin người đặt</h2>
          <div class="form-group">
            <label>Họ tên</label>
            <input type="text" name="name" required>
          </div>
          <div class="form-group">
            <label>Số điện thoại</label>
            <input type="tel" name="phone" required>
          </div>
          <div class="form-group">
            <label>Địa chỉ</label>
            <input type="text" name="address" required>
          </div>
          <div class="form-group">
            <label>Sản phẩm đặt riêng</label>
            <input type="text" name="product" value="Hoa đặt riêng" readonly>
          </div>
          <div class="form-group">
            <label>Loại sản phẩm</label>
            <select name="product_type" required>
              <option value="">Chọn loại sản phẩm</option>
              <option value="bó hoa">Bó hoa</option>
              <option value="lãng hoa">Lãng hoa</option>
              <option value="giỏ hoa">Giỏ hoa</option>
            </select>
          </div>
          <div class="form-group">
            <label>Dịp tặng hoa</label>
            <input type="text" name="occasion">
          </div>
          <div class="form-group">
            <label>Loại hoa chủ đạo</label>
            <input type="text" name="main_flower">
          </div>
          <div class="form-group">
            <label>Màu sắc chủ đạo</label>
            <input type="text" name="main_color">
          </div>
          <div class="form-group">
            <label>Số lượng</label>
            <input type="number" name="quantity" min="1" required>
          </div>
          <div class="form-group">
            <label>Ngân sách (VND)</label>
            <input type="number" name="budget" min="0" required>
          </div>
          <div class="form-group">
            <label>Mô tả</label>
            <textarea name="description" rows="4"></textarea>
          </div>
          <div class="form-group">
            <label>Đính kèm ảnh</label>
            <input type="file" name="image" accept="image/*">
            <img id="preview" alt="Ảnh xem trước">
          </div>
          <div class="form-group">
            <label>Nội dung thiệp/Lời chúc</label>
            <textarea name="message" rows="4"></textarea>
          </div>
        </div>

        <!-- Cột 2: Thông tin người nhận -->
        <div class="form-group">
          <h2>Thông tin người nhận</h2>
          <div class="form-group">
            <label>Họ tên người nhận</label>
            <input type="text" name="recipient_name" required>
          </div>
          <div class="form-group">
            <label>Số điện thoại người nhận</label>
            <input type="tel" name="recipient_phone" required>
          </div>
          <div class="form-group">
            <label>Địa chỉ giao hàng</label>
            <input type="text" name="delivery_address" required>
          </div>
          <div class="form-group">
            <label>Ngày giao</label>
            <input type="date" name="delivery_date" required>
          </div>
          <div class="form-group">
            <label>Khung giờ giao mong muốn</label>
            <input type="time" name="delivery_time" required>
          </div>
        </div>

        <!-- Nút gửi -->
        <div class="col-span-2">
          <button type="submit">Gửi yêu cầu</button>
        </div>
      </form>
    </div>
  </section>

  <!-- Footer -->
  <%@ include file="footer.jsp" %>

  <script>
    // Xem trước ảnh khi người dùng chọn file
    document.querySelector('input[name="image"]').addEventListener('change', function(event) {
      const preview = document.getElementById('preview');
      const file = event.target.files[0];
      if (file) {
        preview.src = URL.createObjectURL(file);
        preview.style.display = 'block';
      } else {
        preview.style.display = 'none';
      }
    });

    // Hiển thị SweetAlert2 nếu có tham số URL
    window.onload = function() {
      console.log("window.onload triggered");
      const urlParams = new URLSearchParams(window.location.search);
      console.log("URL Params:", urlParams.toString());
      const success = urlParams.get('success');
      const error = urlParams.get('error');
      console.log("Success:", success, "Error:", error);

      if (success === '1') {
        Swal.fire({
          title: 'Thành công',
          html: 'Đơn hàng đã được lưu thành công!<br>Chúng tôi sẽ liên lạc lại với bạn trong khoảng thời gian ngắn nhất!',
          icon: 'success',
          showCancelButton: true,
          confirmButtonText: 'Tiếp tục đặt hàng',
          cancelButtonText: 'Đóng',
          confirmButtonColor: '#3b82f6',
          cancelButtonColor: '#6b7280'
        }).then((result) => {
          console.log("SweetAlert success result:", result);
          if (result.isConfirmed) {
            document.getElementById('orderForm').reset();
            document.getElementById('preview').style.display = 'none';
          }
          // Xóa tham số URL sau khi hiển thị
          window.history.replaceState({}, document.title, window.location.pathname);
        });
      } else if (error) {
        Swal.fire({
          title: 'Lỗi',
          text: decodeURIComponent(error),
          icon: 'error',
          showCancelButton: true,
          confirmButtonText: 'Tiếp tục đặt hàng',
          cancelButtonText: 'Đóng',
          confirmButtonColor: '#3b82f6',
          cancelButtonColor: '#6b7280'
        }).then((result) => {
          console.log("SweetAlert error result:", result);
          if (result.isConfirmed) {
            document.getElementById('orderForm').reset();
            document.getElementById('preview').style.display = 'none';
          }
          // Xóa tham số URL sau khi hiển thị
          window.history.replaceState({}, document.title, window.location.pathname);
        });
      } else {
        console.log("No success or error params found");
      }
    };
  </script>
</body>
</html>