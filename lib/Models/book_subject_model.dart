class BookSubjectModel {
  final String? name;
  final int? id;

  BookSubjectModel({
    this.name,
    this.id,
  });

  factory BookSubjectModel.fromJson(Map<String, dynamic> json) => BookSubjectModel(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}