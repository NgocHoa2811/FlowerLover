package com.flowershop.controller;

import com.mongodb.client.*;
import com.flowershop.util.MongoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.bson.Document;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/product-user")
public class ProductUserServlet extends HttpServlet {

   // ... (phần import và class Product giữ nguyên)

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("application/json;charset=UTF-8");
    PrintWriter out = response.getWriter();

    try {
        MongoDatabase database = MongoUtil.getDatabase();
        MongoCollection<Document> collection = database.getCollection("products");

        int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int size = 12; // 3 cột x 4 hàng
        int skip = (page - 1) * size;

        List<Document> products = collection.find()
                .skip(skip)
                .limit(size)
                .into(new ArrayList<>());

        List<Product> productList = new ArrayList<>();
        for (Document doc : products) {
            Product product = new Product();
            product.setId(doc.getObjectId("_id").toString());
            product.setName(doc.getString("name"));
            product.setPrice(doc.getDouble("price"));
            List<String> images = doc.getList("images", String.class);
            product.setImageUrl(images != null && !images.isEmpty() ? images.get(0) : null);
            product.setCategory(doc.getString("category"));
            productList.add(product);
        }

        // Đóng gói giống dashboard-data (nếu cần)
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("flowers", productList);
        out.write(new Gson().toJson(responseData));
    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.write("{\"success\": false, \"message\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
    }
}
}

class Product {
    private String id;
    private String name;
    private double price;
    private String imageUrl;
    private String category;

    // Getters và Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}