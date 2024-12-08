import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/components/modal_component.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/pages/detail_chat_page.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/wishlist_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool isLoading = false;
  bool isLoadingProduct = true;
  late AnimationController _controller;
  ProductModel myProduct = NotFoundProductModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMyProduct();
    });

    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> _getMyProduct() async {
    try {
      ProductProvider productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      myProduct = await productProvider.getProduct(widget.product.id);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      myProduct = NotFoundProductModel();
    }
    if (mounted) {
      setState(() {
        isLoadingProduct = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    Widget indicator(int index) {
      return Container(
        width: currentIndex == index ? 16 : 4,
        height: 4,
        margin: const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currentIndex == index ? primaryColor : const Color(0xffC4C4C4),
        ),
      );
    }

    Widget familiarShoesCard(ProductModel product_) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => ProductDetailPage(product: product_),
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
          width: 54,
          height: 54,
          margin: const EdgeInsets.only(
            right: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: cachedNetworkImage(
            imageUrl(product_.galleries?[0]?.url),
          ),
        ),
      );
    }

    Widget backAndCart() {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left,
                color: blackColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/cart');
              },
              child: Icon(
                Icons.shopping_bag,
                color: primaryColor,
              ),
            ),
          ],
        ),
      );
    }

    Widget header() {
      int index = -1;

      return Column(
        children: [
          backAndCart(),
          const SizedBox(
            height: 20,
          ),
          CarouselSlider(
            items: myProduct.galleries!
                .map(
                  (image) => cachedNetworkImage(
                    imageUrl(image!.url),
                    width: MediaQuery.of(context).size.width,
                    height: 310,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: myProduct.galleries!.map((e) {
              index++;
              return indicator(index);
            }).toList(),
          ),
        ],
      );
    }

    Widget content() {
      int index = -1;

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 17),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          color: backgroundColor2,
        ),
        child: Column(
          children: [
            // NOTE: HEADER
            Container(
              margin: EdgeInsets.only(
                top: defaultMargin,
                left: defaultMargin,
                right: defaultMargin,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          myProduct.name,
                          style: primaryTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                        ),
                        Text(
                          myProduct.category!.name,
                          style: secondaryTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      wishlistProvider.setProduct(myProduct);

                      if (wishlistProvider.isWishlist(myProduct)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: primaryColor,
                            content: Text(
                              'Berhasil ditambahkan ke Produk Favorit!',
                              textAlign: TextAlign.center,
                              style: whiteTextStyle,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: alertColor,
                            content: Text(
                              'Berhasil dihapus dari Produk Favorit!',
                              textAlign: TextAlign.center,
                              style: whiteTextStyle,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: wishlistProvider.isWishlist(myProduct)
                              ? primaryColor
                              : subtitleColor),
                      child: Center(
                        child: Icon(
                          Icons.favorite,
                          size: 24,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // NOTE: PRICE
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 20,
                left: defaultMargin,
                right: defaultMargin,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffeeeeee),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Harga mulai dari',
                    style: primaryTextStyle,
                  ),
                  Text(
                    formatRupiah(myProduct.price),
                    style: priceTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
            ),

            // NOTE: DESCRIPTION
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: defaultMargin,
                left: defaultMargin,
                right: defaultMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deskripsi',
                    style: primaryTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    myProduct.description,
                    style: subtitleTextStyle.copyWith(
                      fontWeight: light,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            // NOTE: FAMILIAR SHOES
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: defaultMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultMargin,
                    ),
                    child: Text(
                      'Produk Terkait',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: Provider.of<ProductProvider>(context)
                          .getRelatedProducts(myProduct.category!.name)
                          .map((product_) {
                        index++;
                        return Container(
                          margin: EdgeInsets.only(
                              left: index == 0 ? defaultMargin : 0),
                          child: familiarShoesCard(product_),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),

            // NOTE: BUTTONS
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(defaultMargin),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (authProvider.user.role.contains("USER")) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailChatPage(
                              product: myProduct,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: alertColor,
                            content: Text(
                              'Fitur tidak tersedia untuk admin!',
                              textAlign: TextAlign.center,
                              style: whiteTextStyle,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: primaryColor, width: 1)),
                      child: Center(
                        child: Icon(
                          Icons.chat,
                          size: 24,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          if (myProduct.variations == null ||
                              myProduct.variations!.keys.isEmpty) {
                            cartProvider.addCart(myProduct, [], "");
                            showDialog(
                              context: context,
                              builder: (_) => const SuccessAddToCartModal(),
                            );
                          } else {
                            showModalBottomSheet<void>(
                              context: context,
                              transitionAnimationController: _controller,
                              builder: (BuildContext context) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 1.0),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: _controller,
                                    curve: Curves.easeInOut,
                                  )),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: backgroundColor2,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(32),
                                        topLeft: Radius.circular(32),
                                      ),
                                    ),
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: subtitleColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: variationSelection(
                                            variations: myProduct.variations,
                                            product: myProduct,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          setState(() {
                            isLoading = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: primaryColor,
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                whiteColor,
                              ))
                            : Text(
                                'Tambah ke Keranjang',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: semiBold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      body: isLoadingProduct
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
            ))
          : myProduct is NotFoundProductModel
              ? Column(children: [
                  backAndCart(),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Produk Tidak Tersedia!",
                        style: primaryTextStyle.copyWith(fontSize: 16),
                      ),
                    ),
                  )
                ])
              : ListView(
                  children: [
                    header(),
                    content(),
                  ],
                ),
    );
  }
}
