import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/theme.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Message Support",
          style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium),
        ),
        backgroundColor: backgroundColor2,
        centerTitle: true,
        toolbarHeight: 64,
      );
    }

    Widget noChat() {
      return Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                shape: BoxShape.rectangle,
                color: secondaryColor),
            child: Column(
              children: [
                Image.asset(
                  "assets/icon_headset.png",
                  width: 80,
                  color: primaryColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Ups! Belum ada chat nih..",
                  style: primaryTextStyle.copyWith(
                      fontSize: 16, fontWeight: medium),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Kamu belum pernah melakukan transaksi",
                  style: secondaryTextStyle,
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: primaryColor),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Jelajahi Toko",
                      style: whiteTextStyle.copyWith(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ));
    }

    Widget listChat() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: defaultMargin / 2,
          ),
          chatTile(),
        ],
      );
    }

    return Column(
      children: [header(), listChat()],
    );
  }
}
