import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

double defaultMargin = 30.0;

Color primaryColor = const Color(0xff3E6B6B);
Color secondaryColor = const Color(0xffffffff);
Color alertColor = const Color(0xffED6363);
Color priceColor = const Color(0xff3E6B6B);
Color backgroundColor1 = const Color(0xfff5efef);
Color backgroundColor2 = const Color(0xffffffff);
Color backgroundColor3 = const Color(0xffffffff);
Color backgroundColor4 = const Color(0xffffffff);
Color backgroundColor5 = const Color(0xffffffff);
Color backgroundColor6 = const Color(0xffffffff);
Color backgroundColor7 = const Color(0xfff5f5f5);
Color primaryTextColor = const Color(0xff3E6B6B);
Color secondaryTextColor = const Color(0xff739394);
Color subtitleColor = const Color(0xffA7BBBC);
Color transparentColor = Colors.transparent;
Color blackColor = const Color(0xff2E2E2E);
Color whiteColor = const Color(0xffffffff);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

TextStyle primaryTextStyle = GoogleFonts.poppins(
  color: primaryTextColor,
);

TextStyle secondaryTextStyle = GoogleFonts.poppins(
  color: secondaryTextColor,
);

TextStyle subtitleTextStyle = GoogleFonts.poppins(
  color: subtitleColor,
);

TextStyle priceTextStyle = GoogleFonts.poppins(color: priceColor);

TextStyle purpleTextStyle = GoogleFonts.poppins(
  color: primaryColor,
);

TextStyle blackTextStyle = GoogleFonts.poppins(
  color: blackColor,
);

TextStyle whiteTextStyle = GoogleFonts.poppins(
  color: whiteColor,
);

TextStyle alertTextStyle = GoogleFonts.poppins(
  color: alertColor,
);

String capitalizeFirstLowerRest(String str) {
  if (str.isEmpty) return str;
  return str[0] + str.substring(1).toLowerCase();
}

String imageUrl(String? url) {
  if (url!.contains("://")) return url;
  return "https://songket.beetcodestudio.com/storage/$url";
}

String formatRupiah(double amount) {
  final NumberFormat formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  return formatter.format(amount);
}
