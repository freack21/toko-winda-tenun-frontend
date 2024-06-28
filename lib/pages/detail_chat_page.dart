import 'package:flutter/material.dart';
import 'package:frontend/components/chat_bubble.dart';
import 'package:frontend/theme.dart';

class DetailChatPage extends StatelessWidget {
  const DetailChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: backgroundColor2,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
        scrolledUnderElevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/image_shop_logo.png"),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Toko Winda Tenun",
                  style: primaryTextStyle.copyWith(
                      fontWeight: medium, fontSize: 16),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Online",
                  style: subtitleTextStyle.copyWith(
                      fontWeight: light, fontSize: 14),
                )
              ],
            )
          ],
        ),
        toolbarHeight: 75,
      );
    }

    Widget productPreview() {
      return Container(
        width: 225,
        height: 75,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: backgroundColor2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: subtitleColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/image_shoes.png",
                width: 54,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Lorem, ipsum dolor.",
                    style: primaryTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "\$57,15",
                    style: priceTextStyle.copyWith(fontWeight: semiBold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Container(
              width: 22,
              height: 22,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: primaryColor),
              child: Center(
                child: Text(
                  "✕",
                  style:
                      whiteTextStyle.copyWith(fontSize: 10, fontWeight: bold),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget chatInput() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(color: whiteColor),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    productPreview(),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              )),
          Container(
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.all(color: subtitleColor),
                      color: backgroundColor2,
                    ),
                    child: Center(
                      child: TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Ketik pesan..",
                          hintStyle: subtitleTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 45,
                  height: 45,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Image.asset(
                    "assets/icon_submit.png",
                    color: whiteColor,
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }

    Widget body() {
      return ListView(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        children: const [
          ChatBubble(
            text: "Apa barangnya masih tersedia?",
            isSender: true,
          ),
          ChatBubble(
            text:
                "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Officia ipsam repellendus nostrum mollitia laboriosam, aperiam perspiciatis corrupti doloribus expedita architecto.",
            isSender: false,
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      bottomNavigationBar: chatInput(),
      body: body(),
    );
  }
}
