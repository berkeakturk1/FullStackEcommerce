package com.example.ecommercebackend.Cart;

import com.example.ecommercebackend.User.User;
import jakarta.persistence.*;

@Entity
@Table(name = "carts")
public class Cart {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int cartId;

    @OneToOne
    @JoinColumn(name = "user_id", referencedColumnName = "userid")
    private User user;

    public int getCartId() {
        return cartId;
    }

    public User getUser() {
        return user;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }


    public void setUser(User user) {
        this.user = user;
    }
}
