import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class ResultCheckoutPage extends StatelessWidget {
  const ResultCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor2,
        title: Text(
          "Checkout Success",
          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      );
    }

    Widget content() {
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
                  Icons.shopping_cart_checkout,
                  color: primaryColor,
                  size: 100,
                ),
              ),
              Text(
                "Kamu berhasil membuat transaksi",
                style: primaryTextStyle.copyWith(
                    fontWeight: semiBold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Tetap di rumah sembari kami menyiapkan pesanan kamu",
                style: secondaryTextStyle.copyWith(
                  fontWeight: regular,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 4),
                child: TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/home");
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(
                      "Pesan Produk Lain",
                      style: whiteTextStyle.copyWith(fontSize: 15),
                    )),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: transparentColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: primaryColor)),
                    ),
                    child: Text(
                      "Lihat Pesanan Saya",
                      style: primaryTextStyle.copyWith(fontSize: 15),
                    )),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: header(),
      backgroundColor: backgroundColor1,
      body: content(),
    );
  }
}
