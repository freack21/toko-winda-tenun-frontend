class CategoryModel {
  late int id;
  late String name;

  CategoryModel({
    this.id = 0,
    this.name = "",
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
