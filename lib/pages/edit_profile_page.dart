import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/components/form_component.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isLoading = false;

  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController usernameController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    handleUpdateUser() async {
      if (nameController.text.isEmpty && usernameController.text.isEmpty) {
        if (!context.mounted) return;
        Navigator.pop(context);
        return;
      }

      setState(() {
        isLoading = true;
      });

      if (await authProvider.updateUser(
        name: nameController.text.isNotEmpty ? nameController.text : user.name,
        username: usernameController.text.isNotEmpty
            ? usernameController.text
            : user.username,
        token: user.token,
      )) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: primaryColor,
            content: Text(
              'Berhasil Edit Profile!',
              textAlign: TextAlign.center,
              style: whiteTextStyle,
            ),
          ),
        );
        nameController.text = "";
        usernameController.text = "";
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: alertColor,
            content: Text(
              'Gagal Edit Profile!',
              textAlign: TextAlign.center,
              style: whiteTextStyle,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }

    Widget header() {
      return Container(
        width: double.infinity,
        color: backgroundColor2,
        padding: EdgeInsets.only(
            top: defaultMargin * 1.25,
            left: defaultMargin / 2,
            right: defaultMargin / 2,
            bottom: defaultMargin / 2.75),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.red,
              ),
              iconSize: 24,
            ),
            Expanded(
              child: Text(
                "Edit Profil",
                style:
                    primaryTextStyle.copyWith(fontWeight: medium, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        subtitleColor,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: handleUpdateUser,
                    icon: Icon(
                      Icons.check_rounded,
                      color: primaryColor,
                    ),
                    iconSize: 24,
                  ),
          ],
        ),
      );
    }

    Widget avatar() {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(defaultMargin),
        child: Center(
          child: ClipOval(
            child: cachedNetworkImage(
              user.avatar,
              width: 120,
            ),
          ),
        ),
      );
    }

    Widget editFields() {
      return Container(
        padding: EdgeInsets.only(right: defaultMargin, left: defaultMargin),
        child: Column(
          children: [
            editProfileField("Nama Lengkap", user.name, context,
                controller: nameController),
            editProfileField("Username", user.username, context,
                controller: usernameController),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          header(),
          avatar(),
          editFields(),
        ],
      ),
    );
  }
}
