// To parse this JSON data, do
//
//     final bookMarkModel = bookMarkModelFromJson(jsonString);

import 'dart:convert';

import 'book_text_address.dart';

BookMarkModel bookMarkModelFromJson(String str) => BookMarkModel.fromJson(json.decode(str));

String bookMarkModelToJson(BookMarkModel data) => json.encode(data.toJson());

class BookMarkModel extends BookTextAddress{
  static const String idText = "bookMarkId";
  static const String bookIdText = "id";
  static const String pageText = "page";
  static const String titleText = "title";
  static const String totalRatingText = "totalRating";
  static const String imageUrlText = "imageUrl";
  static const String isSyncedText = "isSynced";
  static const String localActionTypeText = "localActionType";

  final int? id;
  final String? title;
  final double? totalRating;
  final String? imageUrl;

  BookMarkModel({
    this.id,
    super.bookId,
    super.page,
    this.title,
    this.totalRating,
    this.imageUrl,
    super.isSynced = false,
    required super.localActionType,
    super.selection,
  });

  BookMarkModel copyWith({int? id,bool? isSynced,LocalActionType? localActionType}){
    return BookMarkModel(
      id: id ?? this.id,
      title: title,
      selection: selection,
      imageUrl: imageUrl,
      totalRating: totalRating,
      page: page,
      bookId: bookId,
      isSynced: isSynced ?? this.isSynced,
      localActionType: localActionType ?? this.localActionType,
    );
  }

  factory BookMarkModel.fromJson(Map<String, dynamic> json) => BookMarkModel(
    id: json[idText],
    bookId: json[bookIdText],
    page: json[pageText],
    title: json[titleText],
    totalRating: json[totalRatingText],
    imageUrl: json[imageUrlText],
    isSynced: json[isSyncedText] == 1,
    localActionType: json[localActionTypeText] == null ? null : LocalActionType.values[json[localActionTypeText]],
  );

  Map<String, dynamic> toJson() => {
    idText: id,
    bookIdText: bookId,
    pageText: page,
    titleText: title,
    totalRatingText: totalRating,
    imageUrlText: imageUrl,
    localActionTypeText: localActionType?.index,
    isSyncedText: isSynced ? 1 : 0,
  };
}
