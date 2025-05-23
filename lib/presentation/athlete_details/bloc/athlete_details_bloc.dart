import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rmnevents/imports/data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/response_models/season_passes_response_model.dart';
import '../../../imports/common.dart';
import 'athlete_details_handlers.dart';

part 'athlete_details_event.dart';

part 'athlete_details_state.dart';

part 'athlete_details_bloc.freezed.dart';

class AthleteDetailsBloc
    extends Bloc<AthleteDetailsEvent, AthleteDetailsWithInitialState> {
  AthleteDetailsBloc() : super(AthleteDetailsWithInitialState.initial()) {
    on<TriggerAthleteDetailsFetch>(_onTriggerAthleteDetailsFetch);
    on<TriggerRefreshAthleteDetails>(_onTriggerRefreshAthleteDetails);
    on<TriggerEventsFetch>(_onTriggerEventsFetch);
    on<TriggerTabSelection>(_onTriggerTabSelection);
    on<TriggerDropDownSelection>(_onTriggerDropDownSelection);
    on<TriggerViewPartialOwnerList>(_onTriggerViewPartialOwnerList);
    on<TriggerRemovePartialOwner>(_onTriggerRemovePartialOwner);
    on<TriggerFilterThroughDivList>(_onTriggerFilterThroughDivList);
  }

  FutureOr<void> _onTriggerAthleteDetailsFetch(TriggerAthleteDetailsFetch event,
      Emitter<AthleteDetailsWithInitialState> emit) async {
    emit(AthleteDetailsWithInitialState.initial());
    String? selectedValue;
    String seasonId = AppStrings.global_empty_string;
    if (event.seasons.isNotEmpty) {
      seasonId = event.seasons.first.id!;
    }
    if (seasonId.isNotEmpty) {
      selectedValue =
          event.seasons.firstWhere((element) => element.id! == seasonId).title;
    }
    await fetchAthleteDetailWithSeasonsId(
        isFirstTime: true,
        athleteId: event.athleteId,
        seasonId: seasonId,
        seasons: event.seasons,
        selectedValue: selectedValue ?? AppStrings.global_empty_string,
        emit: emit);
  }

  Future<void> fetchAthleteDetailWithSeasonsId(
      {required bool isFirstTime,
      required String athleteId,
      required String seasonId,
      required String selectedValue,
      required List<SeasonPass> seasons,
      required Emitter<AthleteDetailsWithInitialState> emit}) async {
    try {
      final response = await AthleteRepository.getAthleteDetails(
        athleteId: athleteId,
        seasonId: seasonId,
      );
      response.fold(
        (failure) {
          emit(
            state.copyWith(
              isFailure: true,
              isLoadingAthleteInfo: false,
              isRefreshedRequired: false,
              message: failure.message,
            ),
          );
        },
        (success) {
          Athlete athlete = AthleteDetailsHandlers.updateAthleteParameters(
            assetUrl: success.responseData!.assetsUrl!,
            athlete: success.responseData!.athlete!,
          );

          emit(
            state.copyWith(
                isFailure: false,
                isLoadingAthleteInfo: false,
                athlete: athlete,
                athleteId: athleteId,
                selectedValue: selectedValue,
                seasonId: seasonId,
                isRefreshedRequired: false),
          );
          if (isFirstTime) {
            // add(TriggerViewPartialOwnerList(
            //     athleteId: athleteId, isViewer: true));
            // add(TriggerViewPartialOwnerList(
            //     athleteId: athleteId, isViewer: false));
            add(
              TriggerEventsFetch(
                selectedValue: selectedValue,
                athleteId: athleteId,
                seasonId: seasonId,
                tabNo: 0,
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isFailure: true,
          isLoadingAthleteInfo: false,
          isRefreshedRequired: false,
          message: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onTriggerEventsFetch(TriggerEventsFetch event,
      Emitter<AthleteDetailsWithInitialState> emit) async {
    AthleteDetailsHandlers.emitWithLoaderForTabSelection(
        emit: emit, state: state);
    emit(
        state.copyWith(tabNo: event.tabNo, selectedValue: event.selectedValue));
    try {
      final response =
          await EventsRepository.getEventListSeasonWiseForSpecificAthlete(
              seasonId: event.seasonId,
              athleteId: event.athleteId,
              eventType: event.tabNo == 0
                  ? EventStatus.upcoming.name
                  : EventStatus.past.name);

      response.fold(
        (failure) {
          emit(
            state.copyWith(
              isFailure: true,
              isLoadingForTabs: false,
              isRefreshedRequired: false,
              message: failure.message,
            ),
          );
        },
        (success) {
          List<EventsSeasonWiseForAthlete> events =
              AthleteDetailsHandlers.updateEventsParameters(
                  assetUrl: success.responseData!.assetsUrl!,
                  events: success.responseData?.events ?? []);

          for (EventsSeasonWiseForAthlete event in events) {
            event.registrationWithDivisionIdList =
                AthleteDetailsHandlers.createListOfRegistrationWithDivisionId(
                    registrations: event.registrations ?? []);
          }

          emit(
            state.copyWith(
                isFailure: false,
                events: events,
                isLoadingForTabs: false,
                isRefreshedRequired: false),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isFailure: true,
          isLoadingForTabs: false,
          isRefreshedRequired: false,
          message: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onTriggerTabSelection(TriggerTabSelection event,
      Emitter<AthleteDetailsWithInitialState> emit) async {
    AthleteDetailsHandlers.emitWithLoaderForTabSelection(
        emit: emit, state: state);
    emit(
        state.copyWith(tabNo: event.tabNo, selectedValue: event.selectedValue));
    Either<Failure, AwardsResponseModel>? responseForAwards;
    Either<Failure, AthleteDetailsRankResponseModel>? responseForRanks;
    try {
      switch (event.tabNo) {
        case 2:
          print('****${state.seasonId}');
          responseForAwards =
              await AwardsRepository.getAwardsForSpecificAthlete(
                  athleteId: event.athleteId, seasonId: state.seasonId);
          break;
        case 3:
          responseForRanks = await RankRepository.getRanksForSpecificAthlete(
              athleteId: event.athleteId, seasonId: state.seasonId);
          break;
      }
      if (event.tabNo == 2) {
        fetchAwardsForSpecificAthlete(responseForAwards, emit);
      }
      if (event.tabNo == 3) {
        fetchRanksForSpecificAthlete(responseForRanks, emit);
      }
    } catch (e) {
      emit(
        state.copyWith(
          isFailure: true,
          isLoadingForTabs: false,
          isRefreshedRequired: false,
          message: e.toString(),
        ),
      );
    }
  }

  void fetchRanksForSpecificAthlete(
      Either<Failure, AthleteDetailsRankResponseModel>? responseForRanks,
      Emitter<AthleteDetailsWithInitialState> emit) {
    responseForRanks!.fold(
      (failure) {
        emit(
          state.copyWith(
            isFailure: true,
            isLoadingForTabs: false,
            isRefreshedRequired: false,
            message: failure.message,
          ),
        );
      },
      (success) {
        List<Ranks> ranks = AthleteDetailsHandlers.updateRankParameters(
            ranks: success.responseData?.ranks ?? []);
        emit(
          state.copyWith(
              isFailure: false,
              ranks: ranks,
              isLoadingForTabs: false,
              isRefreshedRequired: false),
        );
      },
    );
  }

  void fetchAwardsForSpecificAthlete(
      Either<Failure, AwardsResponseModel>? responseForAwards,
      Emitter<AthleteDetailsWithInitialState> emit) {
    responseForAwards!.fold(
      (failure) {
        emit(
          state.copyWith(
            isFailure: true,
            isLoadingForTabs: false,
            isRefreshedRequired: false,
            message: failure.message,
          ),
        );
      },
      (success) {
        List<Awards> awards = success.responseData?.awards ?? [];
        for (var i = 0; i < awards.length; i++) {
          awards[i].award!.image = StringManipulation.combineStings(
              prefix: success.responseData!.assetsUrl!,
              suffix: awards[i].award!.image!);
        }
        List<Division> divisions = [];
        List<String> divisionIds = [];
        for (var i = 0; i < awards.length; i++) {
          if (awards[i].division != null) {
            if (!divisionIds.contains(awards[i].division!.id!)) {
              divisions.add(awards[i].division!);
              divisionIds.add(awards[i].division!.id!);
            }
          }
        }
        List<Awards> allAwards = List.from(awards);
        // AthleteDetailsHandlers.updateAwardsParameters(
        //     assetUrl: success.responseData!.assetsUrl!,
        //     awards: success.responseData?.awards ?? []);
        emit(
          state.copyWith(
              isFailure: false,
              awards: awards,
              allAwards: allAwards,
              divisions: divisions,
              lastUpdate: success.responseData?.lastUpdate,
              isLoadingForTabs: false,
              isRefreshedRequired: false),
        );
      },
    );
  }

  FutureOr<void> _onTriggerDropDownSelection(TriggerDropDownSelection event,
      Emitter<AthleteDetailsWithInitialState> emit) async {
    AthleteDetailsHandlers.emitWithLoaderForTabSelection(
        emit: emit, state: state);
    emit(state.copyWith(selectedValue: event.selectedValue));

    String seasonId = event.seasons
        .firstWhere((element) => element.title == event.selectedValue)
        .id!;
    emit(state.copyWith(seasonId: seasonId));
    await fetchAthleteDetailWithSeasonsId(
        selectedValue: event.selectedValue,
        isFirstTime: false,
        athleteId: event.athleteId,
        seasonId: seasonId,
        seasons: event.seasons,
        emit: emit);
    switch (event.selectedTab) {
      case 0:
        add(TriggerEventsFetch(
            selectedValue: event.selectedValue,
            athleteId: event.athleteId,
            seasonId: seasonId,
            tabNo: 0));
      case 1:
        add(TriggerEventsFetch(
            selectedValue: event.selectedValue,
            athleteId: event.athleteId,
            seasonId: seasonId,
            tabNo: 1));
      case 2:
        add(TriggerTabSelection(
            selectedValue: event.selectedValue,
            athleteId: event.athleteId,
            seasonId: seasonId,
            tabNo: 2));
      case 3:
        add(TriggerTabSelection(
            selectedValue: event.selectedValue,
            athleteId: event.athleteId,
            seasonId: seasonId,
            tabNo: 3));
    }
  }

  FutureOr<void> _onTriggerViewPartialOwnerList(
      TriggerViewPartialOwnerList event,
      Emitter<AthleteDetailsWithInitialState> emit) async {
    emit(state.copyWith(
        isLoadingPartialOwners: true, message: AppStrings.global_empty_string));
    try {
      final response = await AthleteRepository.getAthletePartialOwnerList(
          athleteId: state.athleteId, isViewer: event.isViewer);
      response.fold((failure) {
        emit(state.copyWith(
            isLoadingPartialOwners: false, message: failure.message));
      }, (success) {
        List<DataBaseUser> viewers = [];
        List<DataBaseUser> coaches = [];
        for (DataBaseUser partialOwner in success.responseData!.users!) {
          DataBaseUser owner = DataBaseUser(
            underScoreId: partialOwner.underScoreId,
            lastName: GlobalHandlers.dataDecryptionHandler(
                value: partialOwner.lastName!),
            firstName: GlobalHandlers.dataDecryptionHandler(
                value: partialOwner.firstName!),
            profile: partialOwner.profile!.contains('http')
                ? partialOwner.profile
                : StringManipulation.combineStings(
                    prefix: success.responseData!.assetsUrl!,
                    suffix: partialOwner.profile!),
          );
          if (event.isViewer) {
            viewers.add(owner);
          } else {
            coaches.add(owner);
          }
        }
        if (event.isViewer) {
          emit(state.copyWith(isLoadingPartialOwners: false, viewers: viewers));
        } else {
          emit(state.copyWith(isLoadingPartialOwners: false, coaches: coaches));
        }
      });
    } catch (e) {
      emit(
          state.copyWith(isLoadingPartialOwners: false, message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerRemovePartialOwner(TriggerRemovePartialOwner event,
      Emitter<AthleteDetailsWithInitialState> emit) async {
    Navigator.pop(event.context);
    Navigator.pop(event.context);
    emit(state.copyWith(
        isLoadingPartialOwners: true, message: AppStrings.global_empty_string));

    try {
      final response = await AthleteRepository.removeAthletePartialOwner(
          isViewer: event.isViewer,
          athleteId: state.athleteId,
          userId: event.userId);
      response.fold((failure) {
        emit(state.copyWith(
            isLoadingPartialOwners: false, message: failure.message));
      }, (success) {
        emit(state.copyWith(
            isLoadingAthleteInfo: false,
            message:
                success.responseData?.message ?? AppStrings.global_empty_string,
            isRefreshedRequired: true));

        if (event.isViewer) {
          List<DataBaseUser> viewers = List.from(state.viewers);
          viewers
              .removeWhere((element) => element.underScoreId == event.userId);
          Athlete athlete = state.athlete!;
          athlete.viewers = viewers.length;
          emit(state.copyWith(
              isLoadingPartialOwners: false,
              athlete: athlete,
              viewers: viewers));
        } else {
          List<DataBaseUser> coaches = List.from(state.coaches);
          coaches
              .removeWhere((element) => element.underScoreId == event.userId);
          Athlete athlete = state.athlete!;
          athlete.coaches = coaches.length;
          emit(state.copyWith(
              isLoadingPartialOwners: false,
              athlete: athlete,
              coaches: coaches));
        }
      });
    } catch (e) {
      emit(
          state.copyWith(isLoadingPartialOwners: false, message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerRefreshAthleteDetails(
      TriggerRefreshAthleteDetails event,
      Emitter<AthleteDetailsWithInitialState> emit) {
    emit(AthleteDetailsWithInitialState.initial());
  }

  FutureOr<void> _onTriggerFilterThroughDivList(TriggerFilterThroughDivList event, Emitter<AthleteDetailsWithInitialState> emit) {
    emit(state.copyWith(
      isRefreshedRequired: true,
      message:  AppStrings.global_empty_string,
      isLoadingForTabs: false,
      isLoadingAthleteInfo: false,
    ));
    if(state.selectedDivIndex != event.index){
      Division division = state.divisions[event.index];
      List<Awards> awards = List.from(state.allAwards);
      awards.removeWhere((element) => element.division!.id != division.id);
      emit(state.copyWith(
        isRefreshedRequired: false,
        message:  AppStrings.global_empty_string,
        isLoadingForTabs: false,
        isLoadingAthleteInfo: false,
        awards: awards,
        selectedDivIndex: event.index,
      ));
    }
    else{
      List<Awards> awards = List.from(state.allAwards);
      emit(state.copyWith(
        isRefreshedRequired: false,
        message:  AppStrings.global_empty_string,
        isLoadingForTabs: false,
        awards: awards,
        selectedDivIndex: -1,
        isLoadingAthleteInfo: false));
    }

  }
}
