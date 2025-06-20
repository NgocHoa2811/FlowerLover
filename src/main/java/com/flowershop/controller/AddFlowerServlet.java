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
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AddFlowerServlet extends HttpServlet {
    private MongoClient mongoClient;
    private static final String UPLOAD_DIR = "D:/java/FlowerLover/web/uploads"; // Đường dẫn cụ thể, thay đổi nếu cần

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
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> collection = database.getCollection("products");

            // Lấy dữ liệu từ form
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String quantityStr = request.getParameter("quantity");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String color = request.getParameter("color");
            String flowerType = request.getParameter("flowerType");
            String size = request.getParameter("size");
            String status = request.getParameter("status");

            // Kiểm tra và parse số
            if (name == null || priceStr == null || quantityStr == null || category == null || status == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không đầy đủ!\"}");
                return;
            }

            double price = 0.0;
            int quantity = 0;
            try {
                price = Double.parseDouble(priceStr);
                quantity = Integer.parseInt(quantityStr);
            } catch (NumberFormatException e) {
                response.getWriter().write("{\"success\": false, \"message\": \"Giá hoặc số lượng không hợp lệ!\"}");
                return;
            }

            // Kiểm tra trùng lặp dựa trên name
            Document existingFlower = collection.find(new Document("name", name)).first();
            if (existingFlower != null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Sản phẩm đã tồn tại!\"}");
                return;
            }

            // Tạo hoặc kiểm tra thư mục uploads
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Xử lý upload ảnh
            List<String> images = new ArrayList<>();
            for (Part part : request.getParts()) {
                if (part.getName().equals("images") && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    String fileName = UUID.randomUUID().toString() + "_" + part.getSubmittedFileName(); // Tạo tên file duy nhất
                    File file = new File(uploadDir, fileName);
                    part.write(file.getAbsolutePath());
                    images.add("/uploads/" + fileName); // Lưu đường dẫn tương đối
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