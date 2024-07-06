import 'package:flutter/material.dart';
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

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'fixri2104@gmail.com',
      queryParameters: {
        'subject': 'Bantuan Pemakaian Aplikasi Toko Winda Tenun',
        'body':
            'Halo, aku memiliki pertanyaan seputar aplikasi Toko Winda Tenun. Pertanyaanku adalah : '
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print('Could not launch $emailUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    Widget header() {
      return AppBar(
        centerTitle: false,
        toolbarHeight: 100,
        backgroundColor: backgroundColor2,
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.only(
              left: defaultMargin / 1.5,
              right: defaultMargin / 1.5,
              top: defaultMargin / 1.5,
              bottom: defaultMargin / 1.5),
          child: Row(
            children: [
              ClipOval(
                child: Image.network(
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
                      style: primaryTextStyle.copyWith(
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
                      valueColor: AlwaysStoppedAnimation(
                      subtitleColor,
                    ))
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

      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: defaultMargin),
        padding: EdgeInsets.all(defaultMargin / 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Akun",
              style:
                  primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 18),
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
              onTap: () {},
              child: itemMenu("Daftar Pesanan"),
            ),
            GestureDetector(onTap: _sendEmail, child: itemMenu("Bantuan")),
            SizedBox(
              height: defaultMargin,
            ),
            Text(
              "Lainnya",
              style:
                  primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            itemMenu("Ketentuan & Kebijakan"),
            itemMenu("Beri Nilai Aplikasi"),
          ],
        ),
      );
    }

    return Column(
      children: [
        header(),
        profileMenu(),
      ],
    );
  }
}
