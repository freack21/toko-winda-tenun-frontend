import 'package:flutter/foundation.dart';
import 'package:frontend/models/cart_model.dart';
import 'package:frontend/services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  Future<bool> checkout(String token, List<CartModel> carts, double totalPrice,
      String userAddress) async {
    try {
      if (await TransactionService()
          .checkout(token, carts, totalPrice, userAddress)) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }
}
