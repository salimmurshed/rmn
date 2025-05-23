part of 'client_home_bloc.dart';

@immutable
sealed class ClientHomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TriggerAddListenerForEventAndAthleteCardIndex extends ClientHomeEvent {
  TriggerAddListenerForEventAndAthleteCardIndex();

  @override
  List<Object?> get props => [];
}

class TriggerUpdateCurrentIndex extends ClientHomeEvent {
  final int currentIndex;
  final bool isEvent;

  TriggerUpdateCurrentIndex(
      {required this.isEvent, required this.currentIndex});

  @override
  List<Object?> get props => [currentIndex, isEvent];
}

class TriggerHomeEventsFetch extends ClientHomeEvent {}

class TriggerHomeAthletesFetch extends ClientHomeEvent {}

class TriggerFetchPopUp extends ClientHomeEvent {}

class TriggerCleanHomeData extends ClientHomeEvent {}

class TriggerHomeDataFetch extends ClientHomeEvent {}

class TriggerCheckBoxPopUp extends ClientHomeEvent {
  final String id;

  TriggerCheckBoxPopUp({required this.id});

  @override
  List<Object?> get props => [id];
}
