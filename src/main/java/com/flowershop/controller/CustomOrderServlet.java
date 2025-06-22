package com.flowershop.controller;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Base64;
import java.util.Date;
import java.util.UUID;

@WebServlet("/CustomOrderServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class CustomOrderServlet extends HttpServlet {

    private MongoClient mongoClient;
    private static final String DB_NAME = "flowerlover";
    private static final String COLLECTION_NAME = "custom_orders";

    @Override
    public void init() throws ServletException {
        try {
            mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
            MongoDatabase database = mongoClient.getDatabase(DB_NAME);

            boolean collectionExists = false;
            for (String name : database.listCollectionNames()) {
                if (COLLECTION_NAME.equals(name)) {
                    collectionExists = true;
                    break;
                }
            }
            if (!collectionExists) {
                database.createCollection(COLLECTION_NAME);
                System.out.println("Created collection: " + COLLECTION_NAME);
            }

            System.out.println("MongoDB initialized for CustomOrderServlet");
        } catch (Exception e) {
            throw new ServletException("MongoDB init failed: " + e.getMessage());
        }
    }

   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        MongoDatabase database = mongoClient.getDatabase(DB_NAME);
        MongoCollection<Document> collection = database.getCollection(COLLECTION_NAME);

        HttpSession session = request.getSession(false);
        String userId = null;
        if (session != null && session.getAttribute("user") != null) {
            userId = session.getAttribute("user").toString();
        }

        // Lấy dữ liệu từ form
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String productType = request.getParameter("product_type");
        String occasion = request.getParameter("occasion");
        String mainFlower = request.getParameter("main_flower");
        String mainColor = request.getParameter("main_color");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int budget = Integer.parseInt(request.getParameter("budget"));
        String description = request.getParameter("description");
        String message = request.getParameter("message");
        String recipientName = request.getParameter("recipient_name");
        String recipientPhone = request.getParameter("recipient_phone");
        String deliveryAddress = request.getParameter("delivery_address");
        String deliveryDate = request.getParameter("delivery_date");
        String deliveryTime = request.getParameter("delivery_time");

        String imageBase64 = null;
        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            try (InputStream input = imagePart.getInputStream()) {
                byte[] bytes = input.readAllBytes();
                imageBase64 = Base64.getEncoder().encodeToString(bytes);
            }
        }

        Document order = new Document();

        // ✅ Lưu đúng kiểu userId nếu có
        if (userId != null) {
            order.append("userId", new ObjectId(userId));
        }

        order.append("name", name)
                .append("phone", phone)
                .append("address", address)
                .append("product_type", productType)
                .append("occasion", occasion)
                .append("main_flower", mainFlower)
                .append("main_color", mainColor)
                .append("quantity", quantity)
                .append("budget", budget)
                .append("description", description)
                .append("image", imageBase64)
                .append("message", message)
                .append("recipient_name", recipientName)
                .append("recipient_phone", recipientPhone)
                .append("delivery_address", deliveryAddress)
                .append("delivery_date", deliveryDate)
                .append("delivery_time", deliveryTime)
                .append("status", "Đang xử lý")
                .append("created_at", new Date());

        collection.insertOne(order);

        // ✅ Redirect để hiển thị SweetAlert
        response.sendRedirect("custom-order.jsp?success=1");

    } catch (Exception e) {
        e.printStackTrace();
        String msg = e.getMessage().replace("\"", "'").replace("\n", "");
        response.sendRedirect("custom-order.jsp?error=" + java.net.URLEncoder.encode(msg, "UTF-8"));
    }
}

}
