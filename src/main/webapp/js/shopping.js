let currentPage = 1; // Khai báo biến toàn cục

function showToast(message) {
    const toast = $('#toast');
    toast.text(message).fadeIn(400);

    setTimeout(() => {
        toast.fadeOut(400);
    }, 2000); // Ẩn sau 2 giây
}


// Hàm thoát HTML (tái sử dụng từ dashboard.js)
function escapeHtml(unsafe) {
    if (!unsafe)
        return '';
    return unsafe
            .toString()
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;") // Sửa thành &quot; thay vì """
            .replace(/'/g, "&#039;");
}

// Hàm load sản phẩm (tái sử dụng và điều chỉnh từ loadFlowers)
function loadProducts(page) {
    currentPage = page || currentPage;

    // Gọi song song cả 2: danh sách sản phẩm và danh sách yêu thích
    Promise.all([
        fetch(contextPath + '/product-user?page=' + currentPage).then(res => res.json()),
        fetch(contextPath + '/get-favorites').then(res => res.json()),
        fetch(contextPath + '/get-cart').then(res => res.json()) // ⬅️ Lấy thêm giỏ hàng
    ])
            .then(([productData, favorites, cart]) => {
                renderProducts(productData.flowers, favorites, cart); // ⬅️ Truyền thêm cart vào
            })

            .catch(err => {
                $('#productGrid').html('<p style="color: red; text-align: center;">Lỗi: Không thể tải sản phẩm. Vui lòng thử lại! Chi tiết: ' + err.message + '</p>');
                console.error('Fetch error:', err);
            });
}



// Hàm render thẻ sản phẩm
function renderProducts(products, favorites = [], cart = {}) {

    const grid = $('#productGrid');
    grid.empty();

    products.forEach(product => {
        const isFavorite = favorites.includes(product.id); // product.id từ servlet
        const imageUrl = product.imageUrl
                ? contextPath + escapeHtml(product.imageUrl)
                : contextPath + '/uploads/default.jpg';

        const heartIconClass = isFavorite ? "fas fa-heart filled" : "fas fa-heart";

       const cartButtonHtml = `<button class="cart-icon"><i class="fas fa-shopping-cart"></i> Thêm vào giỏ</button>`;

        const card = `
    <div class="product-card" data-id="${escapeHtml(product.id)}" data-category="${escapeHtml(product.category || 'all')}">
        <img src="${imageUrl}" alt="${escapeHtml(product.name)}">
        <span class="favorite-icon" data-id="${escapeHtml(product.id)}">
            <i class="${heartIconClass}"></i>
        </span>
        <h3>${escapeHtml(product.name)}</h3>
        <p>${escapeHtml(product.price)} VND</p>
        <div class="actions">
            ${cartButtonHtml}
            <button class="buy-now">Mua ngay</button>
        </div>
    </div>
`;

        grid.append(card);
    });



    // Xử lý toggle yêu thích
    $('.favorite-icon').off('click').on('click', function (e) {
        e.stopPropagation();
        const iconSpan = $(this); // span.favorite-icon
        const heartIcon = iconSpan.find('i'); // <i class="fas fa-heart">
        const productId = iconSpan.data('id');

        const isCurrentlyFavorite = heartIcon.hasClass('filled');
        const action = isCurrentlyFavorite ? 'remove' : 'add';

        $.ajax({
            url: contextPath + '/favorite',
            type: 'POST',
            data: {
                productId: productId,
                action: action
            },
            success: function (response) {
                if (response.isFavorite) {
                    heartIcon.addClass('filled');  // đúng: add vào <i>
                } else {
                    heartIcon.removeClass('filled');
                }
            },
            error: function () {
                console.error('Lỗi khi cập nhật yêu thích');
            }
        });
    });




    // Xử lý chuyển hướng khi nhấn thẻ hoặc nút Mua ngay
    $('.product-card').off('click').on('click', function (e) {
        if (!$(e.target).closest('.actions').length) {
            const productId = $(this).data('id');
            window.location.href = `product-details.jsp?id=${productId}`;
        }
    });

$('.buy-now').off('click').on('click', function (e) {
    e.stopPropagation();
    const productId = $(this).closest('.product-card').data('id');
    window.location.href = `invoice.jsp?productId=${productId}`;
});



// Xử lý thêm vào giỏ hàng
$('.cart-icon').off('click').on('click', function (e) {
    e.stopPropagation();
    const productId = $(this).closest('.product-card').data('id');

    $.ajax({
        url: contextPath + '/add-to-cart',
        type: 'POST',
        data: { productId },
        success: function () {
            showToast('Đã thêm vào giỏ hàng!');
        },
        error: function () {
            showToast('Lỗi khi thêm vào giỏ hàng');
        }
    });
});



}

// Khởi tạo khi trang được tải
$(document).ready(function () {
    // Tải sản phẩm khi trang được tải
    loadProducts();

    // Xử lý lọc theo danh mục
    $('.category-btn').on('click', function () {
        $('.category-btn').removeClass('active');
        $(this).addClass('active');

        const category = $(this).data('category');
        if (category === 'all') {
            $('.product-card').show();
        } else {
            $('.product-card').hide();
            $('.product-card[data-category="' + category + '"]').show();
        }
    });

    // Tự động cập nhật sản phẩm
    setInterval(() => loadProducts(currentPage), 5000); // Kiểm tra mỗi 5 giây
});