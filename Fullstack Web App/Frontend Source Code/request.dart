import 'dart:convert';
import 'package:eshopping_v2/UserNotifier.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<bool> login(
    String username, String password, BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/api/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    /*Map<String, dynamic> data = await getCartAndUserId(context);
    int cartId = data['cart_id']; // Ensure this is an int
    int userId = data['user_id']; // Ensure this is an int
    Cart cart = Cart(cartId: cartId, userId: userId);

    Provider.of<UserNotifier>(context, listen: false).login(userId, cart); */
    return true;
  } else {
    return false;
  }
}

Future<bool> register(String fname, String lname, String email, String username,
    String password, String bdate, bool usertype) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/api/register'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      'fname': fname,
      'lname': lname,
      'email': email,
      'username': username, // Use email as username
      'password': password,
      'bdate': bdate,
      'usertype': usertype,
    }),
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, then the registration was successful.
    return true;
  } else {
    // If the server returns a response with a status code other than 200,
    // then the registration failed.
    return false;
  }
}

Future<void> logout(BuildContext context) async {
  final response =
      await http.post(Uri.parse('http://localhost:8080/api/logout'));

  if (response.statusCode == 200) {
    Provider.of<UserNotifier>(context, listen: false).logout();
  }
}

Future<Map<String, dynamic>> getCartAndUserId(BuildContext context) async {
  final response = await http.get(
    Uri.parse('http://localhost:8080/api/cart'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    int cartId = data['cart_id']; // Ensure these are integers
    int userId = data['user_id']; // Ensure these are integers
    return {'cart_id': cartId, 'user_id': userId};
  } else {
    throw Exception('Failed to load cart and user ID');
  }
}
