part of 'sign_in_sign_up_bloc.dart';

@immutable
sealed class SignInSignUpEvent extends Equatable{
  const SignInSignUpEvent();

  @override
  List<Object> get props => [];
}

class TriggerReInitializeAuthenticationType extends SignInSignUpEvent {
  final Authentication authenticationType;
  const TriggerReInitializeAuthenticationType({required this.authenticationType});
  @override
  List<Object> get props => [authenticationType];
}

class TriggerUpdateFieldOnChange extends SignInSignUpEvent {
  final FieldType fieldType;
  final String value;
  final String retypedValue;
  const TriggerUpdateFieldOnChange({required this.fieldType, required this.value, this.retypedValue = AppStrings.global_empty_string});
  @override
  List<Object> get props => [fieldType, value, retypedValue];
}

class TriggerHideUnHideFieldContents extends SignInSignUpEvent {
  final FieldType fieldType;
  const TriggerHideUnHideFieldContents({required this.fieldType});
  @override
  List<Object> get props => [fieldType];
}

class TriggerRevealPasswordChecker extends SignInSignUpEvent {}
class TriggerSwitchBetweenSignInSignUpView extends SignInSignUpEvent {}
class TriggerCheckBoxToAgree extends SignInSignUpEvent {}
class TriggerSignInViaEmail extends SignInSignUpEvent{}
class TriggerSignUpViaEmailP extends SignInSignUpEvent{}
class TriggerSignInSignUpViaGoogle extends SignInSignUpEvent{}
class TriggerSignInSignUpViaFacebook extends SignInSignUpEvent{}
class TriggerActivateSignInButton extends SignInSignUpEvent{}
class TriggerCheckForButtonActivity extends SignInSignUpEvent{}
class TriggerReOpenSignInView extends SignInSignUpEvent{}
class TriggerOpenSignUpMask extends SignInSignUpEvent{
  final String email;
  const TriggerOpenSignUpMask({required this.email});
  @override
  List<Object> get props => [email];
}
class TriggerSubmitSignUpMaskData extends SignInSignUpEvent{}
class TriggerSignInViaApple extends SignInSignUpEvent{}
