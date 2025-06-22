package com.flowershop.controller;

import com.mongodb.client.*;
import org.bson.Document;
import org.bson.types.ObjectId;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/custom-orders-data")
public class DashCustomOrderServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            MongoDatabase db = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> customOrders = db.getCollection("custom_orders");

            List<Document> orders = customOrders.find().sort(new Document("created_at", -1)).into(new ArrayList<>());
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

            StringBuilder json = new StringBuilder("{\"success\": true, \"orders\": [");

            for (int i = 0; i < orders.size(); i++) {
                Document order = orders.get(i);

                ObjectId id = order.getObjectId("_id");
                String orderId = (id != null) ? id.toHexString() : "";

                ObjectId userIdObj = null;
                String userId = "";
                Object u = order.get("userId");
                if (u instanceof ObjectId) {
                    userIdObj = (ObjectId) u;
                    userId = userIdObj.toHexString();
                } else if (u instanceof String) {
                    userId = (String) u;
                }

                Date createdAt = order.getDate("created_at");
                String createdAtStr = createdAt != null ? sdf.format(createdAt) : "";

                json.append("{")
                    .append("\"orderId\": \"").append(orderId).append("\",")
                    .append("\"userId\": \"").append(userId).append("\",")
                    .append("\"createdAt\": \"").append(createdAtStr).append("\"")
                    .append("}");

                if (i < orders.size() - 1) {
                    json.append(",");
                }
            }

            json.append("]}");
            out.print(json.toString());

        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"" + escapeJson(e.getMessage()) + "\"}");
        } finally {
            out.close();
        }
    }

    private String escapeJson(String str) {
        return str == null ? "" : str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }
}
