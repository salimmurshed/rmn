part of 'staff_chat_bloc.dart';

@immutable
sealed class StaffChatEvent extends Equatable {
  const StaffChatEvent();

  @override
  List<Object?> get props => [];
}

class TriggerFetchEventsList extends StaffChatEvent {
  const TriggerFetchEventsList();
}


class TriggerPickDivision extends StaffChatEvent {
  final int divIndex;
  const TriggerPickDivision({required this.divIndex});

  @override
  List<Object?> get props => [divIndex];
}



class TriggerRefreshDataOfEvent extends StaffChatEvent {

}

class TriggerMoveToEventChatList extends StaffChatEvent {
  final String eventId;
  final String coverImage;
  const TriggerMoveToEventChatList({required this.eventId, required this.coverImage});

  @override
  List<Object?> get props => [eventId];
}





class TriggerSearchEvent extends StaffChatEvent {
  final String searchText;
  const TriggerSearchEvent({required this.searchText});
  @override
  List<Object?> get props => [searchText];
}

class TriggerUpdateEventListOnMessage extends StaffChatEvent {
  final Chats message;
  const TriggerUpdateEventListOnMessage({required this.message});
  @override
  List<Object?> get props => [message];
}

class TiriggerDisconnectSocket extends StaffChatEvent {
  @override
  List<Object?> get props => [];
}
class TiriggerSetMessageRead extends StaffChatEvent {
  final int index;
  const TiriggerSetMessageRead({required this.index});
  @override
  List<Object?> get props => [index];
}

class TriggerReduseCount extends StaffChatEvent {
  final String eventId;
  final bool isReduse;
  final num totalMessageCount;
  const TriggerReduseCount({required this.eventId, required this.isReduse, required this.totalMessageCount});
  @override
  List<Object?> get props => [eventId, isReduse, totalMessageCount];
}

class TriggerUpdateList extends StaffChatEvent {
  final List<EventListEventData> data;
  const TriggerUpdateList({required this.data});
  @override
  List<Object?> get props => [data];
}