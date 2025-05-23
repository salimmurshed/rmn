part of 'my_athletes_bloc.dart';

@freezed
class MyAthletesWithInitialState with _$MyAthletesWithInitialState {
  const factory MyAthletesWithInitialState({
    required String message,
    required bool isLoading,
    required bool isBottomLoading,
    required bool isFetching,
    required bool isFailure,
    required TextEditingController searchController,
    required ScrollController currentScrollController,
    required FocusNode searchFocusNode,
    required bool isRefreshRequired,
    required List<Athlete> athletes,
    required List<ReceivedAthleteRequestData> requests,
    required int selectedTabNumber,
    required int page,
    required int totalPage,
    required String textForEmptyList,
    required bool isSearch,
    required String radioButtonValue,
    required bool showFooterButton,
    required bool canContactSupport,
    required double scrollerPosition,
    required bool showSearchIcon,
  }) = _MyAthletesWithInitialState;

  factory MyAthletesWithInitialState.initial() => MyAthletesWithInitialState(
      isFailure: false,
      isLoading: true,
      isBottomLoading: false,
      message: AppStrings.global_empty_string,
      searchController: TextEditingController(),
      searchFocusNode: FocusNode(),
      isRefreshRequired: false,
      isFetching: false,
      athletes: [],
      requests: [],
      selectedTabNumber: 0,
      radioButtonValue: '1',
      page: 0,
      totalPage: 0,
      showFooterButton: true,
      canContactSupport: false,
      scrollerPosition: 0.0,
      isSearch: false,
      showSearchIcon: true,
      textForEmptyList: AppStrings.global_empty_string,
      currentScrollController: ScrollController());
}
