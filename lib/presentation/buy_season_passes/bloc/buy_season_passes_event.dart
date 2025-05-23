part of 'buy_season_passes_bloc.dart';

@immutable
sealed class BuySeasonPassesEvent extends Equatable {
  const BuySeasonPassesEvent();

  @override
  List<Object?> get props => [];
}

class TriggerFetchSeasonPasses extends BuySeasonPassesEvent {


}

class TriggerUpdateSeasonPassesSliderIndex extends BuySeasonPassesEvent {
  final num index;

  const TriggerUpdateSeasonPassesSliderIndex({required this.index});

  @override
  List<Object?> get props => [index];
}

class TriggerAddAthleteBackToList extends BuySeasonPassesEvent {
  final List<Athlete> availableAthletes;
  final List<Athlete> athletesWithoutSeasonPass;

  const TriggerAddAthleteBackToList(
      {required this.availableAthletes,
      required this.athletesWithoutSeasonPass});

  @override
  List<Object?> get props => [availableAthletes, athletesWithoutSeasonPass];
}

class TriggerFetchAthleteWithoutSeasonPass extends BuySeasonPassesEvent {

  const TriggerFetchAthleteWithoutSeasonPass();

}

class TriggerUpdateAthleteMembership extends BuySeasonPassesEvent {
  final List<Athlete> athletes;
  final int athleteIndex;
  final String seasonPassTitle;

  const TriggerUpdateAthleteMembership(
      {required this.athletes,
      required this.seasonPassTitle,
      required this.athleteIndex});

  @override
  List<Object?> get props => [athletes, athleteIndex, seasonPassTitle];
}

class TriggerSelectSeasonPass extends BuySeasonPassesEvent {
  final String seasonPassTitle;
  final List<Athlete> athletes;
  final int athleteIndex;

  const TriggerSelectSeasonPass(
      {required this.athleteIndex,
      required this.athletes,
      required this.seasonPassTitle,
     });

  @override
  List<Object?> get props => [athletes, athleteIndex, seasonPassTitle, ];
}

class TriggerAthleteRemove extends BuySeasonPassesEvent {
  final int athleteIndex;
  final List<Athlete> athletes;

  const TriggerAthleteRemove(
      {required this.athleteIndex, required this.athletes});

  @override
  List<Object?> get props => [athleteIndex, athletes];
}

class TriggerOpenBottomSheetForSelection extends BuySeasonPassesEvent {}
class TriggerRefreshSeasonPassBottomSheet extends BuySeasonPassesEvent {
  final int index;
  const TriggerRefreshSeasonPassBottomSheet({required this.index});
  @override
  List<Object?> get props => [index];
}

class TriggerAthleteSelection extends BuySeasonPassesEvent {
  final int athleteIndex;
  final List<Athlete> athleteAvailableForSelection;

  const TriggerAthleteSelection(
      {required this.athleteIndex, required this.athleteAvailableForSelection});

  @override
  List<Object?> get props => [athleteIndex, athleteAvailableForSelection];
}

class TriggerCollectAthletes extends BuySeasonPassesEvent {}
class TriggerRefresh extends BuySeasonPassesEvent {}
class TriggerCollectTransferredAthletes extends BuySeasonPassesEvent {
  final List<Athlete> athletes;
  const TriggerCollectTransferredAthletes({required this.athletes});
  @override
  List<Object?> get props => [athletes];
}
class TriggerCheckForVisibleAthletes extends BuySeasonPassesEvent {
  final List<Athlete> athletes;
  const TriggerCheckForVisibleAthletes({required this.athletes});
  @override
  List<Object?> get props => [athletes];
}