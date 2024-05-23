package com.example.ecommercebackend.Product;

import jakarta.persistence.*;


@Entity
@Table(name = "products")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private int productId;

    private String name;
    private String description;
    private double price;
    private int category_id;

    private String imagepath;

    public int getId() {
        return productId;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public double getPrice() {
        return price;
    }

    public int getProduct_id() {
        return productId;
    }

    public int getCategory_id() {
        return category_id;
    }

    public String getImagepath() {
        return imagepath;
    }

    // Constructors, Getters, and Setters
}
