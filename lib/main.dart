import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/cart_page.dart';
import 'package:frontend/pages/checkout_page.dart';
import 'package:frontend/pages/edit_profile_page.dart';
import 'package:frontend/pages/home/main_page.dart';
import 'package:frontend/pages/result_checkout_page.dart';
import 'package:frontend/pages/sign_in_page.dart';
import 'package:frontend/pages/sign_up2_page.dart';
import 'package:frontend/pages/sign_up_page.dart';
import 'package:frontend/pages/splash_page.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/providers/page_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/transaction_provider.dart';
import 'package:frontend/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    appId: '1:223721923641:android:970543ab146baeb420d9e8',
    apiKey: 'apiKey',
    messagingSenderId: '223721923641',
    projectId: 'tokowindatenun',
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/sign-in': (context) => const SignInPage(),
          '/sign-up': (context) => const SignUpPage(),
          '/sign-up2': (context) => const SignUp2Page(),
          '/home': (context) => const MainPage(),
          '/cart': (context) => const CartPage(),
          '/checkout': (context) => const CheckoutPage(),
          '/checkout-result': (context) => const ResultCheckoutPage(),
          '/edit-profile': (context) => const EditProfilePage(),
        },
      ),
    );
  }
}
