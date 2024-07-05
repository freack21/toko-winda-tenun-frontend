import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WishlistProvider with ChangeNotifier {
  List<ProductModel> _wishlist = [];

  List<ProductModel> get wishlist => _wishlist;

  Future<List<ProductModel>> get wishlistAwait async {
    await loadWishlistFromPrefs();
    return _wishlist;
  }

  set wishlist(List<ProductModel> wishlist) {
    _wishlist = wishlist;
    saveWishlistToPrefs();
    notifyListeners();
  }

  setProduct(ProductModel product) {
    if (!isWishlist(product)) {
      _wishlist.add(product);
    } else {
      _wishlist.removeWhere((element) => element.id == product.id);
    }
    saveWishlistToPrefs();
    notifyListeners();
  }

  isWishlist(ProductModel product) {
    return _wishlist.indexWhere((element) => element.id == product.id) != -1;
  }

  Future<void> saveWishlistToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> wishlistList =
        _wishlist.map((product) => jsonEncode(product.toJson())).toList();
    prefs.setStringList('wishlist', wishlistList);
  }

  Future<void> loadWishlistFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? wishlistList = prefs.getStringList('wishlist');
    if (wishlistList != null) {
      _wishlist = wishlistList
          .map((product) => ProductModel.fromJson(jsonDecode(product)))
          .toList();
      notifyListeners();
    }
  }
}
