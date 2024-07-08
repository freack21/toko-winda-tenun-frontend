import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class SuccessAddToCartModal extends StatefulWidget {
  const SuccessAddToCartModal({super.key});

  @override
  State<StatefulWidget> createState() => SuccessAddToCartModalState();
}

class SuccessAddToCartModalState extends State<SuccessAddToCartModal>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AlertDialog(
          backgroundColor: backgroundColor3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 100,
                  color: primaryColor,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Horee :)',
                  style: primaryTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Produk berhasil ditambahkan!',
                  style: secondaryTextStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 154,
                  height: 44,
                  child: TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/cart');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Lihat Keranjang',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
