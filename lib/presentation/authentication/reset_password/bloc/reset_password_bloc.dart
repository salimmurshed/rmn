import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/repository/authentication_repository.dart';
import 'package:rmnevents/presentation/authentication/reset_password/bloc/reset_password_handler.dart';
import 'package:rmnevents/root_app.dart';

import '../../../../data/models/request_models/reset_password_request_model.dart';
import '../../../../imports/common.dart';
import '../../../../imports/data.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

part 'reset_password_bloc.freezed.dart';

class ResetPasswordBloc
    extends Bloc<ResetPasswordEvent, ResetPasswordWithInitialState> {
  ResetPasswordBloc() : super(ResetPasswordWithInitialState.initial()) {
    on<TriggerCheckResetPasswordButtonActivity>(
        _onTriggerCheckResetPasswordButtonActivity);
    on<TriggerRequestForResetPasswordLink>(
        _onTriggerRequestForResetPasswordLink);
    on<TriggerHideUnHideFieldContentsReset>(
        _onTriggerHideUnHideFieldContentsReset);
    on<TriggerRevealPasswordCheckerReset>(_onTriggerRevealPasswordCheckerReset);
    on<TriggerRebuildFromScratch>(_onTriggerRebuildFromScratch);
    on<TriggerUpdateFieldOnChangeReset>(_onTriggerUpdateFieldOnChangeReset);
    on<TriggerSubmitNewPassword>(_onTriggerSubmitNewPassword);
  }

  FutureOr<void> _onTriggerCheckResetPasswordButtonActivity(
      TriggerCheckResetPasswordButtonActivity event,
      Emitter<ResetPasswordWithInitialState> emit) {
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isRefreshRequired: true,
    ));
    if (event.isForgotPassword) {
      String? isButtonActive =
          TextFieldValidators.validateEmail(state.emailController.text.trim());
      emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: false,
        isVerifyButtonActive: isButtonActive == null,
      ));
    } else {
      bool isButtonActive =
          TextFieldValidators.validatePasswordSecurityPolicies(
                      state.passwordController.text) ==
                  null &&
              TextFieldValidators.validatePasswordSecurityPolicies(
                      state.confirmPasswordController.text) ==
                  null && state.passwordController.text == state.confirmPasswordController.text;

      debugPrint('iii ${isButtonActive} ${state.passwordController.text} ${state.confirmPasswordController.text}');
      emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: false,
        isVerifyButtonActive: isButtonActive,
      ));
    }
  }

  FutureOr<void> _onTriggerRequestForResetPasswordLink(
      TriggerRequestForResetPasswordLink event,
      Emitter<ResetPasswordWithInitialState> emit) async {
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isLoading: true,
    ));
    try {
      final response = await AuthenticationRepository.forgotPassword(
          email: GlobalHandlers.dataEncryptionHandler(
              value: state.emailController.text));
      response.fold(
        (failure) => emit(state.copyWith(
          message: failure.message,
          isLoading: false,
          isFailure: true,
        )),
        (success) => emit(state.copyWith(
          message:
              success.responseData?.message ?? AppStrings.global_empty_string,
          isLoading: false,
          isFailure: false,
        )),
      );
      Navigator.of(navigatorKey.currentContext!).pop();
    } catch (e) {
      return emit(state.copyWith(
        message: e.toString(),
        isLoading: false,
        isFailure: true,
      ));
    }
  }

  FutureOr<void> _onTriggerHideUnHideFieldContentsReset(
      TriggerHideUnHideFieldContentsReset event,
      Emitter<ResetPasswordWithInitialState> emit) {
    ResetPasswordHandler.emitInitialState(emit: emit, state: state);
    if (event.fieldType == FieldType.password) {
      emit(state.copyWith(
        isRefreshRequired: false,
        isPasswordObscure: !state.isPasswordObscure,
      ));
    }
    if (event.fieldType == FieldType.confirmPassword) {
      emit(state.copyWith(
        isRefreshRequired: false,
        isConfirmPasswordObscure: !state.isConfirmPasswordObscure,
      ));
    }
  }

  FutureOr<void> _onTriggerRevealPasswordCheckerReset(
      TriggerRevealPasswordCheckerReset event,
      Emitter<ResetPasswordWithInitialState> emit) {
    ResetPasswordHandler.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
      isRefreshRequired: false,
      isPasswordCheckerHidden: false,
    ));
  }

  FutureOr<void> _onTriggerRebuildFromScratch(TriggerRebuildFromScratch event,
      Emitter<ResetPasswordWithInitialState> emit) async {
    emit(ResetPasswordWithInitialState.initial());
    DataBaseUser user = await GlobalHandlers.extractUserHandler();
    bool isPasswordChangeRequired = user.isPasswordChangeRequired ?? false;
    emit(state.copyWith(
      isPasswordChangeRequired: isPasswordChangeRequired,
    ));
  }

  FutureOr<void> _onTriggerUpdateFieldOnChangeReset(
      TriggerUpdateFieldOnChangeReset event,
      Emitter<ResetPasswordWithInitialState> emit) {
    ResetPasswordHandler.emitInitialState(emit: emit, state: state);
    bool isAtLeastEightCharChecked =
        GlobalHandlers.passwordFieldValidationAgainstChecker(
            passwordChecker: PasswordChecker.isAtLeastEightCharChecked,
            value: event.value);
    bool isAtLeastOneLowerCaseChecked =
        GlobalHandlers.passwordFieldValidationAgainstChecker(
            passwordChecker: PasswordChecker.isAtLeastOneLowerCaseChecked,
            value: event.value);
    bool isAtLeastOneUpperCaseChecked =
        GlobalHandlers.passwordFieldValidationAgainstChecker(
            passwordChecker: PasswordChecker.isAtLeastOneUpperCaseChecked,
            value: event.value);
    bool isAtLeastOneDigitChecked =
        GlobalHandlers.passwordFieldValidationAgainstChecker(
            passwordChecker: PasswordChecker.isAtLeastOneDigitChecked,
            value: event.value);
    bool isAtLeastOneSpecialCharChecked =
        GlobalHandlers.passwordFieldValidationAgainstChecker(
            passwordChecker: PasswordChecker.isAtLeastOneSpecialCharChecked,
            value: event.value);
    emit(state.copyWith(
      isRefreshRequired: false,
      isAtLeastEightCharChecked: isAtLeastEightCharChecked,
      isAtLeastOneLowerCaseChecked: isAtLeastOneLowerCaseChecked,
      isAtLeastOneUpperCaseChecked: isAtLeastOneUpperCaseChecked,
      isAtLeastOneDigitChecked: isAtLeastOneDigitChecked,
      isAtLeastOneSpecialCharChecked: isAtLeastOneSpecialCharChecked,
    ));
  }

  FutureOr<void> _onTriggerSubmitNewPassword(TriggerSubmitNewPassword event,
      Emitter<ResetPasswordWithInitialState> emit) async {
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isLoading: true,
    ));
    DataBaseUser user = await GlobalHandlers.extractUserHandler();
    bool isPasswordChangeRequired = user.isPasswordChangeRequired ?? false;
    try {
      final response = isPasswordChangeRequired ?
      await AuthenticationRepository.changeInitialPassword(
          newPassword: GlobalHandlers.dataEncryptionHandler(
              value: state.confirmPasswordController.text)) :
      await AuthenticationRepository.resetPassword(
          resetPasswordRequest: ResetPasswordRequestModel(
        confirmPassword: GlobalHandlers.dataEncryptionHandler(
            value: state.confirmPasswordController.text),
        newPassword: GlobalHandlers.dataEncryptionHandler(
            value: state.passwordController.text),
        token:  event.token,
      ));
      response.fold(
          (failure) => emit(state.copyWith(
                message: failure.message,
                isLoading: false,
                isFailure: true,
              )), (success) {
        emit(state.copyWith(
          message:
              success.responseData?.message ?? AppStrings.global_empty_string,
          isLoading: false,
          isFailure: false,
        ));


      });
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
        message: e.toString(),
        isLoading: false,
        isFailure: true,
      ));
    }
  }

}
