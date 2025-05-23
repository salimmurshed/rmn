import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/resources/app_strings.dart';
import '../../../data/models/response_models/rank_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/repository/placement_repository.dart';

part 'placement_event.dart';

part 'placement_state.dart';

part 'placement_bloc.freezed.dart';

class PlacementBloc extends Bloc<PlacementEvent, PlacementState> {
  PlacementBloc() : super(PlacementState.initial()) {
    on<TriggerPlacementList>(_onTriggerPlacementList);
    on<TriggerSelectDivision>(_onTriggerSelectDivision);
  }

  FutureOr<void> _onTriggerPlacementList(TriggerPlacementList event, Emitter<PlacementState> emit)async {
    emit(PlacementState.initial());
    try {
      final response = await PlacementRepository.getRanks(id: event.eventId);
      response.fold(
              (l) => emit(state.copyWith(
            message: l.message,
            isFailure: true,
            isLoading: false,
          )), (r) {
        List<Placements> placements = r.responseData?.placements ?? [];
        for (Placements placement in placements) {
          for (DivisionsRank division in placement.divisions ?? []) {
            for (WeightClassesRank weightClass
            in division.weightClasses ?? []) {
              for (AthletesRank athlete in weightClass.athletes ?? []) {
                if (athlete.athleteDetails != null) {
                  athlete.athleteDetails!.profileImage =
                      r.responseData!.assetsUrl! +
                          athlete.athleteDetails!.profileImage!;
                }
              }
            }
          }
        }
        emit(state.copyWith(
          placements: placements,
          isLoading: false,
          isFailure: false,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        isFailure: true,
        isLoading: false,
      ));
    }
  }

  FutureOr<void> _onTriggerSelectDivision(TriggerSelectDivision event, Emitter<PlacementState> emit) {
    emit(state.copyWith(message: AppStrings.global_empty_string, isRefreshedRequired: true));
    emit(state.copyWith(selectedDivType: event.index, isRefreshedRequired: false));
  }
}
