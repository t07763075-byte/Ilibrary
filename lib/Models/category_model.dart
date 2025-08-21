
class CategoryModel {
  final String? name;
  final String? image;
  final bool? inPreferred;
  final int? id;

  CategoryModel({
    this.name,
    this.image,
    this.inPreferred,
    this.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    name: json["name"],
    image: json["image"],
    inPreferred: json["inPreferred"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "inPreferred": inPreferred,
    "id": id,
  };
}