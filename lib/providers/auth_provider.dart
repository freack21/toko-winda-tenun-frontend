import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  late UserModel _user;

  UserModel get user => _user;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
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

      _user = user;
      return true;
    } catch (e) {
      print("Error di authprovider");
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

      _user = user;
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

      _user = user;
      return true;
    } catch (e) {
      print("Error di authprovider");
      print(e);
      return false;
    }
  }
}
