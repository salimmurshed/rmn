import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rmnevents/presentation/home/client_home_bloc/client_home_handlers.dart';
import 'package:rmnevents/root_app.dart';

import '../../../data/repository/pop_up_repository.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../services/shared_preferences_services/pop_up_cached_data.dart';
import '../../base/bloc/base_bloc.dart';
import '../page/client_home.dart';

part 'client_home_event.dart';

part 'client_home_state.dart';

part 'client_home_bloc.freezed.dart';

class ClientHomeBloc extends Bloc<ClientHomeEvent, ClientHomeWithInitialState> {
  ClientHomeBloc() : super(ClientHomeWithInitialState.initial()) {
    on<TriggerAddListenerForEventAndAthleteCardIndex>(
        _onTriggerAddListenerForEventAndAthleteCardIndex);
    on<TriggerUpdateCurrentIndex>(_onTriggerUpdateCurrentIndex);
    on<TriggerHomeEventsFetch>(_onTriggerHomeEventsFetch);
    on<TriggerCleanHomeData>(_onTriggerCleanHomeData);
    on<TriggerHomeAthletesFetch>(_onTriggerHomeAthletesFetch);
    on<TriggerHomeDataFetch>(_onTriggerHomeDataFetch);
    on<TriggerFetchPopUp>(_onTriggerFetchPopUp);
    on<TriggerCheckBoxPopUp>(_onTriggerCheckBoxPopUp);
  }

  List<String> storedIds = [];

  FutureOr<void> _onTriggerAddListenerForEventAndAthleteCardIndex(
      TriggerAddListenerForEventAndAthleteCardIndex event,
      Emitter<ClientHomeWithInitialState> emit) {
    int athleteCurrentIndex = 0;
    int eventCurrentIndex = 0;
    state.eventPageController.addListener(() {
      eventCurrentIndex = state.eventPageController.page!.round();
      add(TriggerUpdateCurrentIndex(
          isEvent: true, currentIndex: eventCurrentIndex));
    });
    state.athletePageController.addListener(() {
      athleteCurrentIndex = state.athletePageController.page!.round();
      add(TriggerUpdateCurrentIndex(
          isEvent: false, currentIndex: athleteCurrentIndex));
    });
    add(TriggerHomeAthletesFetch());
  }

  FutureOr<void> _onTriggerUpdateCurrentIndex(TriggerUpdateCurrentIndex event,
      Emitter<ClientHomeWithInitialState> emit) {
    if (event.isEvent) {
      emit(state.copyWith(eventCurrentIndex: event.currentIndex));
    } else {
      emit(state.copyWith(athleteCurrentIndex: event.currentIndex));
    }
  }

