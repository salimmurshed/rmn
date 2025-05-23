import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:rmnevents/presentation/chat/bloc/chat_handler.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';
import 'package:rmnevents/presentation/staff_chat/user_chat_list/bloc/user_chat_list_bloc.dart';
import 'package:rmnevents/root_app.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../base/bloc/base_bloc.dart';
import '../../staff_chat/event_general_view/bloc/staff_chat_bloc.dart';
import '../../staff_chat/specific_event_chat_list_view/bloc/event_chat_list_bloc.dart';
import '../page/chat_view.dart';

part 'chat_event.dart';

part 'chat_state.dart';

part 'chat_bloc.freezed.dart';

convertToFigmaTime(DateTime createdTime) {
  String formattedTime = DateFormat('h:mm a').format(createdTime.toLocal());
  print(formattedTime);

  return formattedTime;
}

class ChatBloc extends Bloc<ChatEvent, ChatWithInitialState> {
  // String roomId = globalEventResponseData?.event?.chatRoomId ?? AppStrings.global_empty_string;
  // String eventImage = globalEventResponseData?.event?.coverImage ?? AppStrings.global_empty_string;

  initSocket(String eventId, String roomId, bool isFromDetailView,
      bool isForGenralChat, bool isFromPush) async {
    DataBaseUser user = await GlobalHandlers.extractUserHandler();
    if (isForGenralChat) {
      add(TriggerFetchChat(
          eventId: roomId,
          eventImage: globalEventResponseData?.event?.coverImage ??
              AppStrings.global_empty_string,
          isForGeneralChat: true,
          isFromPush: isFromPush,
          eventIdForCheck: eventId));
    } else {
      socket?.emit('joinRoom', {"room_id": roomId});
      if (isFromDetailView) {
        add(TriggerFetchChat(
            eventId: eventId,
            eventImage: globalEventResponseData?.event?.coverImage ??
                AppStrings.global_empty_string));
      } else {
        BlocProvider.of<EventDetailsBloc>(navigatorKey.currentContext!).add(
            TriggerFetchEventDetails(
                eventId: eventId, isFromDetailView: false));
      }
    }
  }

  ChatBloc() : super(ChatWithInitialState.initial()) {
    on<TriggerFetchChat>(_onTriggerFetchChat);
    on<TriggerSendMessage>(_onTriggerSendMessage);
    on<TriggerOpenChat>(_onTriggerOpenChat);
    on<TriggerReceiveMessage>(_onTriggerReceiveMessage);
    on<TriggerShowChatTime>(_onTriggerShowChatTime);
    on<TriggerDisconnectSocket>(_onTriggerDisconnectSocket);
    on<TriggerUnreadMesseage>(_onTriggerUnreadMEssage);
    on<TriggerCloseChatView>(_onTriggerCloseChatView);
    on<TriggerOpenChatView>(_onTriggerOpenChatView);
    on<TirggerAgentAvialibility>(_onTriggerAgentAvailabilty);
    on<TirggerDismissNoAgentAvailablePopup>(_onTriggerDismissNoAgentAvialable);
    on<TriggerMarkAsRead>(_onTriggerMarkAsRead);
  }

  FutureOr<void> _onTriggerFetchChat(TriggerFetchChat event,
      Emitter<ChatWithInitialState> emit) async {
    print(event.eventId);
    emit(state.copyWith(isInsideChatView: true));
    try {
      final response = event.isForGeneralChat ?? false
          ? await ChatRepository.getGeneralChat(eventId: event.eventId)
          : await ChatRepository.getEventChat(eventId: event.eventId);
      response.fold(
            (failure) {
          emit(state.copyWith(
            isLoading: false,
            isFailure: true,
          ));
        },
            (success) {
          List<Chats> chats = event.isForGeneralChat ?? false
              ? success.responseData?.data ?? []
              : success.responseData?.chats ?? [];
          chats = ChatHandler.updateChat(
              chats: chats, isGenralChat: event.isForGeneralChat ?? false);
          emit(state.copyWith(
              isLoading: false,
              chats: chats,
              eventImage: globalEventResponseData?.event?.coverImage ??
                  AppStrings.global_empty_string,
              moveToBottom: true
          ));
          if (event.isForGeneralChat ?? false) {
            add(TriggerUnreadMesseage(
                roomId: event.eventId, eventId: event.eventIdForCheck ?? ''));
            if (event.isFromPush ?? false) {
              BlocProvider.of<StaffChatBloc>(navigatorKey.currentContext!).add(
                  const TriggerFetchEventsList()
              );
              final check = navigatorKey.currentContext!.read<
                  UserChatListBloc>().state.eventId;
              if (check == event.eventIdForCheck) {
                BlocProvider
                    .of<UserChatListBloc>(navigatorKey.currentContext!)
                    .add(TriggerFetchChatList(
                    page: 1,
                    status: navigatorKey.currentContext!.read<
                        UserChatListBloc>().state.selectedCatagory,
                    isRefreshRequeired: true));
              }
            }
          }
          add(TriggerReceiveMessage(
              receivedMessages: navigatorKey.currentContext!
                  .read<BaseBloc>()
                  .state.recivedMessgaes));
          state.scrollController.jumpTo(
              state.scrollController.position.maxScrollExtent);
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
      ));
    }
  }

  //

