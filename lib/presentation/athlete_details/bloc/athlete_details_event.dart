part of 'athlete_details_bloc.dart';

@immutable
sealed class AthleteDetailsEvent extends Equatable {
  const AthleteDetailsEvent();

  @override
  List<Object> get props => [];
}

class TriggerAthleteDetailsFetch extends AthleteDetailsEvent {
  final String athleteId;
  final String seasonId;
  final List<SeasonPass> seasons;

  const TriggerAthleteDetailsFetch(
      {required this.athleteId, required this.seasonId, required this.seasons});

  @override
  List<Object> get props => [athleteId, seasonId, seasons];
}

class TriggerEventsFetch extends AthleteDetailsEvent {
  final String athleteId;
  final String seasonId;
  final int tabNo;
  final String selectedValue;

  const TriggerEventsFetch(
      {required this.athleteId,
      required this.seasonId,
      required this.selectedValue,
      required this.tabNo});

  @override
  List<Object> get props => [athleteId, selectedValue, seasonId, tabNo];
}

class TriggerTabSelection extends AthleteDetailsEvent {
  final String athleteId;
  final String seasonId;
  final int tabNo;
  final String selectedValue;


  const TriggerTabSelection(
      {required this.athleteId, required this.selectedValue, required this.seasonId, required this.tabNo});

  @override
  List<Object> get props => [athleteId, seasonId, tabNo, selectedValue];
}

class TriggerDropDownSelection extends AthleteDetailsEvent {
  final String athleteId;
  final String selectedValue;
  final List<SeasonPass> seasons;
  final int selectedTab;

  const TriggerDropDownSelection(
      {required this.athleteId,

      required this.selectedValue,
      required this.selectedTab,
      required this.seasons});

  @override
  List<Object> get props => [athleteId, selectedTab, selectedValue, seasons];
}
class TriggerViewPartialOwnerList extends AthleteDetailsEvent {
  final String athleteId;
  final bool isViewer;
  const TriggerViewPartialOwnerList({required this.athleteId, required this.isViewer});

  @override
  List<Object> get props => [athleteId, isViewer];
}

class TriggerRemovePartialOwner extends AthleteDetailsEvent {
  final String athleteId;
  final String userId;
  final bool isViewer;
  final BuildContext context;

  const TriggerRemovePartialOwner(
      {required this.athleteId,
      required this.userId,
      required this.isViewer,
     required this.context});

  @override
  List<Object> get props => [athleteId, userId, isViewer, context];
}
class TriggerRefreshAthleteDetails extends AthleteDetailsEvent{}
class TriggerFilterThroughDivList extends AthleteDetailsEvent{
  final int index;
  const TriggerFilterThroughDivList({required this.index});
  @override
  List<Object> get props => [index];
}