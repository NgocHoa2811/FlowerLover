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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.Base64;

@WebServlet("/UpdateUserServlet")
@MultipartConfig
public class UpdateUserServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        try {
            mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
            System.out.println("MongoDB connection initialized successfully for UpdateUserServlet");
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            database.runCommand(new Document("ping", 1));
        } catch (Exception e) {
            System.out.println("MongoDB connection failed: " + e.getMessage());
            throw new ServletException("Cannot connect to MongoDB", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("UpdateUserServlet: doPost called");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone") != null ? request.getParameter("phone") : "";
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String profileImageBase64 = null;

        System.out.println("Received data - Email: " + email + ", FullName: " + fullName + ", Phone: " + phone +
                          ", Address: " + address + ", Password: " + (password != null ? "set" : "not set"));

        Part part = request.getPart("profileImage");
        if (part != null && part.getSize() > 0) {
            byte[] imageBytes = part.getInputStream().readAllBytes();
            profileImageBase64 = Base64.getEncoder().encodeToString(imageBytes);
            System.out.println("Profile image processed, size: " + part.getSize() + " bytes");
        }

        try {
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> collection = database.getCollection("users");

            Document query = new Document("email", email);
            Document user = collection.find(query).first();

            if (user != null) {
                UpdateResult updateResult = collection.updateOne(query, Updates.combine(
                    Updates.set("fullName", fullName != null && !fullName.isEmpty() ? fullName : user.getString("fullName")),
                    Updates.set("phone", !phone.isEmpty() ? phone : user.getString("phone")),
                    Updates.set("address", address != null && !address.isEmpty() ? address : user.getString("address")),
                    Updates.set("password", password != null && !password.isEmpty() ? password : user.getString("password")),
                    Updates.set("profileImage", profileImageBase64 != null ? profileImageBase64 : user.getString("profileImage"))
                ));

                // NEW: Update session attributes
                HttpSession session = request.getSession();
                session.setAttribute("fullName", fullName != null && !fullName.isEmpty() ? fullName : user.getString("fullName"));
                session.setAttribute("phone", !phone.isEmpty() ? phone : user.getString("phone"));
                session.setAttribute("address", address != null && !address.isEmpty() ? address : user.getString("address"));
                session.setAttribute("profileImage", profileImageBase64 != null ? profileImageBase64 : user.getString("profileImage"));

                System.out.println("Update result: Matched count = " + updateResult.getModifiedCount() + ", Modified count = " + updateResult.getModifiedCount());

                if (updateResult.getModifiedCount() > 0) {
                    response.setContentType("text/plain");
                    response.getWriter().write("Thông tin đã được lưu vào MongoDB!");
                } else {
                    response.setContentType("text/plain");
                    response.getWriter().write("Không có thay đổi nào được lưu vào MongoDB!");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.setContentType("text/plain");
                response.getWriter().write("Lỗi: Không tìm thấy user để cập nhật");
                System.out.println("No user found for email: " + email);
            }
        } catch (Exception e) {
            System.out.println("Error updating user: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("text/plain");
            response.getWriter().write("Lỗi khi cập nhật dữ liệu: " + e.getMessage());
        }
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("MongoDB connection closed for UpdateUserServlet.");
        }
    }
}