import 'package:frontend/models/category_model.dart';
import 'package:frontend/models/gallery_model.dart';
import 'package:frontend/models/variation_model.dart';

class ProductModel {
  late int id;
  late String name;
  late double price;
  late String description;
  late String tags;
  late CategoryModel? category;
  late Map<String, List<VariationModel>>? variations;
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late List<GalleryModel?>? galleries;

  ProductModel({
    this.id = 0,
    this.name = "",
    this.price = 0,
    this.description = "",
    this.tags = "",
    this.category,
    this.variations,
    this.createdAt,
    this.updatedAt,
    this.galleries,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = double.parse(json['price'].toString());
    description = json['description'];
    if (json.containsKey('tags')) {
      tags = json['tags'] ?? "";
    }
    category = CategoryModel.fromJson(json['category']);
    galleries = json['galleries']
        .map<GalleryModel>((gallery) => GalleryModel.fromJson(gallery))
        .toList();

    variations = {};
    if (json.containsKey('variations')) {
      for (var data in (json['variations'] as List<dynamic>)) {
        // print(data);
        if (variations!.containsKey(data['option']['name'])) {
          variations![data['option']['name']]?.add(VariationModel.fromJson(
              {'id': data['id'], 'value': data['value']}));
        } else {
          variations![data['option']['name']] = [
            VariationModel.fromJson({'id': data['id'], 'value': data['value']})
          ];
        }
        continue;
      }
    }
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    List variants = [];
    variations?.keys.map((key) {
      variations![key]?.forEach((data) {
        variants.add({
          'id': data.id,
          'value': data.value,
          'option': {'name': key}
        });
      });
    });
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'tags': tags,
      'category': category?.toJson(),
      'galleries': galleries?.map((gallery) => gallery?.toJson()).toList(),
      'variations': variants,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}

class UninitializedProductModel extends ProductModel {}

class NotFoundProductModel extends ProductModel {}
