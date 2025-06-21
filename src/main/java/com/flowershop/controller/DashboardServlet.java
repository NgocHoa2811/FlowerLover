package com.flowershop.controller;

import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
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
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> collection = database.getCollection("products");
            List<Document> flowers = collection.find().into(new ArrayList<>());

            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("{\"success\": true, \"flowers\": [");

            for (int i = 0; i < flowers.size(); i++) {
                Document flower = flowers.get(i);

                jsonBuilder.append("{");
                jsonBuilder.append("\"_id\": \"").append(flower.getObjectId("_id").toString()).append("\",");
                jsonBuilder.append("\"name\": \"").append(escapeJson(flower.getString("name"))).append("\",");

                double price = flower.get("price") instanceof Number ? ((Number) flower.get("price")).doubleValue() : 0.0;
                jsonBuilder.append("\"price\": ").append(price).append(",");

                int quantity = flower.get("quantity") instanceof Number ? ((Number) flower.get("quantity")).intValue() : 0;
                jsonBuilder.append("\"quantity\": ").append(quantity).append(",");

                List<String> images = flower.getList("images", String.class);
                jsonBuilder.append("\"images\": [");
                if (images != null && !images.isEmpty()) {
                    for (int j = 0; j < images.size(); j++) {
                        jsonBuilder.append("\"").append(escapeJson(images.get(j))).append("\"");
                        if (j < images.size() - 1) jsonBuilder.append(",");
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

            out.write(jsonBuilder.toString());
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"success\": false, \"message\": \"Failed to load data: " + escapeJson(e.getMessage()) + "\"}");
        } finally {
            out.close();
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("MongoDB client closed");
        }
    }
}
