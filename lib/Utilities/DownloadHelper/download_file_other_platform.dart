import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'download_file_helper.dart';

class DownloadOtherPlatform extends DownloadFileInterface {

  @override
  Future<String?> downloadBytes({required Uint8List data, required String fileName}) async{
    try{
      Directory? downloadDirectory = await getDownloadsDirectory();
      downloadDirectory ??= await getTemporaryDirectory();
      File file = File("${downloadDirectory.path}/$fileName");
      file.writeAsBytesSync(data);
      return file.path;
    }catch(e){
      return null;
    }
  }
}