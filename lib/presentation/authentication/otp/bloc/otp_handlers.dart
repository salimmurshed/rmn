import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../imports/common.dart';
import 'otp_bloc.dart';

class OtpHandlers {
  static AnimationController handleAnimationControllerInitialization(
      {required TickerProvider vsync}) {
    return AnimationController(
        vsync: vsync, duration: const Duration(seconds: 60))
      ..forward();
  }



  static bool handleToCheckIfAllFieldsAreFilled(
      {required List<TextEditingController> pinControllers}) {
    return pinControllers.every((element) => element.text.isNotEmpty);
  }

  static String handlePinExtraction(
      {required List<TextEditingController> pinControllers}) {
    return pinControllers
        .map((e) => StringManipulation.trimString(value: e.text))
        .join();
  }

  static void emitInitialState(
      {required Emitter<OtpWithInitialState> emit,
      required OtpWithInitialState state}) {
    emit(state.copyWith(
      isResendOtpResponse: false,
      message: AppStrings.global_empty_string,
      isErrorTextHidden: true,
      isRefreshRequired: true,
    ));
  }
  static void emitWithLoader(
      {required Emitter<OtpWithInitialState> emit,
        required OtpWithInitialState state}) {
    emit(state.copyWith(
      isResendOtpResponse: false,
      message: AppStrings.global_empty_string,
      isLoading: true,
      isFailure: false,
      isErrorTextHidden: true,
      isRefreshRequired: true,
    ));
  }
}
