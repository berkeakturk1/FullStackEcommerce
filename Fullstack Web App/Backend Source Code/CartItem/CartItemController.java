package com.example.ecommercebackend.CartItem;

import com.example.ecommercebackend.Cart.Cart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/cart_items")
public class CartItemController {

    @Autowired
    private CartItemService cartItemService;

    /*
    @PostMapping("/addItem")
    public ResponseEntity<Map<String, String>> addCartItem(@RequestBody CartItem cartItem) {
        try {
            System.out.println("Received cart ID: " + cartItem.getCart().getCartId());
            System.out.println("Received product ID: " + cartItem.getProductId());

            if (cartItem.getCart() == null || cartItem.getCart().getCartId() == 0) {
                Map<String, String> errorResponse = new HashMap<>();
                errorResponse.put("error", "Invalid cart ID");
                return ResponseEntity.badRequest().body(errorResponse);
            }

            Cart cart = cartItemService.getCartById(cartItem.getCart().getCartId());
            cartItem.setCart(cart);

            CartItem savedItem = cartItemService.addCartItem(cartItem);
            return ResponseEntity.ok(Collections.singletonMap("message", "Item added successfully"));
        } catch (Exception e) {
            e.printStackTrace(); // Log the error details
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    } */

    @PostMapping("/addItem")
    public ResponseEntity<Map<String, String>> addCartItem(@RequestBody CartItem cartItem) {
        try {
            System.out.println("Received cart ID: " + cartItem.getCart().getCartId());
            System.out.println("Received product ID: " + cartItem.getProductId());

            if (cartItem.getCart() == null || cartItem.getCart().getCartId() == 0) {
                Map<String, String> errorResponse = new HashMap<>();
                errorResponse.put("error", "Invalid cart ID");
                return ResponseEntity.badRequest().body(errorResponse);
            }

            Cart cart = cartItemService.getCartById(cartItem.getCart().getCartId());
            cartItem.setCart(cart);

            CartItem existingCartItem = cartItemService.findByCartIdAndProductId(cartItem.getCart().getCartId(), cartItem.getProductId());
            if (existingCartItem != null) {
                existingCartItem.setQuantity(existingCartItem.getQuantity() + 1);
                cartItemService.updateCartItem(existingCartItem);
            } else {
                cartItemService.addCartItem(cartItem);
            }

            return ResponseEntity.ok(Collections.singletonMap("message", "Item added successfully"));
        } catch (Exception e) {
            e.printStackTrace(); // Log the error details
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }


    @DeleteMapping("/deleteItem/{itemId}")
    public ResponseEntity<?> deleteCartItem(@PathVariable int itemId) {
        try {
            cartItemService.deleteCartItem((long) itemId);
            return ResponseEntity.ok().body("Item deleted successfully");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Failed to delete item");
        }
    }

    @PutMapping("/updateItem")
    public ResponseEntity<?> updateCartItem(@RequestBody CartItem cartItem) {
        try {
            cartItemService.updateCartItem(cartItem);
            return ResponseEntity.ok("Item updated successfully");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating item");
        }
    }

    @DeleteMapping("/{id}")
    public void deleteCartItem(@PathVariable Long id) {
        cartItemService.deleteCartItem(id);
    }
}
