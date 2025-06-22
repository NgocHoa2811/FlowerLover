package com.flowershop.controller;

import com.mongodb.client.*;
import org.bson.Document;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/orders-data")
public class DashboardOrderServlet extends HttpServlet {
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
            MongoCollection<Document> ordersCol = db.getCollection("orders");

            List<Document> orders = ordersCol.find().into(new ArrayList<>());
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm"); // Format phù hợp với input datetime-local

            StringBuilder json = new StringBuilder("{\"success\": true, \"orders\": [");

            for (int i = 0; i < orders.size(); i++) {
                Document o = orders.get(i);
                Date orderDateObj = o.getDate("orderDate");
                String orderDate = orderDateObj != null ? sdf.format(orderDateObj) : "";

                json.append("{")
                   .append("\"orderId\": \"").append(o.getObjectId("_id").toHexString()).append("\",")

                    .append("\"customerName\": \"").append(escapeJson(o.getString("customerName"))).append("\",")
                    .append("\"phone\": \"").append(escapeJson(o.getString("phone"))).append("\",")
                    .append("\"email\": \"").append(escapeJson(o.getString("email"))).append("\",")
                    .append("\"address\": \"").append(escapeJson(o.getString("address"))).append("\",")
                    .append("\"productNames\": \"").append(escapeJson(o.getString("productNames"))).append("\",")
                    .append("\"quantity\": ").append(o.get("quantity", Integer.class)).append(",")
                    .append("\"totalAmount\": ").append(o.get("totalAmount", Double.class)).append(",")
                    .append("\"orderDate\": \"").append(orderDate).append("\",")
                    .append("\"paymentMethod\": \"").append(escapeJson(o.getString("paymentMethod"))).append("\",")
                    .append("\"status\": \"").append(escapeJson(o.getString("status"))).append("\",")
                    .append("\"note\": \"").append(escapeJson(o.getString("note"))).append("\"")
                    .append("}");

                if (i < orders.size() - 1) json.append(",");
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
        return str == null ? "" : str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
    }

    @Override
    public void destroy() {
        if (mongoClient != null) mongoClient.close();
    }
}
