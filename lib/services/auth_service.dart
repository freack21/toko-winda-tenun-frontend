import 'dart:convert';

import 'package:frontend/models/user_model.dart';
import 'package:frontend/theme.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<UserModel> register({
    String name = "",
    String username = "",
    String? phone,
    String email = "",
    String password = "",
  }) async {
    var url = '$apiBaseUrl/register';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'username': username,
      'phone': phone,
      'email': email,
      'password': password,
      'role': "USER",
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data["user"]);
      user.token = "${data["token_type"]} ${data["access_token"]}";

      return user;
    } else {
      var data = jsonDecode(response.body)['data']['error'];
      throw Exception(data);
    }
  }

  Future<UserModel> login({
    String email = "",
    String password = "",
  }) async {
    var url = '$apiBaseUrl/login';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.token = "Bearer ${data['access_token']}";

      return user;
    } else {
      throw Exception('Gagal Login');
    }
  }

  Future<bool> logout({
    String token = "",
  }) async {
    var url = '$apiBaseUrl/logout';
    var headers = {'Authorization': token};

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Gagal Logout');
  }

  Future<bool> check({
    String token = "",
  }) async {
    var url = '$apiBaseUrl/user';
    var headers = {'Authorization': token};

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('User Telah Logout');
  }

  Future<UserModel> updateUser({
    String name = "",
    String username = "",
    String token = "",
  }) async {
    var url = '$apiBaseUrl/user';
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = jsonEncode({
      'name': name,
      'username': username,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      url = '$apiBaseUrl/user';
      headers = {'Content-Type': 'application/json', 'Authorization': token};

      response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        UserModel user = UserModel.fromJson(data);
        user.token = token;

        return user;
      }
    }
    throw Exception('Gagal Edit Profil');
  }
}
