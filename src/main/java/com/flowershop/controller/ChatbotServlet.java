package com.flowershop.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/chat")
public class ChatbotServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tin nhắn người dùng
        String userMessage = request.getParameter("userMessage");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Vui lòng nhập tin nhắn.\"}");
            return;
        }

        // Lấy lịch sử trò chuyện từ session
        List<String> chatHistory = (List<String>) request.getSession().getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
            chatHistory.add("bot:Xin chào! Chúng mình có thể giúp gì cho bạn?");
            request.getSession().setAttribute("chatHistory", chatHistory);
        }

        // Thêm tin nhắn người dùng vào lịch sử
        chatHistory.add("user:" + userMessage);

        // Phản hồi cố định sau tin nhắn người dùng
        String botResponse = "Xin chào, cảm ơn bạn đã liên hệ với chúng tôi. Chúng tôi đã nhận được tin nhắn của bạn và sẽ sớm trả lời.";
        chatHistory.add("bot:" + botResponse);

        // Trả về phản hồi JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"response\":\"" + botResponse.replace("\"", "\\\"") + "\"}");
    }
}