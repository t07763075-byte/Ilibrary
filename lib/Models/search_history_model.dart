
class SearchHistoryModel {
  final int? id;
  final String? searchKeyword;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  SearchHistoryModel({
    this.searchKeyword,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) => SearchHistoryModel(
    searchKeyword: json["searchKeyword"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "searchKeyword": searchKeyword,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "id": id,
  };
}
