package com.flowershop.controller;

import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/addFlower")
@MultipartConfig
public class AddFlowerServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> collection = database.getCollection("products");

            // Lấy dữ liệu từ form
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String color = request.getParameter("color");
            String flowerType = request.getParameter("flowerType");
            String size = request.getParameter("size");
            String status = request.getParameter("status");

            // Kiểm tra trùng lặp dựa trên name
            Document existingFlower = collection.find(new Document("name", name)).first();
            if (existingFlower != null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Sản phẩm đã tồn tại!\"}");
                return;
            }

            // Xử lý upload ảnh (giả sử bạn đã có logic này)
            List<String> images = new ArrayList<>();
            for (Part part : request.getParts()) {
                if (part.getName().equals("images")) {
                    String fileName = part.getSubmittedFileName();
                    // Logic lưu file (giả sử lưu vào thư mục uploads)
                    images.add("/uploads/" + fileName); // Cập nhật đường dẫn thực tế
                }
            }

            // Tạo document mới
            Document newFlower = new Document()
                    .append("name", name)
                    .append("price", price)
                    .append("quantity", quantity)
                    .append("images", images)
                    .append("category", category)
                    .append("description", description)
                    .append("color", color)
                    .append("flowerType", flowerType)
                    .append("size", size)
                    .append("status", status)
                    .append("createdAt", new java.util.Date())
                    .append("updatedAt", new java.util.Date());

            collection.insertOne(newFlower);
            response.getWriter().write("{\"success\": true}");

        } catch (Exception e) {
            System.err.println("Error in AddFlowerServlet: " + e.getMessage());
            response.getWriter().write("{\"success\": false, \"message\": \"Failed to add flower: " + e.getMessage() + "\"}");
        }
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("MongoDB client closed");
        }
    }
}