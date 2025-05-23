import 'package:bloc/bloc.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'client_home_bloc.dart';

class ClientHomeHandlers {
  static void emitInitialState(
      {required Emitter<ClientHomeWithInitialState> emit,
      required ClientHomeWithInitialState state}) {
    emit(state.copyWith(
        isRefreshedRequired: true,
        isFailure: false,
        isLoadingEvents: false,
        isLoadingAthletes: false,
        message: AppStrings.global_empty_string));
  }

  static void emitWithLoaderForEvents(
      {required Emitter<ClientHomeWithInitialState> emit,
      required ClientHomeWithInitialState state}) {
    emit(state.copyWith(
        isRefreshedRequired: true,
        isFailure: false,
        isLoadingEvents: true,
        showPopUp: false,
        message: AppStrings.global_empty_string));
  }

  static void emitWithLoaderForAthletes(
      {required Emitter<ClientHomeWithInitialState> emit,
      required ClientHomeWithInitialState state}) {
    emit(state.copyWith(
        isRefreshedRequired: true,
        isFailure: false,
        isLoadingAthletes: true,
        message: AppStrings.global_empty_string));
  }

  static EventData updateLiveEventStatus({
    required EventData liveEvent,
    required String assetUrl,
  }) {
    liveEvent.coverImage = StringManipulation.combineStings(
        prefix: assetUrl, suffix: liveEvent.coverImage!);
    liveEvent.eventStatus = GlobalHandlers.getStatusEvent(
        startDate: liveEvent.startDatetime!, endDate: liveEvent.endDatetime!);
    return liveEvent;
  }

  static void updateAthleteProfilesParameter(
      {required String assetsUrl,
      required List<UpcomingRegistrations> upcomingRegistrations}) {
    if (upcomingRegistrations.isNotEmpty) {
      for (var events in upcomingRegistrations) {
        events.athleteProfiles = [];
        events.coverImage = StringManipulation.combineStings(
            prefix: assetsUrl, suffix: events.coverImage!);
        if (events.athletes!.isNotEmpty) {
          for (var athlete in events.athletes!) {
            String imageUrl = StringManipulation.combineStings(
                prefix: assetsUrl, suffix: athlete.profileImage!);
            events.athleteProfiles!.add(imageUrl);
          }
        }
      }
    }
  }
}
