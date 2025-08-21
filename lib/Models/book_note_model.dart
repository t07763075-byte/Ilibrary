import 'dart:convert';

import '../Utilities/extensions.dart';
import 'book_text_address.dart';

class BookNoteModel extends BookTextAddress{
  static const String idText = "id";
  static const String noteIndexText = "noteIndex";
  static const String userIdText = "userId";
  static const String bookIdText = "bookId";
  static const String bookTitleText = "bookTitle";
  static const String titleText = "title";
  static const String infoText = "info";
  static const String pageText = "page";
  static const String dateText = "date";
  static const String selectionText = "selection";
  static const String isSyncedText = "isSynced";
  static const String localActionTypeText = "localActionType";

  final int? id;
  final int? userId;
  final String? title;
  final int? noteIndex;
  final String? info;
  final String? bookTitle;
  final DateTime? date;
  BookNoteModel( {
    this.id,
    this.userId,
    super.bookId,
    this.title,
    this.info,
    super.page,
    this.date,
    this.bookTitle,
    super.selection,
    required super.localActionType,
    super.isSynced = false,
    this.noteIndex
  });

  factory BookNoteModel.fromJson(Map<String, dynamic> json) => BookNoteModel(
    id: json[idText],
    noteIndex: json[noteIndexText],
    userId: json[userIdText],
    bookId: json[bookIdText],
    title: json[titleText],
    bookTitle: json[bookTitleText],
    info: json[infoText],
    page: json[pageText],
    isSynced: json[isSyncedText] == 1,
    date: json[dateText] == null ? null : DateTime.parse(json[dateText]),
    localActionType: json[localActionTypeText] == null ? null : LocalActionType.values[json[localActionTypeText]],
    selection: json[selectionText] == null || !json[selectionText].contains("{") ? null : TextSelectionAdapter.fromJson(jsonDecode(json[selectionText])),
  );

  BookNoteModel copyWith({int? id, String? info,bool? isSynced, LocalActionType? localActionType}){
    return BookNoteModel(
      id: id ?? this.id,
      title: title,
      page: page,
      bookId: bookId,
      bookTitle: bookTitle,
      date: date,
      userId: userId,
      noteIndex: noteIndex,
      selection: selection,
      info: info ?? this.info,
      isSynced: isSynced ?? this.isSynced,
      localActionType: localActionType ?? this.localActionType,
    );
  }

  Map<String, dynamic> toJson() => {
    idText: id,
    noteIndexText: noteIndex,
    userIdText: userId,
    bookIdText: bookId,
    bookTitleText: bookTitle,
    titleText: title,
    infoText: info,
    pageText: page,
    isSyncedText: isSynced ? 1 : 0,
    localActionTypeText: localActionType?.index,
    dateText: date?.toIso8601String(),
    selectionText: selection == null? null: jsonEncode(selection?.toJson()),
  };
}
