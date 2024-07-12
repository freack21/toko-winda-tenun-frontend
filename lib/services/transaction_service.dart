import 'dart:convert';
import 'package:frontend/models/cart_model.dart';
import 'package:frontend/models/order_model.dart';
import 'package:frontend/theme.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  Future<bool> checkout(
      String token, List<CartModel> carts, double totalPrice) async {
    var url = '$baseUrl/checkout';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode(
      {
        'address': 'Pekanbaru',
        'items': carts
            .map(
              (cart) => {
                'id': cart.product?.id,
                'quantity': cart.quantity,
              },
            )
            .toList(),
        'status': "PENDING",
        'total_price': totalPrice,
        'shipping_price': 0,
      },
    );

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    // print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal Melakukan Checkout!');
    }
  }

  Future<List<OrderModel>> getTransactions(String token) async {
    var url = '$baseUrl/transactions';
    var headers = {
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    // print(response.body);

    if (response.statusCode == 200) {
      List<OrderModel> orders = [];

      if (jsonDecode(response.body)['data'] is List<dynamic>) {
        List data = jsonDecode(response.body)['data'];
        for (var item in data) {
          orders.add(OrderModel.fromJson(item));
        }
      } else {
        orders.add(OrderModel.fromJson(jsonDecode(response.body)['data']));
      }

      return orders;
    } else {
      throw Exception('Gagal Mengambil Data Transaksi!');
    }
  }
}
