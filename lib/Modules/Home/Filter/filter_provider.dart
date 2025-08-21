import 'package:ELibrary/Models/language_model.dart';
import 'package:flutter/material.dart';

import '../../../Utilities/enum.dart';

class FilterProvider extends ChangeNotifier {
  SortType? selectedSort;
  RatingType? selectedRating;
  LanguageModel? language;

  setFilter({SortType? sort, RatingType? rating, LanguageModel? lang}) {
    language = lang;
    selectedRating = rating;
    selectedSort = sort;
    notifyListeners();
  }

  resetFilter() {
    selectedSort = null;
    selectedRating = null;
    language = null;
    notifyListeners();
  }
  resetLang(){
    language = null;
    notifyListeners();
  }
  resetRating(){
    selectedRating = null;
    notifyListeners();
  }
  resetSort(){
    selectedSort = null;
    notifyListeners();
  }
}
