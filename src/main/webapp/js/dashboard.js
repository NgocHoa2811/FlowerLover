// dashboard.js

function escapeHtml(unsafe) {
    if (!unsafe) return '';
    return unsafe.toString()
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
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
    const headerMap = {
        product: 'Quản lý sản phẩm',
        order: 'Quản lý đơn hàng',
        client: 'Hỗ trợ khách hàng'
    };
    document.querySelector('.header h2').textContent = headerMap[tabId] || tabId;
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
    fetch('/dashboard-data')
        .then(res => res.json())
        .then(data => {
            const tbody = document.getElementById('flowersTableBody');
            tbody.innerHTML = '';

            data.flowers.forEach(f => {
                const row = document.createElement('tr');
                const imageHtml = (f.images || []).map(img => {
                    const fullPath = contextPath + escapeHtml(img);
                    return '<img src="' + fullPath + '" width="50" style="margin-right:4px; border-radius: 4px"/>';
                }).join('');

                row.innerHTML = `
                    <td>${escapeHtml(f._id)}</td>
                    <td>${escapeHtml(f.name)}</td>
                    <td>${f.price} VNĐ</td>
                    <td>${f.quantity}</td>
                    <td><div class="image-gallery">${imageHtml}</div></td>
                    <td>${escapeHtml(f.category || '')}</td>
                    <td>
                        <div class="description-wrapper">
                            <div class="description-preview">${escapeHtml(f.description || '')}</div>
                            <div class="description-popup">${f.description || ''}</div>
                        </div>
                    </td>
                    <td>${escapeHtml(f.color || '')}</td>
                    <td>${escapeHtml(f.flowerType || '')}</td>
                    <td>${escapeHtml(f.size || '')}</td>
                    <td>${escapeHtml(f.status || '')}</td>
                    <td class="action-cell"></td>
                `;

                const actionCell = row.querySelector('.action-cell');

                const editBtn = document.createElement('button');
                editBtn.className = 'edit-btn';
                editBtn.innerHTML = '<span class="material-symbols-outlined">edit</span>';
                editBtn.addEventListener('click', () => {
                    editFlower(
                        f._id, f.name, f.price, f.quantity,
                        (f.images && f.images[0]) || '', f.category, f.description,
                        f.color, f.flowerType, f.size, f.status
                    );
                });

                const delBtn = document.createElement('button');
                delBtn.className = 'delete-btn';
                delBtn.innerHTML = '<span class="material-symbols-outlined">delete</span>';
                delBtn.addEventListener('click', () => confirmDelete(f._id));

                actionCell.append(editBtn, delBtn);
                tbody.appendChild(row);
            });
        })
        .catch(err => console.error(err));
}

document.addEventListener('DOMContentLoaded', () => {
    showTab('product');
    loadFlowers();

    document.getElementById('addFlowerForm')?.addEventListener('submit', e => {
        e.preventDefault();
        const formData = new FormData(e.target);
        fetch('/addFlower', { method: 'POST', body: formData })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    toggleForm();
                    loadFlowers();
                } else {
                    alert('Thêm thất bại: ' + data.message);
                }
            })
            .catch(err => alert('Lỗi khi thêm: ' + err.message));
    });

    document.getElementById('editFlowerForm')?.addEventListener('submit', e => {
        e.preventDefault();
        const formData = new FormData(e.target);
        fetch('/updateFlower', { method: 'POST', body: formData })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert('Cập nhật thành công!');
                        toggleEditForm();
                    loadFlowers();
                } else {
                    alert('Cập nhật thất bại: ' + data.message);
                }
            })
            .catch(err => alert('Lỗi khi cập nhật: ' + err.message));
    });
});
