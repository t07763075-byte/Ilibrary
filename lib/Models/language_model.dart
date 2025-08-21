
class LanguageModel {
  final String? code;
  final String? name;
  final int? id;

  LanguageModel({
    this.code,
    this.name,
    this.id,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
    code: json["code"],
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "id": id,
  };
}