  FutureOr<void> _onTriggerSendMessage(TriggerSendMessage event,
      Emitter<ChatWithInitialState> emit) async {
    DataBaseUser user = await GlobalHandlers.extractUserHandler();
    emit(state.copyWith(
      isRefreshedRequired: true,
    ));
    if (event.isFromGeneralChat ?? false) {
      print(event.roomId);
      print(event.reciverId);
      print(event.eventId);
      socket?.emit(
        'employeeSendMessage',
        {
          "message": state.messageController.text,
          "room_id": event.roomId,
          "receiver_id": event.reciverId,
          "event_id": event.eventId,
        },
      );
    } else {
      socket?.emit(
        'sendMessage',
        {
          "message": state.messageController.text,
          "event_id": event.eventId,
          "room_id": event.roomId,
        },
      );
    }

    List<Chats> chats = List.from(state.chats);
    chats.add(Chats(
      receiverId: null,
      senderId: user.id,
      showTime: true,
      createdAt: DateTime.now().toString(),
      chatTimeInAgoFormat: convertToFigmaTime(DateTime.now()),
      // GlobalHandlers.getHumanReadableTimeStampInAgoFormat(
      //     DateTime.now().toString()),
      roomId: event.roomId,
      dateTimeForGroupingChat: DateFormat.yMMMd().format(DateTime.now()),
      message: state.messageController.text,
    ));
    emit(state.copyWith(
        isRefreshedRequired: false,
        chats: chats,
        messageController: LinkHighlightingController(),
        messageFocus: FocusNode(),
        moveToBottom: true
    ));
  }

  Future<void> _onTriggerReceiveMessage(TriggerReceiveMessage event,
      Emitter<ChatWithInitialState> emit) async {
    List<Chats> receivedChats = ChatHandler.updateChat(
        chats: event.receivedMessages,
        isGenralChat: event.isFromGeneralChat ?? false);

    print(receivedChats.length);
    emit(state.copyWith(
      isRefreshedRequired: true,
    ));
    emit(state.copyWith(
        isRefreshedRequired: false,
        chats: [...state.chats, ...receivedChats],
        moveToBottom: true));
    DataBaseUser user = await GlobalHandlers.extractUserHandler();
    if (user.roles!.contains('admin') || user.roles!.contains('employee') ||
        user.roles!.contains('owner')) {
      if(state.chats.isNotEmpty && event.receivedMessages.isNotEmpty ){
        add(TriggerUnreadMesseage(roomId: state.chats.last.roomId ?? '',
            eventId: event.receivedMessages.last.eventId ?? ''));
      }

    }
    if(event.isFromGeneralChat != null) {
      if (!event.isFromGeneralChat!) {
        if (state.chats.isNotEmpty) {
          add(TriggerMarkAsRead(roomId: state.chats.last.roomId ?? ''));
        }
      }
    }
  }

  FutureOr<void> _onTriggerShowChatTime(TriggerShowChatTime event,
      Emitter<ChatWithInitialState> emit) {
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isRefreshedRequired: true,
    ));
    event.chat.chatTimeInAgoFormat =
        GlobalHandlers.getHumanReadableTimeStampInAgoFormat(
            event.chat.createdAt!);
    event.chat.showTime = !event.chat.showTime!;
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isRefreshedRequired: false,
    ));
  }

  FutureOr<void> _onTriggerDisconnectSocket(TriggerDisconnectSocket event,
      Emitter<ChatWithInitialState> emit) {}

  FutureOr<void> _onTriggerOpenChat(TriggerOpenChat event,
      Emitter<ChatWithInitialState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isLoading: true,
        roomId: event.roomId, chats: []
    ));
  }

  Future<void> _onTriggerUnreadMEssage(TriggerUnreadMesseage event,
      Emitter<ChatWithInitialState> emit) async {
    try {
      final response = await ChatRepository.unReadMessage(roomId: event.roomId);
      response.fold(
            (failure) {
          emit(state.copyWith(
            isLoading: false,
            isFailure: true,
          ));
        },
            (success) {
          emit(state.copyWith(
            isLoading: false,
            isFailure: false,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
      ));
    }
  }

  FutureOr<void> _onTriggerCloseChatView(TriggerCloseChatView event,
      Emitter<ChatWithInitialState> emit) {
    emit(state.copyWith(
      isLoading: false,
      isFailure: true,
      isRefreshedRequired: true,
      message: AppStrings.global_empty_string,
    ));
    emit(state.copyWith(
      isLoading: false,
      isFailure: false,
      isRefreshedRequired: false,
      isInsideChatView: false,
      message: AppStrings.global_empty_string,
    ));
  }

  FutureOr<void> _onTriggerOpenChatView(TriggerOpenChatView event,
      Emitter<ChatWithInitialState> emit) {
    emit(ChatWithInitialState.initial());
  }

  FutureOr<void> _onTriggerAgentAvailabilty(TirggerAgentAvialibility event,
      Emitter<ChatWithInitialState> emit) {
    emit(state.copyWith(isLoading: true, isFailure: false));
    emit(state.copyWith(isLoading: false,
        isFailure: false,
        isSupportAgentAvialable: event.isAvailable));
  }

  FutureOr<void> _onTriggerDismissNoAgentAvialable(
      TirggerDismissNoAgentAvailablePopup event,
      Emitter<ChatWithInitialState> emit) {
    emit(state.copyWith(isLoading: true, isFailure: false));
    emit(state.copyWith(
        isLoading: false, isFailure: false, isSupportAgentAvialable: true));
  }

  Future<void> _onTriggerMarkAsRead(TriggerMarkAsRead event,
      Emitter<ChatWithInitialState> emit) async {
    emit(state.copyWith(isLoading: true, isFailure: false));
    try {
      final response = await ChatRepository.markAsRead(roomId: event.roomId);
      response.fold(
            (failure) {
          emit(state.copyWith(
            isLoading: false,
            isFailure: true,
          ));
        },
            (success) {
          emit(state.copyWith(
            isLoading: false,
            isFailure: false,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
      ));
    }
  }
}
