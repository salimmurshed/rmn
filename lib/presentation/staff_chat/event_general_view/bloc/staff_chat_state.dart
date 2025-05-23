part of 'staff_chat_bloc.dart';

@freezed
class StaffChatState with _$StaffChatState {
  const factory StaffChatState({
    required bool isLoading,
    required int selectedTabIndex,
    required List<String> tabs,
    required TextEditingController searchController,
    required FocusNode focusNode,
    required bool showEraser,
    required PageController pageController,
    required List<ChatType> chatCatagories,
    required ChatType selectedCatagory,
    required bool isFailure,
    required String message,
    required GeneralListresponseData? generalChatListData,
    required ScrollController? scrollControllerForGenralChat,
    required ChatEventListResponseData? eventListResponseData,
    required ChatEventListResponseData? tempEventListResponseData,
    required GlobalKey<FormState> formKey,
  }) = _StaffChatState;

  factory StaffChatState.initial() =>
      StaffChatState(isLoading: true, selectedTabIndex: 0, tabs: const ['Events', 'General'], searchController: TextEditingController(), focusNode: FocusNode(), showEraser: false, pageController: PageController(), chatCatagories: [ChatType.All, ChatType.Unread, ChatType.Archived], isFailure:  false, message: AppStrings.global_empty_string, generalChatListData: null, scrollControllerForGenralChat: ScrollController(), selectedCatagory: ChatType.All, eventListResponseData: ChatEventListResponseData(),tempEventListResponseData: ChatEventListResponseData(),formKey: GlobalKey<FormState>());
}
