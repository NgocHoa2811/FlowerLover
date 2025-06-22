package com.flowershop.controller;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import org.bson.Document;
import org.bson.types.ObjectId;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/order-history")
public class OrderHistoryServlet extends HttpServlet {

    private MongoClient mongoClient;

    @Override
    public void init() {
        mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");
        HttpSession session = req.getSession(false);
        String userIdStr = (session != null) ? (String) session.getAttribute("user") : null;

        if (userIdStr == null) {
            resp.getWriter().write("{\"success\":false, \"message\":\"Chưa đăng nhập\"}");
            return;
        }

        ObjectId userId = new ObjectId(userIdStr);

        MongoDatabase database = mongoClient.getDatabase("flowerlover");
        MongoCollection<Document> orders = database.getCollection("orders");
        MongoCollection<Document> products = database.getCollection("flowers");

        List<Document> orderList = orders.find(new Document("userId", userId)).into(new ArrayList<>());

        List<Document> result = new ArrayList<>();
        for (Document order : orderList) {
            String productName = order.getString("productNames");
            ObjectId productId = order.getObjectId("productId");

            // Tìm ảnh sản phẩm
            Document product = products.find(new Document("_id", productId)).first();
            String imageUrl = "/uploads/default.jpg";
            if (product != null && product.containsKey("images")) {
                List<String> imgs = (List<String>) product.get("images");
                if (!imgs.isEmpty()) {
                    imageUrl = "/uploads/" + imgs.get(0);
                }
            }

            Document item = new Document()
                    .append("productNames", productName)
                    .append("quantity", order.getInteger("quantity"))
                    .append("totalAmount", order.getDouble("totalAmount"))
                    .append("orderDate", new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(order.getDate("orderDate")))
                    .append("status", order.getString("status"))
                    .append("imageUrl", imageUrl);

            result.add(item);
        }

        Document jsonResponse = new Document("success", true).append("orders", result);
        resp.getWriter().write(jsonResponse.toJson());
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }
}
