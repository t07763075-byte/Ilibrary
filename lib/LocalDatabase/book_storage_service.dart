import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import '../Modules/Book/ReadBook/ReadBookDataHandler/remote_data_handler.dart';
import 'local_db_helper.dart';

class BookStorageService{

  static const String jsonKey = "fileContent";

  static Future<String?> saveBook({required int bookId})async{
    String bookPath = join(await LocalDBHelper.getLocalFolderPath(), "$bookId.json",);
    File bookFile = File(bookPath);
    if(bookFile.existsSync()) return bookPath;

    final result = await ReadBookRemoteDataHandler.getBookById(bookId: bookId,disableCache: true);
    if(result.isLeft()) return null;
    List<String> bookPages = result.getOrElse(()=> []);
    bookFile.writeAsStringSync(json.encode({jsonKey: bookPages,}));
    return bookPath;
  }

  static Future<List<String>?> getSavedBook({required int bookId})async{
    String bookPath = join(await LocalDBHelper.getLocalFolderPath(), "$bookId.json",);
    File bookFile = File(bookPath);
    bool isExists = bookFile.existsSync();
    if(!isExists) return null;

    Map<String,dynamic> jsonData = json.decode(bookFile.readAsStringSync());
    List<String> bookPages = List.from((jsonData[jsonKey] as List<dynamic>).map((e)=> e.toString()));
    return bookPages;
  }

  static Future<void> removeSavedBook({required int bookId})async{
    String bookPath = join(await LocalDBHelper.getLocalFolderPath(),bookId.toString());
    File bookFile = File(bookPath);
    if(!bookFile.existsSync()) return;
    bookFile.deleteSync();
  }
}