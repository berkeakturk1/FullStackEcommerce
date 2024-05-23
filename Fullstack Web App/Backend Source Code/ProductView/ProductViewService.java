package com.example.ecommercebackend.ProductView;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductViewService {

    @Autowired
    private ProductViewRepository productViewRepository;

    public List<ProductView> getAllProducts() {
        return productViewRepository.findAll();
    }

    public ProductView getProductById(int productId) {
        return productViewRepository.findByProductId(productId);
    }
}

