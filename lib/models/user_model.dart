class UserModel {
  late int id;
  late String name;
  late String email;
  late String username;
  late String phone;
  late String avatar;
  late String role;
  late String token;

  UserModel({
    this.id = 0,
    this.name = "",
    this.email = "",
    this.username = "",
    this.phone = "",
    this.avatar = "",
    this.role = "",
    this.token = "",
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'] ?? "-";
    phone = json['phone'] ?? "-";
    avatar = json['avatar'];
    role = json['role'];
    if (json.containsKey('token')) token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'phone': phone,
      'avatar': avatar,
      'role': role,
      'token': token,
    };
  }
}
