import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import 'package:synchronized/synchronized.dart';
import '../../LocalDatabase/sync_local_db_service.dart';
import '../../Modules/MyLibrary/Library/library_screen.dart';
import '../../Utilities/lifecycle_service.dart';

bool get deviceHaveInternet => currentContext_ == null ? true: Provider.of<InternetConnectionProvider>(currentContext_!,listen: false).isConnected;

class InternetConnectionProvider with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  static Lock lock = Lock();


  final InternetConnection _internetConnection = InternetConnection();

  Future init()async{
    _isConnected = await _internetConnection.hasInternetAccess;
    notifyListeners();
    _internetConnection.onStatusChange.listen((status) {
      final connected = (status == InternetStatus.connected);
      if (_isConnected != connected) {
        _isConnected = connected;
        if(currentContext_ != null && SharedPref.isLogin && LifecycleService().isVisible && !kDebugMode) currentContext_!.goNamed(LibraryScreen.routeName);
        notifyListeners();
      }
      if(!kIsWeb && _isConnected) lock.synchronized(SyncLocalDBService.startSync);
      if(!kIsWeb && !_isConnected) SyncLocalDBService.stopSync();
    });
  }

}