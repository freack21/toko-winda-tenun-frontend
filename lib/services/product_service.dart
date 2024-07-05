import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/product_model.dart';

class ProductService {
  String baseUrl = 'https://songket.beetcodestudio.com/api';

  Future<List<ProductModel>> getProducts({String category = ""}) async {
    var url = '$baseUrl/products?key=fkrvndii';

    if (category.isNotEmpty) {
      url += '&$category';
    }

    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(Uri.parse(url), headers: headers);

    print(response.body);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['data'];
      List<ProductModel> products = [];

      for (var item in data) {
        products.add(ProductModel.fromJson(item));
      }

      return products;
    } else {
      throw Exception('Gagal Get Products!');
    }
  }
}
