package com.flowershop.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/remove-from-cart")
public class RemoveFromCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");

        if (cart != null) {
            // Xử lý xoá nhiều sản phẩm đã chọn
            String[] selectedIds = request.getParameterValues("selectedIds");
            if (selectedIds != null) {
                for (String id : selectedIds) {
                    cart.remove(id);
                }
            }

            // Xử lý xoá một sản phẩm cụ thể
            String singleProductId = request.getParameter("productId");
            if (singleProductId != null && !singleProductId.isEmpty()) {
                cart.remove(singleProductId);
            }
        }

        response.sendRedirect("cart.jsp");
    }
}
