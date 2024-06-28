import 'package:flutter/material.dart';
import 'package:frontend/pages/menus/chat_page.dart';
import 'package:frontend/pages/menus/home_page.dart';
import 'package:frontend/pages/menus/profile_page.dart';
import 'package:frontend/pages/menus/wishlist_page.dart';
import 'package:frontend/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  Widget body() {
    switch (currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const ChatPage();
      case 2:
        return const WishlistPage();
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

  Widget bottomNavItem(String icon, int index, {double width = 20}) {
    return IconButton(
      iconSize: 32.0,
      icon: Image.asset(
        "assets/$icon",
        width: width,
        color: currentIndex == index ? primaryColor : Color(0xff808191),
      ),
      onPressed: () {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  Widget customBottomNav() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
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
              bottomNavItem("icon_wishlist.png", 2),
              bottomNavItem("icon_profile.png", 3),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      floatingActionButton: cartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customBottomNav(),
      body: body(),
    );
  }
}
