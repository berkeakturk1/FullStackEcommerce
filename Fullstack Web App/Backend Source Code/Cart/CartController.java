package com.example.ecommercebackend.Cart;

import com.example.ecommercebackend.CartItem.CartItem;
import com.example.ecommercebackend.CartItem.CartItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api")
public class CartController {

    @Autowired
    private CartService cartService;

    @Autowired
    private CartItemService cartItemService;

    @GetMapping("/cartByUserId")
    public ResponseEntity<Cart> getCartByUserId(@RequestParam int userId) {
        try {
            Cart cart = cartService.getCartByUserId(userId);
            return ResponseEntity.ok(cart);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/cartItems")
    public ResponseEntity<List<CartItem>> getCartItems(@RequestParam int cartId) {
        try {
            List<CartItem> cartItems = cartItemService.getCartItems(cartId);
            return ResponseEntity.ok(cartItems);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(null);
        }
    }

}
