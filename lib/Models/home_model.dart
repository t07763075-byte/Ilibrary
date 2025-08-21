import 'package:ELibrary/Models/book_model.dart';

import 'category_model.dart';

class HomeModel {
  final List<BookModel> myReads;
  final List<BookModel> recommended;
  final List<BookModel> mostRead;
  final List<CategoryModel> categories;

  HomeModel({
    this.myReads = const [],
    this.recommended = const [],
    this.mostRead = const [],
    this.categories = const [],
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        myReads: json["myReads"] == null
            ? []
            : List<BookModel>.from(
                json["myReads"]!.map((x) => BookModel.fromJson(x))),
        recommended: json["recommended"] == null
            ? []
            : List<BookModel>.from(
                json["recommended"]!.map((x) => BookModel.fromJson(x))),
        mostRead: json["mostRead"] == null
            ? []
            : List<BookModel>.from(
                json["mostRead"]!.map((x) => BookModel.fromJson(x))),
        categories: json["categories"] == null
            ? []
            : List<CategoryModel>.from(
                json["categories"]!.map((x) => CategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "myReads": List<dynamic>.from(myReads.map((x) => x.toJson())),
        "recommended": List<dynamic>.from(recommended.map((x) => x.toJson())),
        "mostRead": List<dynamic>.from(mostRead.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}
