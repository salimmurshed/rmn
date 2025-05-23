part of 'otp_bloc.dart';

@freezed
class OtpWithInitialState with _$OtpWithInitialState {
  const factory OtpWithInitialState({
    required String message,
    required bool isLoading,
    required bool isFailure,
    required bool isResendOtpResponse,
    required bool isErrorTextHidden,
    required List<TextEditingController> pinControllers,
    required List<FocusNode> pinFocusNodes,
    required int noOfPinFields,
    required AnimationController? animationController,
    required double animationPercentValue,
    required String email,
    required num animationValueProgressValue,
    required bool isRefreshRequired,
    required bool isAnimationTerminated,
    required bool isOnChange,
    required bool isVerifyButtonActive,
    required GlobalKey<FormState> formKey,
  }) = _OtpWithInitialState;

  factory OtpWithInitialState.initial() => OtpWithInitialState(
      message: AppStrings.global_empty_string,
      isLoading: false,
      isFailure: false,
      isResendOtpResponse: false,
      email: AppStrings.global_empty_string,
      isErrorTextHidden: true,
      isAnimationTerminated: false,
      isRefreshRequired: false,
      noOfPinFields: 6,
      isVerifyButtonActive: false,
      isOnChange: false,
      pinControllers: List.generate(6, (index) => TextEditingController()),
      pinFocusNodes: List.generate(6, (index) => FocusNode()),
      formKey: GlobalKey<FormState>(),
      animationController: null,
      animationPercentValue: 1,
      animationValueProgressValue: 0);
}

class OtpArgument {
  final String userEmail;
  final String encryptedUserId;
  final bool isFromChangeEmail;

  const OtpArgument({this.userEmail = AppStrings.global_empty_string, this.encryptedUserId = AppStrings.global_empty_string, this.isFromChangeEmail = false});
}
