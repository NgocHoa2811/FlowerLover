<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.HashMap, java.util.Map" %>
<%
    String userId = (String) session.getAttribute("userId");

    if (userId == null) {
        response.getWriter().write("<script>alert('Vui lòng đăng nhập!'); window.location.href='login.jsp';</script>");
        return;
    }

    // Dữ liệu từ session (chỉ dùng ban đầu)
    String fullName = (String) session.getAttribute("fullName");
    String phone = (String) session.getAttribute("phone");
    String address = (String) session.getAttribute("address");
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
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            position: relative;
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
            margin-top: 20px;
            display: none; /* Ẩn mặc định */
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
        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            display: none;
        }
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #88b088;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>
<div class="account-settings">
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner"></div>
    </div>
    <h2>Hồ sơ người dùng</h2>
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
            <label for="email">Email</label>
            <input type="email" id="email" name="email" value="" required readonly>
        </div>
        <div class="form-group">
            <label for="phone">Số điện thoại</label>
            <input type="tel" id="phone" name="phone" value="<%= phone != null ? phone : "" %>" pattern="[0-9]{10}" placeholder="Nhập số điện thoại (10 chữ số)">
        </div>
        <div class="form-group">
            <label for="address">Địa chỉ</label>
            <textarea id="address" name="address" required><%= address != null ? address : "" %></textarea>
        </div>
        <div class="buttons" id="actionButtons"></div>
    </form>
</div>

<script>
    const form = document.getElementById('accountForm');
    const buttons = document.getElementById('actionButtons');
    const profileImg = document.getElementById('profileImg');
    const imageUpload = document.getElementById('imageUpload');
    const contextPath = '<%= request.getContextPath() %>';
    const loadingOverlay = document.getElementById('loadingOverlay');
    let initialData = "";

    function showLoading() {
        loadingOverlay.style.display = 'flex';
    }

    function hideLoading() {
        loadingOverlay.style.display = 'none';
    }

    function fetchUserDataById(userId) {
        showLoading();
        fetch(contextPath + '/GetUserServlet?id=' + encodeURIComponent(userId), {
            method: 'GET',
            headers: { 'Accept': 'application/json' }
        })
        .then(response => {
            if (!response.ok) throw new Error('Failed to fetch: ' + response.status);
            return response.json();
        })
        .then(data => {
            if (data.error) {
                alert(data.error);
                return;
            }

            form.email.value = data.email || '';
            form.fullName.value = data.fullName || '';
            form.phone.value = data.phone || '';
            form.address.value = data.address || '';

            const imageSrc = data.profileImage && !data.profileImage.startsWith("data:image")
                ? 'data:image/jpeg;base64,' + data.profileImage
                : contextPath + '/images/avatar.jpg';
            profileImg.src = imageSrc;

            if (window.updateUserImage) window.updateUserImage(imageSrc);

            initialData = form.fullName.value + "|" + form.email.value + "|" + form.phone.value + "|" + form.address.value;
            checkChanges();
        })
        .catch(error => {
            console.error('Lỗi khi lấy thông tin user:', error);
        })
        .finally(() => {
            hideLoading();
        });
    }

    window.addEventListener('load', () => {
        const userId = '<%= userId %>';
        if (userId) {
            fetchUserDataById(userId);
        } else {
            alert("Không tìm thấy ID người dùng. Vui lòng đăng nhập lại.");
            window.location.href = "login.jsp";
        }
    });

    imageUpload.addEventListener('change', function (e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                profileImg.src = e.target.result;
                if (window.updateUserImage) window.updateUserImage(e.target.result);
            };
            reader.readAsDataURL(file);
            checkChanges();
        }
    });

    function checkChanges() {
        const currentData = form.fullName.value + "|" + form.email.value + "|" + form.phone.value + "|" + form.address.value;
        if (currentData !== initialData || imageUpload.files.length > 0) {
            buttons.style.display = 'block';
            buttons.innerHTML = '<button type="button" class="save-btn" onclick="saveChanges()">Lưu thay đổi</button><button type="button" class="cancel-btn" onclick="resetForm()">Hủy</button>';
        } else {
            buttons.style.display = 'none';
        }
    }

    function saveChanges() {
        showLoading();
        const fullName = form.fullName.value;
        const email = form.email.value;
        const phone = form.phone.value;
        const address = form.address.value;
        const profileImage = imageUpload.files.length > 0 ? imageUpload.files[0] : null;

        const formData = new FormData();
        formData.append('fullName', fullName);
        formData.append('email', email);
        formData.append('phone', phone);
        formData.append('address', address);
        if (profileImage) formData.append('profileImage', profileImage);

        fetch(contextPath + '/UpdateUserServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) throw new Error('Lỗi server: ' + response.status);
            return response.text();
        })
        .then(data => {
            alert(data);
            fetchUserDataById('<%= userId %>'); // cập nhật lại sau khi lưu
        })
        .catch(error => {
            alert("Lỗi khi lưu thay đổi: " + error.message);
        })
        .finally(() => {
            hideLoading();
        });
    }

    function resetForm() {
        fetchUserDataById('<%= userId %>');
    }
</script>

<%@ include file="footer.jsp" %>
</body>
</html>