part of 'base_bloc.dart';

@freezed
class BaseWithInitialState with _$BaseWithInitialState {
  const factory BaseWithInitialState({
    required String message,
    required bool isLoading,
    required bool isLoadingForTheFirstTime,
    required bool isFetchingTeams,
    required bool isFetchingSeasons,
    required bool isFetchingCurrentSeason,
    required bool isRefreshedRequired,
    required bool isFailure,
    required int viewNumber,
    required num transactionFee,
    required List<Team> teams,
    required String currentRole,
    required List<SeasonPass> seasons,
    required List<GradeData> gradeList,
    required CurrentSeasonData currentSeason,
    required num unreadCount,
    required List<Chats> recivedMessgaes,
    required bool isSupportAgentAvilable,
  }) = _BaseWithInitialState;

  factory BaseWithInitialState.initial() => BaseWithInitialState(
        isFailure: false,
        currentRole: AppStrings.global_empty_string,
        isLoading: true,
        isLoadingForTheFirstTime: true,
        isRefreshedRequired: false,
        message: AppStrings.global_empty_string,
        viewNumber: 0,
        transactionFee: 0,
        teams: [],
        seasons: [],
        gradeList: [],
        isFetchingCurrentSeason: false,
        isFetchingSeasons: false,
        isFetchingTeams: false,
        currentSeason: CurrentSeasonData(),
        unreadCount: 0,
         recivedMessgaes: [],
         isSupportAgentAvilable: false
      );
}

EventResponseData? globalEventResponseData;
List<Team> globalTeams = [];
List<GradeData> globalGrades = [];
List<Athlete> myAthletes = [];
List<SeasonPass> globalSeasons = [];
num globalTransactionFee = 0;
CurrentSeasonData globalCurrentSeason = CurrentSeasonData();
String currentRole = AppStrings.global_empty_string;
bool isPopShown = false;
