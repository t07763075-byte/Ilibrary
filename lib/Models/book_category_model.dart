class BookCategoryModel {
  final String? name;
  final bool? inPreferred;
  final int? id;

  BookCategoryModel({
    this.name,
    this.inPreferred,
    this.id,
  });

  String? get nameAfterSplit => (name != null && name!.contains("Browsing:"))
      ? name!.split("Browsing:")[1].trim()
      : name;

  factory BookCategoryModel.fromJson(Map<String, dynamic> json) =>
      BookCategoryModel(
        name: json["name"],
        inPreferred: json["inPreferred"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "inPreferred": inPreferred,
        "id": id,
      };
}
