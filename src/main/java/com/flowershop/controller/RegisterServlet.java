package com.flowershop.controller;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import at.favre.lib.crypto.bcrypt.BCrypt;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        try {
            mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
            System.out.println("MongoDB connection initialized successfully");
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            database.runCommand(new Document("ping", 1));
        } catch (Exception e) {
            System.out.println("MongoDB connection failed: " + e.getMessage());
            throw new ServletException("Cannot connect to MongoDB", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("RegisterServlet: doPost called");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> users = database.getCollection("users");

            Document existingUser = users.find(new Document("email", email)).first();
            if (existingUser != null) {
                request.setAttribute("error", "Email đã được sử dụng");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Mã hóa mật khẩu bằng BCrypt
            String hashedPassword = BCrypt.withDefaults().hashToString(12, password.toCharArray());

            // Phân quyền dựa trên domain email
            String role = email.endsWith("@gmail.com") ? "user" : (email.endsWith("@flowerlover.com") ? "admin" : "user");

            Document newUser = new Document("fullName", fullName)
                    .append("email", email)
                    .append("password", hashedPassword)
                    .append("role", role)
                    .append("created_at", new Date());

            users.insertOne(newUser);
            System.out.println("User inserted successfully: " + email);
            response.sendRedirect("login.jsp?register=success");
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi khi đăng ký: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("MongoDB connection closed.");
        }
    }
}