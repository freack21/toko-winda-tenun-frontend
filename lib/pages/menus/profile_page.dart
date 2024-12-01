import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'fixri2104@gmail.com',
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Bantuan Pemakaian Aplikasi Toko Winda Tenun',
        'body':
            'Halo, aku memiliki pertanyaan seputar aplikasi Toko Winda Tenun. Pertanyaanku adalah : '
      }),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchInBrowser() async {
    if (!await launchUrl(
      Uri.parse(
          "https://play.google.com/store/apps/details?id=com.tokowindatenun.frontend"),
      mode: LaunchMode.externalApplication,
    )) {
      if (kDebugMode) {
        print('Could not launch play google');
      }
    }
  }

  void _launchInBrowserPrivacyPolicy() async {
    if (!await launchUrl(
      Uri.parse("${dotenv.env['BASE_URL']}/privacy.html"),
      mode: LaunchMode.externalApplication,
    )) {
      if (kDebugMode) {
        print('Could not launch chrome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    Widget header() {
      return AppBar(
        centerTitle: false,
        toolbarHeight: 120,
        backgroundColor: transparentColor,
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.only(
            left: defaultMargin / 2,
            right: defaultMargin / 2,
            top: defaultMargin / 1.5,
            bottom: defaultMargin / 2,
          ),
          child: Row(
            children: [
              ClipOval(
                child: cachedNetworkImage(
                  user.avatar,
                  width: 54,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Halo, ${user.name.split(" ")[0]}!",
                      style: whiteTextStyle.copyWith(
                          fontWeight: semiBold, fontSize: 20),
                    ),
                    Text(
                      "@${user.username}",
                      style: subtitleTextStyle.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              isLoading
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        whiteColor,
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });

                        if (await authProvider.logout(token: user.token)) {
                          setState(() {
                            isLoading = false;
                          });

                          if (!context.mounted) return;
                          Navigator.popUntil(context, ModalRoute.withName("/"));
                          Navigator.pushNamed(context, "/sign-in");
                        }
                      },
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                        size: 24,
                      ),
                    )
            ],
          ),
        ),
      );
    }

    Widget profileMenu() {
      Widget itemMenu(String text) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                text,
                style: secondaryTextStyle,
              )),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: secondaryTextColor,
              )
            ],
          ),
        );
      }

      return Expanded(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(defaultMargin),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: backgroundColor2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Akun",
                style: primaryTextStyle.copyWith(
                    fontWeight: semiBold, fontSize: 18),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/edit-profile");
                },
                child: itemMenu("Edit Profil"),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/wishlist");
                },
                child: itemMenu("Wishlist Saya"),
              ),
              GestureDetector(onTap: _sendEmail, child: itemMenu("Bantuan")),
              SizedBox(
                height: defaultMargin,
              ),
              Text(
                "Lainnya",
                style: primaryTextStyle.copyWith(
                    fontWeight: semiBold, fontSize: 18),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: _launchInBrowserPrivacyPolicy,
                // onTap: () {
                //   Navigator.pushNamed(context, "/privacy-policy");
                // },
                child: itemMenu("Ketentuan & Kebijakan"),
              ),
              GestureDetector(
                  onTap: _launchInBrowser,
                  child: itemMenu("Beri Nilai Aplikasi")),
            ],
          ),
        ),
      );
    }

    return Container(
      color: priceColor,
      child: Column(
        children: [
          header(),
          profileMenu(),
        ],
      ),
    );
  }
}
