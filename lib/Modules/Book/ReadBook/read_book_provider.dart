import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../../Models/read_book_style_model.dart';



class ReadBookProvider extends ChangeNotifier {

  ReadBookStyleModel _styleModel = ReadBookStyleModel.defaultStyle;

  ReadBookStyleModel get styleModel => _styleModel;

  void init(){
    _styleModel = SharedPref.getReadBookStyleModel() ?? ReadBookStyleModel.defaultStyle;
  }

  void updateStyle(ReadBookStyleModel value){
    _styleModel = value;
    SharedPref.saveReadBookStyleModel(style: _styleModel);
    notifyListeners();
  }


}
