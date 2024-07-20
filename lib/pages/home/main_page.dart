import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/pages/menus/chat_page.dart';
import 'package:frontend/pages/menus/home_page.dart';
import 'package:frontend/pages/menus/profile_page.dart';
import 'package:frontend/pages/order_page.dart';
import 'package:frontend/providers/page_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    Widget body() {
      switch (pageProvider.currentIndex) {
        case 0:
          return const HomePage();
        case 1:
          return const ChatPage();
        case 2:
          return const OrderPage();
        case 3:
          return const ProfilePage();
        default:
          return const HomePage();
      }
    }

    Widget cartButton() {
      return FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, "/cart");
        },
        shape: const CircleBorder(),
        child: Image.asset(
          "assets/icon_cart.png",
          width: 20,
        ),
      );
    }

    Widget bottomNavItem(String icon, int index,
        {double width = 20, Icon? icons}) {
      return IconButton(
        iconSize: 32.0,
        icon: icons ??
            Image.asset(
              "assets/$icon",
              width: width,
              color: pageProvider.currentIndex == index
                  ? primaryColor
                  : const Color(0xff808191),
            ),
        onPressed: () {
          pageProvider.currentIndex = index;
        },
      );
    }

    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomAppBar(
          padding: EdgeInsets.zero,
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          clipBehavior: Clip.antiAlias,
          color: transparentColor,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin / 2),
            color: backgroundColor2,
            height: 75,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                bottomNavItem("icon_home.png", 0),
                bottomNavItem("icon_chat.png", 1),
                bottomNavItem(
                  "icon_wishlist.png",
                  2,
                  icons: const Icon(
                    Icons.list_rounded,
                    size: 20,
                  ),
                ),
                bottomNavItem("icon_profile.png", 3),
              ],
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 1)) {
          lastPressed = now;
          Fluttertoast.showToast(
            msg: "Tekan sekali lagi untuk keluar",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor1,
        floatingActionButton: cartButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: customBottomNav(),
        extendBody: true,
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation, secondaryAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: body(),
        ),
      ),
    );
  }
}
