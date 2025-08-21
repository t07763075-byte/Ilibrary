import 'package:state_extended/state_extended.dart';

class AboutController extends StateXController {
  // singleton
  factory AboutController() => _this ??= AboutController._();
  static AboutController? _this;

  AboutController._();

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
