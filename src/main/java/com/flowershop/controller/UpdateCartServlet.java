package com.flowershop.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/update-cart")
public class UpdateCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productId = request.getParameter("productId");
        int quantity = 1;
        try {
            quantity = Integer.parseInt(request.getParameter("quantity"));
            if (quantity < 1) quantity = 1;
        } catch (NumberFormatException e) {
            quantity = 1;
        }

        HttpSession session = request.getSession();
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
        }

        cart.put(productId, quantity);
        session.setAttribute("cart", cart);

        response.sendRedirect("cart.jsp");
    }
}
