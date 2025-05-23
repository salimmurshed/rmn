import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/presentation/profile/bloc/profile_handlers.dart';

import '../../../di/di.dart';
import '../../../imports/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../imports/data.dart';
import '../../../imports/services.dart';
import '../../../root_app.dart';
import '../../../services/shared_preferences_services/athlete_cached_data.dart';
import '../../../services/shared_preferences_services/history_cached_data.dart';
import '../../../services/shared_preferences_services/pop_up_cached_data.dart';
import '../../../services/shared_preferences_services/stripe_reader_cached_data.dart';
import '../../base/bloc/base_bloc.dart';

part 'profile_events.dart';

part 'profile_state.dart';

part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileWithInitialState> {
  String email = AppStrings.global_empty_string;
  String fullName = AppStrings.global_empty_string;
  String phone = AppStrings.global_empty_string;
  String athleteCount = AppStrings.global_empty_string;
  String upComingCount = AppStrings.global_empty_string;
  String awardsCount = AppStrings.global_empty_string;
  String profileImage = AppStrings.global_empty_string;
  String userCurrentRole = AppStrings.global_empty_string;

  bool showSwitch = false;

  ProfileBloc() : super(ProfileWithInitialState.initial()) {
    on<TriggerGetProfileData>(_onTriggerGetProfileData);
    on<TriggerUpdateProfile>(_onTriggerUpdateProfile);
    on<TriggerLogout>(_onTriggerLogout);
  }

  FutureOr<void> _onTriggerGetProfileData(TriggerGetProfileData event,
      Emitter<ProfileWithInitialState> emit) async {
    try {
      DataBaseUser user = await GlobalHandlers.extractUserHandler();
      email = await instance<UserCachedData>().getUserEmail() ??
          user.email ??
          AppStrings.global_empty_string;
      athleteCount = user.athletesCount.toString();
      upComingCount = user.upcomingEventsCount.toString();
      awardsCount = user.awardsCount.toString();
      profileImage = user.profile ?? AppStrings.global_empty_string;
      fullName = AccountSettingsHandlers.extractFullNameHandler(user: user);
      phone = user.phoneNumber ?? AppStrings.global_empty_string;
      String setCurrentRole =
          await instance<UserCachedData>().getCurrentRole() ??
              AppStrings.global_empty_string;

      if (setCurrentRole.isNotEmpty) {
        if (user.roles!.contains(setCurrentRole)) {
          userCurrentRole = setCurrentRole;
        } else {
          userCurrentRole = user.currentRole ?? AppStrings.global_empty_string;
        }
      } else {
        userCurrentRole = user.currentRole ?? AppStrings.global_empty_string;
      }


      showSwitch = user.canSwitch ?? false;

      emit(state.copyWith(
          isFailure: true,
          isLoadingForUserInfo: false,
          isLoadingForLogout: false,
          message: AppStrings.global_empty_string,
          cachedNetworkImageUrl: profileImage,
          email: email,
          fullName: fullName,
          phone: phone,
          noOfAthletes: athleteCount,
          noOfAwards: awardsCount,
          noOfUpcomingEvents: upComingCount,
          currentUser: userCurrentRole,
          isSwitchPresent: showSwitch,
          label: user.label == AppStrings.global_role_user
              ? AppStrings.global_empty_string
              : user.label!));
      if(event.isFromRestart) {
        BlocProvider.of<BaseBloc>(navigatorKey.currentContext!)
            .add(TriggerFetchBaseData(
          isFromRestart:true,currentRole: userCurrentRole,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isFailure: true,
        message: e.toString(),
        isLoadingForUserInfo: false,
        isLoadingForLogout: false,
      ));
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
      Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!,
          AppRouteNames.routeSignInSignUp,
          arguments: Authentication.signIn,
          (route) => false);
    }
  }

  FutureOr<void> _onTriggerLogout(
      TriggerLogout event, Emitter<ProfileWithInitialState> emit) async {
    emit(state.copyWith(
      isLoadingForUserInfo: false,
      isLoadingForLogout: true,
      message: AppStrings.global_empty_string,
      isFailure: false,
    ));
    try {
      final response = await AuthenticationRepository.logOut();
      response.fold((failure) {
        emit(state.copyWith(
          isLoadingForUserInfo: false,
          isLoadingForLogout: false,
          isFailure: true,
          message: failure.message,
        ));
      }, (success) {
        socket?.disconnect();
        socket?.close();
        socket?.clearListeners();
        emit(state.copyWith(
          isLoadingForUserInfo: false,
          isLoadingForLogout: false,
          isFailure: false,
          message: success.responseData!.message!,
        ));
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!,
            AppRouteNames.routeSignInSignUp,
            arguments: Authentication.signIn,
            (route) => false);
      });
    } catch (e) {
      emit(state.copyWith(
        isLoadingForUserInfo: false,
        isLoadingForLogout: false,
        isFailure: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerUpdateProfile(
      TriggerUpdateProfile event, Emitter<ProfileWithInitialState> emit) async {
    emit(state.copyWith(
      isLoadingForUserInfo: true,
      isLoadingForLogout: false,
      message: AppStrings.global_empty_string,
      isFailure: false,
    ));
    try {
      final response = await OwnerProfileRepository.getProfile();
      response.fold((failure) {
        emit(state.copyWith(
          isLoadingForUserInfo: false,
          isLoadingForLogout: false,
          isFailure: true,
          //  message: failure.message,
        ));
        debugPrint(failure.message);
      }, (success) {
        emit(state.copyWith(
          isLoadingForUserInfo: false,
          isLoadingForLogout: false,
          isFailure: false,

          //  message: success.responseData!.message!,
        ));
        add(TriggerGetProfileData(
          isFromRestart: event.isFromRestart,
        ));
        // if (event.isFromRestart) {
        //   BlocProvider.of<BaseBloc>(navigatorKey.currentContext!)
        //       .add(TriggerFetchBaseData(
        //     isFromRestart: true,
        //   ));
        // }
      });
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
        isLoadingForUserInfo: false,
        isLoadingForLogout: false,
        isFailure: true,
        // message: e.toString(),
      ));
    }
  }
}
