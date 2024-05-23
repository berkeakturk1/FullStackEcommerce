import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'cart.dart';
import 'cart.dart'; // Ensure you have a CartItem model

class ApiService {
  final String baseUrl = 'http://localhost:8080/api/products';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> productList = json.decode(response.body);
        return productList.map((data) => Product.fromJson(data)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  static Future<Map<String, dynamic>> getCartByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/cartByUserId?userId=$userId'),
    );

    if (response.statusCode == 200) {
      print('Cart data: ${response.body}'); // Debug statement
      return jsonDecode(response.body);
    } else {
      print('Failed to load cart. Status code: ${response.statusCode}');
      throw Exception('Failed to load cart');
    }
  }

  static Future<List<CartItem>> fetchCartItems(int cartId) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/cartItems?cartId=$cartId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> cartItemList = json.decode(response.body);
      return cartItemList.map((data) => CartItem.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  static Future<void> addItemToCart(
      int cartId, int productId, int quantity) async {
    print(
        'Adding item to cart. Cart ID: $cartId, Product ID: $productId, Quantity: $quantity'); // Debug statement
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/cart_items/addItem'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'productId': productId,
        'quantity': quantity,
        'cart': {
          'cartId': cartId
        }, // Ensure this matches the backend expectation
      }),
    );

    if (response.statusCode != 200) {
      print(
          'Error adding item to cart: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to add item to cart');
    }
  }

  static Future<int> getUserId(String username) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/userid'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode == 200) {
      print('User ID: ${jsonDecode(response.body)}'); // Debug statement
      return jsonDecode(response.body);
    } else {
      print('Failed to load user ID. Status code: ${response.statusCode}');
      throw Exception('Failed to load user ID');
    }
  }

  static Future<void> addOrUpdateItemInCart(
      int cartId, int productId, int quantity) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/cart_items/addOrUpdateItem'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(
          {'cartId': cartId, 'productId': productId, 'quantity': quantity}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add/update item in cart');
    }
  }

  static Future<Map<String, dynamic>> fetchProductDetails(int productId) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/products/$productId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load product details');
    }
  }
}
