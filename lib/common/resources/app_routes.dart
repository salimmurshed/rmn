// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:rmnevents/presentation/all_events/page/all_events_list_view.dart';
import 'package:rmnevents/presentation/all_events/page/all_events_map_view.dart';
import 'package:rmnevents/presentation/app_settings/page/app_settings_view.dart';
import 'package:rmnevents/presentation/athlete_details/page/athlete_details_view.dart';
import 'package:rmnevents/presentation/authentication/otp/page/otp_view.dart';
import 'package:rmnevents/presentation/authentication/reset_password/page/reset_password_view.dart';
import 'package:rmnevents/presentation/base/page/base_view.dart';
import 'package:rmnevents/presentation/customer_purchases/page/customer_purchases_view.dart';
import 'package:rmnevents/presentation/event_details/page/event_detail_view.dart';

// import 'package:rmnevents/presentation/event_wise_athlete_selection/page/event_wise_athlete_registration_view.dart';
import 'package:rmnevents/presentation/get_in_touch/page/get_in_touch_contact_us_view.dart';
import 'package:rmnevents/presentation/get_in_touch/page/get_in_touch_faq_view.dart';
import 'package:rmnevents/presentation/home/page/client_home.dart';
import 'package:rmnevents/presentation/home/page/staff_home.dart';
import 'package:rmnevents/presentation/legals/page/foss_view.dart';
import 'package:rmnevents/presentation/notification/page/notification_view.dart';
import 'package:rmnevents/presentation/onboarding/page/onboarding_view.dart';
import 'package:rmnevents/presentation/placement/presentation/placement_view.dart';
import 'package:rmnevents/presentation/purchase/page/purchase_view.dart';
import 'package:rmnevents/presentation/qr_scan_view/page/qr_scan_view.dart';
import 'package:rmnevents/presentation/questionnaire/view/questionnaire_view.dart';
import 'package:rmnevents/presentation/register_and_sell/view/register_and_sell_view.dart';

import '../../app_configurations/app_environments.dart';
import '../../data/models/arguments/athlete_argument.dart';
import '../../data/models/arguments/chat_arguments.dart';
import '../../imports/common.dart';
import '../../imports/data.dart';
import '../../presentation/authentication/otp/bloc/otp_bloc.dart';
import '../../presentation/authentication/signIn_signUp/page/signIn_signUp_view.dart';
import '../../presentation/buy_season_passes/page/buy_season_passes_view.dart';
import '../../presentation/chat/page/chat_view.dart';
import '../../presentation/create_edit_profile/page/create_edit_profile_view.dart';
import '../../presentation/delete_account/page/delete_account_view.dart';
import '../../presentation/purchase/page/client_registration_view.dart';
import '../../presentation/event_details/page/event_details_with_athlete_list.dart';

// import '../../presentation/event_details/page/event_details_with_division_wise_athletes.dart';
import '../../presentation/find_customer/page/find_customer_view.dart';
import '../../presentation/get_in_touch/page/get_in_touch_view.dart';
import '../../presentation/history/page/history_view.dart';
import '../../presentation/legals/page/cms_view.dart';
import '../../presentation/legals/page/legals_view.dart';
import '../../presentation/my_athletes/page/my_athletes_view.dart';
import '../../presentation/my_purchases/page/my_purchases_view.dart';

// import '../../presentation/pos_settings/view/pos_settings_view.dart';
import '../../presentation/pos_settings/view/pos_settings_view.dart';
import '../../presentation/profile/page/profile_view.dart';
import '../../presentation/purchase/page/purchase_add_card_view.dart';
import '../../presentation/purchased_products/page/purchased_products_view.dart';
import '../../presentation/qr_codes/page/qr_codes_view.dart';
import '../../presentation/selected_customer/page/selected_customer_view.dart';
import '../../presentation/splash/page/splash_view.dart';
import '../../presentation/staff_chat/specific_event_chat_list_view/page/event_chat_list_view.dart';
import '../../presentation/staff_chat/event_general_view/page/staff_chat_view.dart';

