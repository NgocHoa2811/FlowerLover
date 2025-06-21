package com.flowershop.controller;

import com.mongodb.client.*;
import com.flowershop.util.MongoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;

import org.bson.Document;
import org.bson.types.ObjectId;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/updateFlower")
@MultipartConfig
public class UpdateFlowerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            MongoDatabase database = MongoUtil.getDatabase();
            MongoCollection<Document> collection = database.getCollection("products");

            String id = request.getParameter("id");
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String color = request.getParameter("color");
            String flowerType = request.getParameter("flowerType");
            String size = request.getParameter("size");
            String status = request.getParameter("status");

            // Load ảnh mới nếu có
            List<String> imageUrls = new ArrayList<>();
            for (Part part : request.getParts()) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    String fileName = part.getSubmittedFileName();
                    String uploadPath = getServletContext().getRealPath("/uploads/") + File.separator + fileName;
                    part.write(uploadPath);

                    imageUrls.add("/uploads/" + fileName);
                }
            }

            // Nếu không có ảnh mới, giữ nguyên ảnh cũ
            if (imageUrls.isEmpty()) {
                String currentImages = request.getParameter("currentImages");
                if (currentImages != null && !currentImages.isEmpty()) {
                    imageUrls.add(currentImages);
                }
            }

            Document updatedData = new Document("name", name)
                    .append("price", price)
                    .append("quantity", quantity)
                    .append("category", category)
                    .append("description", description)
                    .append("color", color)
                    .append("flowerType", flowerType)
                    .append("size", size)
                    .append("status", status)
                    .append("images", imageUrls);

            collection.updateOne(new Document("_id", new ObjectId(id)),
                                 new Document("$set", updatedData));

            out.write("{\"success\": true}");
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"success\": false, \"message\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}
