part of 'user_chat_list_bloc.dart';


@immutable
sealed class UserChatListEvent extends Equatable {
  const UserChatListEvent();

  @override
  List<Object?> get props => [];
}
class TriggerFetchChatList extends UserChatListEvent {
  final int page;
  final ChatType status;
  final bool isRefreshRequeired;
  const TriggerFetchChatList({required this.page, required this.status,required this.isRefreshRequeired});
  @override
  List<Object?> get props => [page];
}

class TriggerChangeFillter extends UserChatListEvent {
  final ChatType selectedType;
  const TriggerChangeFillter({required this.selectedType});
  @override
  List<Object?> get props => [selectedType];
}

class TriggerRefreshData extends UserChatListEvent {}

class TriggerGeneralChatDelete extends UserChatListEvent {
  final String roomId;
  const TriggerGeneralChatDelete({required this.roomId});
  @override
  List<Object?> get props => [roomId];
}

class TriggerAddToArchive extends UserChatListEvent {
  final String roomId;
  const TriggerAddToArchive({required this.roomId});
  @override
  List<Object?> get props => [roomId];
}
class TriggerUnArchivedAll extends UserChatListEvent {}

class TriggerUnArchiveOnly extends UserChatListEvent {
  final String roomId;
  final bool shouldRemoveFromList;
  const TriggerUnArchiveOnly({required this.roomId, required this.shouldRemoveFromList});
  @override
  List<Object?> get props => [roomId];
}

class TriggerPagginationForGenralChatList extends UserChatListEvent {}
class TiriggerDisconnectSocket extends UserChatListEvent {
  @override
  List<Object?> get props => [];
}
class TiriggerSetMessageRead extends UserChatListEvent {
  final int index;
  const TiriggerSetMessageRead({required this.index});
  @override
  List<Object?> get props => [index];
}

class TriggerUpdateEventListOnMessageForGeneral extends UserChatListEvent {
  final Chats message;
  const TriggerUpdateEventListOnMessageForGeneral({required this.message});
  @override
  List<Object?> get props => [message];
}
class TriggerUpdateEventListOnMessageForEvent extends UserChatListEvent {
  final Chats message;
  const TriggerUpdateEventListOnMessageForEvent({required this.message});
  @override
  List<Object?> get props => [message];
}
class TriggerUnreadAllMesssage extends UserChatListEvent {
  final int index;
  const TriggerUnreadAllMesssage({required this.index});
  @override
  List<Object?> get props => [index];
}

class TriggerUnreadFetchUnreadCounts extends UserChatListEvent {}

class TriggerAddbacktoList extends UserChatListEvent {}
class TriggerAddClearData extends UserChatListEvent {}
class TriggerAssignDataToState extends UserChatListEvent {
  final String eventId;
  const TriggerAssignDataToState({required this.eventId});
  @override
  List<Object?> get props => [eventId];
}