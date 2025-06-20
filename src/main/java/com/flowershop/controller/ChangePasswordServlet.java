package com.flowershop.controller;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import com.mongodb.client.result.UpdateResult;
import org.bson.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import at.favre.lib.crypto.bcrypt.BCrypt;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        try {
            mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
            System.out.println("MongoDB connection initialized successfully for ChangePasswordServlet");
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            database.runCommand(new Document("ping", 1));
        } catch (Exception e) {
            System.out.println("MongoDB connection failed during init: " + e.getMessage());
            throw new ServletException("Cannot connect to MongoDB", e);
        }
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    System.out.println("ChangePasswordServlet: doPost called");

    response.setContentType("text/plain; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");

    String email = request.getParameter("email");
    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");

    // Debug: Log các tham số nhận được
    System.out.println("Received parameters - email: " + email + ", currentPassword: " + currentPassword + ", newPassword: " + newPassword);

    if (email == null || email.isEmpty() || currentPassword == null || currentPassword.isEmpty() || 
        newPassword == null || newPassword.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("❌ Lỗi: Vui lòng cung cấp đầy đủ email và mật khẩu!");
        return;
    }

    try {
        MongoDatabase database = mongoClient.getDatabase("flowerlover");
        MongoCollection<Document> collection = database.getCollection("users");

        Document query = new Document("email", email);
        Document user = collection.find(query).first();

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("❌ Lỗi: Không tìm thấy người dùng!");
            return;
        }

        String storedPassword = user.getString("password");

        if (storedPassword == null) {
            response.getWriter().write("❌ Lỗi: Mật khẩu hiện tại không tồn tại!");
            return;
        }

        if (!BCrypt.verifyer().verify(currentPassword.toCharArray(), storedPassword.toCharArray()).verified) {
            response.getWriter().write("❌ Lỗi: Mật khẩu hiện tại không đúng!");
            return;
        }

        if (newPassword.length() < 6) {
            response.getWriter().write("❌ Lỗi: Mật khẩu mới phải có ít nhất 6 ký tự!");
            return;
        }

        String hashedNewPassword = BCrypt.withDefaults().hashToString(12, newPassword.toCharArray());
        UpdateResult updateResult = collection.updateOne(query, Updates.set("password", hashedNewPassword));

        if (updateResult.getModifiedCount() > 0) {
            HttpSession session = request.getSession();
            session.setAttribute("password", newPassword); // Cẩn thận với bảo mật
            response.getWriter().write("✅ Mật khẩu đã được cập nhật thành công!");
        } else {
            response.getWriter().write("⚠️ Không thể cập nhật mật khẩu!");
        }

    } catch (Exception e) {
        System.out.println("Error changing password: " + e.getMessage());
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("❌ Lỗi khi đổi mật khẩu: " + e.getMessage());
    }
}

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("MongoDB connection closed for ChangePasswordServlet.");
        }
    }
}