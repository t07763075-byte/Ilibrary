import 'dart:convert';
import 'package:ELibrary/Models/category_model.dart';
import 'package:ELibrary/Modules/Home/HomeItems/home_items_screen.dart';
import 'package:ELibrary/Utilities/enum.dart';
import 'package:ELibrary/Utilities/router_helper.dart';
import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../Models/definition_model.dart';
import '../Modules/Account/About/about_screen.dart';
import '../Modules/Account/EditProfile/edit_profile_screen.dart';
import '../Modules/Account/GeneralSettings/general_settings_screen.dart';
import '../Modules/Account/HelpCenter/help_center_screen.dart';
import '../Modules/Account/HelpCenter/screens/contact_support_screen.dart';
import '../Modules/Account/HelpCenter/screens/faqs_screen.dart';
import '../Modules/Account/HelpCenter/screens/privacy_policy_screen.dart';
import '../Modules/Account/HelpCenter/screens/terms_conditions_screen.dart';
import '../Modules/Account/NotificationSetting/notification_setting_screen.dart';
import '../Modules/Account/Profile/profile_screen.dart';
import '../Modules/Account/SecurityAndPrivacy/Screens/change_email_screen.dart';
import '../Modules/Account/SecurityAndPrivacy/Screens/change_password_screen.dart';
import '../Modules/Account/SecurityAndPrivacy/Screens/change_phone_number_screen.dart';
import '../Modules/Account/SecurityAndPrivacy/Screens/delete_my_account_screen.dart';
import '../Modules/Account/SecurityAndPrivacy/security_and_privacy_screen.dart';
import '../Modules/Account/Subscription/BillingHistory/billing_history_screen.dart';
import '../Modules/Account/Subscription/MySubscription/my_subscription_screen.dart';
import '../Modules/AppearanceLayoutScreens/appearance_screen.dart';
import '../Modules/Auth/ChooseBookGenre/choose_book_genre_screen.dart';
import '../Modules/Auth/CreateNewPassword/create_new_password_screen.dart';
import '../Modules/Auth/ForgotPassword/forgot_password_screen.dart';
import '../Modules/Auth/Login/sign_in_screen.dart';
import '../Modules/Auth/Onboarding/onboarding_screen.dart';
import '../Modules/Auth/OtpCode/otp_code_screen.dart';
import '../Modules/Auth/Register/sign_up_screen.dart';
import '../Modules/Book/AboutBook/about_book_screen.dart';
import '../Modules/Book/AddRate/add_rate_screen.dart';
import '../Modules/Book/BookDetail/book_detail_screen.dart';
import '../Modules/Book/RateScreen/rate_screen.dart';
import '../Modules/Book/ReadBook/read_book_screen.dart';
import '../Modules/Home/ExploreGenre/BookByGenre/book_by_genre_screen.dart';
import '../Modules/Home/ExploreGenre/ExploreGenre/explore_genre_screen.dart';
import '../Modules/Home/Home/home_screen.dart';
import '../Modules/MyLibrary/Definition/definition_screen.dart';
import '../Modules/MyLibrary/Library/library_screen.dart';
import '../Modules/Notification/notification_screen.dart';
import '../Modules/Search/search_screen.dart';
import '../Modules/Splash/splash_screen.dart';
import 'bottom_sheet_helper.dart';

BuildContext? get currentContext_ =>
    GoRouterConfig.router.routerDelegate.navigatorKey.currentContext;

