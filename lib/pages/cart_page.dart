import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/models/cart_model.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/providers/page_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = true;
  bool isValid = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkProducts();
    });

    super.initState();
  }

  Future<void> _checkProducts() async {
    try {
      CartProvider cartProvider =
          Provider.of<CartProvider>(context, listen: false);
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      List<CartModel> carts_ = [];
      for (var cart in cartProvider.carts) {
        cart.product = await productProvider.getProduct(cart.product!.id);
        if (cart.product is NotFoundProductModel) {
          cart.quantity = 0;
          if (isValid) {
            setState(
              () {
                isValid = false;
              },
            );
          }
        }
        carts_.add(cart);
      }

      cartProvider.carts = carts_;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
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

    Widget listCart() {
      return ListView(
        children: [
          SizedBox(
            height: defaultMargin / 1.5,
          ),
          Column(
            children: cartProvider.carts
                .map((CartModel cart) => cartTile(
                      cart: cart,
                    ))
                .toList(),
          ),
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
                  formatRupiah(cartProvider.totalPrice()),
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
                vertical: defaultMargin / 2, horizontal: defaultMargin),
            child: Column(
              children: [
                Text(
                  "Pastikan sebelum membeli Anda sudah menanyakan produk ke seller!",
                  style: alertTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      if (isValid) {
                        Navigator.pushNamed(context, "/checkout");
                      }
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: isValid ? primaryColor : subtitleColor,
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
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                subtitleColor,
              )),
            )
          : cartProvider.carts.isEmpty
              ? noCart()
              : listCart(),
      bottomNavigationBar:
          cartProvider.carts.isEmpty ? const SizedBox() : footer(),
    );
  }
}
