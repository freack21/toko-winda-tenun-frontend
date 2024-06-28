import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class productCard extends StatelessWidget {
  const productCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/product-detail");
      },
      child: Container(
        width: 215,
        height: 278,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: backgroundColor2, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              "assets/image_shoes.png",
              width: 215,
              height: 130,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hiking",
                    style: secondaryTextStyle.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "COURT VISION 2.0",
                    style: blackTextStyle.copyWith(
                        fontSize: 18, fontWeight: semiBold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "\$58,67",
                    style: priceTextStyle.copyWith(fontWeight: medium),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class productTile extends StatelessWidget {
  const productTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/product-detail");
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: defaultMargin / 1.5,
            left: defaultMargin,
            right: defaultMargin),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            shape: BoxShape.rectangle,
            color: secondaryColor),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/image_shoes.png",
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Football",
                    style: secondaryTextStyle.copyWith(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Predator 20.3 Fire Ground",
                    style: primaryTextStyle.copyWith(
                        fontWeight: semiBold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "\$64,47",
                    style: priceTextStyle.copyWith(fontWeight: medium),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class chatTile extends StatelessWidget {
  const chatTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/chat");
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: defaultMargin / 2,
            left: defaultMargin,
            right: defaultMargin),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            shape: BoxShape.rectangle,
            color: secondaryColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset("assets/image_shop_logo.png"),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Toko Winda Tenun",
                        style: primaryTextStyle.copyWith(
                            fontWeight: medium, fontSize: 15),
                      ),
                      Text(
                        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Dignissimos harum magni fuga eum architecto atque nesciunt ut nihil. Rem, veritatis!",
                        style: subtitleTextStyle.copyWith(
                            fontWeight: light, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "Baru saja",
                  style: subtitleTextStyle.copyWith(fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class cartTile extends StatelessWidget {
  const cartTile({super.key});

  @override
  Widget build(BuildContext context) {
    Widget button(String text, Color color) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Center(
          child: Text(
            text,
            style: whiteTextStyle.copyWith(fontSize: 16),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(
          bottom: defaultMargin / 2, left: defaultMargin, right: defaultMargin),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: secondaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/image_shoes.png",
                  width: 64,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lorem ipsum dolor sit amet",
                      style: primaryTextStyle.copyWith(
                          fontWeight: medium, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "\$120,90",
                      style: priceTextStyle,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  button("+", primaryColor),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "1",
                    style: primaryTextStyle.copyWith(fontWeight: semiBold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  button("-", subtitleColor),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(children: [
              Image.asset(
                "assets/icon_remove.png",
                width: 10,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "Hapus",
                style:
                    primaryTextStyle.copyWith(color: Colors.red, fontSize: 13),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class itemTile extends StatelessWidget {
  const itemTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: secondaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/image_shoes.png",
                  width: 64,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lorem ipsum dolor sit amet",
                      style: primaryTextStyle.copyWith(
                          fontWeight: medium, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "\$120,90",
                      style: priceTextStyle,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  Text(
                    "1 item",
                    style: subtitleTextStyle.copyWith(fontSize: 13),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget addresItemTile(IconData icon, String? title, String? data) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: primaryColor),
          child: Center(
            child: Icon(
              icon,
              color: whiteColor,
              size: 20,
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title!, style: subtitleTextStyle),
              const SizedBox(
                height: 2,
              ),
              Text(data!,
                  style: primaryTextStyle.copyWith(
                      fontWeight: medium, fontSize: 15)),
            ],
          ),
        )
      ],
    ),
  );
}

class favTile extends StatelessWidget {
  const favTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: defaultMargin / 2, left: defaultMargin, right: defaultMargin),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          shape: BoxShape.rectangle,
          color: secondaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset("assets/image_shoes.png", width: 64),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lorem ipsum dolor sit amet",
                      style: primaryTextStyle.copyWith(
                          fontWeight: medium, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "\$69,11",
                      style: priceTextStyle.copyWith(fontWeight: semiBold),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                width: 32,
                height: 32,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                child: Icon(
                  Icons.favorite_rounded,
                  color: whiteColor,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
