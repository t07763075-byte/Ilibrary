import 'package:state_extended/state_extended.dart';
import '../../../Models/book_model.dart';
import '../../../Utilities/general_data_handler.dart';
import '../../../Utilities/toast_helper.dart';

class AboutBookController extends StateXController {
  // singleton
  factory AboutBookController() => _this ??= AboutBookController._();
  static AboutBookController? _this;
  AboutBookController._();
  bool loading=false;
  BookModel book=BookModel();


  getBookDetails(String? id) async {
    setState(() {
      loading = true;
    });
    final result = await GeneralDataHandler.getBookDetails(bookId: id);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      book = r;
    });
    setState(() {
      loading = false;
    });
  }
}
