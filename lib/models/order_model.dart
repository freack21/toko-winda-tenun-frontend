import 'package:frontend/models/cart_model.dart';

class OrderModel {
  late int id;
  late List<CartModel>? items;
  late String? address;
  late String? payment;
  late String? status;
  late String? totalPrice;
  late String? shippingPrice;
  late DateTime? createdAt;
  late DateTime? updatedAt;

  OrderModel({
    this.id = 0,
    this.items,
    this.address,
    this.payment,
    this.status,
    this.totalPrice,
    this.shippingPrice,
    this.createdAt,
    this.updatedAt,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    items = [];
    if (json.containsKey('items')) {
      for (var item in (json['items'] as List<dynamic>)) {
        if (item != null) items?.add(CartModel.fromJson((item)));
      }
    }

    address = json['address'];
    payment = json['payment'];
    status = json['status'];
    totalPrice = json['total_price'];
    shippingPrice = json['shipping_price'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items?.map((cart) => cart.toJson()).toList(),
      'payment': payment,
      'status': status,
      'total_price': totalPrice,
      'shipping_price': shippingPrice,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
