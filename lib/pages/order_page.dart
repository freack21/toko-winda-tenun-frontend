import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/models/order_model.dart';
import 'package:frontend/providers/order_provider.dart';
import 'package:frontend/providers/page_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);

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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  shape: BoxShape.rectangle,
                  color: secondaryColor),
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
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Ayo temukan songket favorit kamu!",
                    style: secondaryTextStyle,
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
      body: orderProvider.orders.isEmpty ? noOrder() : listOrder(),
    );
  }
}