class AppRouteNames {
  static const String routeSplash = '/';
  static const String routeSignInSignUp = '/route-sign-in';
  static const String routeSignUp = '/route-sign-up';
  static const String routeClientHome = '/route-client-home';
  static const String routeStaffHome = '/route-staff-home';
  static const String routeS700View = '/route-S700View';
  static const String routeRegisterNSell = '/route-register-n-sell';
  static const String routeStaffChat = '/route-staff-chat';
  static const String routePosSettings = '/route-pos-settings';
  static const String routeQuestionnaire = '/route-questionnaire';
  static const String routeSelectedCustomer = '/selected-customer';
  static const String routeCreateOrEditAthleteProfile =
      '/route-create-or-edit-profile';
  static const String routeOtp = '/route-otp';
  static const String routeAllEvents = '/route-all-events';
  static const String routeAllEventsOnMap = '/route-all-events-on-maps';
  static const String routeMyAthleteProfiles = '/route-my-athlete-profiles';
  static const String routeMyPurchases = '/route-my-purchases';
  static const String routeAppSettings = '/route-app-settings';
  static const String routeLegals = '/route-legals';
  static const String routeGetInTouch = '/route-get-in-touch';
  static const String routeGetInTouchContactUs =
      '/route-get-in-touch-contact-us';
  static const String routeGetInTouchAboutUs = '/route-get-in-touch-about-us';
  static const String routeGetInTouchFaq = '/route-get-in-touch-faq';
  static const String routeBase = '/route-base';
  static const String routeAthleteDetails = '/route-athlete-details';
  static const String routeProfileView = '/route-account-settings';
  static const String routePurchasedProducts = '/route-purchased-products';
  static const String routeQRCodes = '/route-QRcodes';
  static const String routeBuySeasonPasses = '/route-buy-season-passes';
  static const String routeEventDetails = '/route-event-details';
  static const String routeNotification = '/route-notification';
  static const String routeEventWiseAthleteRegistration =
      '/route-event-wise-athlete-registration';
  static const String routePurchaseRegs = '/route-event-wise-payment-section';
  static const String routePurchases = '/route-purchase-view';
  static const String routeCardForm = '/route-card-form';
  static const String routeCMS = '/route-cms';
  static const String routeFoss = '/route-foss';
  static const String routeChat = '/route-chat';
  static const String routeDeleteAccount = '/route-delete-account';
  static const String routeQRScan = '/route-qr-scan';
  static const String routeRanking = '/ranking';
  static const String routeEventAthleteSelection =
      '/route-event-athlete-selection';
  static const String routeResetPassword = '/route-reset-password';
  static const String routeOnboarding = '/route-onboarding';
  static const String eventChatList = '/route-eventChat-list';
  static const String routeHistory = '/route-history';
  static const String routeFindCustomers = '/route-find-customers';
  static const String routeCustomerPurchases = '/route-customer-purchases';
}

class Routes {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case AppRouteNames.routeSplash:
        return _createRoute(const SplashView(), AppRouteNames.routeSplash);

      case AppRouteNames.routeResetPassword:
        return _createRoute(
          ResetPasswordView(
            token: args as String?,
          ),
          AppRouteNames.routeResetPassword,
        );
      case AppRouteNames.routeFindCustomers:
        return _createRoute(
            const FindCustomerView(), AppRouteNames.routeFindCustomers);
      case AppRouteNames.routeHistory:
        return _createRoute(
          const HistoryView(),
          AppRouteNames.routeHistory,
        );
      case AppRouteNames.routePosSettings:
        return _createRoute(
          const PosSettingsView(),
          AppRouteNames.routePosSettings,
        );
   case AppRouteNames.routeSelectedCustomer:
        return _createRoute(
          const SelectedCustomerView(),
          AppRouteNames.routeSelectedCustomer,
        );

      case AppRouteNames.routeStaffChat:
        return _createRoute(
            const StaffChatView(), AppRouteNames.routeStaffChat);

      case AppRouteNames.routeRegisterNSell:
        return _createRoute(
            RegisterAndSellView(
              eventData: args as EventData,
            ),
            AppRouteNames.routeRegisterNSell);

      case AppRouteNames.routeQRScan:
        return _createRoute(const QRScanView(), AppRouteNames.routeQRScan);

      case AppRouteNames.routeOnboarding:
        return _createRoute(
            const OnboardingView(), AppRouteNames.routeOnboarding);

      case AppRouteNames.routeEventAthleteSelection:
        return _createRoute(
          const EventDetailsWithAthleteList(),
          AppRouteNames.routeEventAthleteSelection,
        );

      case AppRouteNames.routeDeleteAccount:
        return _createRoute(
            const DeleteAccountView(), AppRouteNames.routeDeleteAccount);

      case AppRouteNames.routeCreateOrEditAthleteProfile:
        return _createRoute(
          CreateEditProfileView(
            createProfileType: args as AthleteArgument,
          ),
          AppRouteNames.routeCreateOrEditAthleteProfile,
        );

      case AppRouteNames.routeNotification:
        return _createRoute(
          NotificationView(
            type: args as String?,
          ),
          AppRouteNames.routeNotification,
        );

      case AppRouteNames.routeCustomerPurchases:
        return _createRoute(
          const CustomerPurchasesView(),
          AppRouteNames.routeCustomerPurchases,
        );

      case AppRouteNames.eventChatList:
        return _createRoute(
          EventChatListView(
            arguments: args as ChatArguments,
          ),
          AppRouteNames.eventChatList,
        );

      case AppRouteNames.routeCMS:
        return _createRoute(
          CmsView(
            legals: args as Legals,
          ),
          AppRouteNames.routeCMS,
        );

      case AppRouteNames.routeRanking:
        return _createRoute(
          PlacementView(
            id: args as String,
          ),
          AppRouteNames.routeRanking,
        );

