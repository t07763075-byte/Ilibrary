import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'images_cache_manager.dart';

sealed class CachedImagesHelper {

  static Future<Uint8List?> _loadImageToCache(String url) async {
    try {
      Uint8List? imageBytes = (await http.get(Uri.parse(url))).bodyBytes;
      await saveImageToCache(url, imageBytes);
      return imageBytes;
    } catch (_) {return null;}
  }

  static Future<void> saveImageToCache(String url, Uint8List imageBytes) async {
    try {
      await ImagesCacheManager.instance.putFile(
        url,
        imageBytes,
        eTag: DateTime.now().microsecondsSinceEpoch.toString(),
      );
    } catch (_) {}
  }
  static Future<Uint8List?> fetchImageFromCache(String url) async {
    try {
      final file = await ImagesCacheManager.instance.getFileFromCache(url);
      if(file != null) return file.file.readAsBytes();
      return await _loadImageToCache(url);
    } catch (e) {
      return null;
    }
  }
}