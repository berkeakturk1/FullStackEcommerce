import 'package:flutter/foundation.dart';

class UserNotifier with ChangeNotifier {
  bool _isLoggedIn = false;
  int _userId = 0;
  Map<String, dynamic> _cart = {};

  bool get isLoggedIn => _isLoggedIn;
  int get userId => _userId;
  Map<String, dynamic> get cart => _cart;

  void login(int userId, Map<String, dynamic> cart) {
    _isLoggedIn = true;
    _userId = userId;
    _cart = cart;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userId = 0;
    _cart = {};
    notifyListeners();
  }
}
