import 'package:frontend/models/product_model.dart';

class CartModel {
  late int id;
  late ProductModel? product;
  late List<dynamic>? variationValueIds;
  late String? variationString;
  late int quantity;

  CartModel({
    this.id = 0,
    this.quantity = 0,
    this.product,
    this.variationValueIds,
    this.variationString = "",
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    if (json.containsKey('variation_value_ids')) {
      variationValueIds = json['variation_value_ids'];
    }

    if (json.containsKey('variation_string')) {
      variationString = json['variation_string'];
    }

    if (json.containsKey('product')) {
      product = ProductModel.fromJson(json['product']);
    }

    quantity = json['quantity'] is String
        ? int.parse(json['quantity'])
        : json['quantity'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product?.toJson(),
      'quantity': quantity,
      'variation_value_ids': variationValueIds,
      'variation_string': variationString,
    };
  }

  double getTotalPrice() {
    return product!.price * quantity;
  }
}
