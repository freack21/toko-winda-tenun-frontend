import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  set products(List<ProductModel> products) {
    _products = products;
    notifyListeners();
  }

  Future<void> getProducts({String category = ""}) async {
    try {
      List<ProductModel> products =
          await ProductService().getProducts(category: category);
      _products = products;
      notifyListeners(); // Menambahkan notifyListeners agar UI diperbarui
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  List<ProductModel> getRelatedProducts(String category) {
    try {
      List<ProductModel> relatedProducts = _products.where((product) {
        return product.category!.name.toLowerCase() == category.toLowerCase();
      }).toList();
      return relatedProducts;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return [];
  }
}