  FutureOr<void> _onTriggerHomeEventsFetch(TriggerHomeEventsFetch event,
      Emitter<ClientHomeWithInitialState> emit) async {
    // ClientHomeHandlers.emitWithLoaderForEvents(emit: emit, state: state);

    try {
      final response = await HomeRepository.getClientHome();
      response.fold(
        (failure) {
          emit(
            state.copyWith(
              isFailure: true,
              isLoadingEvents: false,
              message: failure.message,
            ),
          );
        },
        (success) {
          List<UpcomingRegistrations> upcomingRegistrations =
              success.responseData!.upcomingRegistrations ?? [];
          ClientHomeHandlers.updateAthleteProfilesParameter(
              assetsUrl: success.responseData!.assetsUrl!,
              upcomingRegistrations: upcomingRegistrations);
          EventData? liveEvent = success.responseData!.liveEvent;
          if (liveEvent != null) {
            liveEvent = ClientHomeHandlers.updateLiveEventStatus(
                liveEvent: liveEvent,
                assetUrl: success.responseData!.assetsUrl!);
          }

          emit(
            state.copyWith(
              isFailure: false,
              isLoadingEvents: false,
              message: AppStrings.global_empty_string,
              liveEvent: liveEvent,
              upcomingRegistrations: upcomingRegistrations,
            ),
          );

          add(TriggerAddListenerForEventAndAthleteCardIndex());
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isFailure: true,
          isLoadingEvents: false,
          message: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onTriggerHomeAthletesFetch(TriggerHomeAthletesFetch event,
      Emitter<ClientHomeWithInitialState> emit) async {
    ClientHomeHandlers.emitWithLoaderForAthletes(emit: emit, state: state);

    try {
      final response = await AthleteRepository.getAthletesOrSearchAthletes(
          athleteApiType: AthleteApiType.homeAthletes);
      response.fold(
        (failure) {
          emit(
            state.copyWith(
              isFailure: true,
              isLoadingAthletes: false,
              message: failure.message,
            ),
          );
        },
        (success) {
          for (var element in success.responseData!.data!) {
            element.profileImage = StringManipulation.combineStings(
                prefix: success.responseData!.assetsUrl!,
                suffix: element.profileImage!);
          }
          List<Athlete> athletes = [];
          if (success.responseData!.data != null) {
            if (success.responseData!.data!.isNotEmpty) {
              if (success.responseData!.data!.length > 5) {
                athletes = success.responseData!.data!.sublist(0, 5);
              } else {
                athletes = success.responseData!.data!;
              }
            }
          }
          emit(
            state.copyWith(
              isFailure: false,
              isLoadingAthletes: false,
              message: AppStrings.global_empty_string,
              homeAthletes: athletes,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(
          isFailure: true, isLoadingAthletes: false, message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerHomeDataFetch(
      TriggerHomeDataFetch event, Emitter<ClientHomeWithInitialState> emit) {
    // ClientHomeHandlers.emitWithLoaderForEvents(emit: emit, state: state);
    // emit(ClientHomeWithInitialState.initial());
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      athleteCurrentIndex: 0,
      eventCurrentIndex: 0,
    ));
    add(TriggerHomeEventsFetch());

    if (!isPopShown) {
      add(TriggerFetchPopUp());
    }
  }

  FutureOr<void> _onTriggerFetchPopUp(
      TriggerFetchPopUp event, Emitter<ClientHomeWithInitialState> emit) async {
    try {
      final response = await PopUpRepository.getPopUpList();
      storedIds = await instance<PopUpCachedData>().getIds() ?? [];
      response.fold((failure) {
        debugPrint('failure ${failure.message}');
        emit(state.copyWith(
            isFailure: true, message: AppStrings.global_empty_string));
      }, (success) async {
        if (success.responseData != null) {
          for (var element in success.responseData!.data!) {
            element.image = StringManipulation.combineStings(
                prefix: success.responseData!.assetsUrl!,
                suffix: element.image!);
            element.dontShowAgain = false;
          }
          List<String> ids = [];
          for (var element in success.responseData!.data!) {
            ids.add(element.id!);
          }

          emit(state.copyWith(
              isFailure: false,
              message: AppStrings.global_empty_string,
              popUps: success.responseData!.data!,
              showPopUp: true));
          List<PopUpData> popUps = success.responseData!.data!;
          for (var element in popUps) {
            for (var id in storedIds) {
              if (element.id == id) {
                element.dontShowAgain = true;
              }
            }
          }
          showSequentialPopups(navigatorKey.currentContext!, popUps);
          isPopShown = true;
        } else {
          emit(state.copyWith(
              isFailure: true, message: AppStrings.global_empty_string));
        }
      });
    } catch (e) {
      emit(state.copyWith(
          isFailure: true, isLoadingAthletes: false, message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerCleanHomeData(
      TriggerCleanHomeData event, Emitter<ClientHomeWithInitialState> emit) {
    emit(ClientHomeWithInitialState.initial());
  }

  FutureOr<void> _onTriggerCheckBoxPopUp(TriggerCheckBoxPopUp event,
      Emitter<ClientHomeWithInitialState> emit) async {
    emit(state.copyWith(
      isRefreshedRequired: true,
      message: AppStrings.global_empty_string,
      isLoadingAthletes: false,
      isLoadingEvents: false,
    ));
    List<PopUpData> popUps = state.popUps;
    String id = event.id;
    if (storedIds.contains(id)) {
      storedIds.remove(id);
      popUps.firstWhere((element) => element.id == id).dontShowAgain = false;
    } else {
      storedIds.add(id);
      popUps.firstWhere((element) => element.id == id).dontShowAgain = true;
    }

    await instance<PopUpCachedData>()
        .removeSharedPreferencesGeneralFunction(PopKeyManager.popUPId);
    await instance<PopUpCachedData>().setIds(value: storedIds);
    emit(state.copyWith(
      isRefreshedRequired: false,
      message: AppStrings.global_empty_string,
      isLoadingAthletes: false,
      isLoadingEvents: false,
      popUps: popUps,
    ));
  }
}
