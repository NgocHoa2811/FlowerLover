package com.flowershop.controller;

import com.firework.gson.Gson;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import org.bson.Document;
import org.bson.types.ObjectId;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/GetUserServlet")
public class GetUserServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        try {
            mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
            System.out.println("MongoDB connection initialized successfully for GetUserServlet");
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            database.runCommand(new Document("ping", 1));
        } catch (Exception e) {
            System.out.println("MongoDB connection failed: " + e.getMessage());
            throw new ServletException("Cannot connect to MongoDB", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String id = request.getParameter("id"); // hỗ trợ truy cập bằng _id (ObjectId dạng chuỗi)

        System.out.println("GetUserServlet: called with email=" + email + ", id=" + id);

        if ((email == null || email.isEmpty()) && (id == null || id.isEmpty())) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Phải cung cấp email hoặc id để truy vấn\"}");
            return;
        }

        try {
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> collection = database.getCollection("users");

            Document user = null;

            if (email != null && !email.isEmpty()) {
                user = collection.find(new Document("email", email)).first();
            } else if (id != null && !id.isEmpty()) {
                try {
                    user = collection.find(Filters.eq("_id", new ObjectId(id))).first();
                } catch (IllegalArgumentException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"error\":\"ID không hợp lệ\"}");
                    return;
                }
            }

            if (user != null) {
                Document responseDoc = new Document()
                    .append("email", user.getString("email") != null ? user.getString("email") : "")
                    .append("fullName", user.getString("fullName") != null ? user.getString("fullName") : "")
                    .append("phone", user.getString("phone") != null ? user.getString("phone") : "")
                    .append("address", user.getString("address") != null ? user.getString("address") : "")
                    .append("profileImage", user.getString("profileImage") != null ? user.getString("profileImage") : "");
                     
                String jsonResponse = new Gson().toJson(responseDoc);
                response.setContentType("application/json");
                response.getWriter().write(jsonResponse);
                System.out.println("User data found and returned.");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.setContentType("application/json");
                response.getWriter().write("{\"error\":\"Không tìm thấy user\"}");
                System.out.println("No user found.");
            }
        } catch (Exception e) {
            System.out.println("Error fetching user data: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Lỗi server: " + e.getMessage() + "\"}");
        }
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("MongoDB connection closed for GetUserServlet.");
        }
    }
}
