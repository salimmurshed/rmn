part of 'get_in_touch_bloc.dart';

@immutable
sealed class GetInTouchEvent extends Equatable {
  const GetInTouchEvent();

  @override
  List<Object> get props => [];
}

class TriggerSubmitData extends GetInTouchEvent {
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String phoneNumber;
  final String message;

  const TriggerSubmitData({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.message,
  });

  @override
  List<Object> get props =>
      [firstName, lastName, emailAddress, phoneNumber, message];
}

class TriggerCheckContactNumberValidity extends GetInTouchEvent {
  final String phoneNumber;

  const TriggerCheckContactNumberValidity({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}

class TriggerFetchUserCachedData extends GetInTouchEvent {}
class TriggerFaqFetch extends GetInTouchEvent {}