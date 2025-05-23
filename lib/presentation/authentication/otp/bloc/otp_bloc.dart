import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/imports/services.dart';
import 'package:rmnevents/root_app.dart';
import '../../../../data/models/arguments/athlete_argument.dart';
import '../../../../di/di.dart';
import '../../../../imports/common.dart';
import '../../../../imports/data.dart';
import 'otp_handlers.dart';

part 'otp_event.dart';

part 'otp_state.dart';

part 'otp_bloc.freezed.dart';

class OtpBloc extends Bloc<OtpEvent, OtpWithInitialState> {
  late AnimationController animationController;
  late Animation<double> animation;

  OtpBloc() : super(OtpWithInitialState.initial()) {
    on<TriggerAnimationInitialization>(_onTriggerAnimationInitialization);
    on<TriggerTrackingAnimationProgress>(_onTriggerTrackingAnimationProgress);
    on<TriggerVerifyEmail>(_onTriggerVerifyEmail);
    on<TriggerShowErrorText>(_onTriggerShowErrorText);
    on<TriggerResendCode>(_onTriggerResendCode);
    on<TriggerUpdateEmail>(_onTriggerUpdateEmail);
    on<TriggerOtpLengthVerification>(_onTriggerOtpLengthVerification);
  }

  FutureOr<void> _onTriggerAnimationInitialization(
      TriggerAnimationInitialization event,
      Emitter<OtpWithInitialState> emit) async {
    emit(OtpWithInitialState.initial());

    if (!event.isFromChangeEmail) {
      await instance<UserCachedData>().setUserEmail(email: event.email);
    }
    animationController =
        OtpHandlers.handleAnimationControllerInitialization(vsync: event.vsync);
    animation =
        Tween<double>(begin: 60.0, end: 0.0).animate(animationController)
          ..addListener(() {
            add(TriggerTrackingAnimationProgress());
          });
    emit(state.copyWith(
        isRefreshRequired: false,
        email: event.email,
        animationPercentValue: animation.value / 60,
        animationController: animationController));
    // if (event.isResendCode) {
    //   add(TriggerResendCode(vsync: event.vsync, email: event.email));
    // }
  }

  FutureOr<void> _onTriggerTrackingAnimationProgress(
      TriggerTrackingAnimationProgress event,
      Emitter<OtpWithInitialState> emit) {
    OtpHandlers.emitInitialState(emit: emit, state: state);

    bool isAnimationTerminated = false;
    if (animation.status == AnimationStatus.forward) {
      isAnimationTerminated = false;
    } else {
      isAnimationTerminated = true;
    }
    emit(state.copyWith(
      isRefreshRequired: false,
      animationPercentValue: animation.value / 60,
      animationValueProgressValue: animation.value.round(),
      isAnimationTerminated: isAnimationTerminated,
    ));
  }

