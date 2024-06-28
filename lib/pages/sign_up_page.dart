import 'package:flutter/material.dart';
import 'package:frontend/components/form_component.dart';
import 'package:frontend/theme.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController phoneController = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
            Navigator.pop(context);
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
                        label: "Nama Lengkap",
                        placeholder: "Nama Lengkap Kamu",
                        icon: "icon_name.png",
                        icond: Icons.person_rounded,
                        marginTop: 50,
                        controller: nameController),
                    inputField(
                        label: "Username",
                        placeholder: "Username Kamu",
                        icon: "icon_username.png",
                        icond: Icons.alternate_email_rounded,
                        controller: usernameController),
                    inputField(
                        label: "Nomor Telepon",
                        placeholder: "Nomor Telepon Anda",
                        icon: "icon_headset.png",
                        icond: Icons.phone_rounded,
                        inputType: TextInputType.number,
                        controller: phoneController),
                  ],
                ),
              ),
              fullButton("Selanjutnya", () {
                Navigator.pushNamed(context, "/sign-up2", arguments: {
                  'name': nameController.text,
                  'username': usernameController.text,
                  'phone': phoneController.text,
                });
              }, key: _formKey),
              const Spacer(),
              footer(),
            ],
          ),
        ),
      ),
    );
  }
}
