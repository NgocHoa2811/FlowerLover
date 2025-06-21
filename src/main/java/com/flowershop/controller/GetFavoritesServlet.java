package com.flowershop.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.ArrayList;
import com.google.gson.Gson;

@WebServlet("/get-favorites")
public class GetFavoritesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false); // Không tạo mới nếu chưa có session
        List<String> favorites = session != null ? (List<String>) session.getAttribute("favorites") : new ArrayList<>();

        if (favorites == null) {
            favorites = new ArrayList<>();
        }

        out.write(new Gson().toJson(favorites));
    }
}
