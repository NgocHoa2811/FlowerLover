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
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/addFlower")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AddFlowerServlet extends HttpServlet {

    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        try {
            mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
            System.out.println("MongoDB client initialized successfully");
        } catch (Exception e) {
            throw new ServletException("Failed to initialize MongoDB client: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // 1. Lấy context path của thư mục /uploads nằm trong thư mục webapp
            String uploadPath = getServletContext().getRealPath("/uploads");
             System.out.println("Upload path: " + uploadPath);
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs(); // Tạo nếu chưa có
               

            }

            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> collection = database.getCollection("products");

            // 2. Lấy dữ liệu từ form
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String quantityStr = request.getParameter("quantity");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String color = request.getParameter("color");
            String flowerType = request.getParameter("flowerType");
            String size = request.getParameter("size");
            String status = request.getParameter("status");

            if (name == null || priceStr == null || quantityStr == null || category == null || status == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không đầy đủ!\"}");
                return;
            }

            double price = Double.parseDouble(priceStr);
            int quantity = Integer.parseInt(quantityStr);

            // 3. Kiểm tra trùng name
            Document existing = collection.find(new Document("name", name)).first();
            if (existing != null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Sản phẩm đã tồn tại!\"}");
                return;
            }

            // 4. Xử lý file ảnh
            List<String> images = new ArrayList<>();
            for (Part part : request.getParts()) {
                if ("images".equals(part.getName()) && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    String fileName = UUID.randomUUID() + "_" + part.getSubmittedFileName();
                    File file = new File(uploadDir, fileName);
                    part.write(file.getAbsolutePath());
                    images.add("/uploads/" + fileName);
                }
            }

            // 5. Thêm vào MongoDB
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
            System.err.println("Lỗi: " + e.getMessage());
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi khi thêm sản phẩm: " + e.getMessage() + "\"}");
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
