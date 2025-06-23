package com.flowershop.controller;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.bson.Document;
import org.bson.conversions.Bson;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.regex.Pattern;

@WebServlet("/search-products")
public class SearchAllProductsServlet extends HttpServlet {

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
            String keyword = request.getParameter("keyword");
            if (keyword == null || keyword.trim().isEmpty()) {
                out.print("[]");
                return;
            }

            keyword = keyword.trim();

            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> collection = database.getCollection("products");

            // Regex khớp với name hoặc category (không phân biệt hoa thường)
            Pattern regex = Pattern.compile(Pattern.quote(keyword), Pattern.CASE_INSENSITIVE);

            Bson filter = Filters.or(
                Filters.regex("name", regex),
                Filters.regex("category", regex)
            );

            FindIterable<Document> results = collection.find(filter);
            JSONArray jsonArray = new JSONArray();

            for (Document doc : results) {
                JSONObject obj = new JSONObject();
                obj.put("id", doc.getObjectId("_id").toString());
                obj.put("name", doc.getString("name"));
                obj.put("price", doc.get("price") != null ? doc.get("price").toString() : "0");
                obj.put("category", doc.getString("category") != null ? doc.getString("category") : "Khác");

                List<String> images = (List<String>) doc.get("images");
                String imageUrl = (images != null && !images.isEmpty()) ? images.get(0) : "/uploads/default.jpg";
                obj.put("imageUrl", imageUrl);

                jsonArray.put(obj);
            }

            out.print(jsonArray.toString());

        } catch (Exception e) {
            out.print("{\"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        } finally {
            out.close();
        }
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }
}
