import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/components/form_component.dart';
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

class _CheckoutPageState extends State<CheckoutPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  String userAddress = "Pekanbaru";
  TextEditingController addressController = TextEditingController(text: "");

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    String norek = "2201072052";

    void showAddressModal() {
      addressController.text = userAddress;
      _animationController.forward();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ScaleTransition(
            scale: _animation,
            child: AlertDialog(
              backgroundColor: whiteColor,
              title: Text(
                "Ubah Alamat",
                style: primaryTextStyle.copyWith(fontWeight: semiBold),
              ),
              content: TextField(
                controller: addressController,
                style: blackTextStyle,
                decoration: InputDecoration(
                  hintText: "Masukkan alamat baru",
                  hintStyle: subtitleTextStyle,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Batal",
                    style: blackTextStyle.copyWith(color: alertColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    "Simpan",
                    style: primaryTextStyle,
                  ),
                  onPressed: () {
                    setState(() {
                      userAddress = addressController.text;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ).then((_) {
        _animationController.reset();
      });
    }

    handleCheckout() async {
      setState(() {
        isLoading = true;
      });

      bool statusCO = await transactionProvider.checkout(
        authProvider.user.token,
        cartProvider.carts,
        cartProvider.totalPrice(),
        userAddress,
      );
      if (!context.mounted) return;
      Navigator.popAndPushNamed(context, '/checkout-result',
          arguments: {'isSuccess': statusCO});

      if (statusCO) {
        cartProvider.carts = [];
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
            Column(
              children: cartProvider.carts
                  .map(
                    (cart) => itemTile(cart: cart),
                  )
                  .toList(),
            ),
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
              style: primaryTextStyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
            Divider(
              color: subtitleColor,
            ),
            addressItemTile(
              Icons.store,
              "Alamat Toko",
              "Jl. Inpres Gg. Iklas 1, Perhentian Marpoyan, Kec. Marpoyan Damai, Kota Pekanbaru",
            ),
            Row(
              children: [
                Expanded(
                  child: addressItemTile(
                    Icons.location_on,
                    "Alamat Kamu",
                    userAddress,
                  ),
                ),
                GestureDetector(
                  onTap: showAddressModal,
                  child: Icon(
                    Icons.edit_location_alt_rounded,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
              ],
            ),
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
                  "${cartProvider.totalItems()} item",
                  style: primaryTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: semiBold,
                  ),
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
                  formatRupiah(cartProvider.totalPrice()),
                  style: primaryTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: semiBold,
                  ),
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
                    fontSize: 15,
                    fontWeight: semiBold,
                  ),
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
                  formatRupiah(cartProvider.totalPrice()),
                  style: primaryTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: semiBold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  "Bayar Ke",
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          norek,
                          style: primaryTextStyle.copyWith(
                            fontSize: 15,
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.content_copy_rounded,
                            size: 16,
                            color: secondaryTextColor,
                          ),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: norek)).then(
                              (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: primaryColor,
                                    content: Text(
                                      "Nomor rekening berhasil disalin",
                                      textAlign: TextAlign.center,
                                      style: whiteTextStyle,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "BCA a/n Windawati",
                      style: subtitleTextStyle.copyWith(
                        fontSize: 13,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
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
              child: isLoading
                  ? const LoadingButton()
                  : TextButton(
                      onPressed: handleCheckout,
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
