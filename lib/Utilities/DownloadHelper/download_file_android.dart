import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'download_file_helper.dart';


class DownloadFileAndroid extends DownloadFileInterface {
  @override
  Future<String?> downloadBytes({required Uint8List data, required String fileName}) async{
    try{
      Directory? externalStorage = await getExternalStorageDirectory();
      externalStorage ??= await getApplicationSupportDirectory();
      File file = File("${externalStorage.path}/$fileName");
      file.writeAsBytesSync(data);
      return file.path;
    }catch(e){
      return null;
    }
  }
}
