package com.example.ecommercebackend.CartItem;

import com.example.ecommercebackend.Cart.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByCart_cartId(int cartId);

    Optional<CartItem> findByCartAndProductId(Cart cart, int productId);

    CartItem findByCart_CartIdAndProductId(int cartId, int productId);
}
