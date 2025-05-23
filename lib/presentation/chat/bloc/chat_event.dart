part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class TriggerFetchChat extends ChatEvent {
  final String eventId;
  final String? eventImage;
  final bool? isForGeneralChat;
  final bool? isFromPush;
  final String? eventIdForCheck;
  const TriggerFetchChat({required this.eventId, this.eventImage, this.isForGeneralChat, this.isFromPush, this.eventIdForCheck});
  @override

  List<Object> get props => [eventId, eventImage ?? '', isForGeneralChat ?? false, isFromPush ?? false, eventIdForCheck ?? ''];
}

class TriggerSendMessage extends ChatEvent {
 final String eventId;
 final String roomId;
 final bool? isFromGeneralChat;
 final String? reciverId;
 const TriggerSendMessage({required this.eventId, required this.roomId, this.isFromGeneralChat, this.reciverId});
  @override
  List<Object> get props => [eventId, roomId, isFromGeneralChat ?? false, reciverId ?? ''];
}

class TriggerInitSocket extends ChatEvent {

}
class TriggerReceiveMessage extends ChatEvent {
  final List<Chats> receivedMessages;
  final bool? isFromGeneralChat;
  const TriggerReceiveMessage({required this.receivedMessages, this.isFromGeneralChat});
  @override
  List<Object> get props => [receivedMessages, isFromGeneralChat ?? false];
}

class TriggerShowChatTime extends ChatEvent {
  final Chats chat;
  const TriggerShowChatTime({required this.chat});
  @override
  List<Object> get props => [chat];
}
class TriggerDisconnectSocket extends ChatEvent {

}
class TriggerOpenChat extends ChatEvent{
  final String roomId;
  const TriggerOpenChat({required this.roomId});
  @override
  // TODO: implement props
  List<Object> get props => [roomId];
}

class TriggerUnreadMesseage extends ChatEvent{
  final String roomId;
  final String eventId;
  const TriggerUnreadMesseage({required this.roomId, required this.eventId});
  @override
  List<Object> get props => [roomId, eventId];
}

class TriggerCloseChatView extends ChatEvent{}
class TriggerOpenChatView extends ChatEvent{}
class TriggerMarkAsRead extends ChatEvent{
  final String roomId;

  const TriggerMarkAsRead({required this.roomId});
  @override
  List<Object> get props => [roomId];
}
class TirggerAgentAvialibility extends ChatEvent{
  final bool isAvailable;
  const TirggerAgentAvialibility({required this.isAvailable});
  @override
  List<Object> get props => [isAvailable];
}
class TirggerDismissNoAgentAvailablePopup extends ChatEvent{}
