import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/providers/transaction_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleCheckout() async {
      setState(() {
        isLoading = true;
      });

      if (await transactionProvider.checkout(
        authProvider.user.token,
        cartProvider.carts,
        cartProvider.totalPrice(),
      )) {
        cartProvider.carts = [];
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
            context, '/checkout-result', (route) => false);
      }

      setState(() {
        isLoading = false;
      });
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
          "Detail Checkout",
          style: primaryTextStyle.copyWith(fontWeight: medium, fontSize: 18),
        ),
        toolbarHeight: 64,
      );
    }

    Widget listItem() {
      return Container(
        margin: EdgeInsets.all(defaultMargin / 1.5),
        padding: EdgeInsets.all(defaultMargin / 2),
        decoration: BoxDecoration(
            color: whiteColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daftar Item",
              style:
                  primaryTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
            ),
            Divider(
              color: subtitleColor,
            ),
            itemTile(),
            itemTile(),
          ],
        ),
      );
    }

    Widget addressDetails() {
      return Container(
        margin: EdgeInsets.only(
            left: defaultMargin / 1.5,
            right: defaultMargin / 1.5,
            bottom: defaultMargin / 1.5),
        padding: EdgeInsets.all(defaultMargin / 2),
        decoration: BoxDecoration(
            color: whiteColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detail Alamat",
              style:
                  primaryTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
            ),
            Divider(
              color: subtitleColor,
            ),
            addressItemTile(
                Icons.store, "Alamat Toko", "Jl. Jendral Sudirman, Pekanbaru"),
            addressItemTile(Icons.location_on, "Alamat Kamu",
                "Jl. HR Soebrantas, Pekanbaru"),
          ],
        ),
      );
    }

    Widget paymentSummary() {
      return Container(
        margin: EdgeInsets.only(
            left: defaultMargin / 1.5,
            right: defaultMargin / 1.5,
            bottom: defaultMargin / 1.5),
        padding: EdgeInsets.all(defaultMargin / 2),
        decoration: BoxDecoration(
            color: whiteColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detail Pembayaran",
              style:
                  primaryTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
            ),
            Divider(
              color: subtitleColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Jumlah Produk",
                  style: secondaryTextStyle,
                )),
                Text(
                  "2 item",
                  style: primaryTextStyle.copyWith(
                      fontSize: 15, fontWeight: semiBold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Harga Produk",
                  style: secondaryTextStyle,
                )),
                Text(
                  "\$574,12",
                  style: primaryTextStyle.copyWith(
                      fontSize: 15, fontWeight: semiBold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Ongkos Kirim",
                  style: secondaryTextStyle,
                )),
                Text(
                  "Gratis",
                  style: primaryTextStyle.copyWith(
                      fontSize: 15, fontWeight: semiBold),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Divider(
              color: subtitleColor,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Total",
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                )),
                Text(
                  "\$574,12",
                  style: primaryTextStyle.copyWith(
                      fontSize: 15, fontWeight: semiBold),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget footer() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  Navigator.popAndPushNamed(context, "/checkout-result");
                },
                style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20)),
                child: Center(
                  child: Text(
                    "Checkout Sekarang",
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: medium,
                    ),
                  ),
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
      body: ListView(
        children: [listItem(), addressDetails(), paymentSummary()],
      ),
      bottomNavigationBar: footer(),
    );
  }
}
