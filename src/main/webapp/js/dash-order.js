let ordersList = []; // lưu tạm danh sách đơn hàng
let isUpdating = false;
let currentOrderId = null;

window.addEventListener("DOMContentLoaded", () => {
    loadOrders();
});

function loadOrders() {

    fetch("/orders-data")
        .then((res) => res.json())
        .then((data) => {
            
            const tbody = document.querySelector(".order-table tbody");
            tbody.innerHTML = "";
            ordersList = data.orders || [];

            if (data.success && Array.isArray(data.orders)) {
                data.orders.forEach((order, index) => {
                    const row = document.createElement("tr");
                    row.innerHTML = `
                        <td>#${String(index + 1).padStart(5, '0')}</td>
                        <td>${order.orderId}</td>
                        <td>${order.customerName}</td>
                        <td>${order.phone}</td>
                        <td>${order.email}</td>
                        <td>${order.address}</td>
                        <td>${order.productNames}</td>
                        <td>${order.quantity}</td>
                        <td>${order.totalAmount} VNĐ</td>
                        <td>${order.orderDate}</td>
                        <td>${order.paymentMethod}</td>
                        <td>
                            <select onchange="updateStatus('${order.orderId}', this.value)">
                                <option value="Đang xử lý" ${order.status === 'Đang xử lý' ? 'selected' : ''}>Đang xử lý</option>
                                <option value="Đã xác nhận" ${order.status === 'Đã xác nhận' ? 'selected' : ''}>Đã xác nhận</option>
                                <option value="Đã giao" ${order.status === 'Đã giao' ? 'selected' : ''}>Đã giao</option>
                                <option value="Đã hủy" ${order.status === 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                        </td>
                        <td>${order.note || ''}</td>
                        <td>
                            <button onclick="viewDetails('${order.orderId}')">Xem chi tiết</button>
                            <button onclick="updateOrder('${order.orderId}')">Cập nhật</button>
                            <button onclick="printOrder('${order.orderId}')">In đơn</button>
                        </td>
                    `;
                    tbody.appendChild(row);
                });
            } else {
                tbody.innerHTML = '<tr><td colspan="14">Không có đơn hàng nào.</td></tr>';
                console.warn("Dữ liệu đơn hàng không hợp lệ:", data);
            }
        })
        .catch((error) => {
            console.error("Lỗi khi load đơn hàng:", error);
        });
}

function updateStatus(orderId, status) {
    console.log("Updating status for:", orderId, "to:", status);
    fetch("/updateOrderStatus", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams({ orderId, status }),

    })
        .then((res) => res.json())
        .then((data) => {
            alert(data.success ? "Cập nhật trạng thái thành công!" : "Cập nhật trạng thái thất bại: " + data.message);
        })
        .catch((err) => {
            console.error("Lỗi khi cập nhật trạng thái:", err);
        });
}

function viewDetails(orderId) {
    alert(`Xem chi tiết đơn hàng ${orderId}`);
}

function updateOrder(orderId) {
    const order = ordersList.find((o) => o.orderId === orderId);
    if (!order) return alert("Không tìm thấy đơn hàng!");

    const form = document.getElementById("orderForm");

    form.customerName.value = order.customerName;
    form.phone.value = order.phone;
    form.email.value = order.email;
    form.address.value = order.address;
    form.productNames.value = order.productNames;
    form.quantity.value = order.quantity;
    form.totalAmount.value = order.totalAmount;
    form.orderDate.value = order.orderDate;
    form.paymentMethod.value = order.paymentMethod;
    form.status.value = order.status;
    form.note.value = order.note || "";

    isUpdating = true;
    currentOrderId = orderId;

    toggleForm(true);
}

function printOrder(orderId) {
    window.open(`/generate-invoice?orderId=${orderId}`, "_blank");
}


function toggleForm(open = undefined) {
    const form = document.getElementById("addForm");
    if (typeof open === "boolean") {
        form.classList.toggle("active", open);
    } else {
        form.classList.toggle("active");
    }

    if (!form.classList.contains("active")) {
        document.getElementById("orderForm").reset();
        isUpdating = false;
        currentOrderId = null;
    }
}

