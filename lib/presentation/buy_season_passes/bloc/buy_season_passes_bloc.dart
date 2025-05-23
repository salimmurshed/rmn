import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/presentation/buy_season_passes/bloc/buy_season_handlers.dart';
import 'package:rmnevents/root_app.dart';

import '../../../data/models/response_models/season_passes_response_model.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';

part 'buy_season_passes_event.dart';

part 'buy_season_passes_state.dart';

part 'buy_season_passes_bloc.freezed.dart';

class BuySeasonPassesBloc
    extends Bloc<BuySeasonPassesEvent, SeasonPassesWithInitialState> {
  BuySeasonPassesBloc() : super(SeasonPassesWithInitialState.initial()) {
    on<TriggerFetchSeasonPasses>(_onTriggerFetchSeasonPasses);
    on<TriggerCollectTransferredAthletes>(_onTriggerCollectTransferredAthletes);
    on<TriggerSelectSeasonPass>(_onTriggerSelectSeasonPass);
    on<TriggerRefreshSeasonPassBottomSheet>(
        _onTriggerRefreshSeasonPassBottomSheet);
    on<TriggerUpdateAthleteMembership>(_onTriggerUpdateAthleteMembership);
    on<TriggerAthleteRemove>(_onTriggerAthleteRemove);
    on<TriggerOpenBottomSheetForSelection>(
        _onTriggerOpenBottomSheetForSelection);
    on<TriggerAddAthleteBackToList>(_onTriggerAddAthleteBackToList);
    on<TriggerCollectAthletes>(_onTriggerCollectAthletes);
    on<TriggerRefresh>(_onTriggerRefresh);
    on<TriggerAthleteSelection>(_onTriggerAthleteSelection);
    on<TriggerCheckForVisibleAthletes>(_onTriggerCheckForVisibleAthletes);
    on<TriggerUpdateSeasonPassesSliderIndex>(
        _onTriggerUpdateSeasonPassesSliderIndex);
    on<TriggerFetchAthleteWithoutSeasonPass>(
        _onTriggerFetchAthleteWithoutSeasonPass);
  }

  FutureOr<void> _onTriggerFetchSeasonPasses(TriggerFetchSeasonPasses event,
      Emitter<SeasonPassesWithInitialState> emit) async {
    emit(SeasonPassesWithInitialState.initial());
    try {
      final response = await SeasonRepository.getSeasonPasses();
      response.fold(
        (failure) {
          emit(state.copyWith(
            seasonPasses: [],
            isFailure: true,
            message: failure.message,
            isLoadingSeasonPasses: false,
          ));
        },
        (success) {
          emit(state.copyWith(
            seasonPasses: success.responseData?.data ?? [],
            isFailure: false,
            message: AppStrings.global_empty_string,
            isLoadingSeasonPasses: false,
          ));
          add(const TriggerFetchAthleteWithoutSeasonPass());
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoadingSeasonPasses: false, isFailure: true));
    }
  }

  FutureOr<void> _onTriggerUpdateSeasonPassesSliderIndex(
      TriggerUpdateSeasonPassesSliderIndex event,
      Emitter<SeasonPassesWithInitialState> emit) {
    BuySeasonHandlers.emitRefreshState(emit: emit, state: state);

    emit(state.copyWith(
        currentSeasonPassIndex: event.index, isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerFetchAthleteWithoutSeasonPass(
      TriggerFetchAthleteWithoutSeasonPass event,
      Emitter<SeasonPassesWithInitialState> emit) async {
    BuySeasonHandlers.emitInitialState(emit: emit, state: state);

    try {
      final response = await AthleteRepository.getAthletesWithoutSeasonPass();
      response.fold(
        (failure) {
          emit(state.copyWith(
            isFailure: true,
            message: failure.message,
            isLoadingSeasonPasses: false,
          ));
        },
        (success) {
          List<Athlete> athletes =
              BuySeasonHandlers.updateAthleteSeasonParameter(
                  seasons: state.seasonPasses,
                  assetsUrl: success.responseData?.assetsUrl ??
                      AppStrings.global_empty_string,
                  athletes: success.responseData?.data ?? []);
          List<Athlete> availableAthletesForSelection = List.from(athletes);
          bool canWeProceedToPurchase =
              BuySeasonHandlers.checkIfWeCanProceedToPurchase(
                  athletes: athletes);

          emit(state.copyWith(
            athletesWithoutSeasonPass: athletes,
            athletesAvailableForSelection: availableAthletesForSelection,
            isFailure: false,
            canWeProceedToPurchase: canWeProceedToPurchase,
            message: AppStrings.global_empty_string,
            isLoadingSeasonPasses: false,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          isLoadingSeasonPasses: false,
          isFailure: true,
          message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerSelectSeasonPass(TriggerSelectSeasonPass event,
      Emitter<SeasonPassesWithInitialState> emit) {
    BuySeasonHandlers.emitRefreshState(emit: emit, state: state);
    List<Athlete> athletes = event.athletes;
    int index = event.athleteIndex;
    if (athletes[index].temporarySeasonPassTitle! == event.seasonPassTitle) {
      athletes[index].temporarySeasonPassTitle = AppStrings.global_empty_string;
    } else {
      athletes[index].temporarySeasonPassTitle = event.seasonPassTitle;
    }
    if (athletes[index].availableSeasonPasses!.isNotEmpty) {
      String seasonId = AppStrings.global_empty_string;
      for (var i = 0; i < state.seasonPasses.length; i++) {
        if (state.seasonPasses[i].title == event.seasonPassTitle) {
          seasonId = state.seasonPasses[i].id!;
          athletes[index].temporaryMembership = Memberships(
              id: seasonId,
              seasonTitle: state.seasonPasses[i].title,
              price: state.seasonPasses[i].price,
              seasonId: seasonId);
          break;
        }
      }
    } else {
      athletes[index].temporaryMembership = null;
    }
    emit(state.copyWith(
        currentSeasonPassTitle: event.seasonPassTitle,
        currentAthleteIndex: event.athleteIndex,
        athletesWithoutSeasonPass: athletes,
        isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerAthleteRemove(
      TriggerAthleteRemove event, Emitter<SeasonPassesWithInitialState> emit) {
    BuySeasonHandlers.emitRefreshState(emit: emit, state: state);
    List<Athlete> athletes = List.from(event.athletes);
    athletes[event.athleteIndex].isSelected = false;
    athletes[event.athleteIndex].isInList = false;
    athletes[event.athleteIndex].isSelected = false;
    athletes[event.athleteIndex].selectedSeasonPassTitle =
        AppStrings.global_empty_string;
    athletes[event.athleteIndex].membership = null;
    athletes[event.athleteIndex].temporaryMembership = null;
    athletes[event.athleteIndex].temporarySeasonPassTitle =
        AppStrings.global_empty_string;
    athletes.removeAt(event.athleteIndex);
    bool canWeProceedToPurchase =
        BuySeasonHandlers.checkIfWeCanProceedToPurchase(athletes: athletes);
    emit(state.copyWith(
        canWeProceedToPurchase: canWeProceedToPurchase,
        athletesWithoutSeasonPass: athletes,
        isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerAthleteSelection(TriggerAthleteSelection event,
      Emitter<SeasonPassesWithInitialState> emit) {
    BuySeasonHandlers.emitRefreshState(emit: emit, state: state);
    List<Athlete> selectedAthletes = event.athleteAvailableForSelection;
    bool isAnAthleteAddedBack = false;
    selectedAthletes[event.athleteIndex].isSelected =
        !selectedAthletes[event.athleteIndex].isSelected!;

    for (Athlete athlete in selectedAthletes) {
      if (athlete.isSelected!) {
        isAnAthleteAddedBack = true;
        break;
      }
    }
    emit(state.copyWith(
        isAnAthleteAddedBack: isAnAthleteAddedBack,
        athletesAvailableForSelection: selectedAthletes,
        isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerAddAthleteBackToList(
      TriggerAddAthleteBackToList event,
      Emitter<SeasonPassesWithInitialState> emit) {
    BuySeasonHandlers.emitRefreshState(emit: emit, state: state);
    List<Athlete> updatedAthleteList =
        List.from(event.athletesWithoutSeasonPass);

    List<Athlete> availableAthletes = List.from(event.availableAthletes);
    for (Athlete athlete in availableAthletes) {
      if (!athlete.isInList! && athlete.isSelected!) {
        athlete.isSelected = true;
        athlete.isInList = true;
        athlete.membership = null;
        athlete.temporaryMembership = null;
        athlete.selectedSeasonPassTitle = AppStrings.global_empty_string;
        updatedAthleteList.add(athlete);
      }
    }

    bool canWeProceedToPurchase =
        BuySeasonHandlers.checkIfWeCanProceedToPurchase(
            athletes: updatedAthleteList);

    emit(state.copyWith(
        canWeProceedToPurchase: canWeProceedToPurchase,
        athletesWithoutSeasonPass: updatedAthleteList,
        isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerOpenBottomSheetForSelection(
      TriggerOpenBottomSheetForSelection event,
      Emitter<SeasonPassesWithInitialState> emit) {
    emit(state.copyWith(isRefreshRequired: false, isAnAthleteAddedBack: false));
  }

  FutureOr<void> _onTriggerUpdateAthleteMembership(
      TriggerUpdateAthleteMembership event,
      Emitter<SeasonPassesWithInitialState> emit) {
    emit(state.copyWith(isRefreshRequired: true));
    event.athletes[event.athleteIndex].selectedSeasonPassTitle =
        event.athletes[event.athleteIndex].temporarySeasonPassTitle!;
    if (event
        .athletes[event.athleteIndex].selectedSeasonPassTitle!.isNotEmpty) {
      event.athletes[event.athleteIndex].membership =
          event.athletes[event.athleteIndex].temporaryMembership;
    } else {
      event.athletes[event.athleteIndex].membership = null;
      event.athletes[event.athleteIndex].temporaryMembership = null;
    }

    bool canWeProceedToPurchase =
        BuySeasonHandlers.checkIfWeCanProceedToPurchase(
            athletes: event.athletes);
    emit(state.copyWith(
        canWeProceedToPurchase: canWeProceedToPurchase,
        athletesWithoutSeasonPass: event.athletes,
        isRefreshRequired: false,
        currentAthleteIndex: event.athleteIndex));
  }

  FutureOr<void> _onTriggerCollectAthletes(TriggerCollectAthletes event,
      Emitter<SeasonPassesWithInitialState> emit) {
    List<Athlete> athletes = BuySeasonHandlers.collectSelectedAthletes(
        athletes: state.athletesWithoutSeasonPass);
    emit(state.copyWith(athletesSelectedForPurchase: athletes));
    Navigator.pushNamed(
            navigatorKey.currentContext!, AppRouteNames.routePurchases,
            arguments: CouponModules.seasonPasses)
        .then((value) {
      add(TriggerRefresh());
    });
  }

  FutureOr<void> _onTriggerCollectTransferredAthletes(
      TriggerCollectTransferredAthletes event,
      Emitter<SeasonPassesWithInitialState> emit) {
    emit(state.copyWith(
        isLoadingSeasonPasses: false,
        isFailure: false,
        canWeProceedToPurchase:
            event.athletes.any((element) => element.membership != null),
        message: AppStrings.global_empty_string,
        athletesWithoutSeasonPass: event.athletes));
  }

  FutureOr<void> _onTriggerRefresh(
      TriggerRefresh event, Emitter<SeasonPassesWithInitialState> emit) {
    BuySeasonHandlers.emitRefreshState(emit: emit, state: state);
    bool canWeProceed = BuySeasonHandlers.checkIfWeCanProceedToPurchase(
        athletes: state.athletesWithoutSeasonPass);
    // for (var element in state.athletesAvailableForSelection) {
    //   element.isSelected = true;
    //   // element.isInList = true;
    // }
    emit(state.copyWith(
      canWeProceedToPurchase: canWeProceed,
      isLoadingSeasonPasses: false,
      isRefreshRequired: false,
    ));
  }

  FutureOr<void> _onTriggerRefreshSeasonPassBottomSheet(
      TriggerRefreshSeasonPassBottomSheet event,
      Emitter<SeasonPassesWithInitialState> emit) {
    BuySeasonHandlers.emitRefreshState(emit: emit, state: state);
    String seasonTitle =
        state.athletesWithoutSeasonPass[event.index].selectedSeasonPassTitle ??
            AppStrings.global_empty_string;
    if (seasonTitle.isNotEmpty) {
      for (int i = 0; i < state.seasonPasses.length; i++) {
        if (state.seasonPasses[i].title == seasonTitle) {
          state.athletesWithoutSeasonPass[event.index]
              .temporarySeasonPassTitle = state.seasonPasses[i].title;
          state.athletesWithoutSeasonPass[event.index].temporaryMembership =
              Memberships(
            id: state.seasonPasses[i].id,
            seasonTitle: state.seasonPasses[i].title,
            price: state.seasonPasses[i].price,
            seasonId: state.seasonPasses[i].id,
          );
        }
      }
    }
    emit(state.copyWith(
        isRefreshRequired: false,
        athletesWithoutSeasonPass: state.athletesWithoutSeasonPass));
  }

  FutureOr<void> _onTriggerCheckForVisibleAthletes(
      TriggerCheckForVisibleAthletes event,
      Emitter<SeasonPassesWithInitialState> emit) async {}
}
