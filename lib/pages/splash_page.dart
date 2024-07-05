import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/wishlist_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });

    super.initState();
  }

  Future<void> _checkAuth() async {
    Timer(const Duration(seconds: 0), () async {
      try {
        ProductProvider productProvider =
            Provider.of<ProductProvider>(context, listen: false);
        await productProvider.getProducts();

        if (!mounted) return;
        CartProvider cartProvider =
            Provider.of<CartProvider>(context, listen: false);
        await cartProvider.loadCartFromPrefs();

        if (!mounted) return;
        WishlistProvider wishlistProvider =
            Provider.of<WishlistProvider>(context, listen: false);
        await wishlistProvider.loadWishlistFromPrefs();

        if (!mounted) return;
        AuthProvider authProvider =
            Provider.of<AuthProvider>(context, listen: false);
        UserModel user = await authProvider.userAwait;

        if (await authProvider.check(token: user.token)) {
          if (!mounted) return;
          Navigator.popAndPushNamed(context, '/home');
          return;
        }
      } catch (e) {
        print(e);
      }

      if (!mounted) return;
      Navigator.popAndPushNamed(context, '/sign-in');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor1,
        body: Center(
            child: Image.asset(
          "assets/image_splash.png",
          color: primaryColor,
          width: 150,
        )));
  }
}
