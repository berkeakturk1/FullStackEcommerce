package com.example.ecommercebackend.Cart;

import com.example.ecommercebackend.User.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private UserRepository userRepository;

    public Cart getCartByUserId(int userId) {
        return cartRepository.findByUser_Userid(userId)
                .orElseThrow(() -> new IllegalArgumentException("Cart not found for user ID: " + userId));
    }


    public Cart getCartById(int cartId) {
        return cartRepository.findById((long) cartId)
                .orElseThrow(() -> new IllegalArgumentException("Cart not found with id " + cartId));
    }
}
