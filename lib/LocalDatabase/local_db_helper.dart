
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalDBHelper{
  static const String folderPath = "e-LibraryBooks";

  static Future<String> getLocalFolderPath()async{
    Directory? dir;
    if(Platform.isAndroid){
      dir = await getExternalStorageDirectory();
      dir ??= await getApplicationSupportDirectory();
    }else if(Platform.isIOS){
      // On iOS, use getApplicationDocumentsDirectory() instead of getDownloadsDirectory()
      // Downloads directory is restricted and causes permission errors
      dir = await getApplicationDocumentsDirectory();
      dir ??= await getApplicationSupportDirectory();
    }else{
      // For other platforms (desktop)
      dir = await getDownloadsDirectory();
      dir ??= await getApplicationSupportDirectory();
    }
    dir = Directory("${dir.path}/$folderPath");
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir.path;
  }

}