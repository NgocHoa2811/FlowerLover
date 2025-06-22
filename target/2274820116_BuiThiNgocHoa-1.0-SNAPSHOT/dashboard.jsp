<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    String userEmail = (String) session.getAttribute("user");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<script>
    // Định nghĩa contextPath và userEmail làm biến toàn cục
    window.contextPath = '<%= contextPath %>';
    window.userEmail = '<%= userEmail %>';
</script>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="<%= contextPath %>/css/dashboard.css"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@400;700" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet"> <!-- Thêm font nếu cần -->
        <link rel="icon" href="<%= contextPath %>/favicon.ico" type="image/x-icon" /> <!-- Thêm favicon -->
        <title>Dashboard</title>
      
        <script src="<%= contextPath %>/js/dashboard.js"></script>
    </head>
    <body>
        <div class="sidebar" style="justify-content: space-between;">
            <div>
                <button onclick="window.location.href='<%= contextPath %>/dashboard.jsp'"><span class="material-symbols-outlined">local_florist</span></button>
                <button onclick="window.location.href='<%= contextPath %>/dash-order.jsp'"><span class="material-symbols-outlined">receipt_long</span></button>
                <button onclick="window.location.href='<%= contextPath %>/client.jsp'"><span class="material-symbols-outlined">person</span></button>            
            </div>
            <div class="user-actions">
                <a href="#" class="user-icon"><img id="userImage" src="<%= contextPath %>/images/avatar.jpg" alt="User Icon" class="user-image"></a>
                <span class="material-symbols-outlined" onclick="showProfileModal()" title="Chỉnh sửa hồ sơ">account_circle</span>
                <span class="material-symbols-outlined" onclick="window.location.href='<%= contextPath %>/LogoutServlet'" title="Đăng xuất">logout</span>
            </div>
        </div>

        <div id="product" class="tab-content active">    
            <div class="header-top">
                <a href="#" class="logo">FlowerLover</a>
            </div>
            <div class="content">
                <div class="header">
                    <h2>Quản lý sản phẩm</h2>
                    <button onclick="toggleForm()">+ Thêm mới</button>
                </div>
                <div class="table-container">
                    <table id="flowersTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên sản phẩm</th>
                                <th>Giá</th>
                                <th>Số lượng</th>
                                <th>Ảnh</th>
                                <th>Phân loại</th>
                                <th>Mô tả</th>
                                <th>Màu sắc</th>
                                <th>Loại hoa</th>
                                <th>Kích thước</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="flowersTableBody">
                            <!-- Dữ liệu sẽ được tải bằng JavaScript -->
                        </tbody>
                    </table>
                </div>

                <div class="add-form" id="addForm">
                    <form id="addFlowerForm" enctype="multipart/form-data">
                        <div class="form-group">
                            <label for="name">Tên sản phẩm:</label>
                            <input type="text" id="name" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="price">Giá:</label>
                            <input type="number" id="price" name="price" min="0" step="0.01" required>
                        </div>
                        <div class="form-group">
                            <label for="quantity">Số lượng:</label>
                            <input type="number" id="quantity" name="quantity" min="0" required>
                        </div>
                        <div class="form-group">
                            <label for="images">Ảnh:</label>
                            <input type="file" id="images" name="images" accept="image/*" multiple required>
                        </div>
                        <div class="form-group">
                            <label for="category">Phân loại:</label>
                            <select id="category" name="category" required>
                                <option value="Hoa bó">Hoa bó</option>
                                <option value="Lẵng hoa">Lẵng hoa</option>
                                <option value="Hoa lẻ">Hoa lẻ</option>
                                <option value="Hoa chậu">Hoa chậu</option>
                                <option value="Hoa sự kiện">Hoa sự kiện</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="description">Mô tả:</label>
                            <textarea id="description" name="description" rows="3"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="color">Màu sắc:</label>
                            <input type="text" id="color" name="color">
                        </div>
                        <div class="form-group">
                            <label for="flowerType">Loại hoa:</label>
                            <input type="text" id="flowerType" name="flowerType">
                        </div>
                        <div class="form-group">
                            <label for="size">Kích thước:</label>
                            <select id="size" name="size">
                                <option value="Nhỏ">Nhỏ</option>
                                <option value="Trung bình">Trung bình</option>
                                <option value="Lớn">Lớn</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="status">Trạng thái:</label>
                            <select id="status" name="status" required>
                                <option value="Còn hàng">Còn hàng</option>
                                <option value="Hết hàng">Hết hàng</option>
                                <option value="Ngừng kinh doanh">Ngừng kinh doanh</option>
                            </select>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="save-btn">Lưu</button>
                            <button type="button" class="cancel-btn" onclick="toggleForm()">Hủy</button>
                        </div>
                    </form>
                </div>

                <div class="edit-form" id="editForm">
                    <form id="editFlowerForm" enctype="multipart/form-data">
                        <div class="form-group">
                            <label for="editId">ID:</label>
                            <input type="text" id="editId" name="id" readonly>
                        </div>
                        <div class="form-group">
                            <label for="editName">Tên sản phẩm:</label>
                            <input type="text" id="editName" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="editPrice">Giá:</label>
                            <input type="number" id="editPrice" name="price" min="0" step="0.01" required>
                        </div>
                        <div class="form-group">
                            <label for="editQuantity">Số lượng:</label>
                            <input type="number" id="editQuantity" name="quantity" min="0" required>
                        </div>
                        <div class="form-group">
                            <label for="editImages">Ảnh:</label>
                            <input type="file" id="editImages" name="images" accept="image/*" multiple>
                            <input type="hidden" id="editCurrentImages" name="currentImages">
                        </div>
                        <div class="form-group">
                            <label for="editCategory">Phân loại:</label>
                            <select id="editCategory" name="category" required>
                                <option value="Hoa bó">Hoa bó</option>
                                <option value="Lẵng hoa">Lẵng hoa</option>
                                <option value="Hoa lẻ">Hoa lẻ</option>
                                <option value="Hoa chậu">Hoa chậu</option>
                                <option value="Hoa sự kiện">Hoa sự kiện</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="editDescription">Mô tả:</label>
                            <textarea id="editDescription" name="description" rows="3"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="editColor">Màu sắc:</label>
                            <input type="text" id="editColor" name="color">
                        </div>
                        <div class="form-group">
                            <label for="editFlowerType">Loại hoa:</label>
                            <input type="text" id="editFlowerType" name="flowerType">
                        </div>
                        <div class="form-group">
                            <label for="editSize">Kích thước:</label>
                            <select id="editSize" name="size">
                                <option value="Nhỏ">Nhỏ</option>
                                <option value="Trung bình">Trung bình</option>
                                <option value="Lớn">Lớn</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="editStatus">Trạng thái:</label>
                            <select id="editStatus" name="status" required>
                                <option value="Còn hàng">Còn hàng</option>
                                <option value="Hết hàng">Hết hàng</option>
                                <option value="Ngừng kinh doanh">Ngừng kinh doanh</option>
                            </select>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="save-btn">Cập nhật</button>
                            <button type="button" class="cancel-btn" onclick="toggleEditForm()">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div id="order" class="tab-content">
            <!-- Nội dung cho tab Order -->
        </div>
        <div id="client" class="tab-content">
            <!-- Nội dung cho tab Client -->
        </div>

        <!-- Include modal hồ sơ -->
        <jsp:include page="profileModal.jsp">
            <jsp:param name="contextPath" value="<%= contextPath %>" />
            <jsp:param name="userEmail" value="<%= userEmail %>" />
        </jsp:include>
    </body>
    <script>
        // Hàm showProfileModal để mở modal
        function showProfileModal() {
            const iframe = document.createElement('iframe');
            iframe.src = window.contextPath + '/profileModal.jsp';
            iframe.style.position = 'fixed';
            iframe.style.top = '0';
            iframe.style.left = '0';
            iframe.style.width = '100%';
            iframe.style.height = '100%';
            iframe.style.border = 'none';
            iframe.style.zIndex = '1000';
            document.body.appendChild(iframe);

            // Gọi hàm showProfileModal từ iframe
            iframe.onload = function() {
                iframe.contentWindow.showProfileModal();
            };

            // Đóng iframe khi nhấp ra ngoài
            iframe.onclick = function(event) {
                if (event.target === iframe) {
                    document.body.removeChild(iframe);
                }
            };
        }

        // Hàm fetchUserImage để cập nhật avatar trong sidebar
        function fetchUserImage(email) {
            fetch(window.contextPath + '/GetUserServlet?email=' + encodeURIComponent(email), {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            })
            .then(response => {
                if (!response.ok) throw new Error('Failed to fetch: ' + response.status);
                return response.json();
            })
            .then(data => {
                const userImage = document.getElementById('userImage');
                if (data.profileImage && !data.profileImage.startsWith("data:image")) {
                    userImage.src = 'data:image/jpeg;base64,' + data.profileImage;
                } else {
                    userImage.src = window.contextPath + '/images/avatar.jpg';
                }
            })
            .catch(error => {
                console.error('Error fetching user image:', error);
                document.getElementById('userImage').src = window.contextPath + '/images/avatar.jpg';
            });
        }

        // Lắng nghe thông điệp từ iframe để reload avatar
        window.addEventListener('message', function(event) {
            if (event.data === 'profileUpdated') {
                fetchUserImage(window.userEmail);
            }
        });

        // Gọi hàm fetchUserImage khi trang được tải
        window.addEventListener('load', () => {
            if (window.userEmail) {
                fetchUserImage(window.userEmail);
            }
        });
    </script>
</html>