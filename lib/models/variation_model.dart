class VariationModel {
  late int id;
  late String value;

  VariationModel({
    this.id = 0,
    this.value = "",
  });

  VariationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
    };
  }
}
