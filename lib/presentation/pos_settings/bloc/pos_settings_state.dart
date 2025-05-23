part of 'pos_settings_bloc.dart';

@freezed
class PosSettingsState with _$PosSettingsState {
  const factory PosSettingsState({
    required String message,
    required bool isLoading,
    required bool isRefreshedRequired,
    required bool isFailure,
    required List<StripeReaderData> readers,
    required StripeReaderData? selectedReader,
    required int selectedIndex

  }) = _PosSettingsState;

  factory PosSettingsState.initial() =>
      const PosSettingsState(
        isFailure: false,
        isLoading: true,
        isRefreshedRequired: false,
        readers: [],
        selectedIndex: -1,
        selectedReader: null,
        message: AppStrings.global_empty_string,
      );
}
