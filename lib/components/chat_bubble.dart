import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/components/modal_component.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/product_detail_page.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../pages/image_fullscreen_page.dart';

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
                    child: cachedNetworkImage(
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
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          ProductDetailPage(product: product),
                      transitionDuration: const Duration(seconds: 1),
                      transitionsBuilder: (_, animation, __, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                            position: offsetAnimation, child: child);
                      },
                    ),
                  );
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
                  cartProvider.addCart(product, [], "");
                  showDialog(
                    context: context,
                    builder: (_) => const SuccessAddToCartModal(),
                  );
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

    Widget imageMessage() {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ImageFullscreenPage(imageUrl: chatDocument['image_url']),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: cachedNetworkImage(
            chatDocument['image_url'],
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return VisibilityDetector(
      key: Key(chatDocument.id),
      onVisibilityChanged: (visibilityInfo) {
        if (!isSender &&
            visibilityInfo.visibleFraction > 0.5 &&
            !chatDocument['has_read']) {
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
                  child: Column(
                    crossAxisAlignment: isSender
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if ((chatDocument.data() as Map<String, dynamic>)
                          .containsKey('image_url'))
                        imageMessage(),
                      if ((chatDocument.data() as Map<String, dynamic>)
                          .containsKey('text'))
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * .7),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 6, left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: isSender ? whiteColor : primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: Radius.circular((isSender ? 0 : 12)),
                              bottomLeft: Radius.circular((!isSender ? 0 : 12)),
                              bottomRight: const Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: isSender
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                chatDocument['text'],
                                style: isSender
                                    ? primaryTextStyle
                                    : whiteTextStyle,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                DateFormat.Hm().format(
                                  DateTime.parse(chatDocument['created_at']),
                                ),
                                style: (isSender
                                        ? secondaryTextStyle
                                        : subtitleTextStyle)
                                    .copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
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
