class GalleryModel {
  late int id;
  late String url;

  GalleryModel({
    this.id = 0,
    this.url = "",
  });

  GalleryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json.containsKey('image')) {
      url = json['image'];
    } else if (json.containsKey('url')) {
      url = json['url'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': url,
    };
  }
}
