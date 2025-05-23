import 'package:flutter/material.dart';

import '../../di/di.dart';
import '../../imports/common.dart';
import '../../imports/data.dart';
import '../../imports/services.dart';
import '../../root_app.dart';
import '../../services/shared_preferences_services/athlete_cached_data.dart';
import '../../services/shared_preferences_services/history_cached_data.dart';
import '../../services/shared_preferences_services/pop_up_cached_data.dart';
import '../../services/shared_preferences_services/staff_event_cached_data.dart';
import '../../services/shared_preferences_services/stripe_reader_cached_data.dart';

class Failure {
  int code; // 200 or 400
  String message; // error or success

  Failure({required this.code, this.message = AppStrings.global_empty_string});
}

class ResponseCode {
  static const int DEFAULT = -1;
  static const int NO_INTERNET_CONNECTION = -7;
}
//
//
remove()async{
  String id =
      await RepositoryDependencies.userCachedData.getUserId() ?? '';
  await messaging.unsubscribeFromTopic(id);
  await RepositoryDependencies.userCachedData.removeUserDataCache();
  await instance<PopUpCachedData>()
      .removeSharedPreferencesGeneralFunction(PopKeyManager.popUPId);
  await instance<HistoryCachedData>()
      .removeSharedPreferencesGeneralFunction(
      HistoryKeyManager.history);
  await instance<AthleteCachedData>()
      .removeSharedPreferencesGeneralFunction('athlete_list');
  await instance<AthleteCachedData>()
      .removePreselectAthleteData();
  await instance<StripeReaderCachedData>()
      .removeSharedPreferencesGeneralFunction(StripeReaderManager.stripeReader);
  await instance<StaffEventCachedData>()
      .removeSharedPreferencesGeneralFunction(
      EventDataManager.eventData);
}

class AppExceptions implements Exception {
  late Failure failure;
  UserCachedData userData = instance<UserCachedData>();

  AppExceptions.handle({required Failure caughtFailure}) {
    if (caughtFailure.code == 401) {
      remove();
      failure = caughtFailure;
      remove();
      Navigator.pushNamedAndRemoveUntil(navigatorKey.currentState!.context,
          arguments: Authentication.signIn,
          AppRouteNames.routeSignInSignUp, (route) => false);
    } else if (caughtFailure.code == ResponseCode.NO_INTERNET_CONNECTION) {
      caughtFailure.message = AppStrings.global_noInternet_text;
      failure = caughtFailure;
    } else if (caughtFailure.code == ResponseCode.DEFAULT) {
      failure = caughtFailure;
    } else {
      failure = caughtFailure;
    }
  }
}
String extractErrorMessage(dynamic error) {
  if (error is Failure) {
    return error.message;
  }
  String errorMessage = 'An unexpected error occurred';
  if (error is Exception) {
    try {
      final dynamicError = error as dynamic;
      if (dynamicError.message != null) {
        errorMessage = dynamicError.message;
      } else if (dynamicError.toString().contains('message')) {
        errorMessage = error.toString().split('message:').last.trim();
      }
    } catch (_) {
      errorMessage = error.toString();
    }
  } else {
    errorMessage = error.toString();
  }
  return errorMessage;
}