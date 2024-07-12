import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/models/user_model.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessagesByUserId({int userId = 0}) {
    try {
      return firestore
          .collection('messages')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
        var result = list.docs.map<MessageModel>((DocumentSnapshot message) {
          return MessageModel.fromJson(message.data() as Map<String, dynamic>);
        }).toList();

        result.sort(
          (MessageModel a, MessageModel b) =>
              a.createdAt!.compareTo(b.createdAt!),
        );

        return result;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addMessage(
      {UserModel? user,
      bool isFromUser = false,
      String message = "",
      ProductModel? product}) async {
    try {
      firestore.collection('messages').add({
        'userId': user?.id,
        'userName': user?.name,
        'userImage': user?.avatar,
        'isFromUser': isFromUser,
        'message': message,
        'product':
            product is UninitializedProductModel ? {} : product?.toJson(),
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      }).then(
        (value) => print('Pesan Berhasil Dikirim!'),
      );
    } catch (e) {
      throw Exception('Pesan Gagal Dikirim!');
    }
  }
}
