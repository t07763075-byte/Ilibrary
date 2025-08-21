import 'dart:convert';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;

class RouterHelper {
  static String getServerUrl() {
    String completeUrl = html.window.location.href;
    Uri uri = Uri.parse(completeUrl);
    String serverUrl = '${uri.scheme}://${uri.host}${uri.hasPort ? ":${uri.port}" : ""}';
    return serverUrl;
  }

  static void popUntilPath(String pattern) {
    final router = GoRouter.of(currentContext_!);
    while (router.location.contains(pattern)) {
      if (!router.canPop()) return;
      router.pop();
    }
  }

  static Future popAllFromBrowser() async {
    while (html.window.location.href.replaceAll(getServerUrl(), "").length > 2) {
      html.window.history.back();
      await Future.delayed(Duration.zero);
    }
  }

  static void pop(BuildContext context) {
    if (kIsWeb) {
      html.window.history.back();
    } else {
      Navigator.of(context).pop();
    }
  }

  static final Codec<String, String> _stringToBase64Url = utf8.fuse(base64Url);

  static T decode<T>(Map queryParameters, T Function(Map<String, dynamic>) fromMap) {
    if (queryParameters["data"] == null) return fromMap({});
    return fromMap(json.decode(_stringToBase64Url.decode(queryParameters["data"])));
  }

  static Map<String, dynamic> encode(Map<String, dynamic> data) => {"data": _stringToBase64Url.encode(json.encode(data))};

}
