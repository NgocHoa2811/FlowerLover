const contextPath = document.body.getAttribute("data-context") || "";
const productId = document.body.getAttribute("data-product-id") || "";

$(document).ready(function () {
  $('#plusBtn').click(function () {
    let qty = parseInt($('#quantity').val());
    $('#quantity').val(qty + 1);
  });

  $('#minusBtn').click(function () {
    let qty = parseInt($('#quantity').val());
    if (qty > 1) $('#quantity').val(qty - 1);
  });

  $('#addToCart').click(function () {
    const quantity = $('#quantity').val();
    $.post(`${contextPath}/add-to-cart`, { productId, quantity }, function () {
      showToast('Đã thêm vào giỏ hàng!');
    }).fail(() => showToast('Lỗi khi thêm vào giỏ hàng'));
  });

  $('#buyNow').click(function () {
    const quantity = $('#quantity').val();
    window.location.href = `${contextPath}/invoice.jsp?productId=${productId}&quantity=${quantity}`;
  });

  $('#addToFavorite').click(function () {
    const icon = $(this).find('i');
    const isFavorite = icon.hasClass('fas');
    const action = isFavorite ? 'remove' : 'add';

    $.post(`${contextPath}/favorite`, { productId, action }, function (res) {
      icon.toggleClass('far fas');
      $('#addToFavorite').toggleClass('favorited', res.isFavorite);
    });
  });

  $('.thumbnail').click(function () {
    const src = $(this).attr('src');
    $('#mainImage').attr('src', src);
    $('.thumbnail').removeClass('selected');
    $(this).addClass('selected');
  });
});

function showToast(message) {
  let toast = $('#toast');
  if (!toast.length) {
    toast = $('<div id="toast" style="position: fixed; bottom: 20px; right: 20px; background-color: #22392C; color: white; padding: 10px 20px; border-radius: 8px; display: none; z-index: 1000; font-size: 14px; box-shadow: 0 2px 10px rgba(0,0,0,0.2);"></div>');
    $('body').append(toast);
  }
  toast.text(message).fadeIn(400);
  setTimeout(() => toast.fadeOut(400), 2000);
}
