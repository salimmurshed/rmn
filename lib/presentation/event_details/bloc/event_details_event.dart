part of 'event_details_bloc.dart';

@immutable
sealed class EventDetailsEvent extends Equatable {
  const EventDetailsEvent();

  @override
  List<Object?> get props => [];
}

class TriggerFetchEventDetails extends EventDetailsEvent {
  final String eventId;
  final int? divIndex;
  final int? childIndex;
  final CouponModules? isEnteringPurchaseView;
  bool isFromDetailView;
 bool canFetchQuestionnaire;
   TriggerFetchEventDetails(
      {required this.eventId,
      this.divIndex,
      this.childIndex,
        this.canFetchQuestionnaire=false,
      this.isFromDetailView = true,
      this.isEnteringPurchaseView});

  @override
  List<Object?> get props =>
      [eventId, divIndex, childIndex, canFetchQuestionnaire, isEnteringPurchaseView, isFromDetailView];
}

class TriggerShortenEventDetails extends EventDetailsEvent {
  bool isShorten;

  TriggerShortenEventDetails({required this.isShorten});

  @override
  List<Object?> get props => [isShorten];
}

class TriggerFetchEventWiseAthletes extends EventDetailsEvent {
  final String eventId;
  final int? divIndex;
  final int? childIndex;
   bool fetchQuestionnaire;
  final CouponModules? isEnteringPurchaseView;

   TriggerFetchEventWiseAthletes(
      {required this.eventId,
      this.divIndex,
      this.childIndex,
      this.fetchQuestionnaire = false,
      this.isEnteringPurchaseView});

  @override
  List<Object?> get props =>
      [eventId, divIndex, childIndex, fetchQuestionnaire, isEnteringPurchaseView];
}

class TriggerSwitchTab extends EventDetailsEvent {
  final int index;
  final bool isDivTabIndex;

  const TriggerSwitchTab({required this.index, required this.isDivTabIndex});

  @override
  List<Object?> get props => [index, isDivTabIndex];
}

class TriggerExpandTileDivisionTab extends EventDetailsEvent {
  final bool isExpanded;
  final List<DivisionTypes> divisionsTypes;
  final int sublistIndex;
  final int index;

  const TriggerExpandTileDivisionTab(
      {required this.sublistIndex,
      required this.index,
      required this.divisionsTypes,
      required this.isExpanded});

  @override
  List<Object?> get props => [isExpanded, index, sublistIndex, divisionsTypes];
}

class TriggerExpandTileScheduleTile extends EventDetailsEvent {
  final int scheduleTileIndex;

  const TriggerExpandTileScheduleTile({
    required this.scheduleTileIndex,
  });

  @override
  List<Object?> get props => [
        scheduleTileIndex,
      ];
}

class TriggerUpDivisionListAthletes extends EventDetailsEvent {
  final List<DivisionTypes> divisionTypes;
  final int? divIndex;
  final int? childIndex;
  final CouponModules? isEnteringPurchaseView;

  const TriggerUpDivisionListAthletes(
      {required this.divisionTypes,
      this.divIndex,
      this.childIndex,
      this.isEnteringPurchaseView});

  @override
  List<Object?> get props =>
      [divisionTypes, divIndex, childIndex, isEnteringPurchaseView];
}

class TriggerAddAnAthlete extends EventDetailsEvent {
  final AgeGroups ageGroup;

  const TriggerAddAnAthlete({required this.ageGroup});

  @override
  List<Object?> get props => [
        ageGroup,
      ];
}

class TriggerSwitchBetweenAthleteSelectionsTab extends EventDetailsEvent {
  final AthleteSelectionTabs athleteSelectionTabs;

  const TriggerSwitchBetweenAthleteSelectionsTab(
      {required this.athleteSelectionTabs});

  @override
  List<Object?> get props => [
        athleteSelectionTabs,
      ];
}

class TriggerSelectStyleIndex extends EventDetailsEvent {
  final int index;

  const TriggerSelectStyleIndex({required this.index});

  @override
  List<Object?> get props => [
        index,
      ];
}

class TriggerWCSelectionTemporarily extends EventDetailsEvent {
  final int weightIndex;
  final Athlete athlete;
  final DivisionTypes divisionType;
  final AgeGroups ageGroup;
  final AthleteSelectionTabs athleteSelectionTabs;
  const TriggerWCSelectionTemporarily({
    required this.weightIndex,
    required this.athlete,
    required this.ageGroup,
    required this.divisionType,
    required this.athleteSelectionTabs,
  });

  @override
  List<Object?> get props => [
        weightIndex,
        athlete,
        ageGroup,
        divisionType,
        athleteSelectionTabs,
      ];
}

class TriggerUpdateExpansionPaneList extends EventDetailsEvent {
  final AgeGroups ageGroup;
  final DivisionTypes divisionType;
  final Athlete athlete;

