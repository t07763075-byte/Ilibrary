

import 'package:flutter/material.dart';

enum LocalActionType{add, edit, delete}

abstract class BookTextAddress {
  final int? bookId;
  final int? page;
  final TextSelection? selection;
  final bool isSynced;
  final LocalActionType? localActionType;
  int? get pageNumber => page == null ? null: page!+1;

  BookTextAddress({required this.bookId, required this.page, required this.selection, required this.isSynced, required this.localActionType});
}