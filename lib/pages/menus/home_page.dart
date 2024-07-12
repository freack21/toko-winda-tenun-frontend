import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/order_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentCategoryIndex = 0;

  Future<void> _pullRefresh() async {
    try {
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.getProducts();

      if (!mounted) return;
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      UserModel user = authProvider.user;

      if (!mounted) return;
      OrderProvider orderProvider =
          Provider.of<OrderProvider>(context, listen: false);
      orderProvider.userId = authProvider.user.id;
      await orderProvider.getOrders(user.token);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    Widget header() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Halo, ${user.name.split(" ")[0]}!",
                    style: primaryTextStyle.copyWith(
                        fontSize: 24, fontWeight: semiBold),
                  ),
                  Text(
                    "@${user.username}",
                    style: subtitleTextStyle.copyWith(fontSize: 16),
                  )
                ],
              ),
            ),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: cachedNetworkImageProvider(
                      user.avatar,
                    ),
                  )),
            )
          ],
        ),
      );
    }

    Widget categoryChooser() {
      Widget categoryButton(String title, int index) {
        return Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  currentCategoryIndex = index;
                });
              },
              style: TextButton.styleFrom(
                  backgroundColor: currentCategoryIndex == index
                      ? primaryColor
                      : transparentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: currentCategoryIndex == index
                          ? BorderSide.none
                          : BorderSide(color: secondaryTextColor)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              child: Text(
                title,
                style: (currentCategoryIndex == index
                    ? whiteTextStyle.copyWith(fontWeight: medium, fontSize: 13)
                    : secondaryTextStyle.copyWith(
                        fontWeight: light, fontSize: 13)),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        );
      }

      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(
                width: 22,
              ),
              categoryButton("Semua", 0),
              categoryButton("Running", 1),
              categoryButton("Training", 2),
              categoryButton("Basketball", 3),
              categoryButton("Football", 3),
              const SizedBox(
                width: 22,
              ),
            ],
          ),
        ),
      );
    }

    Widget newProductSection() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Text(
                "Produk Terbaru",
                style: primaryTextStyle.copyWith(
                    fontSize: 22, fontWeight: semiBold),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Row(
                    children: productProvider.products
                        .getRange(0, min(5, productProvider.products.length))
                        .map(
                          (product) => productCard(product: product),
                        )
                        .toList(),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget allProductSection() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Text(
                "Semua Produk",
                style: primaryTextStyle.copyWith(
                    fontSize: 22, fontWeight: semiBold),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Column(
              children: productProvider.products
                  .map(
                    (product) => productTile(product: product),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        color: primaryColor,
        child: ListView(
          children: [header(), newProductSection(), allProductSection()],
        ),
      ),
    );
  }
}
