import 'package:ELibrary/Models/category_model.dart';
import 'package:ELibrary/Modules/Auth/Widget/sign_up_success_widget.dart';
import 'package:ELibrary/Modules/Home/Home/home_screen.dart';
import 'package:ELibrary/Utilities/dialog_helper.dart';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';

import '../../../Utilities/toast_helper.dart';
import 'choose_book_genre_data_handler.dart';

class ChooseBookGenreController extends StateXController {
  // singleton
  static ChooseBookGenreController? _this;
  ChooseBookGenreController._();
  factory ChooseBookGenreController() =>
      _this ??= ChooseBookGenreController._();

  bool loading = false;

  List<CategoryModel> categories = [];
  Set<int> selectedCategoriesIds = {};

  Future getCategoriesData()async{
    setState(()=> loading = true);
    final result = await ChooseBookGenreDataHandler.getAllCategories();
    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      (r)=> categories = r,
    );
    if(categories.isNotEmpty) selectedCategoriesIds = categories.where((e)=> e.inPreferred == true).map((e)=> e.id).whereType<int>().toSet();
    setState(()=> loading = false);
  }


  void toggleBookGenreSelection(int? categoryId) {
    if(categoryId == null) return;
    if (selectedCategoriesIds.contains(categoryId)) {
      selectedCategoriesIds.remove(categoryId);
    } else {
      selectedCategoriesIds.add(categoryId);
    }
    setState(() {});
  }

  Future onConfirm() async{
    setState(()=> loading = true);
    final result = await ChooseBookGenreDataHandler.updatePreferred(ids: selectedCategoriesIds.toList());
    setState(()=> loading = false);

    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (r) => DialogHelper.custom(context: currentContext_!).customDialog(
        onDismiss: ()=> currentContext_?.goNamed(HomeScreen.routeName),
        dialogWidget: const SignUpSuccessDialog(),
      ),
    );
  }
}
