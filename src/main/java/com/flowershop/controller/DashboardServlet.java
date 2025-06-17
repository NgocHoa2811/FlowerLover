package com.flowershop.controller;

import com.flowershop.model.Flower;
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
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(DashboardServlet.class);
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        int maxAttempts = 3;
        for (int attempt = 1; attempt <= maxAttempts; attempt++) {
            try {
                logger.debug("Attempting to connect to MongoDB - Attempt {} of {}", attempt, maxAttempts);
                mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
                logger.info("MongoDB connection initialized successfully at {} (Attempt {})", new java.util.Date(), attempt);
                MongoDatabase database = mongoClient.getDatabase("flowerlover");
                logger.debug("Pinging MongoDB database: flowerlover");
                database.runCommand(new Document("ping", 1));
                logger.info("MongoDB ping successful at {}", new java.util.Date());
                break;
            } catch (Exception e) {
                logger.error("MongoDB connection failed at {} (Attempt {}): {}", new java.util.Date(), attempt, e.getMessage());
                if (attempt == maxAttempts) {
                    throw new ServletException("Cannot connect to MongoDB after " + maxAttempts + " attempts", e);
                }
                try {
                    logger.debug("Waiting 2 seconds before next attempt...");
                    Thread.sleep(2000); // Chờ 2 giây trước khi thử lại
                } catch (InterruptedException ie) {
                    logger.error("Interrupted while waiting for retry at {}: {}", new java.util.Date(), ie.getMessage());
                    Thread.currentThread().interrupt();
                    throw new ServletException("Interrupted while retrying MongoDB connection", ie);
                }
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    JSONObject jsonResponse = new JSONObject();
    logger.info("Received GET request to /dashboard at {}", new java.util.Date());

    try {
        MongoDatabase database = mongoClient.getDatabase("flowerlover");
        MongoCollection<Document> flowers = database.getCollection("flowers");

        List<Flower> flowersList = new ArrayList<>();
        for (Document doc : flowers.find().limit(100)) {
            Flower flower = new Flower();
            // Luôn lấy _id từ MongoDB làm id
            flower.setId(doc.getObjectId("_id") != null ? doc.getObjectId("_id").toHexString() : null);
            flower.setName(doc.getString("name"));
            Double price = doc.get("price", Double.class);
            flower.setPrice(price != null ? price : 0.0);
            flower.setImage(doc.getString("image"));
            flower.setCategory(doc.getString("category"));
            Integer stock = doc.getInteger("stock", 0);
            flower.setStock(stock);
            flower.setDescription(doc.getString("description"));
            if (doc.containsKey("created_at")) {
                flower.setCreatedAt(doc.getDate("created_at").toString());
            }
            flowersList.add(flower);
        }

        JSONArray jsonArray = new JSONArray();
        if (flowersList.isEmpty()) {
            logger.warn("No flowers found in collection at {}", new java.util.Date());
        } else {
            for (Flower flower : flowersList) {
                JSONObject flowerJson = new JSONObject();
                flowerJson.put("id", flower.getId()); // Đảm bảo id luôn có giá trị
                flowerJson.put("name", flower.getName() != null ? flower.getName() : "Chưa có tên");
                flowerJson.put("price", flower.getPrice());
                flowerJson.put("image", flower.getImage() != null ? flower.getImage() : "");
                flowerJson.put("category", flower.getCategory() != null ? flower.getCategory() : "");
                flowerJson.put("stock", flower.getStock() != null ? flower.getStock() : 0);
                flowerJson.put("description", flower.getDescription() != null ? flower.getDescription() : "");
                flowerJson.put("created_at", flower.getCreatedAt() != null ? flower.getCreatedAt() : "");
                jsonArray.put(flowerJson);
            }
        }

        jsonResponse.put("success", true);
        jsonResponse.put("flowers", jsonArray);
        response.getWriter().write(jsonResponse.toString());
    } catch (Exception e) {
        logger.error("Error fetching data at {}: {}", new java.util.Date(), e.getMessage(), e);
        jsonResponse.put("success", false);
        jsonResponse.put("message", "Lỗi khi lấy dữ liệu: " + e.getMessage());
        response.getWriter().write(jsonResponse.toString());
    }
}

    @Override
    public void destroy() {
        if (mongoClient != null) {
            try {
                logger.debug("Attempting to close MongoDB connection...");
                mongoClient.close();
                logger.info("MongoDB connection closed at {}", new java.util.Date());
            } catch (Exception e) {
                logger.error("Failed to close MongoDB connection at {}: {}", new java.util.Date(), e.getMessage());
            }
        }
    }
}