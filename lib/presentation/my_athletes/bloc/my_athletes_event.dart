part of 'my_athletes_bloc.dart';

@immutable
sealed class MyAthletesEvent extends Equatable {
  const MyAthletesEvent();

  @override
  List<Object?> get props => [];
}

class TriggerFetchAthletes extends MyAthletesEvent {
  final int selectedTabIndex;
  final AthleteApiCallType isNewTab;
  bool isRequestClearTime;
  bool isNotification;
  final int page;
  final String searchKey;
  final bool isSearch;
  final bool isInitState;
  final List<Athlete> athletes;

  TriggerFetchAthletes(
      {required this.isSearch,
      required this.searchKey,
      required this.selectedTabIndex,
      required this.athletes,
      required this.page,
      required this.isNewTab,
      this.isRequestClearTime = false,
      this.isNotification = false,
      this.isInitState = false});

  @override
  List<Object?> get props => [
        selectedTabIndex,
        isSearch,
        isNotification,
        isNewTab,
        athletes,
        page,
        searchKey,
        isRequestClearTime,
        isInitState,
      ];
}

class TriggerCheckForSearchText extends MyAthletesEvent {
  final String searchText;

  const TriggerCheckForSearchText({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}

class TriggerUpdateScrollControllerPosition extends MyAthletesEvent {
  final ScrollController scrollController;

  const TriggerUpdateScrollControllerPosition({required this.scrollController});

  @override
  List<Object?> get props => [scrollController];
}

class TriggerRequestAccess extends MyAthletesEvent {
  final String athleteId;
  final String accessType;
  final int selectedTabIndex;
  final int index;
  final List<Athlete> athletes;
  final ScrollController scrollController;

  const TriggerRequestAccess(
      {required this.athleteId,
      required this.athletes,
      required this.index,
      required this.selectedTabIndex,
      required this.scrollController,
      required this.accessType});

  @override
  List<Object?> get props => [
        athleteId,
        index,
        scrollController,
        athletes,
        accessType,
        selectedTabIndex
      ];
}

class TriggerAskForSupport extends MyAthletesEvent {
  final ScrollController scrollController;

  const TriggerAskForSupport({required this.scrollController});

  @override
  List<Object?> get props => [scrollController];
}

class TriggerCancel extends MyAthletesEvent {
  final String athleteId;
  final int selectedTabIndex;
  final int index;
  final List<Athlete> athletes;
  final ScrollController scrollController;

  const TriggerCancel({
    required this.athletes,
    required this.index,
    required this.athleteId,
    required this.selectedTabIndex,
    required this.scrollController,
  });

  @override
  List<Object?> get props =>
      [athleteId, selectedTabIndex, index, athletes, scrollController];
}

class TriggerAcceptOReject extends MyAthletesEvent {
  final String requestId;
  final bool isAccepted;
  final int selectedTabIndex;
  final ScrollController scrollController;
  final List<Athlete> athletes;
  final int index;

  const TriggerAcceptOReject(
      {required this.requestId,
      required this.isAccepted,
      required this.athletes,
      required this.index,
      required this.scrollController,
      required this.selectedTabIndex});

  @override
  List<Object?> get props => [
        requestId,
        selectedTabIndex,
        athletes,
        index,
        isAccepted,
        scrollController
      ];
}

class TriggerCoachAthlete extends MyAthletesEvent {}

class TriggerRadioButtonValue extends MyAthletesEvent {
  final String value;

  const TriggerRadioButtonValue({required this.value});

  @override
  List<Object?> get props => [value];
}

class TriggerCheckForRequests extends MyAthletesEvent {}

class TriggerCleanScreen extends MyAthletesEvent {}

class TriggerSearchInLocal extends MyAthletesEvent {}

class TriggerRequestAthleteSupport extends MyAthletesEvent {
  final String athleteId;

  const TriggerRequestAthleteSupport({required this.athleteId});

  @override
  List<Object?> get props => [athleteId];
}
