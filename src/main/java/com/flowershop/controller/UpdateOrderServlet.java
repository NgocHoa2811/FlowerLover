package com.flowershop.controller;

import com.mongodb.client.*;
import org.bson.Document;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import org.bson.types.ObjectId;


@WebServlet("/updateOrder")
public class UpdateOrderServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            MongoDatabase db = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> collection = db.getCollection("orders");

            String orderId = request.getParameter("orderId");
            if (orderId == null || orderId.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Thiếu orderId\"}");
                return;
            }

            Document updatedFields = new Document()
                .append("customerName", request.getParameter("customerName"))
                .append("phone", request.getParameter("phone"))
                .append("email", request.getParameter("email"))
                .append("address", request.getParameter("address"))
                .append("productNames", request.getParameter("productNames"))
                .append("quantity", Integer.parseInt(request.getParameter("quantity")))
                .append("totalAmount", Double.parseDouble(request.getParameter("totalAmount")))
                .append("orderDate", request.getParameter("orderDate"))
                .append("paymentMethod", request.getParameter("paymentMethod"))
                .append("status", request.getParameter("status"))
                .append("note", request.getParameter("note"));

            Document updateDoc = new Document("$set", updatedFields);
            collection.updateOne(new Document("_id", new ObjectId(orderId)), updateDoc);


            out.print("{\"success\": true}");
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    @Override
    public void destroy() {
        if (mongoClient != null) mongoClient.close();
    }
}
