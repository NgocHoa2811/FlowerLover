document.addEventListener('DOMContentLoaded', function () {
    const checkboxes = document.querySelectorAll('.product-card input[type="checkbox"]');
    const totalSpan = document.getElementById('totalAmount');

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

    checkboxes.forEach(cb => {
        cb.addEventListener('change', updateTotal);
    });

    updateTotal();

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
