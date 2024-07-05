import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class inputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final String icon;
  final TextInputType inputType;
  final bool isPassword;
  final double marginTop;
  final IconData? icond;
  final TextEditingController? controller;

  const inputField({
    super.key,
    this.label = "",
    this.placeholder = "",
    this.icon = "",
    this.inputType = TextInputType.text,
    this.isPassword = false,
    this.marginTop = 30,
    this.icond,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                color: backgroundColor2,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Row(
                children: [
                  icond == null
                      ? Image.asset(
                          "assets/$icon",
                          width: 17,
                          color: !icon.contains("email") ? primaryColor : null,
                        )
                      : Icon(
                          icond,
                          color: primaryColor,
                          size: 20,
                        ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: TextFormField(
                    style: primaryTextStyle,
                    obscureText: isPassword,
                    controller: controller,
                    keyboardType: inputType,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "${capitalizeFirstLowerRest(label)} tidak boleh kosong!";
                      } else if (label.toLowerCase().contains("email") &&
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                        return 'Harap masukkan email yang valid!';
                      } else if (label.toLowerCase().contains("username") &&
                          !RegExp(r'^[a-z_]+$').hasMatch(value)) {
                        return 'Nama pengguna harus huruf kecil, tidak ada spasi, dan simbol "_" dan angka!';
                      }
                      return null;
                    },
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: InputDecoration.collapsed(
                      hintText: placeholder,
                      hintStyle: subtitleTextStyle,
                    ),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget editProfileField(String label, String placeholder, BuildContext context,
    {TextInputType inputType = TextInputType.text,
    bool isPassword = false,
    double marginTop = 20,
    IconData? icond,
    TextEditingController? controller}) {
  return Container(
    margin: EdgeInsets.only(top: marginTop),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: primaryTextStyle.copyWith(fontSize: 15, fontWeight: medium),
        ),
        TextFormField(
          style: secondaryTextStyle.copyWith(fontSize: 14),
          obscureText: isPassword,
          keyboardType: inputType,
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: subtitleTextStyle.copyWith(fontSize: 14),
          ),
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        )
      ],
    ),
  );
}

Widget fullButton(String text, Function listener, {GlobalKey<FormState>? key}) {
  return Container(
    margin: const EdgeInsets.only(top: 30),
    width: double.infinity,
    height: 50,
    child: TextButton(
      onPressed: () {
        if (key != null && !key.currentState!.validate()) {
          return;
        }
        listener();
      },
      style: TextButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: whiteTextStyle.copyWith(
          fontSize: 16,
          fontWeight: medium,
        ),
      ),
    ),
  );
}

class LoadingButton extends StatelessWidget {
  const LoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  whiteColor,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'Loading',
              style: whiteTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