document.getElementById("orderForm")?.addEventListener("submit", function (event) {
    event.preventDefault();
    const formData = new FormData(this);

    let url = "/addOrder";
    if (isUpdating && currentOrderId) {
        formData.append("orderId", currentOrderId);
        url = "/updateOrder";
    }

    fetch(url, {
        method: "POST",
        body: formData,
    })
        .then((res) => res.json())
        .then((data) => {
            if (data.success) {
                alert(isUpdating ? "Cập nhật đơn hàng thành công!" : "Thêm đơn hàng thành công!");
                toggleForm(false);
                loadOrders();
            } else {
                alert((isUpdating ? "Cập nhật" : "Thêm") + " đơn hàng thất bại: " + data.message);
            }
        })
        .catch((err) => {
            console.error("Lỗi:", err);
        });
});
 
        function showTab(tabId) {
            const tabs = document.getElementsByClassName('tab-content');
            for (let i = 0; i < tabs.length; i++) {
                tabs[i].classList.remove('active');
            }
            document.getElementById(tabId).classList.add('active');
            let title = tabId.charAt(0).toUpperCase() + tabId.slice(1);
            if (tabId === 'order') title = 'Quản lý đơn hàng';
            document.querySelector('.header h2').textContent = title;
        }

        function toggleForm() {
            const form = document.getElementById('addForm');
            form.classList.toggle('active');
            if (!form.classList.contains('active')) {
                document.getElementById('orderForm').reset();
            }
        }

        function updateStatus(orderId, status) {
            fetch('/updateOrderStatus', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `orderId=${orderId}&status=${status}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Cập nhật trạng thái thành công!');
                } else {
                    alert('Cập nhật trạng thái thất bại: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Lỗi:', error);
                alert('Đã xảy ra lỗi khi cập nhật trạng thái.');
            });
        }
function viewDetails(orderId) {
    const order = ordersList.find(o => o.orderId === orderId);
    if (!order) {
        alert("Không tìm thấy đơn hàng!");
        return;
    }

    const formatter = new Intl.NumberFormat('vi-VN');

    const html = `
        <h3 style="text-align:center">HÓA ĐƠN ĐẶT HÀNG</h3>
        <p><strong>Mã đơn hàng:</strong> ${order.orderId}</p>
        <p><strong>Ngày đặt hàng:</strong> ${order.orderDate}</p>
        <p><strong>Khách hàng:</strong> ${order.customerName}</p>
        <p><strong>Số điện thoại:</strong> ${order.phone}</p>
        <p><strong>Email:</strong> ${order.email}</p>
        <p><strong>Địa chỉ:</strong> ${order.address}</p>
        <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</p>
        <p><strong>Trạng thái:</strong> ${order.status}</p>
        <hr>
        <table style="width:100%; border-collapse: collapse; margin-top:10px;">
            <thead>
                <tr>
                    <th style="border:1px solid #ccc; padding:6px;">Sản phẩm</th>
                    <th style="border:1px solid #ccc; padding:6px;">Số lượng</th>
                    <th style="border:1px solid #ccc; padding:6px;">Tổng tiền (VNĐ)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td style="border:1px solid #ccc; padding:6px;">${order.productNames}</td>
                    <td style="border:1px solid #ccc; padding:6px; text-align:center">${order.quantity}</td>
                    <td style="border:1px solid #ccc; padding:6px; text-align:right">${formatter.format(order.totalAmount)}</td>
                </tr>
            </tbody>
        </table>
        ${order.note ? `<p><strong>Ghi chú:</strong> ${order.note}</p>` : ''}
        <p style="text-align:right; margin-top:40px;">Người lập hóa đơn: ______________________</p>
    `;

    document.getElementById('invoiceContent').innerHTML = html;
    document.getElementById('invoicePopup').style.display = 'flex';
}

function closeInvoicePopup() {
    document.getElementById('invoicePopup').style.display = 'none';
}

        function updateOrder(orderId) {
            alert(`Cập nhật đơn hàng ${orderId}`);
            // Implement update logic
        }

function printOrder(orderId) {
    console.log("Đang in orderId:", orderId); // <== Thêm dòng này

    if (!orderId || orderId.length !== 24) {
        alert("Order ID không hợp lệ: " + orderId);
        return;
    }

    window.open(`/generate-invoice?orderId=${orderId}`, "_blank");
}




        document.getElementById('orderForm').addEventListener('submit', function(event) {
            event.preventDefault();
            const formData = new FormData(this);
            fetch('/addOrder', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Thêm đơn hàng thành công!');
                    toggleForm();
                    location.reload();
                } else {
                    alert('Thêm đơn hàng thất bại: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Lỗi:', error);
                alert('Đã xảy ra lỗi khi thêm đơn hàng.');
            });
        });
