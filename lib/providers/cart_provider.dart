import 'package:flutter/material.dart';
import 'package:frontend/models/cart_model.dart';
import 'package:frontend/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];

  List<CartModel> get carts => _carts;

  Future<List<CartModel>> get cartsAwait async {
    await loadCartFromPrefs();
    return _carts;
  }

  set carts(List<CartModel> carts) {
    _carts = carts;
    saveCartToPrefs();
    notifyListeners();
  }

  addCart(ProductModel product) {
    if (productExist(product)) {
      int index =
          _carts.indexWhere((element) => element.product?.id == product.id);
      _carts[index].quantity++;
    } else {
      _carts.add(
        CartModel(
          id: _carts.length,
          product: product,
          quantity: 1,
        ),
      );
    }
    saveCartToPrefs();
    notifyListeners();
  }

  removeCart(int id) {
    _carts.removeAt(id);
    saveCartToPrefs();
    notifyListeners();
  }

  addQuantity(int id) {
    _carts[id].quantity++;
    saveCartToPrefs();
    notifyListeners();
  }

  reduceQuantity(int id) {
    _carts[id].quantity--;
    if (_carts[id].quantity == 0) {
      _carts.removeAt(id);
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

  productExist(ProductModel product) {
    if (_carts.indexWhere((element) => element.product?.id == product.id) ==
        -1) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartList =
        _carts.map((cart) => jsonEncode(cart.toJson())).toList();
    prefs.setStringList('cart', cartList);
  }

  Future<void> loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cartList = prefs.getStringList('cart');
    if (cartList != null) {
      _carts =
          cartList.map((cart) => CartModel.fromJson(jsonDecode(cart))).toList();
      notifyListeners();
    }
  }
}
