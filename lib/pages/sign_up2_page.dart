import 'package:flutter/material.dart';
import 'package:frontend/components/form_component.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/providers/order_provider.dart';
import 'package:frontend/providers/page_provider.dart';
import 'package:frontend/providers/wishlist_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class SignUp2Page extends StatefulWidget {
  const SignUp2Page({super.key});

  @override
  State<SignUp2Page> createState() => _SignUp2PageState();
}

class _SignUp2PageState extends State<SignUp2Page> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleSignUp() async {
      setState(() {
        isLoading = true;
      });

      List resReg = await authProvider.register(
        name: arguments['name'],
        username: arguments['username'],
        phone: arguments['phone'],
        email: emailController.text,
        password: passwordController.text,
      );
      if (resReg[0]) {
        if (!context.mounted) return;
        CartProvider cartProvider =
            Provider.of<CartProvider>(context, listen: false);
        cartProvider.userId = authProvider.user.id;

        if (!context.mounted) return;
        WishlistProvider wishlistProvider =
            Provider.of<WishlistProvider>(context, listen: false);
        wishlistProvider.userId = authProvider.user.id;

        if (!context.mounted) return;
        OrderProvider orderProvider =
            Provider.of<OrderProvider>(context, listen: false);
        orderProvider.userId = authProvider.user.id;
        await orderProvider.getOrders(authProvider.user.token);

        if (!context.mounted) return;
        PageProvider pageProvider =
            Provider.of<PageProvider>(context, listen: false);
        pageProvider.currentIndex = 0;
        Navigator.popUntil(context, ModalRoute.withName('/'));
        Navigator.pushNamed(context, '/home');
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: alertColor,
            content: Text(
              'Gagal Register!\n${resReg[1]}',
              textAlign: TextAlign.center,
              style: whiteTextStyle,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }

    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daftar",
            style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: bold),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            "Daftar dan Selamat Belanja",
            style:
                subtitleTextStyle.copyWith(fontSize: 14, fontWeight: regular),
          ),
        ],
      );
    }

    Widget footer() {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Sudah memiliki akun? ",
            style: subtitleTextStyle.copyWith(
              fontSize: 13,
            )),
        GestureDetector(
          onTap: () {
            Navigator.popAndPushNamed(context, '/sign-in');
          },
          child: Text(
            "Login",
            style: purpleTextStyle.copyWith(fontSize: 13, fontWeight: medium),
          ),
        )
      ]);
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: defaultMargin, vertical: defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    inputField(
                        label: "Email",
                        placeholder: "johndoe@email.com",
                        icon: "email_icon.png",
                        icond: Icons.email_rounded,
                        inputType: TextInputType.emailAddress,
                        marginTop: 50,
                        controller: emailController),
                    inputField(
                        label: "Password",
                        placeholder: "******",
                        icon: "icon_password.png",
                        icond: Icons.lock_rounded,
                        isPassword: true,
                        controller: passwordController),
                    isLoading
                        ? const LoadingButton()
                        : fullButton("Daftar", handleSignUp, key: _formKey),
                  ],
                ),
              ),
              const Spacer(),
              footer()
            ],
          ),
        ),
      ),
    );
  }
}
