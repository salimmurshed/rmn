part of 'user_chat_list_bloc.dart';


@freezed
class UserChatListState with _$UserChatListState {
  const factory UserChatListState({
    required bool isLoading,
    required bool isLoadingMore,
    required int selectedTabIndex,
    required FocusNode focusNode,
    required bool showEraser,
    required List<ChatType> chatCatagories,
    required ChatType selectedCatagory,
    required bool isFailure,
    required String message,
    required GeneralListresponseData? chatListData,
    required ScrollController? scrollController,
    required bool? shouldUndoVisible,
    required GeneralChatData? recentlyArchivedChat,
    required num? unreadCount,
    required num? archiveCount,
    required String eventId,
  }) = _UserChatListState;

  factory UserChatListState.initial() =>
      UserChatListState(isLoading: true, selectedTabIndex: 0, focusNode: FocusNode(), showEraser: false, chatCatagories: [ChatType.All, ChatType.Unread, ChatType.Archived], isFailure:  false, message: AppStrings.global_empty_string, chatListData: null, scrollController: ScrollController(), selectedCatagory: ChatType.All, shouldUndoVisible: false, recentlyArchivedChat: GeneralChatData(), unreadCount: 0, archiveCount: 0, eventId: '', isLoadingMore: false);
}