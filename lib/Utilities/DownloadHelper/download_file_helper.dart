import 'dart:developer';
import 'dart:io';
import 'package:ELibrary/Utilities/toast_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'download_file_android.dart';
import 'download_file_other_platform.dart';
import "download_file_web.dart";

class DownloadFileHelper{
  static _notifyDownloadComplete({String? filePath})async{
    ToastHelper.showSuccess(message: "${basename(filePath??"")} Downloaded Successfully");
    if(filePath == null) return;
    if (Platform.isWindows) await Process.run('explorer', [File(filePath).parent.path]);
    if (Platform.isWindows) await Process.run( 'cmd', ['/c', 'start', '', filePath]);
    if (Platform.isAndroid || Platform.isIOS) await OpenFile.open(filePath);
  }

  static _notifyDownloadFailed({String? fileName}){
    ToastHelper.showError(message: "$fileName Download Failed");
  }

  static DownloadFileInterface _factoryDownloadInterface(){
    if(kIsWeb) {
      return WebDownloadFile();
    } else if(Platform.isAndroid) {
      return DownloadFileAndroid();
    } else {
      return DownloadOtherPlatform();
    }
  }

  static Future factoryDownloadBytes({required Uint8List data, required String fileName})async{
    String? result = await _factoryDownloadInterface().downloadBytes(data: data, fileName: fileName);
    if(result != null) {
      _notifyDownloadComplete(filePath: result);
    } else {
      _notifyDownloadFailed(fileName: fileName);
    }
  }

  static Future factoryDownloadUri({required Uri uri,String? fileName})async{
    try{
      Uint8List data = (await http.get(uri)).bodyBytes;
      factoryDownloadBytes(data: data, fileName: basename(uri.path));
    }catch(e){
    log("failed to get data $e");
    }
  }
}


abstract class DownloadFileInterface{
  Future<String?> downloadBytes({required Uint8List data, required String fileName});
}