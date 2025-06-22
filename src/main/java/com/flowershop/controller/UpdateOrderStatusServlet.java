package com.flowershop.controller;

import com.mongodb.client.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.bson.Document;

import java.io.IOException;
import java.io.PrintWriter;
import org.bson.types.ObjectId;

@WebServlet("/updateOrderStatus")
public class UpdateOrderStatusServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("status");

        try {
            if (orderId == null || newStatus == null) {
                out.print("{\"success\": false, \"message\": \"Thiếu thông tin orderId hoặc status\"}");
                return;
            }

            MongoDatabase db = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> ordersCol = db.getCollection("orders");

            Document filter = new Document("_id", new ObjectId(orderId));

            Document update = new Document("$set", new Document("status", newStatus));

            var result = ordersCol.updateOne(filter, update);

            if (result.getModifiedCount() > 0) {
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false, \"message\": \"Không tìm thấy hoặc không cập nhật được đơn hàng\"}");
            }
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        } finally {
            out.close();
        }
    }

    @Override
    public void destroy() {
        if (mongoClient != null) mongoClient.close();
    }
}
