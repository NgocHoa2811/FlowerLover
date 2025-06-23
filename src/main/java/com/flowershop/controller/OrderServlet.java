package com.flowershop.controller;

import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.io.IOException;
import java.util.Date;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Kiểm tra session
            HttpSession session = req.getSession(false);
            String userIdStr = (session != null) ? (String) session.getAttribute("user") : null;

            if (userIdStr == null) {
                resp.sendRedirect("login.jsp?error=" + java.net.URLEncoder.encode("Vui lòng đăng nhập để đặt hàng", "UTF-8"));
                return;
            }

            ObjectId userId = new ObjectId(userIdStr);

            // Lấy dữ liệu từ form
            String productId = req.getParameter("productId");
            String productName = req.getParameter("productName");
            String customerName = req.getParameter("customerName");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            String address = req.getParameter("address");
            String paymentMethod = req.getParameter("paymentMethod");
            String note = req.getParameter("note");
            String priceStr = req.getParameter("price");
            String quantityStr = req.getParameter("quantity");

            // Kiểm tra quantity
            if (quantityStr == null || quantityStr.trim().isEmpty()) {
                resp.sendRedirect("invoice.jsp?error=" + java.net.URLEncoder.encode("Vui lòng nhập số lượng", "UTF-8"));
                return;
            }

            int quantity;
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity < 1) {
                    resp.sendRedirect("invoice.jsp?error=" + java.net.URLEncoder.encode("Số lượng phải lớn hơn 0", "UTF-8"));
                    return;
                }
            } catch (NumberFormatException e) {
                resp.sendRedirect("invoice.jsp?error=" + java.net.URLEncoder.encode("Số lượng không hợp lệ", "UTF-8"));
                return;
            }

            // Ghi log để debug
            System.out.println("Quantity from form: " + quantityStr);
            System.out.println("Parsed quantity: " + quantity);

            // Kiểm tra price
            double price;
            try {
                price = Double.parseDouble(priceStr);
                if (price <= 0) {
                    resp.sendRedirect("invoice.jsp?error=" + java.net.URLEncoder.encode("Giá sản phẩm không hợp lệ", "UTF-8"));
                    return;
                }
            } catch (NumberFormatException e) {
                resp.sendRedirect("invoice.jsp?error=" + java.net.URLEncoder.encode("Giá sản phẩm không hợp lệ", "UTF-8"));
                return;
            }

            double totalAmount = price * quantity;

            // Lưu vào MongoDB
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> orders = database.getCollection("orders");

            Document order = new Document()
                    .append("userId", userId)
                    .append("productId", new ObjectId(productId))
                    .append("productNames", productName)
                    .append("customerName", customerName)
                    .append("phone", phone)
                    .append("email", email)
                    .append("address", address)
                    .append("paymentMethod", paymentMethod)
                    .append("note", note)
                    .append("quantity", quantity)
                    .append("totalAmount", totalAmount)
                    .append("orderDate", new Date())
                    .append("status", "Đang xử lý");

            orders.insertOne(order);

            // Chuyển hướng với thông báo thành công
            resp.sendRedirect("invoice.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("invoice.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }
}