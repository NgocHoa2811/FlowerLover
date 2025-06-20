package com.flowershop.controller;

import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import org.bson.types.ObjectId;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dashboard-data")
public class DashboardServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
        System.out.println("MongoDB client initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> collection = database.getCollection("products");
            List<Document> flowers = collection.find().into(new ArrayList<>());
            System.out.println("Fetched " + flowers.size() + " documents from products collection");

            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("{\"success\": true, \"flowers\": [");
            for (int i = 0; i < flowers.size(); i++) {
                Document flower = flowers.get(i);
                jsonBuilder.append("{");
                jsonBuilder.append("\"_id\": \"").append(flower.getObjectId("_id") != null ? flower.getObjectId("_id").toString() : "").append("\",");
                jsonBuilder.append("\"name\": \"").append(escapeJson(flower.getString("name"))).append("\",");
                Object priceObj = flower.get("price");
                double price = (priceObj instanceof Number) ? ((Number) priceObj).doubleValue() : 0.0;
                jsonBuilder.append("\"price\": ").append(price).append(",");
                Object quantityObj = flower.get("quantity");
                int quantity = (quantityObj instanceof Number) ? ((Number) quantityObj).intValue() : 0;
                jsonBuilder.append("\"quantity\": ").append(quantity).append(",");
                List<String> images = flower.getList("images", String.class);
                jsonBuilder.append("\"images\": [");
                for (int j = 0; j < images.size(); j++) {
                    jsonBuilder.append("\"").append(escapeJson(images.get(j))).append("\"");
                    if (j < images.size() - 1) {
                        jsonBuilder.append(",");
                    }
                }
                jsonBuilder.append("],");

                jsonBuilder.append("\"category\": \"").append(escapeJson(flower.getString("category"))).append("\",");
                jsonBuilder.append("\"description\": \"").append(escapeJson(flower.getString("description"))).append("\",");
                jsonBuilder.append("\"color\": \"").append(escapeJson(flower.getString("color"))).append("\",");
                jsonBuilder.append("\"flowerType\": \"").append(escapeJson(flower.getString("flowerType"))).append("\",");
                jsonBuilder.append("\"size\": \"").append(escapeJson(flower.getString("size"))).append("\",");
                jsonBuilder.append("\"status\": \"").append(escapeJson(flower.getString("status"))).append("\"");
                jsonBuilder.append("}");
                if (i < flowers.size() - 1) jsonBuilder.append(",");
            }
            jsonBuilder.append("]}");

            response.getWriter().write(jsonBuilder.toString());
        } catch (Exception e) {
            System.err.println("Error in DashboardServlet: " + e.getMessage());
            response.getWriter().write("{\"success\": false, \"message\": \"Failed to load dashboard: " + e.getMessage() + "\"}");
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\"", "\\\"").replace("\n", "\\n");
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("MongoDB client closed");
        }
    }
}