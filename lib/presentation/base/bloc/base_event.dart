part of 'base_bloc.dart';

@immutable
sealed class BaseEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class TriggerViewNumberUpdates extends BaseEvent {
  final int viewNumber;

  TriggerViewNumberUpdates({required this.viewNumber});

  @override
  List<Object> get props => [viewNumber];
}

class TriggerFetchBaseData extends BaseEvent{
   bool isFromRestart;
   String currentRole;
   TriggerFetchBaseData({this.isFromRestart = false, this.currentRole = AppStrings.global_empty_string});
   @override
   List<Object> get props => [isFromRestart, currentRole];
}
class TriggerTeamsFetch extends BaseEvent{}
class TriggerSeasonsFetch extends BaseEvent{
  final String athleteId;
  TriggerSeasonsFetch({required this.athleteId});
  @override
  List<Object> get props => [athleteId];
}
class TriggerFetchCurrentSeason extends BaseEvent{}
class TriggerTransactionFeeFetch extends BaseEvent{}

class TriggerSwitchBetweenRoles extends BaseEvent {}
class TriggergetUnreadCount extends BaseEvent {}
class TriggerMyAthletesFetch extends BaseEvent{}
class TriggerGradeFetch extends BaseEvent{}
class TriggerGetIntialMessage extends BaseEvent{}
class TriggerISSupportAgentAvialable extends BaseEvent{
  bool isAvailable;
  TriggerISSupportAgentAvialable({required this.isAvailable});
  @override
  List<Object> get props => [isAvailable];
}