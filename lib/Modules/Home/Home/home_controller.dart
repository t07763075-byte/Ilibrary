import 'package:ELibrary/Utilities/toast_helper.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Models/home_model.dart';
import 'home_data_handler.dart';

class HomeController extends StateXController {
  // singleton
  factory HomeController() => _this ??= HomeController._();
  static HomeController? _this;
  HomeController._();

  bool loading = false;
  HomeModel home = HomeModel();

  getHome() async {
    setState(() => loading = true);
    final result = await HomeDataHandler.getHome();
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      home = r;
    });
    setState(() => loading = false);
  }
}