  const TriggerUpdateExpansionPaneList({
    required this.ageGroup,
    required this.athlete,
    required this.divisionType,
  });

  @override
  List<Object?> get props => [ageGroup, athlete, divisionType];
}

class TriggerUpdateYourAthleteList extends EventDetailsEvent {
  final AgeGroups ageGroup;
  final int athleteIndex;

  const TriggerUpdateYourAthleteList({
    required this.ageGroup,
    required this.athleteIndex,
  });

  @override
  List<Object?> get props => [
        ageGroup,
        athleteIndex,
      ];
}

class TriggerOpenAgeGroup extends EventDetailsEvent {
  final int divIndex;
  final int ageGroupIndex;
  bool sendToRoute;
   TriggerOpenAgeGroup(
      {required this.divIndex, this.sendToRoute=true, required this.ageGroupIndex});

  //   required this.divisionTypes,
  // required this.parentIndex,
  // required this.childIndex
  // });

  @override
  List<Object?> get props => [
        ageGroupIndex,
        divIndex, sendToRoute

        //divisionTypes, parentIndex, childIndex
      ];
}

class TriggerMoveBetweenTabs extends EventDetailsEvent {
  final Athlete athlete;

  const TriggerMoveBetweenTabs({
    required this.athlete,
  });

  @override
  List<Object?> get props => [
        athlete,
      ];
}

class TriggerRemoveFromSelectAthlete extends EventDetailsEvent {
  final List<Athlete> selectedAthletes;
  final int index;

  const TriggerRemoveFromSelectAthlete(
      {required this.selectedAthletes, required this.index});

  @override
  List<Object?> get props => [selectedAthletes, index];
}

class TriggerAddToExpansionPanel extends EventDetailsEvent {
  final AgeGroups ageGroup;

  const TriggerAddToExpansionPanel({
    required this.ageGroup,
  });

  @override
  List<Object?> get props => [
        ageGroup,
      ];
}

class TriggerResetStyleIndex extends EventDetailsEvent {
  final AgeGroups ageGroup;
  final Athlete athlete;

  const TriggerResetStyleIndex({
    required this.ageGroup,
    required this.athlete,
  });

  @override
  List<Object?> get props => [
        ageGroup,
        athlete,
      ];
}

class TriggerToCollectRegistrationList extends EventDetailsEvent {
  final List<DivisionTypes> divisionTypes;

  const TriggerToCollectRegistrationList({
    required this.divisionTypes,
  });

  @override
  List<Object?> get props => [divisionTypes];
}

class TriggerSetIndex extends EventDetailsEvent {
  final int parentIndex;
  final int childIndex;

  const TriggerSetIndex({
    required this.parentIndex,
    required this.childIndex,
  });

  @override
  List<Object?> get props => [parentIndex, childIndex];
}

class TriggerGetRegistrationList extends EventDetailsEvent {}

class TriggerSearchReg extends EventDetailsEvent {
  final String searchValue;

  const TriggerSearchReg({required this.searchValue});

  @override
  List<Object?> get props => [searchValue];
}

class TriggerOnChangeSearchEvent extends EventDetailsEvent {
  final String searchValue;

  const TriggerOnChangeSearchEvent({required this.searchValue});

  @override
  List<Object?> get props => [searchValue];
}

class TriggerEraseSearchValue extends EventDetailsEvent {
  const TriggerEraseSearchValue();
}

class TriggerPickDivision extends EventDetailsEvent {
  final List<DivisionTypes> divisionType;
  final int divIndex;
  const TriggerPickDivision({required this.divisionType, required this.divIndex});

  @override
  List<Object?> get props => [divisionType, divIndex];
}
class TriggerRemoveUnConfirmAthlates extends EventDetailsEvent {
  const TriggerRemoveUnConfirmAthlates();

  @override
  List<Object?> get props => [];
}
class IncrementEvent extends EventDetailsEvent {} // Event to increase counter
class DecrementEvent extends EventDetailsEvent {}
class TriggerFetchEmployeeAthletes extends EventDetailsEvent {

}// Event to decrease counter
class TriggerAssembleForDivision extends EventDetailsEvent {
  final List<DivisionTypes> divisionTypes;
  final List<Athlete> athletes;
  final int divIndex;
  final int childIndex;


  const TriggerAssembleForDivision(
      {required this.divisionTypes,
      required this.divIndex,
      required this.athletes,
      required this.childIndex,
      });

  @override
  List<Object?> get props =>
      [divisionTypes, divIndex, childIndex, athletes];
}// Event to decrease counter
class TriggerGetDivisionForEmployee extends EventDetailsEvent {
  final List<DivisionTypes> divisionTypes;
  const TriggerGetDivisionForEmployee({required this.divisionTypes});
  @override

  List<Object?> get props => [divisionTypes];
}

class TriggerChangeTeam extends EventDetailsEvent {

}

class TriggerCheckForUpdateCartStatus extends EventDetailsEvent{}