import 'package:flutter/material.dart';
import 'package:frontend/providers/page_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class ResultCheckoutPage extends StatelessWidget {
  const ResultCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    bool isSuccess = arguments['isSuccess'];

    PreferredSizeWidget header() {
      return AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor2,
        title: Text(
          "Checkout ${isSuccess ? "Sukses" : "Gagal"}",
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
                  isSuccess
                      ? Icons.shopping_cart_checkout
                      : Icons.remove_shopping_cart_rounded,
                  color: isSuccess ? primaryColor : alertColor,
                  size: 100,
                ),
              ),
              Text(
                isSuccess
                    ? "Kamu berhasil membuat transaksi"
                    : "Transaksi gagal!",
                style: (isSuccess ? primaryTextStyle : alertTextStyle)
                    .copyWith(fontWeight: semiBold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                isSuccess
                    ? "Tetap di rumah sembari kami menyiapkan pesanan kamu"
                    : "Silahkan coba lagi nanti ya!",
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
                      Provider.of<PageProvider>(context, listen: false)
                          .currentIndex = 0;
                      Navigator.pushNamed(context, "/home");
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
                    onPressed: () {
                      if (!isSuccess) {
                        Navigator.popAndPushNamed(context, '/cart');
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: transparentColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: primaryColor)),
                    ),
                    child: Text(
                      isSuccess ? "Lihat Pesanan Saya" : "Lihat Keranjang",
                      style: primaryTextStyle.copyWith(fontSize: 15),
                    )),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Provider.of<PageProvider>(context, listen: false).currentIndex = 0;
        Navigator.pushNamed(context, '/home');
      },
      child: Scaffold(
        appBar: header(),
        backgroundColor: backgroundColor1,
        body: content(),
      ),
    );
  }
}