  FutureOr<void> _onTriggerVerifyEmail(
      TriggerVerifyEmail event, Emitter<OtpWithInitialState> emit) async {
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isFailure: false,
      isLoading: true,
      isRefreshRequired: false,
      isErrorTextHidden: true,
    ));
    String otp =
        OtpHandlers.handlePinExtraction(pinControllers: state.pinControllers);
    String encryptedOtp = GlobalHandlers.dataEncryptionHandler(value: otp);
    String message = AppStrings.global_empty_string;
    bool isFailure = false;
    try {
      final response = await AuthenticationRepository.verifyEmail(
          verifyEmailRequestModel: VerifyEmailRequestModel(
        encryptedUserId: event.encryptedUserId,
        encryptedOtp: encryptedOtp,
      ));
      response.fold((failure) {
        message = failure.message;
        isFailure = true;
        emit(state.copyWith(
          message: message,
          isFailure: isFailure,
          isLoading: false,
          isRefreshRequired: false,
          isErrorTextHidden: true,
        ));
      }, (success) {
        message = success.responseData!.message!;
        isFailure = false;
        emit(state.copyWith(
          message: message,
          isFailure: isFailure,
          isLoading: false,
          isRefreshRequired: false,
          isErrorTextHidden: true,
        ));
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!,
            arguments: AthleteArgument(
              createProfileType: CreateProfileTypes.createProfileForOwner
            ),
            AppRouteNames.routeCreateOrEditAthleteProfile,
            (route) => false);
      });
    } catch (e) {
      message = e.toString();
      isFailure = true;
      emit(state.copyWith(
        message: message,
        isFailure: isFailure,
        isLoading: false,
        isRefreshRequired: false,
        isErrorTextHidden: true,
      ));
    }
  }

  FutureOr<void> _onTriggerResendCode(
      TriggerResendCode event, Emitter<OtpWithInitialState> emit) async {
    // OtpHandlers.emitWithLoader(emit: emit, state: state);
    emit(state.copyWith(
      isResendOtpResponse: false,
      message: AppStrings.global_empty_string,
      isLoading: true,
      isFailure: false,
      isErrorTextHidden: true,
      isRefreshRequired: true,
      pinControllers: List.generate(6, (index) => TextEditingController()),
      pinFocusNodes: List.generate(6, (index) => FocusNode()),
      formKey: GlobalKey<FormState>(),
    ));
    String message = AppStrings.global_empty_string;
    bool isResendOtpResponse = false;
    bool isFailure = false;
    try {
      String encryptedEmail =
          GlobalHandlers.dataEncryptionHandler(value: event.email);
      final response = await AuthenticationRepository.resendOtp(
          encryptedEmail: encryptedEmail);
      response.fold(
        (failure) {
          message = failure.message;
          isFailure = true;
          isResendOtpResponse = true;
          emit(state.copyWith(
              message: message,
              isResendOtpResponse: isResendOtpResponse,
              isFailure: isFailure,
              isLoading: false,
              email: event.email,
              isRefreshRequired: false,
              isErrorTextHidden: true));
        },
        (success) {
          message = success.responseData!.message!;
          isFailure = false;
          isResendOtpResponse = true;
          emit(state.copyWith(
              message: message,
              isResendOtpResponse: isResendOtpResponse,
              isFailure: isFailure,
              isLoading: false,
              email: event.email,
              isRefreshRequired: false,
              isErrorTextHidden: true));
          add(TriggerAnimationInitialization(
              vsync: event.vsync,
              isResendCode: true,
              isFromChangeEmail: event.isFromChangeEmail,
              email: event.email));
        },
      );
    } catch (e) {
      message = e.toString();
      isFailure = true;
      isResendOtpResponse = true;
      emit(state.copyWith(
          message: message,
          isResendOtpResponse: isResendOtpResponse,
          isFailure: isFailure,
          isLoading: false,
          email: event.email,
          isRefreshRequired: false,
          isErrorTextHidden: true));
    }
  }

  FutureOr<void> _onTriggerShowErrorText(
      TriggerShowErrorText event, Emitter<OtpWithInitialState> emit) {
    OtpHandlers.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
      isRefreshRequired: false,
      isErrorTextHidden: false,
    ));
  }

  FutureOr<void> _onTriggerOtpLengthVerification(
      TriggerOtpLengthVerification event, Emitter<OtpWithInitialState> emit) {
    // OtpHandlers.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: false,
        isOnChange: true
        // isVerifyButtonActive: isVerifyButtonActive,
        ));
    bool isVerifyButtonActive = OtpHandlers.handleToCheckIfAllFieldsAreFilled(
        pinControllers: state.pinControllers);
    if (isVerifyButtonActive) {
      emit(state.copyWith(
        isRefreshRequired: false,
        isOnChange: false,
      ));
      if (event.isFromChangeEmail) {
        add(TriggerUpdateEmail());
      } else {
        add(
          TriggerVerifyEmail(encryptedUserId: event.encryptedUserId),
        );
      }
    }
    emit(state.copyWith(
      isRefreshRequired: false,
      // isVerifyButtonActive: isVerifyButtonActive,
    ));
  }

  FutureOr<void> _onTriggerUpdateEmail(
      TriggerUpdateEmail event, Emitter<OtpWithInitialState> emit) async {
    OtpHandlers.emitWithLoader(emit: emit, state: state);
    String otp =
        OtpHandlers.handlePinExtraction(pinControllers: state.pinControllers);

    String encryptedEmail =
        GlobalHandlers.dataEncryptionHandler(value: state.email);
    try {
      final response = await OwnerProfileRepository.updateEmail(
          email: encryptedEmail, otp: otp);
      response.fold((failure) {
        emit(state.copyWith(
          message: failure.message,
          isFailure: true,
          isLoading: false,
          isRefreshRequired: false,
          isErrorTextHidden: true,
        ));
      }, (success) async {
        emit(state.copyWith(
          message: success.responseData!.message!,
          isFailure: false,
          isLoading: false,
          isRefreshRequired: false,
        ));
        await instance<UserCachedData>()
            .removeSharedPreferencesGeneralFunction(UserKeyManager.userEmail);
        await instance<UserCachedData>().setUserEmail(email: state.email);
        DataBaseUser user = await GlobalHandlers.extractUserHandler();
        user.email = state.email;
        await instance<UserCachedData>()
            .removeSharedPreferencesGeneralFunction(UserKeyManager.userInfo);
        await instance<UserCachedData>()
            .setUserInfo(jsonEncodedValue: jsonEncode(user.toJson()));
        Navigator.pop(navigatorKey.currentContext!);
      });
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        isFailure: true,
        isLoading: false,
        isRefreshRequired: false,
        isErrorTextHidden: true,
      ));
    }
  }
}
