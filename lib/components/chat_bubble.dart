import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/product_detail_page.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatBubble extends StatelessWidget {
  final DocumentSnapshot chatDocument;

  const ChatBubble({super.key, required this.chatDocument});

  void _updateHasRead() {
    chatDocument.reference.update({'has_read': true});
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;
    bool isSender = chatDocument['user_role'].contains(user.role);

    ProductModel product =
        (chatDocument['product'] as Map<String, dynamic>).containsKey('id')
            ? ProductModel.fromJson(chatDocument['product'])
            : UninitializedProductModel();

    Future<void> showSuccessDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          width: MediaQuery.of(context).size.width - (2 * defaultMargin),
          child: AlertDialog(
            backgroundColor: backgroundColor3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 100,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Horee :)',
                    style: primaryTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Produk berhasil ditambahkan!',
                    style: secondaryTextStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 154,
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Lihat Keranjang',
                        style: whiteTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget productPreview() {
      return Container(
        width: 230,
        margin: EdgeInsets.only(bottom: defaultMargin / 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isSender ? whiteColor : primaryColor,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl(product.galleries?[0]?.url),
                      width: 70,
                    )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: (isSender ? primaryTextStyle : whiteTextStyle)
                            .copyWith(fontSize: 15, fontWeight: medium),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        formatRupiah(product.price),
                        style:
                            (isSender ? secondaryTextStyle : subtitleTextStyle)
                                .copyWith(fontWeight: semiBold),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: product)));
                },
                style: OutlinedButton.styleFrom(
                    side:
                        BorderSide(color: isSender ? primaryColor : whiteColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text(
                  "Detail Produk",
                  style: (isSender ? primaryTextStyle : whiteTextStyle),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  cartProvider.addCart(product);
                  showSuccessDialog();
                },
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: isSender ? primaryColor : whiteColor),
                child: Text(
                  "Tambah ke Keranjang",
                  style: (isSender ? whiteTextStyle : primaryTextStyle)
                      .copyWith(fontSize: 15),
                ),
              ),
            )
          ],
        ),
      );
    }

    return VisibilityDetector(
      key: Key(chatDocument.id),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.5 && !chatDocument['has_read']) {
          _updateHasRead();
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: defaultMargin / 3),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            product is UninitializedProductModel
                ? const SizedBox()
                : productPreview(),
            Row(
              mainAxisAlignment:
                  isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .7),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                        color: isSender ? whiteColor : primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: Radius.circular((isSender ? 0 : 12)),
                          bottomLeft: Radius.circular((!isSender ? 0 : 12)),
                          bottomRight: const Radius.circular(12),
                        )),
                    child: Text(
                      chatDocument['text'],
                      style: isSender ? primaryTextStyle : whiteTextStyle,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
