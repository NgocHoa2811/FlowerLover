document.addEventListener('DOMContentLoaded', function () {
    const checkboxes = document.querySelectorAll('.product-card input[type="checkbox"]');
    const totalSpan = document.getElementById('totalAmount');

    // Hàm cập nhật tổng tiền
    function updateTotal() {
        let total = 0;
        checkboxes.forEach(cb => {
            if (cb.checked) {
                total += parseFloat(cb.dataset.subtotal || 0);
            }
        });
        if (totalSpan) {
            totalSpan.innerText = total.toLocaleString('vi-VN') + ' VND';
        }
    }

    // Gán sự kiện thay đổi checkbox
    checkboxes.forEach(cb => {
        cb.addEventListener('change', updateTotal);
    });

    updateTotal();

    // Xử lý nút xóa
    const deleteForm = document.getElementById('deleteForm');
    if (deleteForm) {
        const deleteBtn = deleteForm.querySelector('.remove-btn');
        if (deleteBtn) {
            deleteBtn.addEventListener('click', function (e) {
                const selected = deleteForm.querySelectorAll('input[name="selectedIds"]:checked');
                if (selected.length === 0) {
                    e.preventDefault();
                    alert('Vui lòng chọn ít nhất một sản phẩm để xóa.');
                }
            });
        }
    }

    // Hàm tạo hoặc lấy orderId (gọi API giả định)
async function createOrder(selectedItems) {
    try {
        const response = await fetch('/order', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(selectedItems),
        });
        const data = await response.json();
        return data.orderId; // Nhận orderId từ server
    } catch (error) {
        console.error('Lỗi khi tạo đơn hàng:', error);
        alert('Không thể tạo đơn hàng. Vui lòng thử lại!');
        return null;
    }
}

    // Hàm xử lý khi nhấp nút Mua ngay (1 sản phẩm)
    function buyNow(productId, quantity) {
        createOrder([{ productId, quantity }]).then(orderId => {
            if (orderId) {
                window.location.href = `invoice.jsp?orderId=${encodeURIComponent(orderId)}&productId=${encodeURIComponent(productId)}&quantity=${encodeURIComponent(quantity)}`;
            }
        });
    }

    // Hàm xử lý khi nhấp nút Mua hàng (nhiều sản phẩm)
    async function buySelectedProduct() {
        const selectedCheckboxes = document.querySelectorAll('.product-card input[name="selectedIds"]:checked');
        if (selectedCheckboxes.length === 0) {
            alert('Vui lòng chọn ít nhất một sản phẩm để mua!');
            return;
        }

        const selectedItems = [];
        selectedCheckboxes.forEach(cb => {
            const productId = cb.value;
            const qtyInput = document.getElementById('qty-' + productId);
            const quantity = qtyInput ? parseInt(qtyInput.value) || 1 : 1;
            selectedItems.push({ productId, quantity });
        });

        const orderId = await createOrder(selectedItems);
        if (orderId) {
            // Chuyển hướng với mảng productId và quantity
            let queryString = selectedItems.map(item => 
                `productId[]=${encodeURIComponent(item.productId)}&quantity[]=${encodeURIComponent(item.quantity)}`
            ).join('&');
            window.location.href = `invoice.jsp?orderId=${encodeURIComponent(orderId)}&${queryString}`;
        }
    }

    // Gán sự kiện cho nút Mua hàng
    const buyButton = document.querySelector('.cart-actions button[onclick="buySelectedProduct()"]');
    if (buyButton) {
        buyButton.addEventListener('click', buySelectedProduct);
        buyButton.removeAttribute('onclick');
    }

    // Gán sự kiện cho nút Mua ngay trên mỗi product-card
    const buyNowButtons = document.querySelectorAll('.buy-now');
    buyNowButtons.forEach(button => {
        button.addEventListener('click', function (e) {
            e.stopPropagation(); // Ngăn sự kiện lan truyền
            const productCard = this.closest('.product-card');
            const productId = productCard.querySelector('input[name="selectedIds"]').value;
            const qtyInput = productCard.querySelector('input[id^="qty-"]');
            const quantity = qtyInput ? parseInt(qtyInput.value) || 1 : 1;
            buyNow(productId, quantity);
        });
    });
});

function changeQuantity(id, delta) {
    const qtyInput = document.getElementById('qty-' + id);
    if (!qtyInput) return;
    let qty = parseInt(qtyInput.value) + delta;
    if (qty < 1) qty = 1;
    qtyInput.value = qty;
    const form = document.getElementById('formQty-' + id);
    if (form) form.submit();
}