import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

import './download_file_helper.dart';

class WebDownloadFile extends DownloadFileInterface{

  @override
  Future<String?> downloadBytes({required Uint8List data, required String fileName}) async{
   try{
     if(!kIsWeb) return null;
     final blob = html.Blob([data]);
     final url = html.Url.createObjectUrlFromBlob(blob);
     final anchor = html.document.createElement('a') as html.AnchorElement
       ..href = url
       ..style.display = 'none'
       ..download = fileName;
     html.document.body?.children.add(anchor);
     anchor.click();
     html.document.body?.children.remove(anchor);
     html.Url.revokeObjectUrl(url);
     return "/download/$fileName";
   }catch(e){
     return null;
   }
  }
}
