import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

enum PickedFileType { image, video, document }

class GenericFile {
  static const List<String> allowExtensions = [
    ...imageExtensions,
    ...videoExtensions,
    ...documentExtensions,
  ];

  static const List<String> imageExtensions = ["png", "jpg", "jpeg", "pjpeg", "gif", "jfif",];
  static const List<String> videoExtensions = ["mp4", "mov", "wmv", "avi", "mkv"];
  static const List<String> documentExtensions = ["pdf", "txt", "xls", "xlsx", "csv", "doc", "docx","tiff"];

  static PickedFileType? getFileType(String? extension) {
    extension = extension?.toLowerCase().replaceAll(".", "");
    if (imageExtensions.contains(extension)) return PickedFileType.image;
    if (videoExtensions.contains(extension)) return PickedFileType.video;
    if (documentExtensions.contains(extension)) return PickedFileType.document;
    return null;
  }

  final String filename;
  final PickedFileType? fileType;
  final Uint8List bytes;
  final Key key;
  final double? size;
  final String? extension;
  String? get sizeAsString => size == null? null : size!/1000 > 1? "${(size!/1000).toStringAsFixed(2) ?? "-"} MB" : "${size?.toStringAsFixed(2) ?? "-"} KB";

  GenericFile._({required this.filename, this.extension, required this.bytes, this.size, required this.key, this.fileType});

  factory GenericFile.fromPlatformFile(PlatformFile file) {
    return GenericFile._(
      fileType: getFileType(file.extension),
      filename: file.name,
      bytes: file.bytes!,
      size: file.size.toDouble(),
      extension: file.extension,
      key: Key(
        DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    );
  }

  static Future fromXFile(XFile file) async {
    Uint8List bytes = await file.readAsBytes();
    return GenericFile._(
      fileType: getFileType(path.extension(file.name)),
      filename: file.name,
      bytes: bytes,
      size: bytes.lengthInBytes/1000,
      key: Key(
        DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    );
  }
}
