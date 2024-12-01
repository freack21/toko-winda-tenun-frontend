import 'package:flutter/foundation.dart';
import 'package:frontend/models/category_model.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];

  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;

  set products(List<ProductModel> products) {
    _products = products;
    notifyListeners();
  }

  set categories(List<CategoryModel> categories) {
    _categories = categories;
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

  Future<ProductModel> getProduct(int id) async {
    try {
      ProductModel product = await ProductService().getProduct(id);
      return product; // Menambahkan notifyListeners agar UI diperbarui
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return NotFoundProductModel();
  }

  Future<void> getCategories() async {
    try {
      List<CategoryModel> categories = await ProductService().getCategories();
      _categories = categories;
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
