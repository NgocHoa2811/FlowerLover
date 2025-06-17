package com.flowershop.controller;

import cn.hutool.json.JSONObject;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;

@WebServlet(urlPatterns = {"/addFlower", "/updateFlower", "/deleteFlower"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Giới hạn file 5MB
public class FlowerManagementServlet extends HttpServlet {
    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        try {
            mongoClient = MongoClients.create("mongodb+srv://flower:FlowerLover@cluster0.reaw2ei.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
            System.out.println("MongoDB connection initialized successfully at " + new Date());
            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            database.runCommand(new Document("ping", 1));
        } catch (Exception e) {
            System.out.println("MongoDB connection failed at " + new Date() + ": " + e.getMessage());
            throw new ServletException("Cannot connect to MongoDB", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doAddOrUpdate(request, response, "POST");
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doAddOrUpdate(request, response, "PUT");
    }

    private void doAddOrUpdate(HttpServletRequest request, HttpServletResponse response, String method)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject jsonResponse = new JSONObject();

        try {
            String id = request.getParameter("id"); // Chỉ có khi cập nhật
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String category = request.getParameter("category");
            String stockStr = request.getParameter("stock");
            String description = request.getParameter("description");
            Part imagePart = request.getPart("image");

            if (name == null || priceStr == null || category == null || stockStr == null || description == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Dữ liệu không đầy đủ!");
                response.getWriter().write(jsonResponse.toString());
                return;
            }

            double price = Double.parseDouble(priceStr);
            int stock = Integer.parseInt(stockStr);

            String image = null;
            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadDir = getServletContext().getRealPath("/images");
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                String fileName = System.currentTimeMillis() + "_" + imagePart.getSubmittedFileName();
                Path filePath = uploadPath.resolve(fileName);
                Files.write(filePath, imagePart.getInputStream().readAllBytes());
                image = "/images/" + fileName;
            } else if ("PUT".equals(method)) {
                image = request.getParameter("currentImage"); // Giữ ảnh cũ nếu không thay đổi
            }

            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> flowers = database.getCollection("flowers");

            if ("POST".equals(method)) {
                Document newFlower = new Document()
                        .append("name", name)
                        .append("price", price)
                        .append("image", image)
                        .append("category", category)
                        .append("stock", stock)
                        .append("description", description)
                        .append("created_at", new Date());
                flowers.insertOne(newFlower);
                System.out.println("Thêm sản phẩm thành công at " + new Date() + ": " + newFlower);
            } else if ("PUT".equals(method) && id != null) {
                if (!ObjectId.isValid(id)) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "ID không hợp lệ!");
                    response.getWriter().write(jsonResponse.toString());
                    return;
                }
                Document updateFlower = new Document()
                        .append("name", name)
                        .append("price", price)
                        .append("image", image != null ? image : "")
                        .append("category", category)
                        .append("stock", stock)
                        .append("description", description)
                        .append("created_at", new Date());
                flowers.updateOne(new Document("_id", new ObjectId(id)), new Document("$set", updateFlower));
                System.out.println("Cập nhật sản phẩm thành công at " + new Date() + " với ID: " + id);
            }

            jsonResponse.put("success", true);
            jsonResponse.put("message", "POST".equals(method) ? "Sản phẩm đã được thêm thành công!" : "Sản phẩm đã được cập nhật thành công!");
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Dữ liệu không hợp lệ: " + e.getMessage());
        } catch (IOException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lỗi khi lưu ảnh: " + e.getMessage());
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Đã xảy ra lỗi: " + e.getMessage());
        }
        response.getWriter().write(jsonResponse.toString());
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject jsonResponse = new JSONObject();

        try {
            String id = request.getParameter("id");
            if (id == null || !ObjectId.isValid(id)) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "ID không hợp lệ hoặc không được cung cấp!");
                response.getWriter().write(jsonResponse.toString());
                return;
            }

            MongoDatabase database = mongoClient.getDatabase("flowerlover");
            MongoCollection<Document> flowers = database.getCollection("flowers");
            flowers.deleteOne(new Document("_id", new ObjectId(id)));
            System.out.println("Xóa sản phẩm thành công at " + new Date() + " với ID: " + id);

            jsonResponse.put("success", true);
            jsonResponse.put("message", "Sản phẩm đã được xóa thành công!");
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Đã xảy ra lỗi khi xóa: " + e.getMessage());
        }
        response.getWriter().write(jsonResponse.toString());
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("MongoDB connection closed at " + new Date());
        }
    }
}