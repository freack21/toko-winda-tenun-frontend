import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/providers/wishlist_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context);

    PreferredSizeWidget header() {
      return AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Produk Favorit",
          style: primaryTextStyle.copyWith(
            fontWeight: medium,
            fontSize: 16,
          ),
        ),
        backgroundColor: backgroundColor2,
        toolbarHeight: 64,
      );
    }

    Widget noFavorite() {
      return Center(
        child: Container(
          margin: EdgeInsets.all(defaultMargin / 1.5),
          padding: EdgeInsets.all(defaultMargin / 1.5),
          decoration: BoxDecoration(
              color: whiteColor, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(bottom: 16),
                child: Icon(
                  Icons.heart_broken_rounded,
                  color: primaryColor,
                  size: 100,
                ),
              ),
              Text(
                "Kamu belum memiliki produk favorit?",
                style: primaryTextStyle.copyWith(
                    fontWeight: semiBold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Ayo temukan produk favoritmu",
                style: secondaryTextStyle.copyWith(
                  fontWeight: regular,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "/home");
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 12, horizontal: defaultMargin),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text(
                    "Jelajahi Toko",
                    style: whiteTextStyle.copyWith(fontSize: 15),
                  )),
            ],
          ),
        ),
      );
    }

    Widget listFavorite() {
      return wishlistProvider.wishlist.isEmpty
          ? noFavorite()
          : ListView(
              children: [
                SizedBox(
                  height: defaultMargin,
                ),
                Column(
                  children: wishlistProvider.wishlist
                      .map((ProductModel product) => favTile(
                            product: product,
                          ))
                      .toList(),
                ),
                SizedBox(
                  height: defaultMargin,
                ),
              ],
            );
    }

    return Scaffold(
      appBar: header(),
      backgroundColor: backgroundColor1,
      body: listFavorite(),
    );
  }
}
