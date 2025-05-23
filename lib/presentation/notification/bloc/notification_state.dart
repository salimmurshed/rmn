part of 'notification_bloc.dart';

@freezed
class NotificationWithInitialState with _$NotificationWithInitialState {
  const factory NotificationWithInitialState({
    required String message,
    required bool isLoading,
    required bool isRefreshedRequired,
    required bool isFailure,
    required List<Notifications> notifications,
    required String unreads,
    required String requestUnReads,
  }) = _NotificationWithInitialState;

  factory NotificationWithInitialState.initial() =>
      const NotificationWithInitialState(
        isFailure: false,
        isLoading: true,
        isRefreshedRequired: false,
        notifications: [],
        requestUnReads: '0',
        unreads: '0',
        message: AppStrings.global_empty_string,
      );
}
