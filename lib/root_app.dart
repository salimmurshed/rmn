import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:rmnevents/imports/app_configurations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rmnevents/presentation/all_events/bloc/all_events_bloc.dart';
import 'package:rmnevents/presentation/app_settings/bloc/app_settings_bloc.dart';
import 'package:rmnevents/presentation/athlete_details/bloc/athlete_details_bloc.dart';
import 'package:rmnevents/presentation/authentication/otp/bloc/otp_bloc.dart';
import 'package:rmnevents/presentation/authentication/reset_password/bloc/reset_password_bloc.dart';
import 'package:rmnevents/presentation/authentication/signIn_signUp/bloc/sign_in_sign_up_bloc.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';
import 'package:rmnevents/presentation/buy_season_passes/bloc/buy_season_passes_bloc.dart';
import 'package:rmnevents/presentation/chat/bloc/chat_bloc.dart';
import 'package:rmnevents/presentation/create_edit_profile/bloc/create_edit_profile_bloc.dart';
import 'package:rmnevents/presentation/customer_purchases/bloc/customer_purchases_bloc.dart';
import 'package:rmnevents/presentation/customer_purchases/page/customer_purchases_view.dart';
import 'package:rmnevents/presentation/delete_account/bloc/delete_bloc.dart';
import 'package:rmnevents/presentation/event_athletes/bloc/event_athletes_bloc.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';
import 'package:rmnevents/presentation/find_customer/bloc/find_customer_bloc.dart';

// import 'package:rmnevents/presentation/event_wise_athlete_selection/bloc/event_wise_athlete_selection_bloc.dart';
import 'package:rmnevents/presentation/get_in_touch/bloc/get_in_touch_bloc.dart';
import 'package:rmnevents/presentation/home/client_home_bloc/client_home_bloc.dart';
import 'package:rmnevents/presentation/home/staff_home_bloc/staff_home_bloc.dart';
import 'package:rmnevents/presentation/legals/bloc/legals_bloc.dart';
import 'package:rmnevents/presentation/my_athletes/bloc/my_athletes_bloc.dart';
import 'package:rmnevents/presentation/my_purchases/bloc/my_purchases_bloc.dart';
import 'package:rmnevents/presentation/notification/bloc/notification_bloc.dart';
import 'package:rmnevents/presentation/placement/bloc/placement_bloc.dart';
import 'package:rmnevents/presentation/pos_settings/bloc/pos_settings_bloc.dart';

// import 'package:rmnevents/presentation/pos_settings/bloc/pos_settings_bloc.dart';
import 'package:rmnevents/presentation/profile/bloc/profile_bloc.dart';
import 'package:rmnevents/presentation/purchase/bloc/purchase_bloc.dart';
import 'package:rmnevents/presentation/purchased_products/bloc/purchased_products_bloc.dart';
import 'package:rmnevents/presentation/qr_codes/bloc/qr_codes_bloc.dart';
import 'package:rmnevents/presentation/qr_scan_view/bloc/qr_scan_bloc.dart';
import 'package:rmnevents/presentation/questionnaire/bloc/questionnaire_bloc.dart';
import 'package:rmnevents/presentation/register_and_sell/bloc/register_and_sell_bloc.dart';
import 'package:rmnevents/presentation/selected_customer/bloc/selected_customer_bloc.dart';
import 'package:rmnevents/presentation/selected_customer/page/selected_customer_view.dart';
import 'package:rmnevents/presentation/splash/bloc/splash_bloc.dart';
import 'package:rmnevents/presentation/staff_chat/event_general_view/bloc/staff_chat_bloc.dart';
import 'package:rmnevents/presentation/staff_chat/specific_event_chat_list_view/bloc/event_chat_list_bloc.dart';
import 'package:rmnevents/presentation/staff_chat/user_chat_list/bloc/user_chat_list_bloc.dart';
import 'package:rmnevents/services/force_update.dart';
import 'package:rmnevents/services/shared_preferences_services/app_data.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'di/di.dart';
import 'firebase_options.dart';
import 'imports/common.dart';
import 'imports/services.dart';

String globalDarkMapStyle = AppStrings.global_empty_string;
bool isTablet = false;

class RouteObserverProvider {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}

Future<void> mainDelegateForEnvironments() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  const fatalError = true;
  await messaging.requestPermission();
  tz.initializeTimeZones();
  await FirebaseCloudMessage()
      .setUpNotificationServiceForOS(isCalledFromBg: true);
  if (await instance<AppData>().isCrashCollectionActivated()) {
    // Non-async exceptions
    FlutterError.onError = (errorDetails) {
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        // ignore: dead_code
      } else {
        // If you want to record a "non-fatal" exception
        FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      }
    };
    // Async exceptions
    PlatformDispatcher.instance.onError = (error, stack) {
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        // ignore: dead_code
      } else {
        // If you want to record a "non-fatal" exception
        FirebaseCrashlytics.instance.recordError(error, stack);
      }
      return true;
    };
  }
  Stripe.publishableKey = AppEnvironments.stripePublishableKey;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(RootApp()));
  globalDarkMapStyle = await rootBundle.loadString(AppAssets.jsonGoogleMapDark);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final botToastBuilder = BotToastInit();

