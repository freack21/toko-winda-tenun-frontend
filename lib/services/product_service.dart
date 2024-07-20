import 'dart:convert';
import 'package:frontend/theme.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/product_model.dart';

class ProductService {
  Future<List<ProductModel>> getProducts({String category = ""}) async {
    var url = '$baseUrl/products?key=fkrvndii';

    if (category.isNotEmpty) {
      url += '&$category';
    }

    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(Uri.parse(url), headers: headers);

    // print(response.body);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      List<ProductModel> products = [];

      for (var item in data) {
        products.add(ProductModel.fromJson(item));
      }

      return products;
    } else {
      throw Exception('Gagal Get Products!');
    }
  }

  Future<ProductModel> getProduct(int id) async {
    var url = '$baseUrl/products?id=$id';

    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      ProductModel product = ProductModel.fromJson(data);

      return product;
    } else {
      throw Exception('Gagal Get Product!');
    }
  }
}
