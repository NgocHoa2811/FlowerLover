package com.flowershop.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

import com.google.gson.Gson;

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("application/json;charset=UTF-8");
    PrintWriter out = response.getWriter();

    String productId = request.getParameter("productId");
    String quantityStr = request.getParameter("quantity");
    int quantity = 1; // Giá trị mặc định
    if (quantityStr != null && !quantityStr.isEmpty()) {
        try {
            quantity = Integer.parseInt(quantityStr);
            if (quantity < 1) quantity = 1; // Đảm bảo số lượng không âm
        } catch (NumberFormatException e) {
            quantity = 1; // Xử lý nếu quantity không hợp lệ
        }
    }

    HttpSession session = request.getSession();
    @SuppressWarnings("unchecked")
    Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
    }

    cart.put(productId, cart.getOrDefault(productId, 0) + quantity);

    session.setAttribute("cart", cart);

    Map<String, Object> result = new HashMap<>();
    result.put("success", true);
    result.put("cartSize", cart.size());
    result.put("quantity", cart.get(productId)); // Trả về số lượng hiện tại
    out.write(new Gson().toJson(result));
    out.flush();
}
}
