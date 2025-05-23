part of 'client_home_bloc.dart';

@freezed
class ClientHomeWithInitialState with _$ClientHomeWithInitialState {
  const factory ClientHomeWithInitialState({
    required String message,
    required bool isLoadingEvents,
    required bool isLoadingAthletes,
    required bool isRefreshedRequired,
    required bool isFailure,
    required bool isDontShowAgain,
    required EventData? liveEvent,
    required List<UpcomingRegistrations> upcomingRegistrations,
    required PageController eventPageController,
    required PageController athletePageController,
    required int eventCurrentIndex,
    required int athleteCurrentIndex,
    required List<Athlete> homeAthletes,
    required List<PopUpData> popUps,
    required bool showPopUp,

  }) = _ClientHomeWithInitialState;

  factory ClientHomeWithInitialState.initial() => ClientHomeWithInitialState(
      isFailure: false,
      isLoadingEvents: true,
      isLoadingAthletes:true,
      isRefreshedRequired:false,
      showPopUp: false,
      message: AppStrings.global_empty_string,
      liveEvent: null,
      isDontShowAgain: false,
      upcomingRegistrations: [

      ],
      popUps: [

      ],
      eventPageController: PageController(),
      athletePageController: PageController(viewportFraction: 0.8),
      eventCurrentIndex: 0,
      athleteCurrentIndex: 0,
      homeAthletes: [

      ]);
}
