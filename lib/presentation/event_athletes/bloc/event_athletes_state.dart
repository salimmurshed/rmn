part of 'event_athletes_bloc.dart';



@freezed
class EventAthletesWithInitialState with _$EventAthletesWithInitialState {
  const factory EventAthletesWithInitialState({
    required String message,
    required bool isLoading,
    required bool isRefreshedRequired,
    required bool isFailure,
    required List<Athlete> selectedAthletes,
    required List<Athlete> registeredAthletes,
    required List<Athlete> nonRegisteredAthletes,
    required String minAge,

  }) = _EventAthletesWithInitialState;

  factory EventAthletesWithInitialState.initial() =>
      const EventAthletesWithInitialState(
          isFailure: false,
          isLoading: false,
          isRefreshedRequired: false,
          message: AppStrings.global_empty_string,
          selectedAthletes: [],
          registeredAthletes: [],
          nonRegisteredAthletes: [],
          minAge: AppStrings.global_empty_string,

      );
}
