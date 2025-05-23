part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvents extends Equatable {
  const ProfileEvents();

  @override
  List<Object> get props => [];
}

class TriggerGetProfileData extends ProfileEvents {
   bool isFromRestart;
   TriggerGetProfileData({this.isFromRestart = false});
  @override
  List<Object> get props => [isFromRestart];
}
class TriggerUpdateProfile extends ProfileEvents {
  final bool isFromRestart;
  final bool isFromRegisterFirstAthlete;
  const TriggerUpdateProfile({this.isFromRestart = false, this.isFromRegisterFirstAthlete = false});
  @override
  List<Object> get props => [isFromRestart, isFromRegisterFirstAthlete];
}

class TriggerLogout extends ProfileEvents {}