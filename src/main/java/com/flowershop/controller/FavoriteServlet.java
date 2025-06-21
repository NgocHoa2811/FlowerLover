package com.flowershop.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/favorite")
public class FavoriteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String productId = request.getParameter("productId");
            String action = request.getParameter("action"); // 🔥 lấy action từ client

            HttpSession session = request.getSession();
            List<String> favorites = (List<String>) session.getAttribute("favorites");
            if (favorites == null) {
                favorites = new ArrayList<>();
            }

            boolean isFavorite = false;

            if ("remove".equalsIgnoreCase(action)) {
                favorites.remove(productId);
                isFavorite = false;
            } else {
                if (!favorites.contains(productId)) {
                    favorites.add(productId);
                }
                isFavorite = true;
            }

            session.setAttribute("favorites", favorites);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("isFavorite", isFavorite);
            out.write(new Gson().toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            out.write(new Gson().toJson(new ResponseMessage("Error: " + e.getMessage())));
        }
    }
}


class ResponseMessage {
    String message;

    public ResponseMessage(String message) {
        this.message = message;
    }
}