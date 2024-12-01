import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/pages/cart_page.dart';
import 'package:frontend/pages/checkout_page.dart';
import 'package:frontend/pages/edit_profile_page.dart';
import 'package:frontend/pages/home/main_page.dart';
import 'package:frontend/pages/menus/wishlist_page.dart';
import 'package:frontend/pages/order_page.dart';
import 'package:frontend/pages/privacy_policy_page.dart';
import 'package:frontend/pages/result_checkout_page.dart';
import 'package:frontend/pages/sign_in_page.dart';
import 'package:frontend/pages/sign_up2_page.dart';
import 'package:frontend/pages/sign_up_page.dart';
import 'package:frontend/pages/splash_page.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/providers/order_provider.dart';
import 'package:frontend/providers/page_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/transaction_provider.dart';
import 'package:frontend/providers/wishlist_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    appId: dotenv.env["FSTORE_APP_ID"] ?? "-",
    apiKey: dotenv.env["FSTORE_API_KEY"] ?? "-",
    messagingSenderId: dotenv.env["FSTORE_SENDER_ID"] ?? "-",
    projectId: dotenv.env["FSTORE_PROJECT_ID"] ?? "-",
  ));
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> routes = {
      '/': const SplashPage(),
      '/sign-in': const SignInPage(),
      '/sign-up': const SignUpPage(),
      '/sign-up2': const SignUp2Page(),
      '/home': const MainPage(),
      '/cart': const CartPage(),
      '/order': const OrderPage(),
      '/wishlist': const WishlistPage(),
      '/checkout': const CheckoutPage(),
      '/checkout-result': const ResultCheckoutPage(),
      '/edit-profile': const EditProfilePage(),
      '/privacy-policy': const PrivacyPolicyPage(),
    };

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
          create: (context) => OrderProvider(),
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
        onGenerateRoute: (settings) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => routes[settings.name],
            transitionsBuilder: (_, animation, __, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 750),
          );
        },
      ),
    );
  }
}
