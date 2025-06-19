<%-- 
    Document   : dashboard
    Created on : Apr 2, 2025, 10:40:49 AM
    Author     : PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/dashboard.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@400;700" rel="stylesheet" />
    <title>Dashboard</title>
</head>
<body>
    <div class="sidebar">
        <div class="logo"><img src="https://i.pinimg.com/736x/57/1d/61/571d612946ec0c51d55d9b7b6700afc2.jpg" alt="alt"/></div>
        <button onclick="showTab('product')"><span class="material-symbols-outlined">local_florist</span></button>
         <button onclick="window.location.href='dash-order.jsp'"><span class="material-symbols-outlined">receipt_long</span></button>
        <button onclick="showTab('client')"><span class="material-symbols-outlined">person</span></button>
    </div>

    <div class="overlay"></div> <!-- Thêm overlay -->

    <div id="product" class="tab-content active">    
        <div class="header-top">
            <a href="#" class="logo">FlowerLover</a>
        </div>
        <div class="content">
            <div class="header">
                <h2>Quản lý sản phẩm</h2>
                <button onclick="toggleForm()">+ Thêm mới</button>
            </div>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Ảnh</th>
                    <th>Phân loại</th>
                    <th>Mô tả</th>
                </tr>
                <c:forEach var="flower" items="${flowers}">
                    <tr>
                        <td>${not empty flower.id ? flower.id : 'Chưa có ID'}</td>
                        <td>${not empty flower.name ? flower.name : 'Chưa có tên'}</td>
                        <td>${not empty flower.price ? flower.price : 0} VNĐ</td>
                        <td>${not empty flower.stock ? flower.stock : 0}</td>
                        <td><img src="${not empty flower.image ? flower.image : ''}" alt="${not empty flower.name ? flower.name : 'Ảnh không có'}" width="50"/></td>
                        <td>${not empty flower.category ? flower.category : 'Chưa phân loại'}</td>
                        <td>${not empty flower.description ? flower.description : ''}</td>
                    </tr>
                </c:forEach>
            </table>
            
            <div class="add-form" id="addForm">
                <form id="addFlowerForm" action="addFlower" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="name">Tên sản phẩm:</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="price">Giá:</label>
                        <input type="number" id="price" name="price" step="0.01" required>
                    </div>
                    <div class="form-group">
                        <label for="image">Ảnh:</label>
                        <input type="file" id="image" name="image" accept="image/*" required>
                    </div>
                    <div class="form-group">
                        <label for="category">Phân loại:</label>
                        <select id="category" name="category" required>
                            <option value="bó hoa">Bó hoa</option>
                            <option value="lãng hoa">Lãng hoa</option>
                            <option value="giỏ hoa">Giỏ hoa</option>
                            <option value="hoa thô">Hoa thô</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="stock">Số lượng:</label>
                        <input type="number" id="stock" name="stock" min="0" required>
                    </div>
                    <div class="form-group">
                        <label for="description">Mô tả:</label>
                        <textarea id="description" name="description" rows="3" required></textarea>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="save-btn">Lưu</button>
                        <button type="button" class="cancel-btn" onclick="toggleForm()">Hủy</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Form Chỉnh sửa -->
            <div class="edit-form" id="editForm">
                <form id="editFlowerForm" action="updateFlower" method="put" enctype="multipart/form-data">
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
                        <input type="number" id="editPrice" name="price" step="0.01" required>
                    </div>
                    <div class="form-group">
                        <label for="editImage">Ảnh:</label>
                        <input type="file" id="editImage" name="image" accept="image/*">
                        <input type="hidden" id="editCurrentImage" name="currentImage">
                    </div>
                    <div class="form-group">
                        <label for="editCategory">Phân loại:</label>
                        <select id="editCategory" name="category" required>
                            <option value="bó hoa">Bó hoa</option>
                            <option value="lãng hoa">Lãng hoa</option>
                            <option value="giỏ hoa">Giỏ hoa</option>
                            <option value="hoa thô">Hoa thô</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editStock">Số lượng:</label>
                        <input type="number" id="editStock" name="stock" min="0" required>
                    </div>
                    <div class="form-group">
                        <label for="editDescription">Mô tả:</label>
                        <textarea id="editDescription" name="description" rows="3" required></textarea>
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

