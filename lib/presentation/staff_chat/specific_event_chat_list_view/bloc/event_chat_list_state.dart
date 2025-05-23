part of 'event_chat_list_bloc.dart';


@freezed
class EventChatListState with _$EventChatListState {
  const factory EventChatListState({
    required bool isLoading,
    required bool isFailure,
    required String message,
    required String eventId,
    required List<ChatType> chatCatagories,
    required ChatType selectedCatagory,
    required GeneralListresponseData? eventChatListData,
  }) = _EventChatListState;

  factory EventChatListState.initial() =>
      EventChatListState(isLoading: true, isFailure: false, message: AppStrings.global_empty_string, eventChatListData: GeneralListresponseData(),chatCatagories: [ChatType.All, ChatType.Unread, ChatType.Archived], selectedCatagory: ChatType.All, eventId: '');
}