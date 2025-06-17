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
                        <td>${flower.id}</td>
                        <td>${flower.name}</td>
                        <td>${flower.price} VNĐ</td>
                        <td>${flower.stock != null ? flower.stock : 0}</td>
                        <td><img src="${flower.image}" alt="${flower.name}" width="50"/></td>
                        <td>${flower.category}</td>
                        <td>${flower.description}</td>
                    </tr>
                </c:forEach>
            </table>
            <div class="add-form" id="addForm">
                <form id="addFlowerForm" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="id">ID:</label>
                        <input type="text" id="id" name="id" required>
                    </div>
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

    <div id="order" class="tab-content">
        
    </div>
    <div id="client" class="tab-content">
        
    </div>

<script>
    function showTab(tabId) {
        const tabs = document.getElementsByClassName('tab-content');
        for (let i = 0; i < tabs.length; i++) {
            tabs[i].classList.remove('active');
        }
        document.getElementById(tabId).classList.add('active');
        
        // Cập nhật tiêu đề dựa trên tabId
        let title = tabId.charAt(0).toUpperCase() + tabId.slice(1); // Chuyển thành chữ cái đầu in hoa
        if (tabId === 'product') title = 'Quản lý sản phẩm'; // Tiêu đề đặc biệt cho product
        else if (tabId === 'order') title = 'Quản lý đơn hàng'; // Tiêu đề cho order
        else if (tabId === 'client') title = 'Hỗ trợ khách hàng'; // Tiêu đề cho client
        document.querySelector('.header h2').textContent = title;
    }

    function toggleForm() {
        const form = document.getElementById('addForm');
        form.classList.toggle('active');
        if (!form.classList.contains('active')) {
            document.getElementById('addFlowerForm').reset(); // Reset form khi hủy
        }
    }

    document.getElementById('addFlowerForm').addEventListener('submit', function(event) {
        event.preventDefault();

        const formData = new FormData(this);
        console.log("Dữ liệu gửi đi:", Object.fromEntries(formData)); // Log dữ liệu để kiểm tra
        fetch('/addFlower', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                alert('Thêm sản phẩm thành công!');
                toggleForm();
                location.reload();
            } else {
                alert('Thêm sản phẩm thất bại: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Lỗi:', error);
            alert('Đã xảy ra lỗi khi thêm sản phẩm.');
        });
    });
</script>
</body>
</html>