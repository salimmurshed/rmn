part of 'selected_customer_bloc.dart';

@freezed
class SelectedCustomerState with _$SelectedCustomerState {
  const factory SelectedCustomerState({
    required String message,
    required bool isRefreshRequired,
    required bool isFailure,
    required DataBaseUser? customer,
    required EventData? eventData,
    required bool? isFromOnBehalf,
  }) = _SelectedCustomerState;

  factory SelectedCustomerState.initial() => const SelectedCustomerState(
        isFailure: false,
        isRefreshRequired: true,
        message: AppStrings.global_empty_string,
        customer: null,
        eventData: null,
        isFromOnBehalf: null,
      );
}
