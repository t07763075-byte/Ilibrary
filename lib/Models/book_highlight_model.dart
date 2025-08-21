import 'dart:convert';

import '../Utilities/extensions.dart';
import 'book_text_address.dart';


class BookHighlightModel extends BookTextAddress{
  static const String idText = "id";
  static const String bookIdText = "bookId";
  static const String titleText = "title";
  static const String pageText = "page";
  static const String dateText = "date";
  static const String colorText = "color";
  static const String selectionText = "selection";
  static const String isSyncedText = "isSynced";
  static const String localActionTypeText = "localActionType";


  final int? id;
  final String? title;
  final DateTime? date;
  final String? color;


  BookHighlightModel({
    this.id,
    super.bookId,
    this.title,
    super.page,
    this.date,
    this.color,
    super.selection,
    super.isSynced = false,
    required super.localActionType,
  });

  factory BookHighlightModel.fromJson(Map<String, dynamic> json) => BookHighlightModel(
    id: json[idText],
    bookId: json[bookIdText],
    title: json[titleText],
    page: json[pageText],
    date: json[dateText] == null ? null : DateTime.parse(json[dateText]),
    color: json[colorText],
    isSynced: json[isSyncedText] == 1,
    selection: json[selectionText] == null || !json[selectionText].contains("{") ? null : TextSelectionAdapter.fromJson(jsonDecode(json[selectionText])),
    localActionType: json[localActionTypeText] == null ? null : LocalActionType.values[json[localActionTypeText]],
  );

  BookHighlightModel copyWith({int? id,String? color,bool? isSynced,LocalActionType? localActionType}){
    return BookHighlightModel(
      id: id ?? this.id,
      color: color ?? this.color,
      title: title,
      date: date,
      selection: selection,
      page: page,
      bookId: bookId,
      isSynced: isSynced ?? this.isSynced,
      localActionType: localActionType ?? this.localActionType,
    );
  }

  Map<String, dynamic> toJson() => {
    idText: id,
    bookIdText: bookId,
    titleText: title,
    pageText: page,
    dateText: date?.toIso8601String(),
    colorText: color,
    localActionTypeText: localActionType?.index,
    isSyncedText: isSynced ? 1 : 0,
    selectionText: selection == null? null: jsonEncode(selection?.toJson()),
  };
}
