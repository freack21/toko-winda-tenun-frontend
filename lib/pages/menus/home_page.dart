import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/models/category_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/order_provider.dart';
import 'package:frontend/providers/page_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _pullRefresh() async {
    try {
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.getCategories();
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
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _setCategories() async {
    try {
      PageProvider pageProvider =
          Provider.of<PageProvider>(context, listen: false);

      if (!mounted) return;
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      if (pageProvider.currentCategoryIndex == -1 &&
          pageProvider.prevCategoryIndex != -1) {
        await productProvider.getProducts();
      } else if (pageProvider.currentCategoryIndex !=
          pageProvider.prevCategoryIndex) {
        await productProvider.getProducts(
          category: productProvider.categories
              .firstWhere((cm) => cm.id == pageProvider.currentCategoryIndex)
              .name,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    PageProvider pageProvider = Provider.of<PageProvider>(context);

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
              onPressed: () async {
                pageProvider.currentCategoryIndex = index;

                await _setCategories();
              },
              style: TextButton.styleFrom(
                  backgroundColor: pageProvider.currentCategoryIndex == index
                      ? primaryColor
                      : transparentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: pageProvider.currentCategoryIndex == index
                          ? BorderSide.none
                          : BorderSide(color: secondaryTextColor)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              child: Text(
                title,
                style: (pageProvider.currentCategoryIndex == index
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
              categoryButton("Semua", -1),
              Row(
                children: productProvider.categories
                    .map((CategoryModel cm) => categoryButton(cm.name, cm.id))
                    .toList(),
              ),
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

    return Scaffold(
      backgroundColor: backgroundColor1,
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        color: primaryColor,
        child: ListView(
          children: [
            header(),
            categoryChooser(),
            newProductSection(),
            allProductSection(),
          ],
        ),
      ),
    );
  }
}
