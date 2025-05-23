part of 'staff_home_bloc.dart';

@freezed
class StaffHomeWithInitialState with _$StaffHomeWithInitialState {
  const factory StaffHomeWithInitialState({
    required String message,
    required bool isLoading,
    required bool isRefreshedRequired,
    required bool isFailure,
    required String imageUrl,
    required String name,
    required String assetUrl,
    required StripeReaderData? readerData,
    required List<EventData> eventList,
    required EventData? eventData,
  }) = _StaffHomeWithInitialState;

  factory StaffHomeWithInitialState.initial() =>
      const StaffHomeWithInitialState(
        isFailure: false,
        isLoading: true,
        isRefreshedRequired: false,
        eventList: [],
        eventData: null,
        assetUrl: AppStrings.global_empty_string,
        message: AppStrings.global_empty_string,
        imageUrl: AppStrings.global_empty_string,
        name: AppStrings.global_empty_string,
        readerData: null,
      );
}
