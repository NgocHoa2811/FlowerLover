let customOrdersList = [];

window.addEventListener("DOMContentLoaded", () => {
    loadCustomOrders();
});

function loadCustomOrders() {
    fetch(`${CONTEXT_PATH}/custom-orders-data`)
        .then((res) => res.json())
        .then((data) => {
            const tbody = document.getElementById("customOrdersTableBody");
            tbody.innerHTML = "";
            customOrdersList = data.orders || [];

            if (data.success && Array.isArray(data.orders)) {
                data.orders.forEach((order, index) => {
                    const status = order.status || "Chờ duyệt";

                    const row = document.createElement("tr");
                    row.innerHTML = `
                        <td>#${String(index + 1).padStart(5, '0')}</td>
                        <td>${order.orderId}</td>
                        <td>${order.userId || "Ẩn danh"}</td>
                        <td>${order.createdAt}</td>
                        <td>
                            <button onclick="viewCustomDetail('${order.orderId}')">Xem</button>
                            <button onclick="deleteCustomOrder('${order.orderId}')">Xóa</button>
                            <select id="status-${order.orderId}">
                                <option value="Chờ duyệt" ${status === "Chờ duyệt" ? "selected" : ""}>Chờ duyệt</option>
                                <option value="Đã xác nhận" ${status === "Đã xác nhận" ? "selected" : ""}>Đã xác nhận</option>
                                <option value="Đã giao" ${status === "Đã giao" ? "selected" : ""}>Đã giao</option>
                                <option value="Đã hủy" ${status === "Đã hủy" ? "selected" : ""}>Đã hủy</option>
                            </select>
                            <button onclick="saveCustomStatus('${order.orderId}')">Lưu</button>
                        </td>
                    `;

                    tbody.appendChild(row);
                });
            } else {
                tbody.innerHTML = "<tr><td colspan='5'>Không có đơn đặt riêng nào.</td></tr>";
            }
        })
        .catch((error) => {
            console.error("Lỗi khi load đơn đặt riêng:", error);
        });
}

function viewCustomDetail(orderId) {
    fetch(`${CONTEXT_PATH}/custom-order-detail?id=${orderId}`)
        .then(res => res.json())
        .then(data => {
            if (!data.success || !data.order) {
                alert("Không tìm thấy thông tin đơn hàng.");
                return;
            }

            const order = data.order;
            const formatter = new Intl.NumberFormat('vi-VN');

            const html = `
                <h3 style="text-align:center">CHI TIẾT ĐƠN ĐẶT RIÊNG</h3>
                <p><strong>Mã đơn hàng:</strong> ${order.orderId}</p>
                <p><strong>Người đặt:</strong> ${order.name || "Ẩn danh"}</p>
                <p><strong>SĐT:</strong> ${order.phone || ""}</p>
                <p><strong>Địa chỉ:</strong> ${order.address || ""}</p>
                <p><strong>Loại sản phẩm:</strong> ${order.product_type}</p>
                <p><strong>Dịp:</strong> ${order.occasion}</p>
                <p><strong>Loài hoa chính:</strong> ${order.main_flower}</p>
                <p><strong>Màu sắc chủ đạo:</strong> ${order.main_color}</p>
                <p><strong>Số lượng:</strong> ${order.quantity}</p>
                <p><strong>Ngân sách:</strong> ${formatter.format(order.budget)} VNĐ</p>
                <p><strong>Mô tả:</strong> ${order.description}</p>
                <p><strong>Lời nhắn:</strong> ${order.message}</p>
                <p><strong>Người nhận:</strong> ${order.recipient_name} - ${order.recipient_phone}</p>
                <p><strong>Giao đến:</strong> ${order.delivery_address}</p>
                <p><strong>Thời gian giao:</strong> ${order.delivery_date} lúc ${order.delivery_time}</p>
                ${order.image ? `<img src="data:image/jpeg;base64,${order.image}" style="max-width:100%; margin-top:10px;" />` : ''}
                <p style="text-align:right; margin-top:40px;">Người lập hóa đơn: ______________________</p>
            `;

            document.getElementById("invoiceContent").innerHTML = html;
            document.getElementById("invoicePopup").style.display = "flex";
        })
        .catch(err => {
            console.error("Lỗi khi tải chi tiết đơn hàng:", err);
            alert("Đã xảy ra lỗi khi lấy dữ liệu.");
        });
}

function closePopup() {
    document.getElementById("invoicePopup").style.display = "none";
}

function updateCustomStatus(orderId, status) {
    fetch(`${CONTEXT_PATH}/UpdateCustomOrderStatusServlet`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `orderId=${encodeURIComponent(orderId)}&status=${encodeURIComponent(status)}`
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            alert("Cập nhật trạng thái thành công!");
        } else {
            alert("Thất bại: " + data.message);
        }
    })
    .catch(err => {
        console.error("Lỗi khi cập nhật trạng thái:", err);
    });
}

function saveCustomStatus(orderId) {
    const select = document.getElementById(`status-${orderId}`);
    const selectedStatus = select.value;
    updateCustomStatus(orderId, selectedStatus);
}

function deleteCustomOrder(orderId) {
    if (!confirm("Bạn có chắc chắn muốn xóa đơn này?")) return;

    fetch(`${CONTEXT_PATH}/delete-custom-order`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `orderId=${encodeURIComponent(orderId)}`
    })
    .then(res => res.json())
    .then(data => {
        alert(data.success ? "Xóa đơn thành công!" : "Xóa thất bại: " + data.message);
        loadCustomOrders();
    })
    .catch(err => {
        console.error("Lỗi khi xóa đơn hàng:", err);
    });
}
