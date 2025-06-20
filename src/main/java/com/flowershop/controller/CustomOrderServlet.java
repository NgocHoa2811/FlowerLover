package com.flowershop.controller;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.Base64;

@WebServlet("/CustomOrderServlet")
@MultipartConfig
public class CustomOrderServlet extends HttpServlet {
    private MongoClient mongoClient;
    private static final String DB_NAME = "flowerlover";
    private static final String COLLECTION_NAME = "custom_orders";

    @Override
    public void init() throws ServletException {
        try {
            mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
            System.out.println("MongoDB connection initialized successfully for CustomOrderServlet");
            MongoDatabase database = mongoClient.getDatabase(DB_NAME);
            database.runCommand(new Document("ping", 1));
            if (!database.listCollectionNames().into(new java.util.ArrayList<>()).contains(COLLECTION_NAME)) {
                database.createCollection(COLLECTION_NAME);
                System.out.println("Collection 'custom_orders' created successfully");
            }
        } catch (Exception e) {
            System.out.println("MongoDB connection failed: " + e.getMessage());
            throw new ServletException("Cannot connect to MongoDB", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("CustomOrderServlet: doPost called");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            MongoDatabase database = mongoClient.getDatabase(DB_NAME);
            MongoCollection<Document> collection = database.getCollection(COLLECTION_NAME);

            // Lấy dữ liệu từ form
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String product = request.getParameter("product");
            String productType = request.getParameter("product_type");
            String occasion = request.getParameter("occasion");
            String mainFlower = request.getParameter("main_flower");
            String mainColor = request.getParameter("main_color");
            String quantity = request.getParameter("quantity");
            String budget = request.getParameter("budget");
            String description = request.getParameter("description");
            String message = request.getParameter("message");
            String recipientName = request.getParameter("recipient_name");
            String recipientPhone = request.getParameter("recipient_phone");
            String deliveryAddress = request.getParameter("delivery_address");
            String deliveryDate = request.getParameter("delivery_date");
            String deliveryTime = request.getParameter("delivery_time");

            // Kiểm tra dữ liệu đầu vào
            if (name == null || phone == null || address == null || productType == null || 
                quantity == null || budget == null || recipientName == null || 
                recipientPhone == null || deliveryAddress == null || deliveryDate == null || 
                deliveryTime == null) {
                throw new IllegalArgumentException("Thiếu các trường bắt buộc");
            }

            // Chuyển đổi quantity và budget
            int qty, budg;
            try {
                qty = Integer.parseInt(quantity);
                budg = Integer.parseInt(budget);
                if (qty < 1) throw new IllegalArgumentException("Số lượng phải lớn hơn 0");
                if (budg < 0) throw new IllegalArgumentException("Ngân sách không được âm");
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Số lượng hoặc ngân sách không hợp lệ");
            }

            // Lấy userId từ session (xử lý cả String và Document)
            HttpSession session = request.getSession(false);
            String userId = null;
            if (session != null && session.getAttribute("user") != null) {
                Object userAttr = session.getAttribute("user");
                if (userAttr instanceof Document) {
                    Document user = (Document) userAttr;
                    ObjectId userObjectId = user.getObjectId("_id");
                    if (userObjectId != null) {
                        userId = userObjectId.toString();
                        System.out.println("User _id from session (Document): " + userId);
                    } else {
                        System.out.println("No _id found in session user document");
                    }
                } else if (userAttr instanceof String) {
                    userId = (String) userAttr; // Giả định String là userId
                    System.out.println("User ID from session (String): " + userId);
                } else {
                    System.out.println("Unexpected type for session user: " + userAttr.getClass().getName());
                }
            } else {
                System.out.println("No session or user found");
            }

            // Xử lý tệp ảnh
            String imageBase64 = null;
            jakarta.servlet.http.Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                try (InputStream fileContent = filePart.getInputStream()) {
                    byte[] fileBytes = fileContent.readAllBytes();
                    imageBase64 = Base64.getEncoder().encodeToString(fileBytes);
                }
            }

            // Tạo document để lưu vào MongoDB
            Document order = new Document()
                    .append("name", name)
                    .append("phone", phone)
                    .append("address", address)
                    .append("product", product)
                    .append("product_type", productType)
                    .append("occasion", occasion != null ? occasion : "")
                    .append("main_flower", mainFlower != null ? mainFlower : "")
                    .append("main_color", mainColor != null ? mainColor : "")
                    .append("quantity", qty)
                    .append("budget", budg)
                    .append("description", description != null ? description : "")
                    .append("image", imageBase64)
                    .append("message", message != null ? message : "")
                    .append("recipient_name", recipientName)
                    .append("recipient_phone", recipientPhone)
                    .append("delivery_address", deliveryAddress)
                    .append("delivery_date", deliveryDate)
                    .append("delivery_time", deliveryTime)
                    .append("userId", userId)
                    .append("created_at", new java.util.Date());

            // Lưu document vào collection
            collection.insertOne(order);
            System.out.println("Order saved successfully with userId: " + userId);

            // Chuyển hướng với thông báo thành công
            response.sendRedirect(request.getContextPath() + "/custom-order.jsp?success=1");
        } catch (Exception e) {
            System.out.println("Error processing order: " + e.getMessage());
            e.printStackTrace();
            String errorMessage = URLEncoder.encode("Đã xảy ra lỗi khi lưu đơn hàng: " + e.getMessage(), "UTF-8");
            response.sendRedirect(request.getContextPath() + "/custom-order.jsp?error=" + errorMessage);
        }
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("MongoDB connection closed for CustomOrderServlet.");
        }
    }
}