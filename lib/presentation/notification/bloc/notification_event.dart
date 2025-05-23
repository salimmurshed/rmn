part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent extends Equatable{
  const NotificationEvent();

  @override
  List<Object> get props => [];
}
class TriggerGetNotifications extends NotificationEvent {
  final String type;
  const TriggerGetNotifications({this.type= AppStrings.global_empty_string});
  @override
  List<Object> get props => [type];
}
class TriggerGetNotificationCount extends NotificationEvent {
  final String messageType;
  const TriggerGetNotificationCount({required this.messageType});
 @override

  List<Object> get props => [messageType];
}