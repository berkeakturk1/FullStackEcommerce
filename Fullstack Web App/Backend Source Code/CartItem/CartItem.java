package com.example.ecommercebackend.CartItem;

import com.example.ecommercebackend.Cart.Cart;
import jakarta.persistence.*;

@Entity
@Table(name = "cart_items")
public class CartItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int itemId;

    @Column(name = "quantity", nullable = false)
    private int quantity;

    @Column(name = "product_id", nullable = false)
    private int productId;

    @ManyToOne
    @JoinColumn(name="cart_id", nullable = false)
    private Cart cart;

    public CartItem() {}

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Cart getCart() {
        return cart;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }
}
