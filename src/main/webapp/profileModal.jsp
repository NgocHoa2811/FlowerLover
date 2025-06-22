<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap, java.util.Map" %>
<%
    String contextPath = request.getContextPath();
    String userEmail = (String) session.getAttribute("user");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="<%= contextPath %>/css/modal.css">
    <style>
        /* CSS cho modal */
.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    justify-content: center;
    align-items: center;
}
.modal-content {
    max-width: 500px;
    width: 90%;
    background-color: #fff;
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
    position: relative;
    box-sizing: border-box;
}
.modal-content h2 {
    text-align: center;
    font-family: 'Dancing Script', cursive;
    color: #88b088;
    margin-bottom: 20px;
}
.profile-image {
    text-align: center;
    margin-bottom: 20px;
}
.profile-image img {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    object-fit: cover;
}
.profile-image .add-image-btn {
    display: inline-block;
    padding: 8px 16px;
    background-color: #88b088;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin-left: 10px;
}
.profile-image input[type="file"] {
    display: none;
}
.form-group {
    margin-bottom: 15px;
    padding: 0 10px;
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
    box-sizing: border-box;
}
.form-group input[readonly], .form-group textarea[readonly] {
    background-color: #f9f9f9;
}
.buttons {
    margin-top: 20px;
    text-align: center;
}
.buttons button {
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}
.buttons .save-btn {
    background-color: #88b088;
    color: white;
}
.buttons .close-btn {
    background-color: #ccc;
    color: #333;
    margin-left: 10px;
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
    z-index: 1001;
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
/* CSS cho modal thành công */
.success-modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: 2000;
    justify-content: center;
    align-items: center;
}
.success-content {
    background-color: #fff;
    padding: 20px;
    border-radius: 10px;
    text-align: center;
    max-width: 300px;
    width: 90%;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
.success-content h3 {
    color: #88b088;
    font-family: 'Dancing Script', cursive;
    margin-bottom: 15px;
}
.success-content p {
    color: #333;
    margin-bottom: 20px;
}
.success-content .ok-btn {
    padding: 10px 20px;
    background-color: #88b088;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}
@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}
.success-modal.show {
    display: flex;
    animation: fadeIn 0.3s ease-in-out;
}
    </style>
    <title>Modal Hồ Sơ</title>
</head>
<body>
    <!-- Modal hồ sơ -->
    <div class="modal" id="profileModal">
        <div class="modal-content">
            <div class="loading-overlay" id="loadingOverlay">
                <div class="spinner"></div>
            </div>
            <h2>Hồ sơ người dùng</h2>
            <div class="profile-image">
                <img src="<%= contextPath %>/images/avatar.jpg" alt="Profile Image" id="modalProfileImg">
                <input type="file" id="imageUpload" accept="image/*">
                <button type="button" class="add-image-btn" onclick="document.getElementById('imageUpload').click()">Thêm ảnh</button>
            </div>
            <form id="profileForm">
                <div class="form-group">
                    <label for="modalFullName">Tên người dùng</label>
                    <input type="text" id="modalFullName" name="fullName">
                </div>
                <div class="form-group">
                    <label for="modalEmail">Email</label>
                    <input type="email" id="modalEmail" name="email" readonly>
                </div>
                <div class="form-group">
                    <label for="modalPhone">Số điện thoại</label>
                    <input type="tel" id="modalPhone" name="phone" pattern="[0-9]{10}" placeholder="Nhập số điện thoại (10 chữ số)">
                </div>
                <div class="form-group">
                    <label for="modalAddress">Địa chỉ</label>
                    <textarea id="modalAddress" name="address"></textarea>
                </div>
                <div class="buttons">
                    <button type="button" class="save-btn" onclick="saveChanges()">Lưu thay đổi</button>
                    <button type="button" class="close-btn" onclick="closeProfileModal()">Hủy</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal thành công -->
    <div class="success-modal" id="successModal">
        <div class="success-content">
            <h3>Thành công!</h3>
            <p>Hồ sơ của bạn đã được cập nhật thành công.</p>
            <button class="ok-btn" onclick="closeSuccessModal()">OK</button>
        </div>
    </div>

    <script>
        const contextPath = '<%= contextPath %>';
        const userEmail = '<%= userEmail %>';
        const profileModal = document.getElementById('profileModal');
        const successModal = document.getElementById('successModal');
        const loadingOverlay = document.getElementById('loadingOverlay');
        const imageUpload = document.getElementById('imageUpload');

        function showLoading() {
            loadingOverlay.style.display = 'flex';
        }

        function hideLoading() {
            loadingOverlay.style.display = 'none';
        }

        function showProfileModal() {
            profileModal.style.display = 'flex';
            fetchUserData(userEmail);
        }

        function closeProfileModal() {
            profileModal.style.display = 'none';
            imageUpload.value = ''; // Reset input file khi đóng modal
        }

        function showSuccessModal() {
            successModal.classList.add('show');
        }

        function closeSuccessModal() {
            successModal.classList.remove('show');
            closeProfileModal(); // Đóng modal hồ sơ sau khi thành công
            fetchUserData(userEmail); // Cập nhật dữ liệu sau khi lưu
        }

        function fetchUserData(email) {
            showLoading();
            fetch(contextPath + '/GetUserServlet?email=' + encodeURIComponent(email), {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            })
            .then(response => {
                if (!response.ok) throw new Error('Failed to fetch: ' + response.status);
                return response.json();
            })
            .then(data => {
                const userImage = window.parent.document.getElementById('userImage'); // Truy cập từ parent
                const modalProfileImg = document.getElementById('modalProfileImg');
                const modalForm = document.getElementById('profileForm');

                if (data.error) {
                    console.error('Error fetching user data:', data.error);
                    if (userImage) userImage.src = contextPath + '/images/avatar.jpg';
                    modalProfileImg.src = contextPath + '/images/avatar.jpg';
                    modalForm.fullName.value = '';
                    modalForm.email.value = email;
                    modalForm.phone.value = '';
                    modalForm.address.value = '';
                } else {
                    const imageSrc = data.profileImage && !data.profileImage.startsWith("data:image") 
                        ? 'data:image/jpeg;base64,' + data.profileImage 
                        : contextPath + '/images/avatar.jpg';
                    if (userImage) userImage.src = imageSrc;
                    modalProfileImg.src = imageSrc;
                    modalForm.fullName.value = data.fullName || '';
                    modalForm.email.value = data.email || email;
                    modalForm.phone.value = data.phone || '';
                    modalForm.address.value = data.address || '';
                }
            })
            .catch(error => {
                console.error('Error fetching user data:', error);
                const userImage = window.parent.document.getElementById('userImage');
                if (userImage) userImage.src = contextPath + '/images/avatar.jpg';
                document.getElementById('modalProfileImg').src = contextPath + '/images/avatar.jpg';
                document.getElementById('profileForm').fullName.value = '';
                document.getElementById('profileForm').email.value = email;
                document.getElementById('profileForm').phone.value = '';
                document.getElementById('profileForm').address.value = '';
            })
            .finally(() => {
                hideLoading();
            });
        }

        imageUpload.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('modalProfileImg').src = e.target.result;
                    const userImage = window.parent.document.getElementById('userImage');
                    if (userImage) userImage.src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        });

        function saveChanges() {
            showLoading();
            const fullName = document.getElementById('modalFullName').value;
            const email = document.getElementById('modalEmail').value;
            const phone = document.getElementById('modalPhone').value;
            const address = document.getElementById('modalAddress').value;
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
                if (!response.ok) throw new Error('Server error: ' + response.status);
                return response.text();
            })
            .then(data => {
                showSuccessModal(); // Hiển thị modal thành công
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Lỗi: ' + error.message);
            })
            .finally(() => {
                hideLoading();
            });
        }

        // Đóng modal khi nhấp ra ngoài modal-content
        window.addEventListener('click', (event) => {
            if (event.target === profileModal) {
                closeProfileModal();
            } else if (event.target === successModal) {
                closeSuccessModal();
            }
        });
    </script>
</body>
</html>