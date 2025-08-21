import 'package:ELibrary/Utilities/general_data_handler.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rush/rush.dart';
import 'package:ELibrary/LocalDatabase/database_helper.dart';
import 'Modules/Book/ReadBook/html_manipulation_helper.dart';
import 'Modules/Book/ReadBook/read_book_provider.dart';
import 'Modules/Home/Filter/filter_provider.dart';
import 'Utilities/bottom_sheet_helper.dart';
import 'Utilities/git_it.dart';
import 'Utilities/lifecycle_service.dart';
import 'Utilities/router_config.dart';
import 'package:provider/provider.dart';
import 'core/API/request_on_progress_provider.dart';
import 'core/Font/font_provider.dart';
import 'core/Language/app_languages.dart';
import 'core/Language/locales.dart';
import 'core/Theme/theme_provider.dart';
import 'core/network/internet_connection_provider.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';


const bool enableLargeScreens = false;
const bool enableMediumScreens = false;
const bool enableSmallScreens = true;


//=========khaled=========
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  if(!kIsWeb) await DatabaseHelper().init();
  LifecycleService();

  responseSetUp(
    enableLargeScreens: enableLargeScreens,
    enableMediumScreens: enableMediumScreens,
    enableSmallScreens: enableSmallScreens
  );
  await GitIt.initGitIt();
   GeneralDataHandler.init();
  usePathUrlStrategy();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppLanguage>(create: (_) => AppLanguage()),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<FontProvider>(create: (_) => FontProvider()),
          ChangeNotifierProvider<ReadBookProvider>(create: (_) => ReadBookProvider()..init()),
          ChangeNotifierProvider<BottomSheetVisibilityProvider>(create: (_) => BottomSheetVisibilityProvider()),
          ChangeNotifierProvider<FilterProvider>(create: (_) => FilterProvider()),
          ChangeNotifierProvider<InternetConnectionProvider>(create: (_) => InternetConnectionProvider()),
          ChangeNotifierProvider<UploadRequestProgressProvider>(create: (_) => UploadRequestProgressProvider()),
          ChangeNotifierProvider<DownloadRequestProgressProvider>(create: (_) => DownloadRequestProgressProvider()),
          ChangeNotifierProvider<BookProcessingProvider>(create: (_) => BookProcessingProvider()),
        ],
        child: const EntryPoint(),
      )
  );
}


class EntryPoint extends StatelessWidget {
  const EntryPoint({Key? key}) : super(key: key);

  static Size largeSize = const Size(1920,1080);
  static Size mediumSize = const Size(1000,780);
  static Size smallSize = const Size(430,932);

  @override
  Widget build(BuildContext context) {

    final appLan = Provider.of<AppLanguage>(context);
    final appTheme = Provider.of<ThemeProvider>(context);
    Provider.of<InternetConnectionProvider>(context,listen: false).init();

    appLan.fetchLocale();
    appTheme.fetchTheme();
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        final screenSize = mediaQuery.size;
        final aspectRatio = screenSize.aspectRatio;
        Size designSize;
        if (screenSize.width > 1000 || aspectRatio > 1.5) {
          designSize = const Size(1024, 768); // Tablet landscape
        } else if (screenSize.width > 600 || aspectRatio > 1.5) {
          designSize = const Size(668, 1024); // Tablet portrait
        } else {
          designSize = const Size(375, 812); // Mobile
        }
        return ScreenUtilInit(
          designSize: designSize,
          builder:(_,__)=> MaterialApp.router(
            scrollBehavior: MyCustomScrollBehavior(),
            routerConfig: GoRouterConfig.router,
            debugShowCheckedModeBanner: false,
            title: 'Ilibrary',
            locale: Locale(appLan.appLang.name),

            theme: appTheme.appThemeMode?.copyWith(
              scaffoldBackgroundColor: ThemeClass.of(context).backGroundColor,
            ),
            supportedLocales: Languages.values.map((e) => Locale(e.name)).toList(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultMaterialLocalizations.delegate,
              LocaleNamesLocalizationsDelegate(),
            ],
          ),
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
