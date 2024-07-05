import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  late UserModel _user;

  UserModel get user {
    return _user;
  }

  Future<UserModel> get userAwait async {
    await _loadUserFromPrefs();
    return _user;
  }

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    if (userData != null) {
      _user = UserModel.fromJson(jsonDecode(userData));
      notifyListeners();
    }
  }

  Future<void> setUser(UserModel user) async {
    _user = user;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<bool> register({
    String name = "",
    String username = "",
    String phone = "",
    String email = "",
    String password = "",
  }) async {
    try {
      UserModel user = await AuthService().register(
        name: name,
        username: username,
        phone: phone,
        email: email,
        password: password,
      );

      setUser(user);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login({
    String email = "",
    String password = "",
  }) async {
    try {
      UserModel user = await AuthService().login(
        email: email,
        password: password,
      );

      setUser(user);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout({
    String token = "",
  }) async {
    try {
      bool isLoggedOut = await AuthService().logout(
        token: token,
      );

      if (isLoggedOut) {
        _user.token = "";
        setUser(_user);
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> check({
    String token = "",
  }) async {
    try {
      bool isLoggedIn = await AuthService().check(
        token: token,
      );

      return isLoggedIn;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> updateUser({
    String name = "",
    String username = "",
    String token = "",
  }) async {
    try {
      UserModel user = await AuthService().updateUser(
        name: name,
        username: username,
        token: token,
      );

      setUser(user);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
