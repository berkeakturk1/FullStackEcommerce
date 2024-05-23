package com.example.ecommercebackend.ProductView;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductViewRepository extends JpaRepository<ProductView, Long> {
    ProductView findByProductId(int productId);
}

