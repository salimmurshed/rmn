part of 'splash_bloc.dart';

@freezed
class SplashWithInitialState with _$SplashWithInitialState {
  const factory SplashWithInitialState({
    required String message,
    required bool isRefreshRequired,
    required bool isFailure,
    required String routeName,
  }) = _SplashWithInitialState;

  factory SplashWithInitialState.initial() => const SplashWithInitialState(
        isFailure: false,
        isRefreshRequired: false,
        message: AppStrings.global_empty_string,
        routeName: AppStrings.global_empty_string,
      );
}
