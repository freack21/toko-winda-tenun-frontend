import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/page_provider.dart';
import 'package:frontend/theme.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel user = authProvider.user;
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    Widget header() {
      return AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Message Support",
          style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium),
        ),
        scrolledUnderElevation: 0.0,
        backgroundColor: backgroundColor2,
        centerTitle: true,
        toolbarHeight: 64,
      );
    }

    Widget noChat() {
      return Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              shape: BoxShape.rectangle,
              color: secondaryColor,
            ),
            child: Column(
              children: [
                Image.asset(
                  "assets/icon_headset.png",
                  width: 80,
                  color: primaryColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Ups! Belum ada chat nih..",
                  style: primaryTextStyle.copyWith(
                      fontSize: 16, fontWeight: medium),
                ),
                const SizedBox(
                  height: 12,
                ),
                user.role.contains("ADMIN")
                    ? const SizedBox()
                    : Column(
                        children: [
                          Text(
                            "Kamu belum pernah melakukan transaksi",
                            style: secondaryTextStyle,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: primaryColor),
                            child: TextButton(
                              onPressed: () {
                                pageProvider.currentIndex = 0;
                              },
                              child: Text(
                                "Jelajahi Toko",
                                style: whiteTextStyle.copyWith(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ],
      ));
    }

    return Column(
      children: [
        header(),
        StreamBuilder<QuerySnapshot>(
            stream: user.role.contains("ADMIN")
                ? firestore.collection('messages').snapshots()
                : firestore
                    .collection('messages')
                    .where('user_id', isEqualTo: user.id)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                  child: Container(
                    color: backgroundColor1,
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                        subtitleColor,
                      )),
                    ),
                  ),
                );
              }

              if (snapshot.data!.size == 0) {
                return noChat();
              }

              List<DocumentSnapshot<Object?>> chatDocuments =
                  snapshot.data!.docs;

              if (user.role.contains("ADMIN")) {
                var userChatDocuments = <String, DocumentSnapshot>{};
                var unreadCounts = <String, int>{};

                for (var doc in chatDocuments) {
                  var userId = doc['user_id'].toString();
                  if (userChatDocuments.containsKey(userId)) {
                    var existingDoc = userChatDocuments[userId]!;
                    var existingTimestamp =
                        DateTime.parse(existingDoc['created_at']);
                    var newTimestamp = DateTime.parse(doc['created_at']);

                    if (newTimestamp.compareTo(existingTimestamp) > 0) {
                      userChatDocuments[userId] = doc;
                    }

                    if (!doc['has_read'] &&
                        !doc['user_role'].contains(user.role)) {
                      unreadCounts[userId] = (unreadCounts[userId] ?? 0) + 1;
                    }
                  } else {
                    userChatDocuments[userId] = doc;

                    if (!doc['has_read'] &&
                        !doc['user_role'].contains(user.role)) {
                      unreadCounts[userId] = 1;
                    }
                  }
                }

                chatDocuments = userChatDocuments.values.toList();

                chatDocuments.sort((b, a) {
                  return (DateTime.parse(a['created_at']))
                      .compareTo(DateTime.parse(b['created_at']));
                });

                return Expanded(
                  child: Container(
                    color: backgroundColor1,
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          top: defaultMargin / 2, bottom: defaultMargin * 4),
                      itemCount: chatDocuments.length,
                      itemBuilder: (context, index) {
                        return chatTile(
                          chatDocument: chatDocuments[index],
                          unreadMessagesCount: unreadCounts[
                                  chatDocuments[index]['user_id'].toString()] ??
                              0,
                        );
                      },
                    ),
                  ),
                );
              }

              chatDocuments.sort((a, b) {
                return (DateTime.parse(a['created_at']))
                    .compareTo(DateTime.parse(b['created_at']));
              });

              return Expanded(
                child: Container(
                  color: backgroundColor1,
                  child: ListView(
                    padding: EdgeInsets.only(
                      top: defaultMargin / 2,
                      bottom: defaultMargin * 4,
                    ),
                    children: [
                      chatTile(
                        chatDocument: chatDocuments[chatDocuments.length - 1],
                        unreadMessagesCount: chatDocuments
                            .where((doc) => (!doc['has_read'] &&
                                !doc['user_role'].contains(user.role)))
                            .length,
                      )
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}
