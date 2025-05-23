part of 'athlete_details_bloc.dart';

@freezed
class AthleteDetailsWithInitialState with _$AthleteDetailsWithInitialState {
  const factory AthleteDetailsWithInitialState({
    required String message,
    required bool isLoadingAthleteInfo,
    required bool isRefreshedRequired,
    required bool isLoadingPartialOwners,
    required bool isFailure,
    required int tabNo,
    required Athlete? athlete,
    required String athleteId,
    required String? selectedValue,
    required GlobalKey<dynamic> dropDownKey,
    required bool isExpanded,
    required bool isLoadingForTabs,
    required String seasonId,
    required int selectedDivIndex,
    required List<DataBaseUser> viewers,
    required List<DataBaseUser> coaches,
    required List<Awards> awards,
    required List<Awards> allAwards,
    required List<Division> divisions,
    required List<EventsSeasonWiseForAthlete> events,
    required List<Ranks> ranks,
    required LastUpdate? lastUpdate,
  }) = _AthleteDetailsWithInitialState;

  factory AthleteDetailsWithInitialState.initial() =>
      AthleteDetailsWithInitialState(
          message: AppStrings.global_empty_string,
          isFailure: false,
          tabNo: 0,
          viewers: [],
          coaches: [],
          selectedDivIndex: -1,
          divisions: [],
          lastUpdate: null,
          isLoadingPartialOwners: false,
          athleteId: AppStrings.global_empty_string,
          isLoadingAthleteInfo: true,
          isRefreshedRequired: false,
          athlete: null,
          dropDownKey: GlobalKey(),
          selectedValue: null,
          isExpanded: false,
          isLoadingForTabs: false,
          seasonId: AppStrings.global_empty_string,
          awards: [],
          allAwards: [],
          ranks: [],
          events: []);
}
