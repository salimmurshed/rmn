part of 'reset_password_bloc.dart';

@freezed
class ResetPasswordWithInitialState with _$ResetPasswordWithInitialState {
  const factory ResetPasswordWithInitialState({
    required String message,
    required bool isLoading,
    required bool isRefreshRequired,
    required bool isFailure,
    required bool isResendOtpResponse,
    required bool isErrorTextHidden,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required FocusNode emailFocus,
    required FocusNode passwordFocus,
    required FocusNode confirmPasswordFocus,
    required bool isVerifyButtonActive,
    required bool isPasswordChangeRequired,
    required GlobalKey<FormState> formKey,
    required bool isAtLeastEightCharChecked,
    required bool isAtLeastOneLowerCaseChecked,
    required bool isAtLeastOneUpperCaseChecked,
    required bool isAtLeastOneDigitChecked,
    required bool isAtLeastOneSpecialCharChecked,
    required bool isPasswordCheckerHidden,
    required bool isConfirmPasswordObscure,
    required bool isPasswordObscure,
  }) = _ResetPasswordWithInitialState;

  factory ResetPasswordWithInitialState.initial() => ResetPasswordWithInitialState(
      message: AppStrings.global_empty_string,
      isLoading: false,
      isFailure: false,
      isRefreshRequired: false,
      isResendOtpResponse: false,
      isErrorTextHidden: true,
      isVerifyButtonActive: false,
      formKey: GlobalKey<FormState>(),
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      confirmPasswordController: TextEditingController(),
      emailFocus: FocusNode(),
      passwordFocus: FocusNode(),
      confirmPasswordFocus: FocusNode(),
      isAtLeastEightCharChecked: false,
      isPasswordChangeRequired: false,
      isAtLeastOneLowerCaseChecked: false,
      isAtLeastOneUpperCaseChecked: false,
      isAtLeastOneDigitChecked: false,
      isAtLeastOneSpecialCharChecked: false,
      isPasswordCheckerHidden: true,
      isConfirmPasswordObscure: true,
      isPasswordObscure: true
      );
}
