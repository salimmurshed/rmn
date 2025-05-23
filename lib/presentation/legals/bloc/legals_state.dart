part of 'legals_bloc.dart';

@freezed
class LegalsWithInitialState with _$LegalsWithInitialState {
  const factory LegalsWithInitialState({
    required String message,
    required bool isLoading,
    required bool isRefreshedRequired,
    required bool isFailure,
    required List<String> legals,
    required List<LegalsData>? data,
  }) = _LegalsWithInitialState;

  factory LegalsWithInitialState.initial() => const LegalsWithInitialState(
          isFailure: false,
          isLoading: false,
          isRefreshedRequired: false,
          message: AppStrings.global_empty_string,
          legals: [
            AppStrings.accountSettings_menu_legals_imprints_title,
            AppStrings.accountSettings_menu_legals_tou_title,
            AppStrings.accountSettings_menu_legals_pp_title,
            AppStrings.accountSettings_menu_legals_foss_title,
          ],
          data: []);
}
