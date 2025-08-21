import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/Utilities/toast_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Models/rating_data_model.dart';
import '../../../Utilities/dialog_helper.dart';
import '../../../Utilities/general_data_handler.dart';
import '../RateScreen/rate_controller.dart';
import 'Widget/submitted_rate_successfully_widget.dart';

class AddRateController extends StateXController {
  // singleton
  factory AddRateController() => _this ??= AddRateController._();
  static AddRateController? _this;

  AddRateController._();

  bool loading = false;

  BookModel book=BookModel();
  double rate = 1;
  late TextEditingController describeController;
  late ScrollController scrollController;

  late FocusNode focusNode;
  RatingDataModel ratingData=RatingDataModel();
  @override
  void initState() {
    describeController = TextEditingController();

    focusNode = FocusNode();
    scrollController = ScrollController();
    focusNode.addListener(() {
      if (focusNode.hasFocus) _scrollToBottom();
    });
    super.initState();
  }

  @override
  void dispose() {
    describeController.dispose();
    focusNode.removeListener(() {});
    focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 500));
    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }

  onSubmit() async {
    setState(() {
      loading = true;
    });
    final result = await GeneralDataHandler.addRating(
        rating: rate, describe: describeController.text, bookId: book.id);
    result.fold((l) {
      ToastHelper.showSuccess(message: l.message);
    }, (r) async {
      await RateController().getData(removeOld: true);
      DialogHelper.custom(context: currentContext_!).customDialog(
          dialogWidget: SubmittedRateSuccessfullyWidget(bookTitle: book.title),
          dismiss: false);
    });
    setState(() {
      loading = false;
    });
  }

  getBookDetails(String? id) async {
    setState(() {
      loading = true;
    });
    final result = await GeneralDataHandler.getBookDetails(bookId: id);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      book = r;
      describeController = TextEditingController(text: book.myReview ?? '');
      rate =book.myRate;
    });
    setState(() {
      loading = false;
    });
  }

}
