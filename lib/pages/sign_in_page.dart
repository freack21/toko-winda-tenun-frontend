import 'package:flutter/material.dart';
import 'package:frontend/components/form_component.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/page_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    pageProvider.currentIndex = 0;

    handleSignIn() async {
      setState(() {
        isLoading = true;
      });

      if (await authProvider.login(
        email: emailController.text,
        password: passwordController.text,
      )) {
        if (!context.mounted) return;
        Navigator.popUntil(context, ModalRoute.withName('/'));
        Navigator.pushNamed(context, '/home');
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: alertColor,
            content: Text(
              'Gagal Login!',
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
            "Login",
            style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: bold),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            "Masuk Untuk Melanjutkan",
            style:
                subtitleTextStyle.copyWith(fontSize: 14, fontWeight: regular),
          ),
        ],
      );
    }

    Widget footer() {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Belum punya akun? ",
            style: subtitleTextStyle.copyWith(
              fontSize: 13,
            )),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/sign-up');
          },
          child: Text(
            "Daftar",
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
                      placeholder: "Email Kamu",
                      icon: "email_icon.png",
                      icond: Icons.email_rounded,
                      inputType: TextInputType.emailAddress,
                      marginTop: 70,
                      controller: emailController,
                    ),
                    inputField(
                      label: "Password",
                      placeholder: "Password Kamu",
                      icon: "icon_password.png",
                      icond: Icons.lock_rounded,
                      isPassword: true,
                      controller: passwordController,
                    ),
                  ],
                ),
              ),
              isLoading
                  ? const LoadingButton()
                  : fullButton("Masuk", handleSignIn, key: _formKey),
              const Spacer(),
              footer()
            ],
          ),
        ),
      ),
    );
  }
}
