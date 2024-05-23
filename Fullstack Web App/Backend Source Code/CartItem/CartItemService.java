package com.example.ecommercebackend.CartItem;

import com.example.ecommercebackend.Cart.Cart;
import com.example.ecommercebackend.Cart.CartRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CartItemService {

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private CartRepository cartRepository;

    public CartItem addCartItem(CartItem cartItem) {
        Cart cart = cartRepository.findById((long) cartItem.getCart().getCartId())
                .orElseThrow(() -> new IllegalArgumentException("Cart not found with id " + cartItem.getCart().getCartId()));
        cartItem.setCart(cart);
        return cartItemRepository.save(cartItem);
    }

    public CartItem addOrUpdateCartItem(int cartId, int productId, int quantity) {
        Cart cart = cartRepository.findById((long) cartId).orElseThrow(() -> new RuntimeException("Cart not found"));

        Optional<CartItem> existingItem = cartItemRepository.findByCartAndProductId(cart, productId);

        if (existingItem.isPresent()) {
            CartItem cartItem = existingItem.get();
            cartItem.setQuantity(cartItem.getQuantity() + quantity);
            return cartItemRepository.save(cartItem);
        } else {
            CartItem newItem = new CartItem();
            newItem.setCart(cart);
            newItem.setProductId(productId);
            newItem.setQuantity(quantity);
            return cartItemRepository.save(newItem);
        }
    }

    public List<CartItem> getCartItems(int cartId) {
        return cartItemRepository.findByCart_cartId(cartId);
    }

    public Cart getCartById(int cartId) {
        return cartRepository.findById((long) cartId)
                .orElseThrow(() -> new IllegalArgumentException("Cart not found with id " + cartId));
    }

    public void deleteCartItem(Long id) {
        cartItemRepository.deleteById(id);
    }

    public void updateCartItem(CartItem cartItem) {
        cartItemRepository.save(cartItem);
    }

    public CartItem findByCartIdAndProductId(int cartId, int productId) {
        return cartItemRepository.findByCart_CartIdAndProductId(cartId, productId);
    }

}
