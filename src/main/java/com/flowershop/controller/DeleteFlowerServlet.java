package com.flowershop.controller;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.flowershop.util.MongoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.bson.Document;
import org.bson.types.ObjectId;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/deleteFlower")
public class DeleteFlowerServlet extends HttpServlet {

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String id = request.getParameter("id");
            MongoDatabase database = MongoUtil.getDatabase();
            MongoCollection<Document> collection = database.getCollection("products");

            collection.deleteOne(new Document("_id", new ObjectId(id)));

            out.write("{\"success\": true}");
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"success\": false, \"message\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}
