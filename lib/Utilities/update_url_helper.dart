import 'package:universal_html/html.dart';

class UpdateUrlHelper {
  //example
  static void changeEntryId({required int? id}) => _changeParameter(parameter: "entryId",value: id, );

  static void _changeParameter({required int? value, required String parameter}) {
    Uri uri = Uri.parse(window.location.href);
    if (value == null) {
      uri = uri.replace(queryParameters: {...uri.queryParameters}..removeWhere((key, value) => key == parameter));
    } else {
      if (uri.queryParameters[parameter] != value.toString()) {
        uri = uri.replace(queryParameters: {...uri.queryParameters}..addAll({parameter: value.toString()}));
      }
    }
    final String finalUrl = uri.queryParameters.isNotEmpty ? uri.toString() : uri.toString().replaceAll("?", "");
    window.history.replaceState(null, "", finalUrl);
  }
}
