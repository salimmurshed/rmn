
import 'package:bloc/bloc.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rmnevents/root_app.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../widget/custom_marker.dart';
import 'all_events_bloc.dart';

class AllEventsHandlers {
  static void emitInitialState(
      {required Emitter<AllEventsWithInitialState> emit,
      required AllEventsWithInitialState state}) {
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isLoading: true,
      isFailure: false,
      isSearchModeOn: false,
      isRefreshRequired: false,
      past: [],
      upcoming: [],
      miscellaneous: [],
      customMarkers: [],
    ));
  }

  static void emitRefreshState(
      {required Emitter<AllEventsWithInitialState> emit,
      required AllEventsWithInitialState state}) {
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isLoading: false,
      isFailure: false,
      isSearchModeOn: false,
      isRefreshRequired: true,
    ));
  }

  static void emitRefreshStateForUserLocation(
      {required Emitter<AllEventsWithInitialState> emit,
        required AllEventsWithInitialState state}) {
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isLoading: false,
      isFailure: false,
      isSearchModeOn: false,
      isRefreshRequired: true,
      searchController: TextEditingController(),
      searchKeyForNoResult: AppStrings.global_empty_string,
      filterType: FilterType.miscellaneous,
      isFilterOn: false,
      past: [],
      upcoming: [],
      miscellaneous: [],
      customMarkers: [],
      focusNode: FocusNode(),
    ));
  }

  static void emitErrorState(
      {required Emitter<AllEventsWithInitialState> emit,
      required AllEventsWithInitialState state,
      required String message}) {
    return emit(state.copyWith(
        isLoading: false,
        isFailure: true,
        isLoadingList: false,
        filterType: state.filterType,
        isRefreshRequired: false,
        message: message));
  }

  static List<EventData> updateEventDataParameter(
      {required String assetUrl, required List<EventData> events}) {
    List<EventData> updatedEvents = events;
    for (EventData eventData in updatedEvents) {
      eventData.coverImage = '$assetUrl${eventData.coverImage}';

      if (eventData.registrations!.isNotEmpty) {
        eventData.athleteProfiles = [];
        for (Registrations registration in eventData.registrations!) {
          eventData.athleteProfiles!
              .add('$assetUrl${registration.athlete!.profileImage!}');
        }
      }
    }
    return updatedEvents;
  }

  static List<MarkerData> updateEventMarkerDataParameter(
      {required String assetUrl, required List<MapEvents> events}) {
    List<MapEvents> updatedEvents = events;
    List<MarkerData> updatedEventMarkerData = [];
    for (MapEvents eventData in updatedEvents) {
      eventData.coverImage = '$assetUrl${eventData.coverImage}';
      eventData.eventStatus = GlobalHandlers.getStatusEvent(
          startDate: eventData.startDatetime!, endDate: eventData.endDatetime!);
      if (eventData.eventStatus == EventStatus.upcoming) {
        eventData.eventInDays =
            'In ${GlobalHandlers.eventInDays(startDate: eventData.startDatetime!)}\ndays';
      } else if (eventData.eventStatus == EventStatus.past) {
        eventData.eventInDays =
            '${GlobalHandlers.eventInDaysAgo(endDate: eventData.endDatetime!)}\ndays ago';
      } else {
        eventData.eventInDays = '';
      }
    }
    for (MapEvents eventData in updatedEvents) {
      updatedEventMarkerData.add(MarkerData(
          marker: Marker(
            onTap: (){  Navigator.pushNamed(
                navigatorKey.currentContext!, AppRouteNames.routeEventDetails,
                arguments: eventData.id);},
              markerId: MarkerId((eventData.id).toString()),
              position: LatLng(
                  double.parse(
                      eventData.coordinates!.coordinates!.last.toString()),
                  double.parse(
                      eventData.coordinates!.coordinates!.first.toString()))),
          child: CustomMarker(
            eventName: eventData.title!,
            imageUrl: eventData.coverImage!,
            eventStatus: eventData.eventStatus!,
            eventInDays: eventData.eventInDays!,
          )));
    }
    return updatedEventMarkerData;
  }

  static Future<void> handleMiscellaneousListOfEvents({
    required Emitter<AllEventsWithInitialState> emit,
    required AllEventsWithInitialState state,
  }) async {
    try {
      final response = await EventsRepository.getAllEvents(page: state.page);
      response.fold(
          (failure) => AllEventsHandlers.emitErrorState(
              state: state, emit: emit, message: failure.message), (success) {
        List<EventData> updatedEventData =
            AllEventsHandlers.updateEventDataParameter(
                assetUrl: success.responseData!.assetsUrl!,
                events: success.responseData!.data!);
        final updatedState = state.copyWith(
          isLoading: false,
          isFailure: false,
          page: state.page,
          totalPage: state.totalPage,
          miscellaneous: [...state.miscellaneous, ...updatedEventData],
        );
        emit(updatedState);
        emit(updatedState.copyWith(
          allEventsData: updatedState.miscellaneous,
        ));
      });
    } catch (e) {
      AllEventsHandlers.emitErrorState(
          state: state, emit: emit, message: e.toString());
    }
  }

  static Future<void> handleFilteredListOfEvents({
    required TriggerFetchFilterResults event,
    required Emitter<AllEventsWithInitialState> emit,
    required AllEventsWithInitialState state,
  }) async {
    try {
      final response = await EventsRepository.getFilteredEvents(
          page: state.page, filterType: event.filterType);
      response.fold(
          (failure) => AllEventsHandlers.emitErrorState(
              state: state, emit: emit, message: failure.message), (success) {
        List<EventData> updatedEventData =
            AllEventsHandlers.updateEventDataParameter(
                assetUrl: success.responseData!.assetsUrl!,
                events: success.responseData!.data!);

        late AllEventsWithInitialState updatedState;
        if (event.filterType == FilterType.upcoming) {
          updatedState = state.copyWith(
            isLoading: false,
            isFailure: false,
            page: success.responseData!.page!,
            miscellaneous: [],
            filterType: event.filterType,
            allEventsData: [],
            isFilterOn: true,
            totalPage: success.responseData!.totalPage!,
            past: [],
            upcoming: [...state.upcoming, ...updatedEventData],
          );
        }
        else {
          updatedState = state.copyWith(
            isLoading: false,
            isFailure: false,
            page: success.responseData!.page!,
            miscellaneous: [],
            filterType: event.filterType,
            isFilterOn: true,
            allEventsData: [],
            totalPage: success.responseData!.totalPage!,
            upcoming: [],
            past: [...state.past, ...updatedEventData],
          );
        }
        emit(updatedState.copyWith(

          allEventsData: event.filterType == FilterType.upcoming
              ? updatedState.upcoming
              : updatedState.past,
        ));
      });
    } catch (e) {
      AllEventsHandlers.emitErrorState(
          state: state, emit: emit, message: e.toString());
    }
  }

  static Future<void> handleSearchListOfEvents({
    required Emitter<AllEventsWithInitialState> emit,
    required AllEventsWithInitialState state,
  }) async {
    try {
      final response = await EventsRepository.getSearchResults(
          page: 1,
          filterType: state.filterType,
          searchKeyword: state.searchController.text);
      response.fold(
          (failure) => AllEventsHandlers.emitErrorState(
              state: state, emit: emit, message: failure.message), (success) {
        List<EventData> updateEventData =
            AllEventsHandlers.updateEventDataParameter(
                assetUrl: success.responseData!.assetsUrl!,
                events: success.responseData!.data!);
        emit(state.copyWith(
          isLoading: false,
          isLoadingList: false,
          userLocation: null,
          isFailure: false,
          filterType: state.filterType,
          isFilterOnForList: true,
          searchKeyForNoResult: state.searchControllerForList.text,
          allEventsData: updateEventData,
        ));
      });
    } catch (e) {
      AllEventsHandlers.emitErrorState(
          state: state, emit: emit, message: e.toString());
    }
  }



}
