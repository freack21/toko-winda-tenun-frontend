import 'package:frontend/models/product_model.dart';

class CartModel {
  late int id;
  late ProductModel? product;
  late int quantity;

  CartModel({
    this.id = 0,
    this.quantity = 0,
    this.product,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = ProductModel.fromJson(json['product']);
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product?.toJson(),
      'quantity': quantity,
    };
  }

  double getTotalPrice() {
    return product!.price * quantity;
  }
}
