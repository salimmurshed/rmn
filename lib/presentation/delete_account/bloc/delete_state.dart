part of 'delete_bloc.dart';

@freezed
class DeleteAccountWithInitialState with _$DeleteAccountWithInitialState {
  const factory DeleteAccountWithInitialState({
    required String message,
    required bool isLoading,
    required bool isRefreshedRequired,
    required bool isFailure,


  }) = _DeleteAccountWithInitialState;

  factory DeleteAccountWithInitialState.initial() =>
      const DeleteAccountWithInitialState(
          isFailure: false,
          isLoading: false,
          isRefreshedRequired: false,

          message: AppStrings.global_empty_string,

      );
}