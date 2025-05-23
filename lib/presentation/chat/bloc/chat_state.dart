part of 'chat_bloc.dart';

@freezed
class ChatWithInitialState with _$ChatWithInitialState {
  const factory ChatWithInitialState({
    required String message,
    required bool isLoading,
    required bool moveToBottom,
    required bool isRefreshedRequired,
    required bool isFailure,
    required List<Chats> chats,
    required String eventImage,
    required LinkHighlightingController messageController,
    required FocusNode messageFocus,
    required ScrollController scrollController,
    required bool isInsideChatView,
    required bool isSupportAgentAvialable,
    required String roomId,
  }) = _ChatWithInitialState;

  factory ChatWithInitialState.initial() =>
       ChatWithInitialState(
        isFailure: false,
        isLoading: true,
        isRefreshedRequired: false,
        eventImage: AppStrings.global_empty_string,
        message: AppStrings.global_empty_string,
        isInsideChatView: false,
        roomId: '',
        chats: [],
          messageController: LinkHighlightingController(),
          messageFocus:  FocusNode(),
          scrollController:  ScrollController(),
         moveToBottom: false,
         isSupportAgentAvialable: navigatorKey.currentContext!.read<BaseBloc>().state.isSupportAgentAvilable,
       );
}
