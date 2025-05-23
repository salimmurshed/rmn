part of 'event_chat_list_bloc.dart';


@immutable
sealed class EventChatListEvent extends Equatable {
  const EventChatListEvent();
  @override
  List<Object?> get props => [];
}

class TriggerFetchEventListData extends EventChatListEvent {
  final String eventId;
  final int page;
  final ChatType type;
  const TriggerFetchEventListData({required this.eventId, required this.page, required this.type});

  @override
  List<Object?> get props => [eventId];
}

class TriggerChangeFillterforEventUserList extends EventChatListEvent {
  final ChatType selectedType;
  final String eventId;
  const TriggerChangeFillterforEventUserList({required this.selectedType, required this.eventId});

  @override
  List<Object?> get props => [selectedType, eventId];
}

class TriggerRefreshChatListData extends EventChatListEvent {
  final String eventId;
  final ChatType type;
  const TriggerRefreshChatListData({required this.eventId, required this.type});

  @override
  List<Object?> get props => [eventId];
}

class TriggerUnreadAllMessage extends EventChatListEvent {
  final int index;
  const TriggerUnreadAllMessage({required this.index});

  @override
  List<Object?> get props => [index];
}
class TriggerPagination extends EventChatListEvent {
  final String eventId;
  const TriggerPagination({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

