import 'dart:convert';
import 'dart:typed_data';
import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:flutter/foundation.dart' as foundation;
import "package:universal_html/html.dart";
import 'books_cache_manager.dart';

sealed class CachedBooksHelper {
  static Future<void> _cacheBook({required bookId, required Uint8List bookContent}) async {
    if (foundation.kIsWeb) {
      window.localStorage["book_$bookId.json"] = String.fromCharCodes(bookContent);
    } else {
      await BooksCacheManager.instance.putFile("book_$bookId.json", bookContent);
    }
  }

  static Future<Uint8List?> _getCachedBook(int bookId) async {
    if(foundation.kIsWeb){
      String? bookData = window.localStorage["book_$bookId.json"];
      if (bookData != null) {
        return Uint8List.fromList(bookData.codeUnits);
      }
    }else{
      final fileInfo = await BooksCacheManager.instance.getFileFromCache("book_$bookId.json");
      if (fileInfo != null) {
        return fileInfo.file.readAsBytesSync();
      }
    }
    return null;
  }


  static Future<void> cacheBook({required bookId, required List<String> bookContent}) async {
    Uint8List bookData = Uint8List.fromList(utf8.encode(jsonEncode(bookContent)));
    await _cacheBook(bookId: bookId, bookContent: bookData);
  }

  static Future<List<String>?> getCachedBook(int bookId) async {
    final Uint8List? bookData = await _getCachedBook(bookId);
    if(bookData == null) return null;

    return List<String>.from(jsonDecode(utf8.decode(bookData)));
  }


  static Future<void> cacheLastReadingPage({required bookId, required int pageNumber}) async {
    await SharedPref.prefs.setInt("bookMark_$bookId", pageNumber);
  }

  static int? getCachedLastReadingPage(int bookId)=> SharedPref.prefs.getInt("bookMark_$bookId");

}