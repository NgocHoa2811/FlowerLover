// js/dash-order.js

window.addEventListener("DOMContentLoaded", () => {
    loadOrders();
});

function loadOrders() {
    fetch("/orders-data")
        .then((res) => res.json())
        .then((data) => {
            const tbody = document.querySelector(".order-table tbody");
            tbody.innerHTML = "";

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
    fetch("/updateOrderStatus", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `orderId=${orderId}&status=${status}`,
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
    alert(`Cập nhật đơn hàng ${orderId}`);
}

function printOrder(orderId) {
    alert(`In đơn hàng ${orderId}`);
}

document.getElementById("orderForm")?.addEventListener("submit", function (event) {
    event.preventDefault();
    const formData = new FormData(this);
    fetch("/addOrder", {
        method: "POST",
        body: formData,
    })
        .then((res) => res.json())
        .then((data) => {
            if (data.success) {
                alert("Thêm đơn hàng thành công!");
                toggleForm();
                location.reload();
            } else {
                alert("Thêm đơn hàng thất bại: " + data.message);
            }
        })
        .catch((err) => {
            console.error("Lỗi khi thêm đơn hàng:", err);
        });
});
