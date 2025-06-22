<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, com.mongodb.client.*, org.bson.Document, org.bson.types.ObjectId" %>
<%@ page import="com.flowershop.util.MongoUtil" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng - FlowerLover</title>
        <link rel="stylesheet" href="css/shopping.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
        <script>
            function updateTotal() {
                let total = 0;
                document.querySelectorAll('.product-card input[type=checkbox]:checked').forEach(cb => {
                    total += parseFloat(cb.dataset.subtotal);
                });
                document.getElementById('totalAmount').innerText = total.toLocaleString('vi-VN') + ' VND';
            }

            function changeQuantity(id, delta) {
                const qtyInput = document.getElementById('qty-' + id);
                let qty = parseInt(qtyInput.value) + delta;
                if (qty < 1)
                    qty = 1;
                qtyInput.value = qty;
                document.getElementById('formQty-' + id).submit();
            }

            function deleteSelected() {
                document.getElementById('deleteForm').submit();
            }
        </script>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <section class="gallery-banner">
            <div class="overlay"></div>
            <h1>Giỏ hàng của bạn</h1>
            <p>Danh sách các sản phẩm đã thêm vào giỏ</p>
        </section>

        <%
            Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
            MongoCollection<Document> collection = MongoUtil.getDatabase().getCollection("products");
        %>

        <section class="product-gallery">
            <div class="container">
                <form id="deleteForm" action="remove-from-cart" method="post">
                    <div class="product-grid">
                        <% if (cart != null && !cart.isEmpty()) {
                                double total = 0.0;
                                for (Map.Entry<String, Integer> entry : cart.entrySet()) {
                                    String id = entry.getKey();
                                    int quantity = entry.getValue();

                                    try {
                                        Document product = collection.find(new Document("_id", new ObjectId(id))).first();
                                        if (product != null) {
                                            List<String> images = product.getList("images", String.class);
                                            String imageUrl = (images != null && !images.isEmpty()) ? images.get(0) : "/uploads/default.jpg";
                                            double price = product.getDouble("price");
                                            double subtotal = price * quantity;
                        %>
                        <div class="product-card">
                            <input type="checkbox" name="selectedIds" value="<%=id%>" data-subtotal="<%=subtotal%>" onchange="updateTotal()">
                            <img src="<%=request.getContextPath() + imageUrl%>" alt="<%=product.getString("name")%>">
                            <h3><%=product.getString("name")%></h3>
                            <p>Đơn giá: <%=String.format("%.0f", price)%> VND</p>
                            <form id="formQty-<%=id%>" method="post" action="update-cart">
                                <input type="hidden" name="productId" value="<%=id%>">
                                <div class="quantity-controls">
                                    <button type="button" onclick="changeQuantity('<%=id%>', -1)">-</button>
                                    <input type="text" name="quantity" id="qty-<%=id%>" value="<%=quantity%>" readonly>
                                    <button type="button" onclick="changeQuantity('<%=id%>', 1)">+</button>
                                </div>
                            </form>

                            <form method="post" action="remove-from-cart">
                                <input type="hidden" name="productId" value="<%=id%>">
                                <button type="submit" class="remove-btn">Xóa</button>
                            </form>

                        </div>
                        <%      }
                                } catch (Exception ex) {
                                    out.println("<!-- Lỗi khi lấy sản phẩm trong giỏ hàng: " + ex.getMessage() + " -->");
                                }
                            }
                        %>
                    </div>
                    <div class="cart-actions">
                        <p><strong>Tổng cộng: </strong><span id="totalAmount">0 VND</span></p>
                        <button type="submit" action ="">Xóa đã chọn</button>
                        <button formaction="checkout" formmethod="post">Mua hàng</button>
                    </div>

                </form>
                <% } else { %>
                <p style="text-align: center; font-size: 18px; color: #555;">Giỏ hàng của bạn hiện chưa có sản phẩm nào!</p>
                <% }%>
            </div>
        </section>

        <%@ include file="footer.jsp" %>
    </body>
</html>