class RootApp extends StatefulWidget {
  const RootApp._internal();

  static const RootApp instance = RootApp._internal();

  factory RootApp() => instance;

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.colorPrimary,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.colorPrimary,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    if (Platform.isAndroid) {
      checkForUpdate();
    } else {
      Future.delayed(const Duration(seconds: 7), () {
        ForceUpdateChecker.checkForUpdate(context);
      });
    }
    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _setOrientation();
  }

  void _setOrientation() {
    if (MediaQuery.of(context).size.shortestSide >= 600) {
      // Device is a tablet
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp, //could set landscape if needed in future
      ]);
      isTablet = true;
    } else {
      // Device is a phone
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      isTablet = false;
    }
  }

  void checkForUpdate() async {
    final updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      await InAppUpdate.performImmediateUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BuySeasonPassesBloc(),
        ),
        BlocProvider(
          create: (context) => PosSettingsBloc(),
        ),
        BlocProvider(
          create: (context) => ResetPasswordBloc(),
        ),
        BlocProvider(
          create: (context) => QuestionnaireBloc(),
        ),
        BlocProvider(
          create: (context) => CustomerPurchasesBloc(),
        ),
        BlocProvider(
          create: (context) => FindCustomerBloc(),
        ),
        BlocProvider(
          create: (context) => SignInSignUpBloc(),
        ),
        BlocProvider(
          create: (context) => ChatBloc(),
        ),
        BlocProvider(
          create: (context) => GetInTouchBloc(),
        ),
        BlocProvider(
          create: (context) => PlacementBloc(),
        ),
        BlocProvider(
          create: (context) => PurchasedProductsBloc(),
        ),
        BlocProvider(
          create: (context) => LegalsBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider(
          create: (context) => PurchaseBloc(),
        ),
        BlocProvider(
          create: (context) => BaseBloc(),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(),
        ),
        BlocProvider(
          create: (context) => DeleteBloc(),
        ),
        BlocProvider(
          create: (context) => SplashBloc(),
        ),
        BlocProvider(
          create: (context) => ClientHomeBloc(),
        ),
        BlocProvider(
          create: (context) => SelectedCustomerBloc(),
        ),
        BlocProvider(
          create: (context) => StaffHomeBloc(),
        ),
        BlocProvider(
          create: (context) => AllEventsBloc(),
        ),
        BlocProvider(
          create: (context) => AppSettingsBloc(),
        ),
        BlocProvider(
          create: (context) => AthleteDetailsBloc(),
        ),
        BlocProvider(
          create: (context) => OtpBloc(),
        ),
        BlocProvider(
          create: (context) => EventAthletesBloc(),
        ),
        BlocProvider(
          create: (context) => EventDetailsBloc(),
        ),
        // BlocProvider(
        //   create: (context) => EventWiseAthleteSelectionBloc(),
        // ),
        BlocProvider(
          create: (context) => MyAthletesBloc(),
        ),
        BlocProvider(
          create: (context) => MyPurchasesBloc(),
        ),
        BlocProvider(
          create: (context) => CreateEditProfileBloc(),
        ),
        BlocProvider(
          create: (context) => MyPurchasesBloc(),
        ),
        BlocProvider(
          create: (context) => QrScanBloc(),
        ),
        BlocProvider(
          create: (context) => QrCodesBloc(),
        ),
        BlocProvider(
          create: (context) => StaffChatBloc(),
        ),
        BlocProvider(
          create: (context) => EventChatListBloc(),
        ),
        BlocProvider(
          create: (context) => UserChatListBloc(),
        ),
        // BlocProvider(
        //   create: (context) => PosSettingsBloc(),
        // ),
        BlocProvider(
          create: (context) => RegisterAndSellBloc(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: false,
          builder: (context, child) {
            return MaterialApp(
              localizationsDelegates: const [
                // GlobalWidgetsLocalizations.delegate,
                // GlobalMaterialLocalizations.delegate,
                // MonthYearPickerLocalizations.delegate,
              ],
              navigatorObservers: [RouteObserverProvider.routeObserver],
              theme: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: AppColors.colorPrimaryAccent,
                  selectionHandleColor: AppColors.colorPrimaryAccent,
                  selectionColor: AppColors.colorPrimaryAccent,
                ),
                // you can decide app bar themes here
              ),
              debugShowCheckedModeBanner: false,
              //AppEnvironments.debugBannerBoolean,
              builder: (ctx, child) {
                //ScreenUtil.init(ctx);
                child = botToastBuilder(context, child);

                return ResponsiveBreakpoints.builder(
                  child: child,
                  breakpoints: [
                    const Breakpoint(start: 0, end: 450, name: MOBILE),
                    const Breakpoint(start: 451, end: 800, name: TABLET),
                    const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                    const Breakpoint(
                        start: 1921, end: double.infinity, name: '4K'),
                  ],
                );
              },
              initialRoute: AppRouteNames.routeSplash,
              onGenerateRoute: Routes.getRoute,
              title: AppEnvironments.appName,
              navigatorKey: navigatorKey,
            );
          }),
    );
  }
}
