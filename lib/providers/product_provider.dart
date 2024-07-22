import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _allProducts = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _allProducts = data.map((item) => Product.fromJson(item)).toList();
      _products.addAll(_allProducts.take(10)); // Initial 10 products
      notifyListeners();
    } else {
      throw Exception('Failed to load products');
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _products = List.from(_allProducts.take(10)); // Reset to initial 10 products
    } else {
      _products = _allProducts
          .where((product) => product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void loadMoreProducts() {
    int currentLength = _products.length;
    if (currentLength < _allProducts.length) {
      _products.addAll(_allProducts.skip(currentLength).take(10)); // Load next 10 products
      notifyListeners();
    }
  }

  void sortProducts(String sortOption) {
    if (sortOption == 'price') {
      _products.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOption == 'popularity') {
      _products.sort((a, b) => b.rating.count.compareTo(a.rating.count));
    } else if (sortOption == 'rating') {
      _products.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
    }
    notifyListeners();
  }

  void filterProducts(String category, double minPrice, double maxPrice) {
    _products = _allProducts
        .where((product) =>
            product.category == category &&
            product.price >= minPrice &&
            product.price <= maxPrice)
        .toList();
    notifyListeners();
  }
}
