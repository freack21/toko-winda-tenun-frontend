import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/order_model.dart';
import 'package:frontend/services/transaction_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  int _userId = -1;

  List<OrderModel> get orders => _orders;
  int get userId => _userId;

  Future<List<OrderModel>> get ordersAwait async {
    await loadOrderFromPrefs();
    return _orders;
  }

  set userId(int userID) {
    _userId = userID;
    loadOrderFromPrefs(); // Load order for the new user ID
    notifyListeners();
  }

  setOrders(List<OrderModel> orders) {
    _orders = orders;
    saveOrderToPrefs();
    notifyListeners();
  }

  Future<void> saveOrderToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> orderList =
        _orders.map((order) => jsonEncode(order.toJson())).toList();
    await prefs.setStringList('order_$_userId', orderList);
  }

  Future<void> loadOrderFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? orderList = prefs.getStringList('order_$_userId');
    if (orderList != null) {
      _orders = orderList
          .map((order) => OrderModel.fromJson(jsonDecode(order)))
          .toList();
    } else {
      _orders = [];
    }
    notifyListeners();
  }

  Future<bool> getOrders(String token) async {
    try {
      List<OrderModel> orders =
          await TransactionService().getTransactions(token);

      setOrders(orders);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }
}