<script>
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

    function toggleForm(isEdit = false, id = '', name = '', price = 0, stock = 0, image = '', category = '', description = '') {
        const form = document.getElementById('addForm');
        const overlay = document.querySelector('.overlay');
        form.classList.toggle('active');
        overlay.classList.toggle('active');

        const formElement = document.getElementById('addFlowerForm');
        if (form.classList.contains('active')) {
            document.getElementById('name').value = name;
            document.getElementById('price').value = price;
            document.getElementById('stock').value = stock;
            document.getElementById('image').value = ''; // Không thể set file, chỉ reset
            document.getElementById('category').value = category;
            document.getElementById('description').value = description;

            // Thay đổi action và method cho cập nhật
            if (isEdit) {
                formElement.action = `/updateFlower?id=${id}`;
                formElement.method = 'PUT'; // Sử dụng PUT cho cập nhật
                document.querySelector('.save-btn').textContent = 'Cập nhật';
            } else {
                formElement.action = '/addFlower';
                formElement.method = 'POST';
                document.querySelector('.save-btn').textContent = 'Lưu';
                formElement.reset();
            }
        } else {
            formElement.reset();
        }
    }
    
function toggleEditForm(id = '', name = '', price = 0, stock = 0, image = '', category = '', description = '') {
    const form = document.getElementById('editForm');
    const overlay = document.querySelector('.overlay');
    form.classList.toggle('active');
    overlay.classList.toggle('active');

    const formElement = document.getElementById('editFlowerForm');
    if (form.classList.contains('active')) {
        document.getElementById('editId').value = id || '';
        document.getElementById('editName').value = name || '';
       ument.getElementById('editImage').value = ''; // Reset file input
        document.getElementById('editCategory').value = category || 'bó hoa';
        document.getElementById('editDescription').value = description || '';
        doc document.getElementById('editPrice').value = price || 0;
        document.getElementById('editStock').value = stock || 0;
        document.getElementById('editImage').value = ''; // Reset file input
        document.getElementById('editCategory').value = category || 'bó hoa';
        document.getElementById('editDescription').value = description || '';
        document.getElementById('editCurrentImage').value = image || '';
    } else {
        formElement.reset();
        document.getElementById('editCurrentImage').value = '';
    }
}

function editFlower(id, name, price, stock, image, category, description) {
    // Thoát ký tự đặc biệt để tránh lỗi cú pháp
    name = name.replace(/'/g, "\\'").replace(/"/g, '\\"');
    description = description.replace(/'/g, "\\'").replace(/"/g, '\\"');
    toggleEditForm(id, name, price, stock, image, category, description);
}





    function renderTable(flowers) {
        const table = document.querySelector('.content table');
        table.innerHTML = `
            <tr>
                <th>ID</th>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Ảnh</th>
                <th>Phân loại</th>
                <th>Mô tả</th>
                <th> </th>
            </tr>
        `;
        flowers.forEach(flower => {
            const row = table.insertRow();
            row.innerHTML = `
                <td>${flower.id || flower._id.$oid}</td>
                <td>${flower.name}</td>
                <td>${flower.price} VNĐ</td>
                <td>${flower.stock != null ? flower.stock : 0}</td>
                <td><img src="${flower.image}" alt="${flower.name}" width="50"/></td>
                <td>${flower.category}</td>
                <td>${flower.description}</td>
                <td>
                    <button class="edit-btn" onclick="editFlower('${flower.id}', '${flower.name}', ${flower.price}, ${flower.stock}, '${flower.image}', '${flower.category}', '${flower.description}')">
                        <span class="material-symbols-outlined">edit</span>
                    </button>
                    <button class="delete-btn" onclick="confirmDelete('${flower.id}')">
                        <span class="material-symbols-outlined">delete</span>
                    </button>
                </td>
            `;
        });
    }

    document.getElementById('addFlowerForm').addEventListener('submit', function(event) {
        event.preventDefault();

        const formData = new FormData(this);
        const method = this.method.toUpperCase();
        fetch(this.action, {
            method: method,
            body: formData
        })
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.json();
        })
        .then(data => {
            if (data.success) {
                alert(method === 'POST' ? 'Thêm sản phẩm thành công!' : 'Cập nhật sản phẩm thành công!');
                toggleForm();
                fetch('/dashboard')
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            renderTable(data.flowers);
                        }
                    })
                    .catch(error => console.error('Lỗi khi cập nhật bảng:', error));
            } else {
                alert((method === 'POST' ? 'Thêm' : 'Cập nhật') + ' sản phẩm thất bại: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Lỗi chi tiết:', error);
            alert('Đã xảy ra lỗi khi ' + (method === 'POST' ? 'thêm' : 'cập nhật') + ' sản phẩm: ' + error.message);
        });
    });

    // Load bảng khi trang mở
    window.onload = function() {
        fetch('/dashboard')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    renderTable(data.flowers);
                }
            })
            .catch(error => console.error('Lỗi khi tải bảng:', error));
    };
</script>
</body>
</html>