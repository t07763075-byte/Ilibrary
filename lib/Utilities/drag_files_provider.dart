import 'package:ELibrary/Utilities/generic_file.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DragFilesProvider extends ChangeNotifier {
  List<GenericFile> _images = [];

  List<GenericFile> get images => _images;

  Future clearAll() async {
    if (_images.isEmpty) return;
    _images = [];
    notifyListeners();
  }

  Future removeAt(int index) async {
    _images.removeAt(index);
    notifyListeners();
  }

  Future onDropFile(List<XFile>? data, BuildContext context,) async {
    if (data == null) return;
    for (var item in data) {
      _images.add(await GenericFile.fromXFile(item));
    }
    notifyListeners();
  }

  //*   pick an image
  Future pickFile({bool allowMultiple = true, required BuildContext context}) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: GenericFile.allowExtensions,
      type: FileType.custom,
      allowMultiple: allowMultiple,
    );

    if (result != null && result.files.isNotEmpty) {
      if (!allowMultiple) {
        _images = [];
      }
      for (var e in result.files) {
        if (e.bytes != null || e.path != null) _images.add(GenericFile.fromPlatformFile(e));
      }
      notifyListeners();
    }
  }
}
