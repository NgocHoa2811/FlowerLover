package com.flowershop.controller;

import com.mongodb.client.*;
import org.bson.Document;
import org.bson.types.ObjectId;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/delete-custom-order")
public class DeleteCustomOrderServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        // Kết nối MongoDB
        mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String orderId = request.getParameter("orderId");

        if (orderId == null || orderId.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Thiếu orderId!\"}");
            return;
        }

        try {
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> collection = database.getCollection("custom_orders");

            ObjectId objectId = new ObjectId(orderId);
            long deletedCount = collection.deleteOne(new Document("_id", objectId)).getDeletedCount();

            if (deletedCount > 0) {
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false, \"message\": \"Không tìm thấy đơn hàng để xóa.\"}");
            }

        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"" + escapeJson(e.getMessage()) + "\"}");
        } finally {
            out.close();
        }
    }

    private String escapeJson(String str) {
        return str == null ? "" : str.replace("\\", "\\\\")
                                     .replace("\"", "\\\"")
                                     .replace("\n", "\\n")
                                     .replace("\r", "");
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }
}
