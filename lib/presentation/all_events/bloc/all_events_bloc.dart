import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../root_app.dart';
import 'all_events_handlers.dart';

part 'all_events_event.dart';

part 'all_events_state.dart';

part 'all_events_bloc.freezed.dart';

class AllEventsBloc extends Bloc<AllEventsEvent, AllEventsWithInitialState> {
  AllEventsBloc() : super(AllEventsWithInitialState.initial()) {
    on<TriggerGetUserLocation>(_onTriggerGetUserLocation);
    on<TriggerFetchAllEventsOnMap>(_onTriggerFetchAllEventsOnMap);
    on<TriggerOnChangeSearchEvent>(_onTriggerOnChangeSearchEvent);
    on<TriggerEraseSearchKeywordEvent>(_onTriggerEraseSearchKeywordEvent);
    on<TriggerFetchAllEvents>(_onTriggerFetchAllEvents);
    on<TriggerFetchFilterResults>(_onTriggerFetchFilterResults);
    on<TriggerRefreshPage>(_onTriggerRefreshPage);
    on<TriggerFetchFilterEventsOnMap>(_onTriggerFetchFilterEventsOnMap);
    on<TriggerTapOnFilter>(_onTriggerTapOnFilter);
    on<TriggerSearchEvent>(_onTriggerSearchEvent);
    on<TriggerSearchEventsOnMap>(_onTriggerSearchEventOnMap);
    on<TriggerPagination>(_onTriggerPagination);
    on<TriggerAddScrollControllerListener>(
        _onTriggerAddScrollControllerListener);
  }

  FutureOr<void> _onTriggerGetUserLocation(TriggerGetUserLocation event,
      Emitter<AllEventsWithInitialState> emit) async {
    emit((AllEventsWithInitialState.initial()));
    LatLng? userLocation;

    // serviceEnabled = await location.serviceEnabled();
    // if (!serviceEnabled) {
    //   serviceEnabled = await location.requestService();
    //   if (!serviceEnabled) {}
    // }
    //
    // permissionGranted = await location.hasPermission();
    // if (permissionGranted == PermissionStatus.denied) {
    //   permissionGranted = await location.requestPermission();
    //   if (permissionGranted != PermissionStatus.granted) {}
    // }
    //
    // if (permissionGranted == PermissionStatus.granted) {
    //   locationData = await location.getLocation();
    //   userLocation = LatLng(locationData.latitude!, locationData.longitude!);
    // }

    emit(state.copyWith(isLoading: false, userLocation: userLocation));
    add(const TriggerFetchAllEventsOnMap());

  }

