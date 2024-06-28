import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final bool hasProduct;

  const ChatBubble(
      {super.key,
      this.text = '',
      this.isSender = false,
      this.hasProduct = false});

  @override
  Widget build(BuildContext context) {
    Widget productPreview() {
      return Container(
        width: 230,
        margin: EdgeInsets.only(bottom: defaultMargin / 2.5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isSender ? whiteColor : primaryColor,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/image_shoes.png",
                      width: 70,
                    )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lorem ipsum dolor sit",
                        style: (isSender ? primaryTextStyle : whiteTextStyle)
                            .copyWith(fontSize: 15, fontWeight: medium),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "\$57,15",
                        style:
                            (isSender ? secondaryTextStyle : subtitleTextStyle)
                                .copyWith(fontWeight: semiBold),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    side:
                        BorderSide(color: isSender ? primaryColor : whiteColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text(
                  "Tambah ke Keranjang",
                  style: (isSender ? primaryTextStyle : whiteTextStyle),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: isSender ? primaryColor : whiteColor),
                child: Text(
                  "Beli Sekarang",
                  style: (isSender ? whiteTextStyle : primaryTextStyle)
                      .copyWith(fontSize: 15),
                ),
              ),
            )
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: defaultMargin / 1.5),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          hasProduct ? productPreview() : const SizedBox(),
          Row(
            mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .7),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                      color: isSender ? whiteColor : primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: Radius.circular((isSender ? 0 : 12)),
                        bottomLeft: Radius.circular((!isSender ? 0 : 12)),
                        bottomRight: const Radius.circular(12),
                      )),
                  child: Text(
                    text,
                    style: isSender ? primaryTextStyle : whiteTextStyle,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
