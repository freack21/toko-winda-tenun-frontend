// ignore_for_file: camel_case_types

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/modal_component.dart';
import 'package:frontend/models/cart_model.dart';
import 'package:frontend/models/order_model.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/models/variation_model.dart';
import 'package:frontend/pages/detail_chat_page.dart';
import 'package:frontend/pages/product_detail_page.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/providers/wishlist_provider.dart';
import 'package:frontend/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class productCard extends StatelessWidget {
  final ProductModel product;
  const productCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ProductDetailPage(product: product),
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (_, animation, __, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      },
      child: Container(
        width: 215,
        height: 278,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor2,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            cachedNetworkImage(
              imageUrl(product.galleries?[0]?.url),
              width: 215,
              height: 130,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category!.name,
                    style: secondaryTextStyle.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    product.name,
                    style: blackTextStyle.copyWith(
                        fontSize: 18, fontWeight: semiBold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    formatRupiah(product.price),
                    style: priceTextStyle.copyWith(fontWeight: medium),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class productTile extends StatelessWidget {
  final ProductModel product;

  const productTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ProductDetailPage(product: product),
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (_, animation, __, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: defaultMargin / 1.5,
          left: defaultMargin,
          right: defaultMargin,
        ),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          shape: BoxShape.rectangle,
          color: secondaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: cachedNetworkImage(
                imageUrl(product.galleries?[0]?.url),
                width: 75,
                height: 75,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category!.name,
                    style: secondaryTextStyle.copyWith(fontSize: 11),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  Text(
                    product.name,
                    style: blackTextStyle.copyWith(
                      fontWeight: semiBold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    formatRupiah(product.price),
                    style: priceTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class chatTile extends StatelessWidget {
  final DocumentSnapshot chatDocument;
  final int unreadMessagesCount;

  const chatTile({
    super.key,
    required this.chatDocument,
    required this.unreadMessagesCount,
  });

  String _getTimeAgo(DateTime createdAt) {
    DateTime now = DateTime.now();
    DateTime createdDateTime = createdAt;
    Duration difference = now.difference(createdDateTime);

    if (difference.inMinutes < 2) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam';
    } else {
      return DateFormat('dd MMM yyyy').format(createdDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                DetailChatPage(
              product: UninitializedProductModel(),
              user_id: authProvider.user.role.contains("ADMIN")
                  ? chatDocument['user_id']
                  : null,
              user_avatar: authProvider.user.role.contains("ADMIN")
                  ? chatDocument['user_avatar']
                  : null,
              user_name: authProvider.user.role.contains("ADMIN")
                  ? chatDocument['user_name']
                  : null,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // Mulai dari kanan layar
              const end = Offset.zero; // Berakhir di posisi default
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: defaultMargin / 2,
          left: defaultMargin,
          right: defaultMargin,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          shape: BoxShape.rectangle,
          color: secondaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: authProvider.user.role.contains("ADMIN")
                          ? cachedNetworkImageProvider(
                              imageUrl(
                                chatDocument['user_avatar'],
                              ),
                            )
                          : const AssetImage("assets/logo_twt_chat.jpg"),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        authProvider.user.role == "USER"
                            ? "Toko Winda Tenun"
                            : chatDocument['user_name'],
                        style: primaryTextStyle.copyWith(
                          fontWeight: unreadMessagesCount > 0 ? bold : medium,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 3),
                      if ((chatDocument.data() as Map<String, dynamic>)
                          .containsKey('text'))
                        Text(
                          "${(chatDocument['text'] as String).split("\n")[0]}${(chatDocument['text'] as String).contains("\n") ? '...' : ''}",
                          style: subtitleTextStyle.copyWith(
                            fontWeight:
                                unreadMessagesCount > 0 ? medium : light,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      if ((chatDocument.data() as Map<String, dynamic>)
                          .containsKey('image_url'))
                        Row(
                          children: [
                            Icon(
                              Icons.image,
                              color: primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Gambar',
                              style: subtitleTextStyle.copyWith(
                                fontWeight:
                                    unreadMessagesCount > 0 ? medium : light,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getTimeAgo(DateTime.parse(chatDocument['created_at'])),
                      style: subtitleTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight:
                            unreadMessagesCount > 0 ? semiBold : regular,
                      ),
                    ),
                    unreadMessagesCount > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                            child: Text(
                              unreadMessagesCount.toString(),
                              style: whiteTextStyle.copyWith(fontSize: 12),
                            ),
                          )
                        : const SizedBox(),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class cartTile extends StatelessWidget {
  final CartModel cart;

  const cartTile({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    bool isNotFound = cart.product is NotFoundProductModel;

    Widget button(String text, Color color) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Center(
          child: Text(
            text,
            style: whiteTextStyle.copyWith(fontSize: 16),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(
        bottom: defaultMargin / 2,
        left: defaultMargin,
        right: defaultMargin,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: secondaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            ProductDetailPage(product: cart.product!),
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
                  child: isNotFound
                      ? Icon(
                          Icons.broken_image_rounded,
                          size: 32,
                          color: primaryColor,
                        )
                      : cachedNetworkImage(
                          imageUrl(cart.product?.galleries![0]!.url),
                          width: 64,
                        ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: isNotFound
                      ? [
                          Text(
                            "Produk Tidak Tersedia",
                            style: alertTextStyle.copyWith(
                              fontWeight: medium,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]
                      : [
                          Text(
                            cart.product!.name,
                            style: blackTextStyle.copyWith(
                              fontWeight: medium,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          cart.variationString != null &&
                                  cart.variationString!.isNotEmpty
                              ? Column(
                                  children: [
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      '[${cart.variationString!}]',
                                      style: subtitleTextStyle.copyWith(
                                          fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            formatRupiah(cart.product!.price),
                            style:
                                priceTextStyle.copyWith(fontWeight: semiBold),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      cartProvider.addQuantity(cart.id);
                    },
                    child: button("+", primaryColor),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${cart.quantity}',
                    style: primaryTextStyle.copyWith(fontWeight: semiBold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      cartProvider.reduceQuantity(cart.id);
                    },
                    child: button("-", subtitleColor),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              cartProvider.removeCart(cart.id);
            },
            child: Row(children: [
              Image.asset(
                "assets/icon_remove.png",
                width: 10,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "Hapus",
                style:
                    primaryTextStyle.copyWith(color: Colors.red, fontSize: 13),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class orderTile extends StatelessWidget {
  final OrderModel order;

  const orderTile({super.key, required this.order});

  int totalProduct() {
    int retVal = 0;
    order.items?.forEach((item) {
      retVal += item.quantity;
    });

    return retVal;
  }

  double totalPrice() {
    double retVal = 0;
    order.items?.forEach((item) {
      retVal += item.getTotalPrice();
    });

    return retVal;
  }

  @override
  Widget build(BuildContext context) {
    Widget orderItem(CartModel cart) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  ProductDetailPage(product: cart.product!),
              transitionDuration: const Duration(seconds: 1),
              transitionsBuilder: (_, animation, __, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: secondaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: cachedNetworkImage(
                      imageUrl(cart.product?.galleries![0]!.url),
                      width: 64,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cart.product!.name,
                          style: blackTextStyle.copyWith(
                            fontWeight: medium,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        cart.variationString != null &&
                                cart.variationString!.isNotEmpty
                            ? Column(
                                children: [
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    '[${cart.variationString!}]',
                                    style: subtitleTextStyle.copyWith(
                                        fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          formatRupiah(cart.product!.price),
                          style: priceTextStyle.copyWith(fontWeight: semiBold),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    'x ${cart.quantity}',
                    style: primaryTextStyle.copyWith(
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(
        bottom: defaultMargin,
        left: defaultMargin,
        right: defaultMargin,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: secondaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 4,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.address!,
                    style: blackTextStyle.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DateFormat("EEEE, d MMMM yyyy", "id_ID")
                        .format(order.createdAt!),
                    style: blackTextStyle.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )),
                child: Text(
                  order.status!,
                  style: whiteTextStyle,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          const Divider(),
          Column(
            children: order.items!.map((item) => orderItem(item)).toList(),
          ),
          const Divider(),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${totalProduct()} produk',
                style: primaryTextStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: 13,
                ),
              ),
              Text(
                'Total Harga : ${formatRupiah(totalPrice())}',
                style: primaryTextStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}

class itemTile extends StatelessWidget {
  final CartModel cart;

  const itemTile({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: secondaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: cachedNetworkImage(
                  imageUrl(cart.product?.galleries![0]!.url),
                  width: 64,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cart.product!.name,
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    cart.variationString != null &&
                            cart.variationString!.isNotEmpty
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                '[${cart.variationString!}]',
                                style: subtitleTextStyle.copyWith(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      formatRupiah(cart.product!.price),
                      style: priceTextStyle.copyWith(fontWeight: semiBold),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  Text(
                    "${cart.quantity} item",
                    style: subtitleTextStyle.copyWith(fontSize: 13),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget addressItemTile(IconData icon, String? title, String? data) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: primaryColor),
          child: Center(
            child: Icon(
              icon,
              color: whiteColor,
              size: 20,
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title!, style: subtitleTextStyle),
              const SizedBox(
                height: 2,
              ),
              Text(data!,
                  style: primaryTextStyle.copyWith(
                      fontWeight: medium, fontSize: 15)),
            ],
          ),
        )
      ],
    ),
  );
}

class favTile extends StatelessWidget {
  final ProductModel product;

  const favTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ProductDetailPage(product: product),
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (_, animation, __, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: defaultMargin / 2,
            left: defaultMargin,
            right: defaultMargin),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            shape: BoxShape.rectangle,
            color: secondaryColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: cachedNetworkImage(
                      imageUrl(product.galleries![0]!.url),
                      width: 64,
                    )),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: primaryTextStyle.copyWith(
                            fontWeight: medium, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        formatRupiah(product.price),
                        style: priceTextStyle.copyWith(fontWeight: semiBold),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    wishlistProvider.setProduct(product);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: primaryColor),
                    child: Icon(
                      Icons.favorite_rounded,
                      color: whiteColor,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class variationSelection extends StatefulWidget {
  final Map<String, List<VariationModel>>? variations;
  final ProductModel product;

  const variationSelection(
      {super.key, required this.variations, required this.product});

  @override
  State<variationSelection> createState() => _variationSelectionState();
}

class _variationSelectionState extends State<variationSelection> {
  Map<String, int> currentIndexs = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    for (var key in widget.variations!.keys) {
      currentIndexs[key] = -1;
    }
  }

  bool isFullfilled() {
    for (var key in currentIndexs.keys) {
      if (currentIndexs[key] == -1) return false;
    }

    return true;
  }

  List<int> variationIds() {
    List<int> ids = [];
    for (var key in currentIndexs.keys) {
      ids.add(currentIndexs[key]!);
    }

    return ids;
  }

  String variationIdsString() {
    return "[${variationIds().join(",")}]";
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    String variationString() {
      List<String> retVal = [];
      for (var key in currentIndexs.keys) {
        String value = "";
        for (var data in widget.variations![key]!) {
          if (data.id == currentIndexs[key]) value = data.value;
        }
        retVal.add(value);
      }
      return retVal.join(", ");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.variations!.keys.map((key) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    key,
                    style: blackTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    spacing: 12,
                    children:
                        widget.variations![key]!.asMap().entries.map((entry) {
                      VariationModel variant = entry.value;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndexs[key] = variant.id;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: currentIndexs[key] == variant.id
                                ? primaryColor
                                : const Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text(
                            variant.value,
                            style: currentIndexs[key] == variant.id
                                ? whiteTextStyle
                                : blackTextStyle,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }).toList()),
        const SizedBox(
          height: 15,
        ),
        Divider(
          color: subtitleColor,
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: TextButton(
            onPressed: () async {
              if (!isFullfilled()) return;

              setState(() {
                isLoading = true;
              });

              Navigator.pop(context);
              cartProvider.addCart(
                  widget.product, variationIds(), variationString());
              showDialog(
                context: context,
                builder: (_) => const SuccessAddToCartModal(),
              );

              setState(() {
                isLoading = false;
              });
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor:
                  isFullfilled() ? primaryColor : const Color(0xff999999),
            ),
            child: isLoading
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          whiteColor,
                        )),
                  )
                : Text(
                    'Tambah ke Keranjang',
                    style: whiteTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: semiBold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

Widget brokenImage(
    BuildContext context, Object exception, StackTrace? stackTrace) {
  return Center(
    child: Image.asset(
      "assets/img_broken.png",
      color: whiteColor,
    ),
  );
}

Widget brokenImageNetwork() {
  return Center(
    child: Image.asset(
      "assets/img_broken.png",
      color: whiteColor,
    ),
  );
}

Widget cachedNetworkImage(String imageUrl,
    {double? width, double? height, BoxFit? fit}) {
  return CachedNetworkImage(
    progressIndicatorBuilder: (context, url, progress) => Center(
      child: CircularProgressIndicator(
        value: progress.progress,
        valueColor: AlwaysStoppedAnimation(
          subtitleColor,
        ),
      ),
    ),
    imageUrl: imageUrl,
    width: width,
    height: height,
    fit: fit,
    errorWidget: (_, __, ___) => brokenImageNetwork(),
  );
}

ImageProvider cachedNetworkImageProvider(String imageUrl) {
  return CachedNetworkImageProvider(imageUrl);
}

ImageProvider errorImageProvider() {
  return const AssetImage("assets/img_broken.png");
}
