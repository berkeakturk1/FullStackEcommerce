package com.example.ecommercebackend.ProductView;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/productviews")
public class ProductViewController {

    @Autowired
    private ProductViewService productViewService;

    @GetMapping
    public ResponseEntity<List<ProductView>> getAllProducts() {
        List<ProductView> products = productViewService.getAllProducts();
        return ResponseEntity.ok(products);
    }

    @GetMapping("/{productId}")
    public ResponseEntity<ProductView> getProductById(@PathVariable int productId) {
        try {
            ProductView product = productViewService.getProductById(productId);
            if (product != null) {
                return ResponseEntity.ok(product);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).build();
        }
    }
}
