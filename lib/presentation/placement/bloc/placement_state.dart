part of 'placement_bloc.dart';

@freezed
class PlacementState with _$PlacementState {
  const factory PlacementState({
    required String message,
    required bool isLoading,
    required bool isRefreshedRequired,
    required bool isFailure,
    required List<Placements> placements,
    required int selectedDivType,
    required String unreads,
    required String requestUnReads,
  }) = _PlacementState;

  factory PlacementState.initial() =>
       const PlacementState(
        isFailure: false,
        isLoading: true,
        selectedDivType: 0,
        isRefreshedRequired: false,
        placements: [],
        requestUnReads: '0',
        unreads: '0',
        message: AppStrings.global_empty_string,
      );
}

