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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import at.favre.lib.crypto.bcrypt.BCrypt;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
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
        System.out.println("LoginServlet: doPost called");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> users = database.getCollection("users");

            Document query = new Document("email", email);
            Document user = users.find(query).first();

            if (user != null) {
                // Kiểm tra mật khẩu đã mã hóa
                String hashedPassword = user.getString("password");
                BCrypt.Result result = BCrypt.verifyer().verify(password.toCharArray(), hashedPassword.toCharArray());
                if (result.verified) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user.getString("email"));
                    session.setAttribute("role", user.getString("role"));

                    // Chuyển hướng dựa trên vai trò
                    String role = user.getString("role");
                    if ("admin".equals(role)) {
                        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                    }
                } else {
                    request.setAttribute("errorMessage", "Email hoặc mật khẩu không đúng");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Email hoặc mật khẩu không đúng");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi đăng nhập: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
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