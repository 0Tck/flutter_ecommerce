import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    // Implement your login logic here
    // For simplicity, let's assume the login is always successful
    if (email == "test@example.com" && password == "password") {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    // Implement your registration logic here
    // For simplicity, let's assume the registration is always successful
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
