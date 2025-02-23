import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/cart_model.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];
  int _userId = -1;

  List<CartModel> get carts => _carts;
  int get userId => _userId;

  Future<List<CartModel>> get cartsAwait async {
    await loadCartFromPrefs();
    return _carts;
  }

  set userId(int userID) {
    _userId = userID;
    loadCartFromPrefs(); // Load cart for the new user ID
    notifyListeners();
  }

  set carts(List<CartModel> carts) {
    _carts = carts;
    saveCartToPrefs();
    notifyListeners();
  }

  addCart(ProductModel product, List<dynamic>? variationValueIds,
      String? variationString) {
    if (productExist(product, variationValueIds, variationString)) {
      int index = _carts.indexWhere((element) =>
          element.product?.id == product.id &&
          areListsEqual(element.variationValueIds, variationValueIds) &&
          element.variationString == variationString);
      _carts[index].quantity++;
    } else {
      _carts.add(
        CartModel(
          id: _carts.length,
          product: product,
          quantity: 1,
          variationValueIds: variationValueIds,
          variationString: variationString,
        ),
      );
    }
    saveCartToPrefs();
    notifyListeners();
  }

  removeCart(int id) {
    int index = _carts.indexWhere((element) => element.id == id);
    _carts.removeAt(index);
    saveCartToPrefs();
    notifyListeners();
  }

  addQuantity(int id) {
    int index = _carts.indexWhere((element) => element.id == id);
    _carts[index].quantity++;
    saveCartToPrefs();
    notifyListeners();
  }

  reduceQuantity(int id) {
    int index = _carts.indexWhere((element) => element.id == id);
    _carts[index].quantity--;
    if (_carts[index].quantity == 0) {
      _carts.removeAt(index);
    }
    saveCartToPrefs();
    notifyListeners();
  }

  totalItems() {
    int total = 0;
    for (var item in _carts) {
      total += item.quantity;
    }
    return total;
  }

  totalPrice() {
    double total = 0;
    for (var item in _carts) {
      total += (item.quantity * item.product!.price);
    }
    return total;
  }

  productExist(ProductModel product, List<dynamic>? variationValueIds,
      String? variationString) {
    return _carts.indexWhere((element) =>
            element.product?.id == product.id &&
            areListsEqual(element.variationValueIds, variationValueIds) &&
            element.variationString == variationString) !=
        -1;
  }

  Future<void> saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartList =
        _carts.map((cart) => jsonEncode(cart.toJson())).toList();
    await prefs.setStringList('cart_$_userId', cartList);
  }

  Future<void> loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cartList = prefs.getStringList('cart_$_userId');
    if (cartList != null) {
      _carts =
          cartList.map((cart) => CartModel.fromJson(jsonDecode(cart))).toList();
    } else {
      _carts = [];
    }
    notifyListeners();
  }
}
