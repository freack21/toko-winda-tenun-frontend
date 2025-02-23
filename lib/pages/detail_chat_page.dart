// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/components/chat_bubble.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class DetailChatPage extends StatefulWidget {
  ProductModel product;
  final int? user_id;
  final String? user_name;
  final String? user_avatar;
  DetailChatPage({
    super.key,
    required this.product,
    this.user_id,
    this.user_name,
    this.user_avatar,
  });

  @override
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController(text: '');
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getTimeAgo(DateTime createdAt) {
    DateTime now = DateTime.now();
    DateTime createdDateTime = createdAt;
    Duration difference = now.difference(createdDateTime);

    if (difference.inHours < 24) {
      return 'Hari Ini';
    } else if (difference.inHours < 48) {
      return 'Kemarin';
    } else {
      return DateFormat('dd MMM yyyy').format(createdDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;

    void scrollToBottom() {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }

    Future<void> handleSendImage() async {
      try {
        final XFile? imageFile =
            await _picker.pickImage(source: ImageSource.gallery);

        if (imageFile == null) return; // User batal memilih gambar

        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation(
                    whiteColor,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                DefaultTextStyle(
                  style: whiteTextStyle.copyWith(
                    fontSize: 14,
                  ),
                  child: const Text(
                    "Mohon tidak menutup halaman ini",
                  ),
                ),
              ],
            ),
          ),
        );

        final dio = Dio();
        final formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(imageFile.path),
        });

        final response = await dio.post(
          '$apiBaseUrl/save-image',
          data: formData,
          options: Options(persistentConnection: false),
        );

        if (!context.mounted) return;
        Navigator.pop(context);

        if (response.statusCode == 200) {
          var data = response.data;
          final imageUrl = '${dotenv.env["BASE_URL"]}${data["url"]}';

          firestore.collection('messages').add({
            'user_id': widget.user_id ?? user.id,
            'user_name': widget.user_name ?? user.name,
            'user_avatar': widget.user_avatar ?? user.avatar,
            'user_role': user.role,
            'has_read': false,
            'image_url': imageUrl,
            'product': widget.product is UninitializedProductModel
                ? {}
                : widget.product.toJson(),
            'created_at': DateTime.now().toString(),
            'updated_at': DateTime.now().toString(),
          });
        } else {
          throw Exception('Gagal mengunggah gambar');
        }
      } catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context);

        if (kDebugMode) {
          print('Error saat mengirim gambar: $e');
        }

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: alertColor,
            content: Text(
              "Gambar gagal diunggah! Mohon periksa koneksi internet anda.",
              textAlign: TextAlign.center,
              style: whiteTextStyle,
            ),
          ),
        );
      }
      setState(() {
        widget.product = UninitializedProductModel();
        messageController.text = '';
      });

      scrollToBottom();
    }

    handleAddMessage() async {
      if (messageController.text.isEmpty) return;

      try {
        firestore.collection('messages').add({
          'user_id': widget.user_id ?? user.id,
          'user_name': widget.user_name ?? user.name,
          'user_avatar': widget.user_avatar ?? user.avatar,
          'user_role': user.role,
          'has_read': false,
          'text': messageController.text,
          'product': widget.product is UninitializedProductModel
              ? {}
              : widget.product.toJson(),
          'created_at': DateTime.now().toString(),
          'updated_at': DateTime.now().toString(),
        });
      } catch (e) {
        if (kDebugMode) {
          print('Pesan Gagal Dikirim!');
          print(e);
        }
      }

      setState(() {
        widget.product = UninitializedProductModel();
        messageController.text = '';
      });

      scrollToBottom();
    }

    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: transparentColor,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
        scrolledUnderElevation: 0.0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: backgroundColor2,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(
            top: defaultMargin + 10,
            left: 20,
            right: 20,
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 24,
                    color: primaryColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: widget.user_avatar != null
                        ? cachedNetworkImageProvider(
                            imageUrl(widget.user_avatar),
                          )
                        : const AssetImage("assets/logo_twt_chat.jpg"),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.user_name ?? "Toko Winda Tenun",
                    style: primaryTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        toolbarHeight: 72,
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
              child: cachedNetworkImage(
                imageUrl(widget.product.galleries![0]!.url),
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
                    widget.product.name,
                    style: primaryTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    formatRupiah(widget.product.price),
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
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.product = UninitializedProductModel();
                  });
                },
                child: Center(
                  child: Text(
                    "✕",
                    style:
                        whiteTextStyle.copyWith(fontSize: 10, fontWeight: bold),
                  ),
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
          widget.product is UninitializedProductModel
              ? const SizedBox()
              : Container(
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
                  ),
                ),
          Container(
            padding: const EdgeInsets.only(
              bottom: 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            decoration: BoxDecoration(
              color: backgroundColor2,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                      minHeight: 45,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: inputColor,
                      border: Border.all(
                        color: primaryColor,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: messageController,
                        style: blackTextStyle,
                        maxLines: null,
                        minLines: 1,
                        decoration: InputDecoration.collapsed(
                          hintText: "Ketik pesan..",
                          hintStyle: subtitleTextStyle,
                        ),
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        cursorColor: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: handleSendImage,
                  child: Container(
                    width: 45,
                    height: 45,
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: primaryColor,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: handleAddMessage,
                  child: Container(
                    width: 45,
                    height: 45,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/icon_submit.png",
                        color: whiteColor,
                        width: 18,
                        height: 18,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ))
        ],
      );
    }

    Widget body() {
      return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('messages')
            .where('user_id', isEqualTo: widget.user_id ?? user.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
              subtitleColor,
            )));
          }

          var chatDocuments = snapshot.data!.docs;

          chatDocuments.sort((a, b) {
            return (DateTime.parse(a['created_at']))
                .compareTo(DateTime.parse(b['created_at']));
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollToBottom();
          });

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            itemCount: chatDocuments.length,
            itemBuilder: (context, index) {
              DateTime currentCreatedAt =
                  DateTime.parse(chatDocuments[index]['created_at']);
              DateTime? previousCreatedAt;

              // Parse the previous message's timestamp (if there is one)
              if (index > 0) {
                previousCreatedAt =
                    DateTime.parse(chatDocuments[index - 1]['created_at']);
              }

              // Determine if we need to show the time label
              bool showTimeLabel = previousCreatedAt == null ||
                  _getTimeAgo(currentCreatedAt) !=
                      _getTimeAgo(previousCreatedAt);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showTimeLabel)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 12,
                          top: 8,
                        ),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(0, 1),
                              blurStyle: BlurStyle.inner,
                            ),
                          ],
                        ),
                        child: Text(
                          _getTimeAgo(currentCreatedAt),
                          style: primaryTextStyle.copyWith(
                            fontWeight: medium,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ChatBubble(
                    chatDocument: chatDocuments[index],
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: inputColor,
      appBar: header(),
      bottomNavigationBar: chatInput(),
      body: body(),
    );
  }
}
