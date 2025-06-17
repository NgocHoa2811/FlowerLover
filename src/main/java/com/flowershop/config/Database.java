package com.flowershop.config;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.core.MongoTemplate;

@Configuration
public class Database {

    // Thông tin kết nối (thay bằng thông tin thực tế của bạn từ MongoDB Atlas)
    private static final String USERNAME = "flower"; // Thay bằng username thực tế
    private static final String PASSWORD = "FlowerLover"; // Thay bằng mật khẩu thực tế
    private static final String CLUSTER_URL = "cluster0.reaw2ei.mongodb.net"; // Thay bằng URL cluster thực tế
    private static final String DATABASE_NAME = "flowerlover"; // Tên database mong muốn
    private static final String CONNECTION_STRING = String.format(
            "mongodb+srv://%s:%s@%s/%s?retryWrites=true&w=majority&authSource=admin&ssl=true",
            USERNAME, PASSWORD, CLUSTER_URL, DATABASE_NAME
    );

    // Tạo MongoClient như một Bean để tái sử dụng
    @Bean
    public MongoClient mongoClient() {
        MongoClientSettings settings = MongoClientSettings.builder()
                .applyConnectionString(new ConnectionString(CONNECTION_STRING))
                .build();
        MongoClient mongoClient = MongoClients.create(settings);
        try {
            // Kiểm tra kết nối bằng lệnh ping
            MongoDatabase database = mongoClient.getDatabase(DATABASE_NAME);
            database.runCommand(new Document("ping", 1));
            System.out.println("Kết nối thành công! Server trả về: " + database.runCommand(new Document("ping", 1)).toJson());
        } catch (Exception e) {
            System.err.println("Lỗi kết nối MongoDB: " + e.getMessage());
            throw new RuntimeException("Không thể kết nối tới MongoDB", e);
        }
        return mongoClient;
    }

    // Tạo MongoTemplate như một Bean để sử dụng trong Spring
    @Bean
    public MongoTemplate mongoTemplate() {
        return new MongoTemplate(mongoClient(), DATABASE_NAME);
    }

    // Lấy collection cụ thể (dùng MongoTemplate nếu cần)
    public MongoCollection<Document> getCollection(String collectionName) {
        return mongoClient().getDatabase(DATABASE_NAME).getCollection(collectionName);
    }

    // Phương thức main để test (có thể xóa sau khi tích hợp)
    public static void main(String[] args) {
        try {
            MongoClientSettings settings = MongoClientSettings.builder()
                    .applyConnectionString(new ConnectionString(CONNECTION_STRING))
                    .build();
            MongoClient mongoClient = MongoClients.create(settings);
            MongoDatabase database = mongoClient.getDatabase(DATABASE_NAME);
            database.runCommand(new Document("ping", 1));
            System.out.println("Kết nối thành công đến database: " + DATABASE_NAME);
            MongoCollection<Document> testCollection = database.getCollection("test");
            System.out.println("Collection 'test' đã sẵn sàng hoặc được tạo.");
        } catch (Exception e) {
            System.err.println("Lỗi: " + e.getMessage());
        }
    }
}