  FutureOr<void> _onTriggerFetchAllEventsOnMap(TriggerFetchAllEventsOnMap event,
      Emitter<AllEventsWithInitialState> emit) async {
    if (!event.isFirstTime) {
      emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isLoading: false,
        customMarkers: [],
        isFailure: false,
        isSearchModeOn: false,
        isRefreshRequired: true,
      ));
    }
    try {
      final response = await EventsRepository.getEventsOnMap();
      response.fold((failure) {
        AllEventsHandlers.emitErrorState(
            emit: emit, state: state, message: failure.message);
      }, (success) {
        List<MarkerData> customMarkers =
            AllEventsHandlers.updateEventMarkerDataParameter(
                assetUrl: success.responseData!.assetsUrl!,
                events: success.responseData!.events!);
        emit(state.copyWith(
            customMarkers: customMarkers,
            isLoading: false,
            isFailure: false,
            isRefreshRequired: false,
            isFilterOn: false,
            message: customMarkers.isNotEmpty
                ? AppStrings.global_empty_string
                : AppStrings.allEvents_emptyMiscellaneousMap_text));
      });
      // add(TriggerGetUserLocation());
    } catch (e) {
      AllEventsHandlers.emitErrorState(
          emit: emit, state: state, message: e.toString());
    }
  }

  FutureOr<void> _onTriggerOnChangeSearchEvent(TriggerOnChangeSearchEvent event,
      Emitter<AllEventsWithInitialState> emit) {
    emit(state.copyWith(
        isRefreshRequired: false,
        isSearchModeOn: true,
        isFailure: false,
        filterType: state.filterType,
        message: AppStrings.global_empty_string,
        showEraserForEraser: event.searchValue.isNotEmpty,
        showEraser: event.searchValue.isNotEmpty));
  }

  FutureOr<void> _onTriggerEraseSearchKeywordEvent(
      TriggerEraseSearchKeywordEvent event,
      Emitter<AllEventsWithInitialState> emit) {
    emit(state.copyWith(
        isRefreshRequired: false,
        showEraser: false,
        showEraserForEraser: false,
        message: AppStrings.global_empty_string,
        isSearchModeOn: false,
        isFailure: false,
        searchControllerForList: TextEditingController(text: AppStrings.global_empty_string),
        searchController:
            TextEditingController(text: AppStrings.global_empty_string),
        focusNode: FocusNode()));
  }

  FutureOr<void> _onTriggerFetchAllEvents(TriggerFetchAllEvents event,
      Emitter<AllEventsWithInitialState> emit) async {
    emit((AllEventsWithInitialState.initial()));
    await AllEventsHandlers.handleMiscellaneousListOfEvents(
        emit: emit, state: state);
  }

  FutureOr<void> _onTriggerAddScrollControllerListener(
      TriggerAddScrollControllerListener event,
      Emitter<AllEventsWithInitialState> emit) {

    // state.scrollController.addListener(() {
    //   if (state.scrollController.position.pixels ==
    //       state.scrollController.position.maxScrollExtent) {
    //     num page = state.page;
    //     num totalPage = state.totalPage;
    //     if (page < totalPage) {
    //       emit(state.copyWith(
    //         page: page + 1,
    //       ));
    //       if (state.filterType == FilterType.miscellaneous) {
    //         add(TriggerFetchAllEvents());
    //       } else {
    //         add(TriggerFetchFilterResults(filterType: state.filterType,page: page));
    //       }
    //     }
    //   }
    // });

    add( TriggerFetchFilterResults(
      isSwitch: true,
        filterType: FilterType.upcoming, page: 1, isList: true));
  }

  FutureOr<void> _onTriggerFetchFilterResults(TriggerFetchFilterResults event,
      Emitter<AllEventsWithInitialState> emit) async {
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isFilterOn: event.isList ? false : true,
      isLoadingList: event.isSwitch,
      isFilterOnForList: event.isList? true : false,
      isFailure: false,
      isRefreshRequired: false,
      filterType: event.filterType,
      scrollController: state.scrollController,
      showEraser: false,
      showEraserForEraser: false,
      isSearchModeOn: false,
      userLocation: null,
      searchControllerForList: TextEditingController(text: AppStrings.global_empty_string),
      searchController:
          TextEditingController(text: AppStrings.global_empty_string),
    ));

    try {
      final response = await EventsRepository.getFilteredEvents(
          page: event.page?? 1, filterType: event.filterType);
      response.fold(
          (failure) => AllEventsHandlers.emitErrorState(
              state: state, emit: emit, message: failure.message), (success) {
        List<EventData> updatedEventData =
            AllEventsHandlers.updateEventDataParameter(
                assetUrl: success.responseData!.assetsUrl!,
                events: success.responseData!.data!);


        if (event.filterType == FilterType.upcoming) {

          emit(state.copyWith(
            isLoadingList: false,
            isFailure: false,
            page: success.responseData!.page!,
            miscellaneous: [],
            filterType: event.filterType,
            isFilterOn: true,
            totalPage: success.responseData!.totalPage!,
            past: [],
            upcoming: [...state.upcoming, ...updatedEventData],
            allEventsData:[...state.upcoming, ...updatedEventData],
          ));
        } else {

          emit(state.copyWith(
            isLoadingList: false,
            isFailure: false,
            page: success.responseData!.page!,
            miscellaneous: [],
            filterType: event.filterType,
            isFilterOn: true,
            totalPage: success.responseData!.totalPage!,
            upcoming: [],
            past: [...state.past, ...updatedEventData],
            allEventsData: [...state.past, ...updatedEventData],
          ));
        }
        debugPrint('User Location 888 ${state.scrollController.position}');
      });
    } catch (e) {
      AllEventsHandlers.emitErrorState(
          state: state, emit: emit, message: e.toString());
    }
  }

  FutureOr<void> _onTriggerTapOnFilter(
      TriggerTapOnFilter event, Emitter<AllEventsWithInitialState> emit) {
    emit(state.copyWith(
        isFilterOn: !state.isFilterOn,
        upcoming: [],
        past: [],
        isSearchModeOn: false,
        showEraser: false,
        showEraserForEraser: false,
        isRefreshRequired: true,
        message: AppStrings.global_empty_string,
        isLoading: false,
        searchControllerForList: TextEditingController(text: AppStrings.global_empty_string),
        searchController:
            TextEditingController(text: AppStrings.global_empty_string),
        miscellaneous: [],
        allEventsData: []));
    if (state.isFilterOn) {
      if (event.isMap) {
        add(const TriggerFetchFilterEventsOnMap(
            filterType: FilterType.upcoming));
      } else {
        add( TriggerFetchFilterResults(
          isSwitch: true,
            filterType: FilterType.upcoming, isList: false));
      }
    } else {
      if (event.isMap) {
        add(const TriggerFetchAllEventsOnMap(isFirstTime: false));
      } else {
        add(TriggerFetchAllEvents());
      }
    }
  }

  FutureOr<void> _onTriggerSearchEvent(
      TriggerSearchEvent event, Emitter<AllEventsWithInitialState> emit) async {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isLoading: event.isList? false: true,
        isLoadingList: event.isList? true: false,
        isFilterOnForList: event.isList? true: false,
        isFailure: false,
        isRefreshRequired: false,
        miscellaneous: [],
        upcoming: [],
        past: [],
        filterType: event.filterType,
        isFilterOn: event.isList? false: true,
        isSearchModeOn: true));

    try {
      final response = await EventsRepository.getSearchResults(
          page: 1,
          filterType: event.filterType,
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
          filterType: event.filterType,
          isFilterOnForList: true,
          searchKeyForNoResult: state.searchControllerForList.text,
          allEventsData: updateEventData,
        ));
      });
    } catch (e) {
      AllEventsHandlers.emitErrorState(
          state: state, emit: emit, message: e.toString());
    }
    // await AllEventsHandlers.handleSearchListOfEvents(state: state, emit: emit);
  }

  FutureOr<void> _onTriggerSearchEventOnMap(TriggerSearchEventsOnMap event,
      Emitter<AllEventsWithInitialState> emit) async {
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isLoading: true,
      isFailure: false,
      isFilterOn: false,
      userLocation: null,
      customMarkers: [],
      filterType: FilterType.miscellaneous,
      isRefreshRequired: false,
      isSearchModeOn: true,
    ));
    try {
      final response = await EventsRepository.getSearchEventsOnMap(
          searchKey: state.searchController.text);
      response.fold((failure) {
        AllEventsHandlers.emitErrorState(
            emit: emit, state: state, message: failure.message);
      }, (success) {
        List<MarkerData> customMarkers =
            AllEventsHandlers.updateEventMarkerDataParameter(
                assetUrl: success.responseData!.assetsUrl!,
                events: success.responseData!.events!);
        emit(state.copyWith(
          customMarkers: customMarkers,
          isLoading: false,
          isFailure: customMarkers.isNotEmpty ? false : true,
          isRefreshRequired: false,
          message: customMarkers.isNotEmpty
              ? AppStrings.global_empty_string
              : AppStrings.allEvents_emptySearchResult_text(
                  searchKey: state.searchController.text),
        ));
      });
    } catch (e) {
      AllEventsHandlers.emitErrorState(
          emit: emit, state: state, message: e.toString());
    }
  }

  FutureOr<void> _onTriggerFetchFilterEventsOnMap(
      TriggerFetchFilterEventsOnMap event,
      Emitter<AllEventsWithInitialState> emit) async {
    // AllEventsHandlers.emitRefreshState(emit: emit, state: state);
    emit(state.copyWith(
      customMarkers: [],
      userLocation: null,
      filterType: event.filterType,
    ));
    try {
      final response =
          await EventsRepository.getEventsOnMap(filterType: event.filterType);
      response.fold((failure) {
        AllEventsHandlers.emitErrorState(
            emit: emit, state: state, message: failure.message);
      }, (success) {
        List<MarkerData> customMarkers =
            AllEventsHandlers.updateEventMarkerDataParameter(
                assetUrl: success.responseData!.assetsUrl!,
                events: success.responseData!.events!);
        emit(state.copyWith(
          customMarkers: customMarkers,
          isLoading: false,
          isFailure: customMarkers.isNotEmpty ? false : true,
          isRefreshRequired: false,
          filterType: event.filterType,
          message: customMarkers.isNotEmpty
              ? AppStrings.global_empty_string
              : event.filterType == FilterType.upcoming
                  ? AppStrings.allEvents_emptyUpcomingMap_text
                  : AppStrings.allEvents_emptyPastMap_text,
        ));
      });
    } catch (e) {
      AllEventsHandlers.emitErrorState(
          emit: emit, state: state, message: e.toString());
    }
  }

  FutureOr<void> _onTriggerRefreshPage(
      TriggerRefreshPage event, Emitter<AllEventsWithInitialState> emit) {
    emit(AllEventsWithInitialState.initial());
    emit(state.copyWith(filterType: FilterType.upcoming,isFilterOnForList: true, isFilterOn: false));
    add(TriggerAddScrollControllerListener());
  }

  FutureOr<void> _onTriggerPagination(TriggerPagination event, Emitter<AllEventsWithInitialState> emit) {
   if(state.page < state.totalPage) {
     num page = state.page + 1;
     debugPrint('Page 888 $page ${state.scrollController.position}');
     emit(state.copyWith(page: page, isRefreshRequired: false,
       scrollController: state.scrollController,
     ));
     add(TriggerFetchFilterResults(filterType: state.filterType,
         isSwitch: false,
         page: page, isList: true));

   }
  }
}
