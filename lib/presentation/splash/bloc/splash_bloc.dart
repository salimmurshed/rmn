import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../../../imports/services.dart';
import '../../../root_app.dart';

part 'splash_event.dart';

part 'splash_state.dart';

part 'splash_bloc.freezed.dart';

class SplashBloc extends Bloc<SplashEvent, SplashWithInitialState> {
  final UserCachedData userData = instance<UserCachedData>();

  SplashBloc() : super(SplashWithInitialState.initial()) {
    on<TriggerSplashNavigation>(_onTriggerSplashNavigation);
    on<TriggerSplashTiming>(_onTriggerSplashTiming);
    on<TriggerCheckForDynamic>(_onTriggerCheckForDynamic);
  }

  FutureOr<void> _onTriggerSplashNavigation(TriggerSplashNavigation event,
      Emitter<SplashWithInitialState> emit) async {
    bool isFirstTimeUser = await userData.isFirstTimeUser();
    if (!isFirstTimeUser) {
      bool isUserSignedIn = await userData.isUserSignedIn();
      if (isUserSignedIn) {
        emit(state.copyWith(
          routeName: AppRouteNames.routeBase,
        ));
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!,
            AppRouteNames.routeBase,
            arguments: false,
            (route) => false);
        debugPrint('it is the route ${ModalRoute.of(navigatorKey.currentContext!)?.settings.name}');
      } else {
        emit(state.copyWith(
          routeName: AppRouteNames.routeSignInSignUp,
        ));
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!,
            AppRouteNames.routeSignInSignUp,
            arguments: Authentication.signIn,
            (route) => false);
      }
    }
    else {
      emit(state.copyWith(routeName: AppRouteNames.routeOnboarding));
      Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
          AppRouteNames.routeOnboarding, (route) => false);
    }
  }

  FutureOr<void> _onTriggerSplashTiming(
      TriggerSplashTiming event, Emitter<SplashWithInitialState> emit) async {
    await getAPNToken();
    DeviceInfoPlugin().deviceInfo.then((value) {});

    //FirebaseCloudMessage().setUpNotificationServiceForOS(isCalledFromBg: false);
    Future.delayed(const Duration(seconds: 5), () {
      add(TriggerCheckForDynamic());
    });
  }

  FutureOr<void> _onTriggerCheckForDynamic(TriggerCheckForDynamic event,
      Emitter<SplashWithInitialState> emit)
  async {
    Uri? deepLink = await ResetPasswordDynamicLinkServices
        .resetDynamicLinkFromTerminatedState();
    if (deepLink == null || ['com.rmnevents', 'com.rmnevents.dev'].contains(deepLink.scheme)) {
      String? deepLinkExtracted;
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        deepLinkExtracted = await ResetPasswordDynamicLinkServices
            .resetDynamicLinkOnBackgroundOrForeground();
      });
      debugPrint("deepLinkExtracted=> $deepLinkExtracted");
      if (deepLinkExtracted == null) {
        add(TriggerSplashNavigation());
      }
    } else {
      emit(state.copyWith(isRefreshRequired: false));
      debugPrint('deeplink from else $deepLink');
      ResetPasswordDynamicLinkServices
          .resetDynamicLinkObtainedFromTerminatedState(deepLink: deepLink);
    }
  }
}
