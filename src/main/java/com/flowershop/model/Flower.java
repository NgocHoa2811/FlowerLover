package com.flowershop.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "flowerlover.product")
public class Flower {
    @Id
    private String id;
    private String name;
    private double price;
    private String image;
    private String category;
    private String description;
    private int stock; // Thêm trường số lượng

    // Constructor
    public Flower() {}
    public Flower(String name, double price, String image, String category, String description, int stock) {
        this.name = name;
        this.price = price;
        this.image = image;
        this.category = category;
        this.description = description;
        this.stock = stock;
    }

    // Getters và Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
}