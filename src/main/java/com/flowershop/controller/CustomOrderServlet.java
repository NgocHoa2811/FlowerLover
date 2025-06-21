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
    private static final String USER_COLLECTION = "user";

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
            if (!database.listCollectionNames().into(new java.util.ArrayList<>()).contains(USER_COLLECTION)) {
                database.createCollection(USER_COLLECTION);
                System.out.println("Collection 'user' created successfully");
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
            MongoCollection<Document> usersCollection = database.getCollection(USER_COLLECTION);

            // Lấy dữ liệu từ form
            String name = request.getParameter("name") != null ? request.getParameter("name").trim() : "";
            String phone = request.getParameter("phone") != null ? request.getParameter("phone").trim() : "";
            String address = request.getParameter("address") != null ? request.getParameter("address").trim() : "";
            String product = request.getParameter("product");
            String productType = request.getParameter("product_type");
            String occasion = request.getParameter("occasion");
            String mainFlower = request.getParameter("main_flower");
            String mainColor = request.getParameter("main_color");
            String quantity = request.getParameter("quantity");
            String budget = request.getParameter("budget");
            String description = request.getParameter("description");
            String message = request.getParameter("message");
            String recipientName = request.getParameter("recipient_name") != null ? request.getParameter("recipient_name").trim() : "";
            String recipientPhone = request.getParameter("recipient_phone") != null ? request.getParameter("recipient_phone").trim() : "";
            String deliveryAddress = request.getParameter("delivery_address") != null ? request.getParameter("delivery_address").trim() : "";
            String deliveryDate = request.getParameter("delivery_date");
            String deliveryTime = request.getParameter("delivery_time");

            // Kiểm tra dữ liệu đầu vào
            if (name.isEmpty() || phone.isEmpty() || address.isEmpty() || productType == null || 
                quantity == null || budget == null || recipientName.isEmpty() || 
                recipientPhone.isEmpty() || deliveryAddress.isEmpty() || deliveryDate == null || 
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

            // Lấy userId từ session và truy vấn thông tin người dùng
            HttpSession session = request.getSession(false);
            String userId = null;
            Document user = null;
            if (session != null && session.getAttribute("user") != null) {
                Object userAttr = session.getAttribute("user");
                if (userAttr instanceof Document) {
                    user = (Document) userAttr;
                    ObjectId userObjectId = user.getObjectId("_id");
                    if (userObjectId != null) {
                        userId = userObjectId.toString();
                        System.out.println("User _id from session (Document): " + userId);
                    }
                } else if (userAttr instanceof String) {
                    userId = (String) userAttr;
                    System.out.println("User ID from session (String): " + userId);
                    try {
                        ObjectId objectId = new ObjectId(userId);
                        user = usersCollection.find(new Document("_id", objectId)).first();
                        if (user != null) {
                            System.out.println("User found from database: " + user.toJson());
                        } else {
                            System.out.println("No user found in database with _id: " + userId);
                        }
                    } catch (IllegalArgumentException e) {
                        System.out.println("Invalid ObjectId format: " + userId + " - " + e.getMessage());
                    }
                } else {
                    System.out.println("Unexpected type for session user: " + userAttr.getClass().getName());
                }
            } else {
                System.out.println("No session or user found");
            }

            // Sử dụng thông tin từ user nếu form trống và user tồn tại
            if (user != null) {
                String userName = user.getString("name");
                String userPhone = user.getString("phone");
                String userAddress = user.getString("address");
                name = name.length() == 0 ? (userName != null ? userName : name) : name;
                phone = phone.length() == 0 ? (userPhone != null ? userPhone : phone) : phone;
                address = address.length() == 0 ? (userAddress != null ? userAddress : address) : address;
            }

            // Xử lý tệp ảnh
            String imageBase64 = null;
            jakarta.servlet.http.Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                try (InputStream fileContent = filePart.getInputStream()) {
                    byte[] fileBytes = fileContent.readAllBytes();
                    imageBase64 = Base64.getEncoder().encodeToString(fileBytes);
                } catch (IOException e) {
                    System.out.println("Error processing image: " + e.getMessage());
                    imageBase64 = null; // Tiếp tục mà không có ảnh
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
            try {
                collection.insertOne(order);
                System.out.println("Order saved successfully with userId: " + userId);
            } catch (Exception e) {
                System.out.println("Failed to save order: " + e.getMessage());
                throw new ServletException("Failed to save order", e);
            }

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