class GoRouterConfig {
  static GoRouter get router => _router;
  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: SplashScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const SplashScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        path: AppearanceScreen.routeName,
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const AppearanceScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        name: BookDetailScreen.routeName,
        path: "/${BookDetailScreen.routeName}",
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: BookDetailScreen(
              bookId: state.queryParameters['bookId'],
            ),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            name: AboutBookScreen.routeName,
            path: AboutBookScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: AboutBookScreen(
                  bookId: state.queryParameters['bookId']??'',
                ),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: RateScreen.routeName,
            path: RateScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: RateScreen(
                  bookId: state.queryParameters['bookId']??'',
                ),
              );
            },
            routes: <RouteBase>[
              GoRoute(
                name: AddRateScreen.routeName,
                path: AddRateScreen.routeName,
                pageBuilder: (_, GoRouterState state) {
                  return getCustomTransitionPage(
                    state: state,
                    child: AddRateScreen(
                      bookId: state.queryParameters['bookId']??'',
                    ),
                  );
                },
                routes: const <RouteBase>[],
              ),
            ],
          ),
          GoRoute(
            name: ReadBookScreen.routeName,
            path: "${ReadBookScreen.routeName}/:bookId/:bookName",
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: ReadBookScreen(
                  bookName: state.pathParameters['bookName'] ?? "",
                  bookId: int.parse(
                      state.pathParameters['bookId']?.toString() ?? "0"),
                  startAt: int.tryParse(state.queryParameters["startAt"] ?? ""),
                  toHighlightId:
                      int.tryParse(state.queryParameters["toHighlightId"] ?? ""),
                  bookUrl:
                      "https://www.gutenberg.org/cache/epub/75031/pg75031-images.html",
                ),
              );
            },
            routes: const <RouteBase>[],
          ),
        ],
      ),
      GoRoute(
        name: HomeScreen.routeName,
        path: "/${HomeScreen.routeName}",
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const HomeScreen(),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            name: ExploreGenreScreen.routeName,
            path: ExploreGenreScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const ExploreGenreScreen(),
              );
            },
            routes: <RouteBase>[
              GoRoute(
                name: BookByGenreScreen.routeName,
                path: BookByGenreScreen.routeName,
                pageBuilder: (_, GoRouterState state) {
                  return getCustomTransitionPage(
                    state: state,
                    child: BookByGenreScreen(
                      category: RouterHelper.decode(state.queryParameters, CategoryModel.fromJson),
                    ),
                  );
                },
                routes: const <RouteBase>[],
              ),
            ],
          ),

          GoRoute(
            name: HomeItemsScreen.routeName,
            path: HomeItemsScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              // استرجاع القيمة المشفرة وفكها
              final encodedHomeType = state.queryParameters['homeType'];
              final decodedHomeType = encodedHomeType != null
                  ? utf8.decode(base64Url.decode(encodedHomeType))
                  : null;

              return getCustomTransitionPage(
                state: state,
                child: HomeItemsScreen(
                  homeType: HomeType.values.firstWhere(
                        (e) => e.toString() == decodedHomeType,
                    orElse: () => HomeType.continueReading,
                  ),
                ),
              );
            },
            routes: const <RouteBase>[],
          ),
        ],
      ),
      GoRoute(
        name: OnboardingScreen.routeName,
        path: '/${OnboardingScreen.routeName}',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const OnboardingScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        name: SignInScreen.routeName,
        path: '/${SignInScreen.routeName}',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const SignInScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        name: ForgotPasswordScreen.routeName,
        path: '/${ForgotPasswordScreen.routeName}',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const ForgotPasswordScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        name: CreateNewPasswordScreen.routeName,
        path: '/${CreateNewPasswordScreen.routeName}',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: CreateNewPasswordScreen(
              emailOrPhone: state.queryParameters["emailOrPhone"] ?? "",
              countryCode: state.queryParameters["countryCode"] ?? "",
            ),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        name: SignUpScreen.routeName,
        path: '/${SignUpScreen.routeName}',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const SignUpScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        name: OtpCodeScreen.routeName,
        path: '/${OtpCodeScreen.routeName}',
        pageBuilder: (_, GoRouterState state) {
          final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
          return getCustomTransitionPage(
            state: state,
            child: OtpCodeScreen(
              onVerify: extra['onVerify'] as Function(String)?,
              emailOrPhone: extra['emailOrPhone'],
              countryCode: extra['countryCode'],
            ),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        name: ChooseBookGenreScreen.routeName,
        path: '/${ChooseBookGenreScreen.routeName}',
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const ChooseBookGenreScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        name: ProfileScreen.routeName,
        path: "/${ProfileScreen.routeName}",
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const ProfileScreen(),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            name: SecurityAndPrivacyScreen.routeName,
            path: SecurityAndPrivacyScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const SecurityAndPrivacyScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: DeleteMyAccountScreen.routeName,
            path: DeleteMyAccountScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const DeleteMyAccountScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: ChangeEmailScreen.routeName,
            path: ChangeEmailScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const ChangeEmailScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: ChangePhoneNumberScreen.routeName,
            path: ChangePhoneNumberScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const ChangePhoneNumberScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: ChangePasswordScreen.routeName,
            path: ChangePasswordScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const ChangePasswordScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: AboutScreen.routeName,
            path: AboutScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const AboutScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: GeneralSettingsScreen.routeName,
            path: GeneralSettingsScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const GeneralSettingsScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: HelpCenterScreen.routeName,
            path: HelpCenterScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const HelpCenterScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: PrivacyPolicyScreen.routeName,
            path: PrivacyPolicyScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const PrivacyPolicyScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: TermsConditionsScreen.routeName,
            path: TermsConditionsScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const TermsConditionsScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: FAQsScreen.routeName,
            path: FAQsScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const FAQsScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: ContactSupportScreen.routeName,
            path: ContactSupportScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const ContactSupportScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: EditProfileScreen.routeName,
            path: EditProfileScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const EditProfileScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
          GoRoute(
            name: MySubscriptionScreen.routeName,
            path: MySubscriptionScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const MySubscriptionScreen(),
              );
            },
            routes: <RouteBase>[
              GoRoute(
                name: BillingHistoryScreen.routeName,
                path: BillingHistoryScreen.routeName,
                pageBuilder: (_, GoRouterState state) {
                  return getCustomTransitionPage(
                    state: state,
                    child: const BillingHistoryScreen(),
                  );
                },
                routes: const <RouteBase>[],
              ),
            ],
          ),
          GoRoute(
            name: NotificationSettingScreen.routeName,
            path: NotificationSettingScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: const NotificationSettingScreen(),
              );
            },
            routes: const <RouteBase>[],
          ),
        ],
      ),
      GoRoute(
        name: LibraryScreen.routeName,
        path: "/${LibraryScreen.routeName}",
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const LibraryScreen(),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            name: DefinitionScreen.routeName,
            path: DefinitionScreen.routeName,
            pageBuilder: (_, GoRouterState state) {
              return getCustomTransitionPage(
                state: state,
                child: DefinitionScreen(
                  definition: RouterHelper.decode(state.queryParameters, DefinitionModel.fromJson),
                ),
              );
            },
            routes: const <RouteBase>[],
          ),
        ],
      ),
      GoRoute(
        name: NotificationScreen.routeName,
        path: "/${NotificationScreen.routeName}",
        pageBuilder: (_, GoRouterState state) {
          return getCustomTransitionPage(
            state: state,
            child: const NotificationScreen(),
          );
        },
        routes: const <RouteBase>[],
      ),
      GoRoute(
        name: SearchScreen.routeName,
        path: "/${SearchScreen.routeName}",
        pageBuilder: (_, GoRouterState state) {
          final encodedValue = state.queryParameters['showPreviousSearch'];
          final showPreviousSearch = encodedValue != null
              ? utf8.decode(base64Url.decode(encodedValue)) == 'true'
              : false;

          return getCustomTransitionPage(
            state: state,
            child: SearchScreen(
              showPreviousSearch: showPreviousSearch,
            ),
          );
        },
        routes: const <RouteBase>[],
      ),
    ],
    observers: [
    MyNavigatorObserver()
  ],
    redirect: (context, state) {
      bool isScreenNotLogin =
          state.location == '/${SplashScreen.routeName}'
          || state.location == '/${OnboardingScreen.routeName}'
          || state.location == '/${SignInScreen.routeName}'
          || state.location == '/${SignUpScreen.routeName}';

      if (SharedPref.isLogin && isScreenNotLogin) return "/${HomeScreen.routeName}";
      return null;
    },
  );

  static CustomTransitionPage getCustomTransitionPage(
      {required GoRouterState state, required Widget child}) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.runtimeType == ModalBottomSheetRoute) {
      Provider.of<BottomSheetVisibilityProvider>(currentContext_!,
              listen: false)
          .updateBottomSheetVisibility(true);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is ModalRoute) {
      if (route.runtimeType == ModalBottomSheetRoute) {
        Provider.of<BottomSheetVisibilityProvider>(currentContext_!,
                listen: false)
            .updateBottomSheetVisibility(false);
      }
    }
  }
}