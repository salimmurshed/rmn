part of 'staff_home_bloc.dart';

@immutable
sealed class StaffHomeEvent extends Equatable {
  const StaffHomeEvent();

  @override
  List<Object> get props => [];
}

class TriggerFetchStaffHomeInfo extends StaffHomeEvent {}
class TriggerCheckIfReaderIsExisting extends StaffHomeEvent {}
class TriggerFetchEventList extends StaffHomeEvent {}
class TriggerChooseEvent extends StaffHomeEvent {
  final String eventName;

  const TriggerChooseEvent({required this.eventName});
  @override
  List<Object> get props => [eventName];
}
class TriggerRefreshHome extends StaffHomeEvent {}
class TriggerCheckOnAppRestart extends StaffHomeEvent {}
class TriggerGetBackReader extends StaffHomeEvent {}