      case AppRouteNames.routeChat:
        return _createRoute(
          ChatView(
            arguments: args as ChatArguments,
          ),
          AppRouteNames.routeChat,
        );

      case AppRouteNames.routeGetInTouchFaq:
        return _createRoute(
            const GetInTouchFaqView(), AppRouteNames.routeGetInTouchFaq);

      case AppRouteNames.routeCardForm:
        return _createRoute(
            const PurchaseAddCardView(), AppRouteNames.routeCardForm);

      case AppRouteNames.routeFoss:
        return _createRoute(const FossView(), AppRouteNames.routeFoss);

      case AppRouteNames.routeGetInTouch:
        return _createRoute(
            const GetInTouchView(), AppRouteNames.routeGetInTouch);

      case AppRouteNames.routeGetInTouchContactUs:
        return _createRoute(const GetInTouchContactUsView(),
            AppRouteNames.routeGetInTouchContactUs);

      case AppRouteNames.routeSignInSignUp:
        return _createRoute(
          SigInSignUpView(
            authenticationType: args as Authentication,
          ),
          AppRouteNames.routeSignInSignUp,
        );

      case AppRouteNames.routeLegals:
        return _createRoute(const LegalsView(), AppRouteNames.routeLegals);

      case AppRouteNames.routeBase:
        return _createRoute(
          BaseView(
            justSignedIn: args as bool?,
          ),
          AppRouteNames.routeBase,
        );

      case AppRouteNames.routeClientHome:
        return _createRoute(const ClientHome(), AppRouteNames.routeClientHome);

      case AppRouteNames.routeStaffHome:
        return _createRoute(const StaffHome(), AppRouteNames.routeStaffHome);

      case AppRouteNames.routeAppSettings:
        return _createRoute(
          AppSettingsView(
            isFromOnboarding: args as bool?,
          ),
          AppRouteNames.routeAppSettings,
        );

      case AppRouteNames.routeOtp:
        return _createRoute(
          OtpView(
            otpArgument: args as OtpArgument,
          ),
          AppRouteNames.routeOtp,
        );

      case AppRouteNames.routeAllEventsOnMap:
        return _createRoute(
            const AllEventsMapView(), AppRouteNames.routeAllEventsOnMap);

      case AppRouteNames.routeAllEvents:
        return _createRoute(
            const AllEventsListView(), AppRouteNames.routeAllEvents);

      case AppRouteNames.routeQuestionnaire:
        return _createRoute(
            const QuestionnaireView(), AppRouteNames.routeQuestionnaire);

      case AppRouteNames.routeMyAthleteProfiles:
        return _createRoute(
          MyAthletesView(
            tabIndex: args as int?,
          ),
          AppRouteNames.routeMyAthleteProfiles,
        );

      case AppRouteNames.routeEventDetails:
        return _createRoute(
          EventDetailViewWithScrollAnimation(
            eventId: args as String,
          ),
          AppRouteNames.routeEventDetails,
        );

      case AppRouteNames.routeAthleteDetails:
        return _createRoute(
          AthleteDetailsView(
            athleteId: args as String,
          ),
          AppRouteNames.routeAthleteDetails,
        );

      case AppRouteNames.routeProfileView:
        return _createRoute(
            const ProfileView(), AppRouteNames.routeProfileView);

      case AppRouteNames.routeMyPurchases:
        return _createRoute(
          MyPurchasesView(
            myPurchases: args as MyPurchases?,
          ),
          AppRouteNames.routeMyPurchases,
        );

      case AppRouteNames.routePurchasedProducts:
        return _createRoute(
          PurchasedProductsView(
            eventId: args as String,
          ),
          AppRouteNames.routePurchasedProducts,
        );

      case AppRouteNames.routePurchaseRegs:
        return _createRoute(
          ClientRegistrationView(
            couponModule: args as CouponModules,
          ),
          AppRouteNames.routePurchaseRegs,
        );
        case AppRouteNames.routePurchases:
        return _createRoute(
          PurchaseView(
            couponModule: args as CouponModules,
          ),
          AppRouteNames.routePurchases,
        );

      case AppRouteNames.routeQRCodes:
        return _createRoute(
          QrCodesView(
            registrations: args as List<Registrations>,
          ),
          AppRouteNames.routeQRCodes,
        );

      case AppRouteNames.routeBuySeasonPasses:
        return _createRoute(
            const BuySeasonPassesView(), AppRouteNames.routeBuySeasonPasses);

      // Handle undefined routes
      default:
        return undefinedRoute(routeSettings);
    }
  }

  static Route<dynamic> _createRoute(Widget page, String routeName) {
    debugPrint('-------------------------------');
    debugPrint(routeName.toString());
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(2.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route<dynamic> undefinedRoute(RouteSettings routeSetting) {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppEnvironments.appName),
              ),
              body: Center(
                child: Text(routeSetting.name ?? 'null'),
              ),
            ));
  }
}
