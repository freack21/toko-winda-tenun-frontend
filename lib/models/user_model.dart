class UserModel {
  late int id;
  late String name;
  late String email;
  late String username;
  late String phone;
  late String avatar;
  late String token;

  UserModel({
    this.id = 0,
    this.name = "",
    this.email = "",
    this.username = "",
    this.phone = "",
    this.avatar = "",
    this.token = "",
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    phone = json['phone'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'phone': phone,
      'avatar': avatar,
      'token': token,
    };
  }
}
