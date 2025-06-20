<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/dashboard.css"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@400;700" rel="stylesheet" />
        <title>Dashboard</title>
        <script>
            function escapeHtml(unsafe) {
                if (!unsafe)
                    return '';
                return unsafe.replace(/&/g, "&amp;")
                        .replace(/</g, "&lt;")
                        .replace(/>/g, "&gt;")
                        .replace(/\"/g, '&quot;')
                        .replace(/'/g, '&#039;');
            }

           function escapeJS(str) {
    if (!str) return '';
    return str
        .replace(/\\/g, '\\\\')
        .replace(/'/g, "\\'")
        .replace(/"/g, '\\"')
        .replace(/\n/g, '\\n')
        .replace(/\r/g, '\\r');
}

            function showTab(tabId) {
                document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
                document.getElementById(tabId).classList.add('active');
                const headerMap = {product: 'Quản lý sản phẩm', order: 'Quản lý đơn hàng', client: 'Hỗ trợ khách hàng'};
                document.querySelector('.header h2').textContent = headerMap[tabId] || tabId;
            }

            function toggleForm() {
                const form = document.getElementById('addForm');
                if (form) {
                    form.classList.toggle('active');
                    if (!form.classList.contains('active'))
                        document.getElementById('addFlowerForm').reset();
                }
            }

            function toggleEditForm(id = '', name = '', price = 0, quantity = 0, images = '', category = '', description = '', color = '', flowerType = '', size = '', status = '') {
                const form = document.getElementById('editForm');
                if (!form)
                    return;
                form.classList.toggle('active');
                if (form.classList.contains('active')) {
                    document.getElementById('editId').value = id;
                    document.getElementById('editName').value = name;
                    document.getElementById('editPrice').value = price;
                    document.getElementById('editQuantity').value = quantity;
                    document.getElementById('editImages').value = '';
                    document.getElementById('editCurrentImages').value = images;
                    document.getElementById('editCategory').value = category;
                    document.getElementById('editDescription').value = description;
                    document.getElementById('editColor').value = color;
                    document.getElementById('editFlowerType').value = flowerType;
                    document.getElementById('editSize').value = size;
                    document.getElementById('editStatus').value = status;
                } else {
                    document.getElementById('editFlowerForm').reset();
                    document.getElementById('editCurrentImages').value = '';
            }
            }

            function editFlower(id, name, price, quantity, images, category, description, color, flowerType, size, status) {
                toggleEditForm(id, name, price, quantity, images, category, description, color, flowerType, size, status);
            }

            function confirmDelete(id) {
                if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
                    fetch('/deleteFlower?id=' + id, {method: 'DELETE'})
                            .then(res => res.json())
                            .then(data => {

                                alert(data.success ? 'Xóa thành công!' : 'Xóa thất bại: ' + data.message);
                                if (data.success)
                                    loadFlowers();
                            })
                            .catch(err => alert('Lỗi khi xóa: ' + err.message));
                }
            }

            function loadFlowers() {
                console.log("loadFlowers() called");
                fetch('/dashboard-data')
                        .then(res => res.json())
                        .then(data => {
                            if (!data.success || !Array.isArray(data.flowers)) {
                                alert('Không thể tải danh sách sản phẩm.');
                                return;
                            }

                            const tbody = document.getElementById('flowersTableBody');
                            tbody.innerHTML = ''; // Xóa dữ liệu cũ
                            console.log(data.flowers)
                            data.flowers.forEach(flower => {
                                const id = flower._id;
                                const name = flower.name || '';
                                const price = flower.price || 0;
                                const quantity = flower.quantity || 0;
                                const image = (flower.images && flower.images.length > 0) ? flower.images[0] : '';
                                const category = flower.category || '';
                                const description = flower.description || '';
                                const color = flower.color || '';
                                const flowerType = flower.flowerType || '';
                                const size = flower.size || '';
                                const status = flower.status || '';

                                const row = document.createElement('tr');
                                row.innerHTML = `
                                    <td>${id}</td>
                                    <td>${name}</td>
                                    <td>${price} VNĐ</td>
                                    <td>${quantity}</td>
                                    <td><img src="${image}" alt="${name}" width="50"/></td>
                                    <td>${category}</td>
                                    <td>${description}</td>
                                    <td>${color}</td>
                                    <td>${flowerType}</td>
                                    <td>${size}</td>
                                    <td>${status}</td>
                                    <td>
                                       
                <span class="material-symbols-outlined">edit</span>
            </button>
            <button class="delete-btn" onclick="confirmDelete('${id}')">
                <span class="material-symbols-outlined">delete</span>
            </button>
        </td>
    `;
                                tbody.appendChild(row);
                            });


                        })
                        .catch(err => alert('Lỗi khi tải dữ liệu: ' + err.message));
            }


            document.addEventListener('DOMContentLoaded', () => {
                showTab('product');
                loadFlowers();

                document.getElementById('addFlowerForm')?.addEventListener('submit', e => {
                    e.preventDefault();
                    const formData = new FormData(e.target);
                    fetch('/addFlower', {method: 'POST', body: formData})
                            .then(res => res.json())
                            .then(data => {
                                if (data.success) {
                                    toggleForm();
                                    loadFlowers();
                                } else
                                    alert('Thêm thất bại: ' + data.message);
                            })
                            .catch(err => alert('Lỗi khi thêm: ' + err.message));
                });

                document.getElementById('editFlowerForm')?.addEventListener('submit', e => {
                    e.preventDefault();
                    const formData = new FormData(e.target);
                    fetch('/updateFlower', {method: 'POST', body: formData})
                            .then(res => res.json())
                            .then(data => {
                                if (data.success) {
                                    alert('Cập nhật thành công!');
                                    toggleEditForm();
                                    loadFlowers();
                                } else
                                    alert('Cập nhật thất bại: ' + data.message);
                            })
                            .catch(err => alert('Lỗi khi cập nhật: ' + err.message));
                });
            });
        </script>
    </head>
    <body>
        <div class="sidebar">
            <div class="logo"><img src="https://i.pinimg.com/736x/57/1d/61/571d612946ec0c51d55d9b7b6700afc2.jpg" alt="alt"/></div>
            <button onclick="showTab('product')"><span class="material-symbols-outlined">local_florist</span></button>
            <button onclick="window.location.href = 'dash-order.jsp'"><span class="material-symbols-outlined">receipt_long</span></button>
            <button onclick="showTab('client')"><span class="material-symbols-outlined">person</span></button>
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
    </body>
</html>


