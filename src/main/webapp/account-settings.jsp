<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap, java.util.Map" %>
<%
    String userEmail = (String) session.getAttribute("user");
    String fullName = (String) session.getAttribute("fullName");
    String phone = (String) session.getAttribute("phone");
    String address = (String) session.getAttribute("address");
    String initialData = (fullName != null ? fullName : "") + (phone != null ? phone : "") + (address != null ? address : "");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thiết lập tài khoản - FlowerLover</title>
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
    <style>
        .account-settings {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .profile-image {
            text-align: center;
            margin-bottom: 20px;
        }
        .profile-image img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
        }
        .profile-image .add-image-btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #88b088;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }
        .profile-image input[type="file"] {
            display: none;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
        }
        .form-group input, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }
        .buttons {
            display: none;
            margin-top: 20px;
        }
        .buttons button {
            padding: 10px 20px;
            margin-right: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .buttons .save-btn {
            background-color: #88b088;
            color: white;
        }
        .buttons .cancel-btn {
            background-color: #ccc;
            color: #333;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="account-settings">
        <h2>Thiết lập tài khoản</h2>
        <div class="profile-image">
            <img src="images/avatar.jpg" alt="Profile Image" id="profileImg">
            <input type="file" id="imageUpload" accept="image/*">
            <button type="button" class="add-image-btn" onclick="document.getElementById('imageUpload').click()">Thêm ảnh</button>
        </div>
        <form id="accountForm" oninput="checkChanges()">
            <div class="form-group">
                <label for="fullName">Tên người dùng</label>
                <input type="text" id="fullName" name="fullName" value="<%= fullName != null ? fullName : "" %>" required>
            </div>
            <div class="form-group">
                <label for="phoneEmail">SĐT/Email</label>
                <input type="text" id="phoneEmail" name="phoneEmail" value="<%= phone != null ? phone : userEmail %>" required>
            </div>
            <div class="form-group">
                <label for="address">Địa chỉ</label>
                <textarea id="address" name="address" required><%= address != null ? address : "" %></textarea>
            </div>
            <div class="form-group">
                <label for="password">Đổi mật khẩu</label>
                <input type="password" id="password" name="password">
            </div>
            <div class="buttons" id="actionButtons"></div>
        </form>
    </div>

    <script>
        const initialData = "<%= initialData %>";
        const form = document.getElementById('accountForm');
        const buttons = document.getElementById('actionButtons');
        const profileImg = document.getElementById('profileImg');
        const imageUpload = document.getElementById('imageUpload');

        imageUpload.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    profileImg.src = e.target.result;
                };
                reader.readAsDataURL(file);
                checkChanges();
            }
        });

        function checkChanges() {
            const currentData = form.fullName.value + form.phoneEmail.value + form.address.value + (form.password.value ? "changed" : "");
            if (currentData !== initialData || imageUpload.files.length > 0) {
                buttons.style.display = 'block';
                buttons.innerHTML = '<button type="button" class="save-btn" onclick="saveChanges()">Lưu thay đổi</button><button type="button" class="cancel-btn" onclick="resetForm()">Hủy</button>';
            } else {
                buttons.style.display = 'none';
            }
        }

        function saveChanges() {
            const fullName = form.fullName.value;
            const phoneEmail = form.phoneEmail.value;
            const address = form.address.value;
            const password = form.password.value;

            // Cập nhật session (chỉ trong bộ nhớ trình duyệt)
            <% if (userEmail != null) { %>
                sessionStorage.setItem('fullName', fullName);
                sessionStorage.setItem('phone', phoneEmail);
                sessionStorage.setItem('address', address);
                if (password) {
                    sessionStorage.setItem('password', password); // Lưu ý: không an toàn, chỉ demo
                }
                sessionStorage.setItem('initialData', fullName + phoneEmail + address);
            <% } %>

            // Lưu ảnh nếu có
            if (imageUpload.files.length > 0) {
                const file = imageUpload.files[0];
                const reader = new FileReader();
                reader.onload = function(e) {
                    sessionStorage.setItem('profileImage', e.target.result);
                    profileImg.src = e.target.result;
                };
                reader.readAsDataURL(file);
            }

            alert("Thông tin đã được lưu trong session!");
            resetForm();
        }

        function resetForm() {
            form.reset();
            profileImg.src = 'images/avatar.jpg';
            imageUpload.value = '';
            buttons.style.display = 'none';
            checkChanges();
            // Khôi phục dữ liệu ban đầu từ sessionStorage
            const storedFullName = sessionStorage.getItem('fullName') || "<%= fullName != null ? fullName : "" %>";
            const storedPhone = sessionStorage.getItem('phone') || "<%= phone != null ? phone : userEmail %>";
            const storedAddress = sessionStorage.getItem('address') || "<%= address != null ? address : "" %>";
            const storedImage = sessionStorage.getItem('profileImage') || 'images/user-icon.jpg';
            form.fullName.value = storedFullName;
            form.phoneEmail.value = storedPhone;
            form.address.value = storedAddress;
            profileImg.src = storedImage;
        }

        // Khởi tạo kiểm tra lần đầu
        checkChanges();
    </script>
    <%@ include file="footer.jsp" %>
</body>
</html>