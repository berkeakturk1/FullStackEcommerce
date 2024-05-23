import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ApiService.dart';

class CartItem {
  final int itemId;
  final int productId;
  int quantity;
  final Cart cart;
  String? productName;
  double? productPrice;
  String? imagePath;

  CartItem({
    required this.itemId,
    required this.productId,
    required this.quantity,
    required this.cart,
    this.productName,
    this.productPrice,
    this.imagePath,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      itemId: json['itemId'] ?? 0,
      productId: json['productId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      cart: Cart.fromJson(json['cart']),
      productName: json['productName'],
      productPrice: json['productPrice'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'productId': productId,
      'quantity': quantity,
      'cart': cart.toJson(),
      'productName': productName,
      'productPrice': productPrice,
      'imagePath': imagePath,
    };
  }
}

class Cart {
  final int cartId;
  final int userId;
  List<CartItem> cartItems;

  Cart({
    required this.cartId,
    required this.userId,
    List<CartItem>? cartItems,
  }) : cartItems = cartItems ?? [];

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cartId'] ?? 0,
      userId: json['user']['userid'] ?? 0,
      cartItems: (json['cartItems'] as List?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'user': {'userid': userId},
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
    };
  }

  void addItem(CartItem item) {
    cartItems.add(item);
  }
}

class CartPage extends StatefulWidget {
  final Cart cart;

  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<CartItem>> cartItemsFuture;

  @override
  void initState() {
    super.initState();
    cartItemsFuture = fetchCartItems();
  }

  Future<List<CartItem>> fetchCartItems() async {
    try {
      final cartItems = await ApiService.fetchCartItems(widget.cart.cartId);
      for (var item in cartItems) {
        final productDetails =
            await ApiService.fetchProductDetails(item.productId);
        item.productName = productDetails['name'];
        item.productPrice = productDetails['price'];
        item.imagePath = productDetails['imagepath'];
      }
      // Sort the cart items alphabetically by product name
      cartItems.sort((a, b) => a.productName!.compareTo(b.productName!));
      return aggregateCartItems(cartItems);
    } catch (e) {
      print('Error fetching cart items: $e');
      throw Exception('Failed to load cart items');
    }
  }

  List<CartItem> aggregateCartItems(List<CartItem> cartItems) {
    Map<int, CartItem> aggregatedItems = {};
    for (var item in cartItems) {
      if (aggregatedItems.containsKey(item.productId)) {
        aggregatedItems[item.productId]!.quantity += item.quantity;
      } else {
        aggregatedItems[item.productId] = item;
      }
    }
    return aggregatedItems.values.toList();
  }

  void updateCartItemQuantity(CartItem cartItem, int newQuantity) async {
    if (newQuantity == 0) {
      final response = await http.delete(
        Uri.parse(
            'http://localhost:8080/api/cart_items/deleteItem/${cartItem.itemId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          widget.cart.cartItems.remove(cartItem);
          cartItemsFuture = fetchCartItems();
        });
      } else {
        print(
            'Failed to delete item. Status code: ${response.statusCode}, Response body: ${response.body}');
      }
    } else {
      cartItem.quantity = newQuantity;
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/cart_items/updateItem'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(cartItem.toJson()),
      );

      if (response.statusCode == 200) {
        setState(() {
          int index = widget.cart.cartItems
              .indexWhere((item) => item.itemId == cartItem.itemId);
          if (index != -1) {
            widget.cart.cartItems[index] = cartItem;
          }
          cartItemsFuture = fetchCartItems();
        });
      } else {
        print(
            'Failed to update item quantity. Status code: ${response.statusCode}, Response body: ${response.body}');
      }
    }
  }

  void addItemToCart(CartItem cartItem) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/cart_items/addItem'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(cartItem.toJson()),
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItemsFuture = fetchCartItems();
        });
      } else {
        print(
            'Failed to add item. Status code: ${response.statusCode}, Response body: ${response.body}');
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<CartItem>>(
          future: cartItemsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No items in cart'));
            } else {
              return Column(
                children: snapshot.data!.map((cartItem) {
                  double totalPrice =
                      cartItem.productPrice! * cartItem.quantity;
                  return Card(
                    key: ValueKey(cartItem.itemId),
                    child: ListTile(
                      leading: Image.asset(
                        cartItem.imagePath!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text('${cartItem.productName}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity: ${cartItem.quantity}'),
                          Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (cartItem.quantity > 1) {
                                setState(() {
                                  cartItem.quantity--;
                                  updateCartItemQuantity(
                                      cartItem, cartItem.quantity);
                                });
                              } else if (cartItem.quantity == 1) {
                                setState(() {
                                  updateCartItemQuantity(cartItem, 0);
                                });
                              }
                            },
                          ),
                          Text('${cartItem.quantity}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                cartItem.quantity++;
                                updateCartItemQuantity(cartItem,
                                    cartItem.quantity); // Ensure correct update
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: FutureBuilder<List<CartItem>>(
        future: cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total: \$0.00',
                      style: TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Checkout logic here
                      },
                      child: Text('Checkout'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            double totalPrice = snapshot.data!.fold<double>(
                0,
                (previousValue, item) =>
                    previousValue + (item.quantity * item.productPrice!));
            return BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total: \$${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Checkout logic here
                      },
                      child: Text('Checkout'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
