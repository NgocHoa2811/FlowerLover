package com.flowershop.config;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.MongoException;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import org.bson.Document;

public class Database {
    // Thông tin kết nối (thay bằng thông tin thực tế của bạn)
    private static final String USERNAME = "flower"; // Thay bằng username thực tế
    private static final String PASSWORD = "FlowerLover"; // Thay bằng mật khẩu thực tế
    private static final String CLUSTER_URL = "cluster0.reaw2ei.mongodb.net"; // Thay bằng URL cluster thực tế
    private static final String DATABASE_NAME = "flowerlover"; // Tên database mong muốn
    private static final String CONNECTION_STRING = String.format(
            "mongodb+srv://%s:%s@%s/?retryWrites=true&w=majority&appName=Cluster0",
            USERNAME, PASSWORD, CLUSTER_URL
    );

    // Lấy MongoDatabase
    public static MongoDatabase getDatabase() {
        try {
            MongoClientSettings settings = MongoClientSettings.builder()
                    .applyConnectionString(new ConnectionString(CONNECTION_STRING))
                    .build();
            MongoClient mongoClient = MongoClients.create(settings);
            MongoDatabase database = mongoClient.getDatabase(DATABASE_NAME);
            // Kiểm tra kết nối bằng lệnh ping
            database.runCommand(new Document("ping", 1));
            System.out.println("Kết nối thành công! Server trả về: " + database.runCommand(new Document("ping", 1)).toJson());
            return database;
        } catch (MongoException e) {
            System.err.println("Lỗi kết nối MongoDB: " + e.getMessage());
            throw e;
        }
    }

    // Lấy hoặc tạo collection
    public static MongoCollection<Document> getCollection(String collectionName) {
        MongoDatabase database = getDatabase();
        return database.getCollection(collectionName);
    }

    // Đóng kết nối (không cần thiết vì mỗi lần tạo mới MongoClient)
    public static void close() {
        // Không cần đóng vì MongoClient được tạo mới mỗi lần
        System.out.println("Không cần đóng kết nối vì mỗi lần tạo mới MongoClient.");
    }

    // Phương thức main để test
    public static void main(String[] args) {
        try {
            MongoDatabase database = getDatabase();
            System.out.println("Kết nối thành công đến database: " + DATABASE_NAME);
            MongoCollection<Document> testCollection = getCollection("test");
            System.out.println("Collection 'test' đã sẵn sàng hoặc được tạo.");
        } catch (MongoException e) {
            System.err.println("Lỗi: " + e.getMessage());
        }
    }
}