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
import java.util.Date;

@WebServlet("/custom-order-detail")
public class CustomOrderDetailServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Thiếu ID đơn hàng\"}");
                return;
            }

            MongoDatabase db = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> collection = db.getCollection("custom_orders");

            Document order = collection.find(new Document("_id", new ObjectId(idParam))).first();

            if (order == null) {
                out.print("{\"success\": false, \"message\": \"Không tìm thấy đơn hàng\"}");
                return;
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            String json = "{"
                    + "\"success\": true,"
                    + "\"order\": {"
                    + "\"orderId\": \"" + order.getObjectId("_id").toHexString() + "\","
                    + "\"userId\": \"" + safeString(order.get("userId")) + "\","
                    + "\"name\": \"" + escape(order.getString("name")) + "\","
                    + "\"phone\": \"" + escape(order.getString("phone")) + "\","
                    + "\"address\": \"" + escape(order.getString("address")) + "\","
                    + "\"product_type\": \"" + escape(order.getString("product_type")) + "\","
                    + "\"occasion\": \"" + escape(order.getString("occasion")) + "\","
                    + "\"main_flower\": \"" + escape(order.getString("main_flower")) + "\","
                    + "\"main_color\": \"" + escape(order.getString("main_color")) + "\","
                    + "\"quantity\": " + getInt(order, "quantity") + ","
                    + "\"budget\": " + getInt(order, "budget") + ","
                    + "\"description\": \"" + escape(order.getString("description")) + "\","
                    + "\"message\": \"" + escape(order.getString("message")) + "\","
                    + "\"recipient_name\": \"" + escape(order.getString("recipient_name")) + "\","
                    + "\"recipient_phone\": \"" + escape(order.getString("recipient_phone")) + "\","
                    + "\"delivery_address\": \"" + escape(order.getString("delivery_address")) + "\","
                    + "\"delivery_date\": \"" + escape(order.getString("delivery_date")) + "\","
                    + "\"delivery_time\": \"" + escape(order.getString("delivery_time")) + "\","
                    + "\"image\": \"" + escape(order.getString("image")) + "\","
                    + "\"created_at\": \"" + (order.getDate("created_at") != null ? sdf.format(order.getDate("created_at")) : "") + "\""
                    + "}"
                    + "}";

            out.print(json);
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"" + escape(e.getMessage()) + "\"}");
        } finally {
            out.close();
        }
    }

    private String escape(String s) {
        return s == null ? "" : s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }

    private String safeString(Object obj) {
        return obj == null ? "" : escape(obj.toString());
    }

    private int getInt(Document doc, String key) {
        Integer value = doc.getInteger(key);
        return value != null ? value : 0;
    }

    @Override
    public void destroy() {
        if (mongoClient != null) mongoClient.close();
    }
}
