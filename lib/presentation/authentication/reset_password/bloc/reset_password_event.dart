part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordEvent extends Equatable{
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class TriggerCheckResetPasswordButtonActivity extends ResetPasswordEvent {
  final bool isForgotPassword;
  const TriggerCheckResetPasswordButtonActivity({required this.isForgotPassword});
  @override
  List<Object> get props => [isForgotPassword];
}
class TriggerRequestForResetPasswordLink extends ResetPasswordEvent {}
class TriggerRebuildFromScratch extends ResetPasswordEvent {}
class TriggerUpdateFieldOnChangeReset extends ResetPasswordEvent {
  final FieldType fieldType;
  final String value;
  final String retypedValue;
  const TriggerUpdateFieldOnChangeReset({required this.fieldType, required this.value, this.retypedValue = AppStrings.global_empty_string});
  @override
  List<Object> get props => [fieldType, value, retypedValue];
}
class TriggerHideUnHideFieldContentsReset extends ResetPasswordEvent {
  final FieldType fieldType;
  const TriggerHideUnHideFieldContentsReset({required this.fieldType});
  @override
  List<Object> get props => [fieldType];
}
class TriggerRevealPasswordCheckerReset extends ResetPasswordEvent {}
class TriggerSubmitNewPassword extends ResetPasswordEvent {
  final String token;
  const TriggerSubmitNewPassword({required this.token});
  @override
  List<Object> get props => [token];
}

