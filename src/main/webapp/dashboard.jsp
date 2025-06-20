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
            if (unsafe == null) return '';
            return String(unsafe)
                    .replace(/&/g, "&")
                    .replace(/</g, "<")
                    .replace(/>/g, ">")
                    .replace(/"/g, "\"")
                    .replace(/'/g, "'");
        }

        function escapeJsString(str) {
            if (str == null) return '';
            return String(str)
                    .replace(/\\/g, "\\\\")
                    .replace(/'/g, "\\'")
                    .replace(/"/g, '\\"')
                    .replace(/\n/g, "\\n")
                    .replace(/\r/g, "\\r");
        }

        function showTab(tabId) {
            const tabs = document.getElementsByClassName('tab-content');
            for (let i = 0; i < tabs.length; i++) {
                tabs[i].classList.remove('active');
            }
            document.getElementById(tabId).classList.add('active');

            let title = tabId.charAt(0).toUpperCase() + tabId.slice(1);
            if (tabId === 'product') title = 'Quản lý sản phẩm';
            else if (tabId === 'order') title = 'Quản lý đơn hàng';
            else if (tabId === 'client') title = 'Hỗ trợ khách hàng';
            document.querySelector('.header h2').textContent = title;
        }

        function toggleForm() {
            const form = document.getElementById('addForm');
            if (form) {
                form.classList.toggle('active');
                if (!form.classList.contains('active')) {
                    document.getElementById('addFlowerForm').reset();
                }
            }
        }

        function toggleEditForm(id, name, price, quantity, images, category, description, color, flowerType, size, status) {
            const form = document.getElementById('editForm');
            if (form) {
                form.classList.toggle('active');
                if (form.classList.contains('active')) {
                    document.getElementById('editId').value = id || '';
                    document.getElementById('editName').value = name || '';
                    document.getElementById('editPrice').value = price || 0;
                    document.getElementById('editQuantity').value = quantity || 0;
                    document.getElementById('editImages').value = '';
                    document.getElementById('editCurrentImages').value = images || '';
                    document.getElementById('editCategory').value = category || '';
                    document.getElementById('editDescription').value = description || '';
                    document.getElementById('editColor').value = color || '';
                    document.getElementById('editFlowerType').value = flowerType || '';
                    document.getElementById('editSize').value = size || '';
                    document.getElementById('editStatus').value = status || '';
                } else {
                    document.getElementById('editFlowerForm').reset();
                    document.getElementById('editCurrentImages').value = '';
                }
            }
        }

        function editFlower(id, name, price, quantity, images, category, description, color, flowerType, size, status) {
            toggleEditForm(
                escapeJsString(id),
                escapeJsString(name),
                price,
                quantity,
                escapeJsString(images),
                escapeJsString(category),
                escapeJsString(description),
                escapeJsString(color),
                escapeJsString(flowerType),
                escapeJsString(size),
                escapeJsString(status)
            );
        }

        function confirmDelete(id) {
            if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
                fetch('/deleteFlower?id=' + escapeJsString(id), {
                    method: 'DELETE'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Xóa sản phẩm thành công!');
                        loadFlowers();
                    } else {
                        alert('Xóa sản phẩm thất bại: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Lỗi:', error);
                    alert('Đã xảy ra lỗi khi xóa sản phẩm.');
                });
            }
        }

        function loadFlowers() {
            fetch('/dashboard-data')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.statusText);
                    }
                    return response.text();
                })
                .then(text => {
                    console.log('Raw response:', text);
                    const data = JSON.parse(text);
                    console.log('Parsed data:', data);
                    if (data.success) {
                        const tbody = document.getElementById('flowersTableBody');
                        if (tbody) {
                            tbody.innerHTML = '';
                            if (data.flowers && Array.isArray(data.flowers)) {
                                data.flowers.forEach(flower => {
                                    console.log("Đang xử lý flower:", flower);

                                    const id = flower._id || '';
                                    const name = escapeHtml(flower.name || '');
                                    const price = flower.price || 0;
                                    const quantity = flower.quantity || 0;
                                    const image = (flower.images && flower.images.length > 0) ? escapeHtml(flower.images[0]) : '';
                                    const category = escapeHtml(flower.category || '');
                                    const description = escapeHtml(flower.description || '');
                                    const color = escapeHtml(flower.color || '');
                                    const flowerType = escapeHtml(flower.flowerType || '');
                                    const size = escapeHtml(flower.size || '');
                                    const status = escapeHtml(flower.status || '');

                                    const row = document.createElement('tr');
                                    row.innerHTML = `
                                        <td>${id}</td>
                                        <td>${name}</td>
                                        <td>${price.toFixed(2)} VNĐ</td>
                                        <td>${quantity}</td>
                                        <td><img src="${image}" alt="${name}" width="50" onerror="this.src='https://via.placeholder.com/50'"></td>
                                        <td>${category}</td>
                                        <td>${description}</td>
                                        <td>${color}</td>
                                        <td>${flowerType}</td>
                                        <td>${size}</td>
                                        <td>${status}</td>
                                        <td>
                                            <button class="edit-btn" onclick="editFlower('${id}', '${name}', ${price}, ${quantity}, '${image}', '${category}', '${description}', '${color}', '${flowerType}', '${size}', '${status}')">
                                                <span class="material-symbols-outlined">edit</span>
                                            </button>
                                            <button class="delete-btn" onclick="confirmDelete('${id}')">
                                                <span class="material-symbols-outlined">delete</span>
                                            </button>
                                        </td>
                                    `;
                                    tbody.appendChild(row);
                                    console.log("Row added:", row.innerHTML);
                                });
                            } else {
                                console.warn('No valid flowers array in response:', data.flowers);
                                alert('Không có dữ liệu sản phẩm để hiển thị.');
                            }
                        }
                    } else {
                        console.error('Failed to load flowers:', data.message);
                        alert('Không thể tải danh sách sản phẩm: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Lỗi khi tải bảng:', error);
                    alert('Đã xảy ra lỗi khi tải danh sách sản phẩm: ' + error.message);
                });
        }

        document.addEventListener('DOMContentLoaded', function() {
            const addForm = document.getElementById('addFlowerForm');
            if (addForm) {
                addForm.addEventListener('submit', function(event) {
                    event.preventDefault();
                    const formData = new FormData(this);
                    fetch('/addFlower', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            toggleForm();
                            loadFlowers();
                        } else {
                            alert('Thêm sản phẩm thất bại: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Lỗi:', error);
                        alert('Đã xảy ra lỗi khi thêm sản phẩm: ' + error.message);
                    });
                });
            }

            const editForm = document.getElementById('editFlowerForm');
            if (editForm) {
                editForm.addEventListener('submit', function(event) {
                    event.preventDefault();
                    const formData = new FormData(this);
                    fetch('/updateFlower', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Cập nhật sản phẩm thành công!');
                            toggleEditForm();
                            loadFlowers();
                        } else {
                            alert('Cập nhật sản phẩm thất bại: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Lỗi:', error);
                        alert('Đã xảy ra lỗi khi cập nhật sản phẩm: ' + error.message);
                    });
                });
            }
        });

        window.onload = function() {
            showTab('product');
            loadFlowers();
        };
    </script>
</head>
<body>
    <div class="sidebar">
        <div class="logo"><img src="https://i.pinimg.com/736x/57/1d/61/571d612946ec0c51d55d9b7b6700afc2.jpg" alt="alt"/></div>
        <button onclick="showTab('product')"><span class="material-symbols-outlined">local_florist</span></button>
        <button onclick="window.location.href='dash-order.jsp'"><span class="material-symbols-outlined">receipt_long</span></button>
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