import 'package:flutter/widgets.dart';

class LifecycleService with WidgetsBindingObserver {
  static final LifecycleService _instance = LifecycleService._internal();
  factory LifecycleService() => _instance;

  LifecycleService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  bool _isVisible = true; // App starts in foreground
  bool get isVisible => _isVisible;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isVisible = state == AppLifecycleState.resumed;
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
