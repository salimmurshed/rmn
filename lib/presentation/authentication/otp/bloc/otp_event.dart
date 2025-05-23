part of 'otp_bloc.dart';

@immutable
sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class TriggerAnimationInitialization extends OtpEvent {
  final TickerProvider vsync;
  final bool isResendCode;
  final bool isFromChangeEmail;
  final String email;

  const TriggerAnimationInitialization({
    required this.vsync,
    required this.isResendCode,
    this.isFromChangeEmail = false,
    this.email = AppStrings.global_empty_string,
  });

  @override
  List<Object?> get props => [vsync, isResendCode, email, isFromChangeEmail];
}

class TriggerTrackingAnimationProgress extends OtpEvent {}

class TriggerVerifyEmail extends OtpEvent {
  final String encryptedUserId;

  const TriggerVerifyEmail(
      {required this.encryptedUserId, });

  @override
  List<Object?> get props => [encryptedUserId,];
}

class TriggerShowErrorText extends OtpEvent {}

class TriggerResendCode extends OtpEvent {
  final TickerProvider vsync;
  final String email;
  final bool isFromChangeEmail;

  const TriggerResendCode({
    required this.vsync,
    required this.email,
    required this.isFromChangeEmail,
  });

  @override
  List<Object?> get props => [vsync, email, isFromChangeEmail];
}

class TriggerOtpLengthVerification extends OtpEvent {
  final bool isFromChangeEmail;
  final String encryptedUserId;
  const TriggerOtpLengthVerification({required this.isFromChangeEmail, required this.encryptedUserId});
  @override
  List<Object?> get props => [isFromChangeEmail, encryptedUserId];
}
class TriggerUpdateEmail extends OtpEvent {

}