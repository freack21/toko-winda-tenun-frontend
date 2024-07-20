import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/models/order_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/order_provider.dart';
import 'package:frontend/providers/page_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    Future<void> pullRefresh() async {
      try {
        ProductProvider productProvider =
            Provider.of<ProductProvider>(context, listen: false);
        await productProvider.getProducts();

        if (!context.mounted) return;
        AuthProvider authProvider =
            Provider.of<AuthProvider>(context, listen: false);
        UserModel user = authProvider.user;

        await orderProvider.getOrders(user.token);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: backgroundColor2,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
        scrolledUnderElevation: 0.0,
        title: Text(
          "Daftar Pesanan Kamu",
          style: primaryTextStyle.copyWith(fontWeight: medium, fontSize: 18),
        ),
        toolbarHeight: 64,
      );
    }

    Widget noOrder() {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                shape: BoxShape.rectangle,
                color: secondaryColor,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Ups! Kamu belum punya pesanan nih..",
                    style: primaryTextStyle.copyWith(
                        fontSize: 16, fontWeight: medium),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Ayo temukan songket favorit kamu!",
                    style: secondaryTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: primaryColor),
                    child: TextButton(
                      onPressed: () {
                        pageProvider.currentIndex = 0;
                        Navigator.popAndPushNamed(context, "/home");
                      },
                      child: Text(
                        "Jelajahi Toko",
                        style: whiteTextStyle.copyWith(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget listOrder() {
      return ListView(
        children: [
          SizedBox(
            height: defaultMargin / 1.5,
          ),
          Column(
            children: orderProvider.orders
                .map((OrderModel order) => orderTile(
                      order: order,
                    ))
                .toList(),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: RefreshIndicator(
        onRefresh: pullRefresh,
        color: primaryColor,
        child: orderProvider.orders.isEmpty ? noOrder() : listOrder(),
      ),
    );
  }
}
