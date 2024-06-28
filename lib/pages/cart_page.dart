import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/theme.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: backgroundColor2,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
        scrolledUnderElevation: 0.0,
        title: Text(
          "Keranjang Kamu",
          style: primaryTextStyle.copyWith(fontWeight: medium, fontSize: 18),
        ),
        toolbarHeight: 64,
      );
    }

    Widget noCart() {
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
                    Icons.remove_shopping_cart,
                    size: 80,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Ups! Keranjang kamu kosong nih..",
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
                      onPressed: () {},
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

    Widget listCart() {
      return ListView(
        children: [
          SizedBox(
            height: defaultMargin / 1.5,
          ),
          cartTile(),
          cartTile(),
          cartTile(),
          cartTile(),
          cartTile(),
          cartTile(),
          cartTile(),
          cartTile(),
          cartTile(),
          cartTile(),
        ],
      );
    }

    Widget footer() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                bottom: defaultMargin / 2,
                left: defaultMargin / 2,
                right: defaultMargin / 2),
            padding: EdgeInsets.symmetric(
                horizontal: defaultMargin / 1.5, vertical: defaultMargin / 2),
            decoration: BoxDecoration(
                color: whiteColor, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Subtotal",
                    style: primaryTextStyle.copyWith(fontSize: 15),
                  ),
                ),
                Text(
                  "\$1000,90",
                  style: priceTextStyle.copyWith(
                      fontWeight: semiBold, fontSize: 16),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
            ),
            padding: EdgeInsets.symmetric(
                vertical: defaultMargin / 1.25, horizontal: defaultMargin),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/checkout");
                },
                style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Checkout",
                        style: whiteTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: whiteColor,
                      size: 24,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: listCart(),
      bottomNavigationBar: footer(),
    );
  }
}
