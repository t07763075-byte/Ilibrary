import 'dart:convert';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Models/language_model.dart';
import '../../../Utilities/enum.dart';
import '../../Search/search_screen.dart';
import 'filter_provider.dart';

class FilterController extends StateXController {
  // singleton
  factory FilterController() => _this ??= FilterController._();
  static FilterController? _this;

  FilterController._();

  SortType? selectedSort;
  LanguageModel? selectedLanguage;
  RatingType? selectedRating ;
  GeneralFilterType selectedFilter = GeneralFilterType.sort;

  onReset() {
    selectedFilter = GeneralFilterType.sort;
    selectedSort = null;
    selectedRating = null;
    selectedLanguage=null;
    setState((){});
    final filterProvider = Provider.of<FilterProvider>(currentContext_!,listen: false);
    filterProvider.setFilter(
        rating: selectedRating,
        lang: selectedLanguage,
        sort: selectedSort
    );
  }
  onApply(){
    final filterProvider = Provider.of<FilterProvider>(currentContext_!,listen: false);
    filterProvider.setFilter(
      rating: selectedRating,
      lang: selectedLanguage,
      sort: selectedSort
    );
    if(selectedRating!=null||selectedLanguage!=null||selectedSort!=null) currentContext_!.pushNamed(SearchScreen.routeName,queryParameters: {'showPreviousSearch':base64Url.encode(utf8.encode('false'))});
  }
}
