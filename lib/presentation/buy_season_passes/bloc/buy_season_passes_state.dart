part of 'buy_season_passes_bloc.dart';

@freezed
class SeasonPassesWithInitialState with _$SeasonPassesWithInitialState {
  const factory SeasonPassesWithInitialState({
    required List<SeasonPass> seasonPasses,
    required bool isFailure,
    required bool isLoadingSeasonPasses,
    required bool isRefreshRequired,
    required String message,
    required num currentSeasonPassIndex,
    required ScrollController scrollControllerForScrollBar,
    required ScrollController scrollController,
    required List<Athlete> athletesWithoutSeasonPass,
    required Athlete? selectAthlete,
    required int currentAthleteIndex,
    required String currentSeasonPassTitle,
    required List<Athlete> athletesAvailableForSelection,
    required List<Athlete> athletesSelectedForPurchase,
    required bool isAnAthleteAddedBack,
    required bool canWeProceedToPurchase,
  }) = _SeasonPassesWithInitialState;

  factory SeasonPassesWithInitialState.initial() =>
      SeasonPassesWithInitialState(
        currentSeasonPassIndex: 0,
        currentAthleteIndex: -1,
        currentSeasonPassTitle: AppStrings.global_empty_string,
        message: AppStrings.global_empty_string,
        isLoadingSeasonPasses: true,
        isFailure: false,
        isRefreshRequired: false,
        seasonPasses: [

        ],
        athletesSelectedForPurchase: [],
        athletesWithoutSeasonPass: [],
        athletesAvailableForSelection: [],
        isAnAthleteAddedBack: false,
        canWeProceedToPurchase: false,
          selectAthlete:null,
        scrollController: ScrollController(initialScrollOffset: 2),
        scrollControllerForScrollBar: ScrollController(),
      );
}
