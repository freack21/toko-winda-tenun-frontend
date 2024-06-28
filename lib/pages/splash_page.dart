import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() async {
    super.initState();

    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    if (await authProvider.check(
      token: user.token,
    )) {
      if (!context.mounted) Navigator.popAndPushNamed(context, '/home');
    } else {
      if (!context.mounted) Navigator.popAndPushNamed(context, '/sign-in');
    }
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
