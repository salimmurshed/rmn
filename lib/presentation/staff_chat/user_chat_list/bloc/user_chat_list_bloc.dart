import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/functions/global_handlers.dart';
import '../../../../common/resources/app_enums.dart';
import '../../../../common/resources/app_strings.dart';
import '../../../../data/models/request_models/chat_list_request_model.dart';
import '../../../../data/models/response_models/chat_response_model.dart';
import '../../../../data/models/response_models/general_chat_list_response_model.dart';
import '../../../../data/models/response_models/user_response_model.dart';
import '../../../../data/repository/staff_chat_repository.dart';
import '../../../../root_app.dart';

import '../../../chat/bloc/chat_bloc.dart';
import '../../event_general_view/bloc/staff_chat_bloc.dart';

part 'user_chat_list_event.dart';
part 'user_chat_list_state.dart';
part 'user_chat_list_bloc.freezed.dart';

class UserChatListBloc extends Bloc<UserChatListEvent, UserChatListState> {
  // late IO.Socket socket;
  initSocket(String? eventId)async {
    DataBaseUser user = await GlobalHandlers.extractUserHandler();
    // socket = IO.io(
    //     "${AppEnvironments.socketUrl}?token=${user.token}",
    //     <String, dynamic>{
    //       'autoConnect': false,
    //       'transports': ['websocket'],
    //     });
    // socket.connect();
    // socket.onConnect((_) {
    //   debugPrint('Connection established');
    //   socket.emit('joinRoom', {"room_id": 'admin-global'});
    // });
    // socket?.off("newMessageForStaff");
    // socket?.on(
    //   'newMessageForStaff',
    //       (data)  {
    //     List<ReceivedChatResponseModel> receivedMessages = [];
    //     List<Chats> extractedChat = [];
    //     ReceivedChatResponseModel messageReceived =
    //     ReceivedChatResponseModel.fromJson(data);
    //     receivedMessages.add(messageReceived);
    //     List<String>chatIds =[];
    //     for (ReceivedChatResponseModel message in receivedMessages) {
    //       if(!chatIds.contains(message.messageData!.id)){
    //         chatIds.add(message.messageData!.id!);
    //         extractedChat.add(message.messageData!);
    //         print(message.messageData?.createdAt ?? '');
    //         if (eventId == ''){
    //           add(TriggerUpdateEventListOnMessageForGeneral(message: message.messageData!,eventId:''));
    //         }else{
    //           add(TriggerUpdateEventListOnMessageForEvent(message: message.messageData!,eventId: eventId ?? ''));
    //         }
    //       }
    //     }
    //   },
    // );

  }

  UserChatListBloc() : super(UserChatListState.initial()) {
    on<TriggerFetchChatList>(_onTriggerFetchGenralList);
    on<TriggerChangeFillter>(_onTriggerChangeFillter);
    on<TriggerRefreshData>(_onTriggerRefreshData);
    on<TriggerGeneralChatDelete>(_onTriggerGeneralChatDelete);
    on<TriggerAddToArchive>(_onTriggerAddToArchive);
    on<TriggerUnArchivedAll>(_onTriggerUnArchivedAll);
    on<TriggerUnArchiveOnly>(_onTriggerUnArchivedOnly);
    on<TriggerPagginationForGenralChatList>(_onTriggerGeneralListPagination);
    on<TiriggerDisconnectSocket>(_onTriggerDisconnectSocket);
    on<TiriggerSetMessageRead>(_onTriggersetReadMessage);
    on<TriggerUpdateEventListOnMessageForGeneral>(_onTriggerUpdateListOnMessageArrivalGeneral);
    on<TriggerUpdateEventListOnMessageForEvent>(_onTriggerUpdateListOnMessageArrivalEvent);
    on<TriggerUnreadAllMesssage>(_onTriggerReadAll);
    on<TriggerUnreadFetchUnreadCounts>(_onTriggerFetchUnreadCounts);
    on<TriggerAddbacktoList>(_onTriggerAddbacktoList);
    on<TriggerAddClearData>(_onTriggerClearData);
    on<TriggerAssignDataToState>(_onTriggerAssignDataToStae);
  }
  FutureOr<void> _onTriggerReadAll(TriggerUnreadAllMesssage event, Emitter<UserChatListState> emit) {
    if (state.chatListData?.generalChatData?[event.index].unreadCount != 0){
      emit(state.copyWith(unreadCount: state.unreadCount! - 1));
    }

    if(state.eventId != ""){
      BlocProvider.of<StaffChatBloc>(navigatorKey.currentContext!).add(TriggerReduseCount(eventId: state.eventId, isReduse: true, totalMessageCount: state.chatListData?.generalChatData?[event.index].unreadCount ?? 0));
    }
    state.chatListData?.generalChatData?[event.index].unreadCount = 0;
    emit(state.copyWith(message: AppStrings.global_empty_string, isLoading: false, isFailure: false));
  }
  Future<void> _onTriggerFetchGenralList(TriggerFetchChatList event, Emitter<UserChatListState> emit) async {
    print('this is the eventid ${state.eventId}');
    try {
      final response = state.eventId != "" ?  await GeneralChatRepository.fetchEventChatsData(chatRequestModel: ChatListRequestModel(page: event.page, type: event.status, eventId: state.eventId)) :await GeneralChatRepository.getGenralChatList(chatRequestModel: ChatListRequestModel(page: event.page, type: event.status));
      response.fold((failure) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: failure.message));
      }, (success) async {
        if (success.generalListresponseData!.page!.toInt() == 1){
            emit(state.copyWith(
                isLoading: false,
                isFailure: false, chatListData:success.generalListresponseData));
            add(TriggerUnreadFetchUnreadCounts());
        }else{
          GeneralListresponseData chatdata = state.chatListData ?? GeneralListresponseData();
          chatdata.page = success.generalListresponseData?.page ?? 1;
          chatdata.generalChatData?.addAll(success.generalListresponseData!.generalChatData!);
          emit(state.copyWith(
              isLoading: false,
              isFailure: false, chatListData: chatdata, isLoadingMore: false));
        }
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerChangeFillter(TriggerChangeFillter event, Emitter<UserChatListState> emit) {
    emit(state.copyWith(selectedCatagory: event.selectedType, message: AppStrings.global_empty_string, isLoading: true));
    BlocProvider.of<UserChatListBloc>(navigatorKey.currentContext!)
        .add(TriggerFetchChatList(page: 1, status: state.selectedCatagory, isRefreshRequeired: true));
  }

  FutureOr<void> _onTriggerRefreshData(TriggerRefreshData event, Emitter<UserChatListState> emit) {
    BlocProvider.of<UserChatListBloc>(navigatorKey.currentContext!)
          .add(TriggerFetchChatList(page: 1,status: state.selectedCatagory, isRefreshRequeired: true));
  }

  Future<void> _onTriggerGeneralChatDelete(TriggerGeneralChatDelete event, Emitter<UserChatListState> emit) async {
    try {
      final response = await GeneralChatRepository.deleteGeneralChat(roomId: event.roomId);
      response.fold((failure) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: failure.message));
      }, (success) async {
        state.chatListData?.generalChatData?.removeWhere((element) => element.roomId == event.roomId);
        emit(state.copyWith(
          isLoading: false,
          isFailure: false, message: success.responseData?.message ?? '',unreadCount: state.chatListData?.generalChatData?.where((element) => element.unreadCount != 0).length));
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }

  Future<void> _onTriggerAddToArchive(TriggerAddToArchive event, Emitter<UserChatListState> emit) async {
    emit(state.copyWith(isFailure: false, isLoading: false));
    state.chatListData?.generalChatData?.asMap().entries.forEach((entry) {
      int index = entry.key; // Get index
      var element = entry.value; // Get element
      if (element.roomId == event.roomId) {
        element.index = index; // Assuming `index` exists in the model
        emit(state.copyWith(recentlyArchivedChat: element));
      }
    });
    try {
      final response = await GeneralChatRepository.addToArchiveChat(roomId: event.roomId);
      response.fold((failure) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: failure.message));
      }, (success) async {
        emit(state.copyWith(
          isLoading: false,
          isFailure: false, message: success.responseData?.message ?? '',shouldUndoVisible: true,  archiveCount: state.archiveCount! +
            1));
        state.chatListData?.generalChatData?.removeWhere((element) => element.roomId == event.roomId);
        emit(state.copyWith(
            isLoading: false,
            isFailure: false,shouldUndoVisible: false));
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }

  Future<void> _onTriggerUnArchivedAll(TriggerUnArchivedAll event, Emitter<UserChatListState> emit) async {
    emit(state.copyWith(isLoading: true, message: AppStrings.global_empty_string));
    try {
      final response = await GeneralChatRepository.unArchiveAll(eventId:state.eventId);
      response.fold((failure) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: failure.message));
      }, (success) async {
        state.chatListData?.generalChatData?.clear();
        emit(state.copyWith(
          isLoading: false,
          isFailure: false, message: success.responseData?.message ?? '', archiveCount: 0));
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }

  Future<void> _onTriggerUnArchivedOnly(TriggerUnArchiveOnly event, Emitter<UserChatListState> emit) async {
    state.chatListData?.generalChatData?.removeWhere((element) => element.roomId == event.roomId);
    emit(state.copyWith(message: AppStrings.global_empty_string, archiveCount: state.chatListData?.generalChatData?.where((element) => element.status == 'archived').length));
    try {
      final response = await GeneralChatRepository.removeFromArchiveChat(roomId: event.roomId);
      response.fold((failure) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: failure.message, archiveCount: state.archiveCount ?? 1 - 1));
      }, (success) async {
        emit(state.copyWith(
            isLoading: false,
            isFailure: false));
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }

  Future<void> _onTriggerGeneralListPagination(TriggerPagginationForGenralChatList event, Emitter<UserChatListState> emit) async {
    if(!state.isLoading){
      if(state.chatListData!.page! < state.chatListData!.totalPage!) {
        emit(state.copyWith(isLoading: false, isFailure: false, isLoadingMore: true));
        num page = state.chatListData!.page! + 1;
        add(TriggerFetchChatList(page: page.toInt(), status: state.selectedCatagory, isRefreshRequeired: false));
      }else{
        emit(state.copyWith(isLoading: false, isFailure: false, isLoadingMore: false));
      }
    }
  }

  FutureOr<void> _onTriggerDisconnectSocket(TiriggerDisconnectSocket event, Emitter<UserChatListState> emit) {
  }
  FutureOr<void> _onTriggersetReadMessage(TiriggerSetMessageRead event, Emitter<UserChatListState> emit) {
    // emit(state.copyWith(isLoading: true, isFailure: false));
    // state.chatListData?[event.index].unreadCount = 0;
    // emit(state.copyWith(isLoading: false, isFailure: false));
  }

  Future<void> _onTriggerUpdateListOnMessageArrivalGeneral(TriggerUpdateEventListOnMessageForGeneral event, Emitter<UserChatListState> emit) async {
    if (state.chatListData?.generalChatData?.any((element) => element.roomId == event.message.roomId) ?? false) {
      emit(state.copyWith(isFailure: false,isLoading: true));
      int index = state.chatListData?.generalChatData?.indexWhere(
              (element) => element.roomId == event.message.roomId) ?? -1;
      if (index != -1) {
        if(event.message.receiverId == null){
          bool isInsideChatView = navigatorKey.currentContext!.read<ChatBloc>().state.isInsideChatView;
          if (!isInsideChatView) {
            state.chatListData?.generalChatData?[index].unreadCount =
                (state.chatListData?.generalChatData?[index].unreadCount ??
                    0) + 1;
          }
          emit(state.copyWith(unreadCount: state.chatListData?.generalChatData?.where((element) => element.unreadCount != 0).length));
        }
        state.chatListData?.generalChatData?[index].messageTime = event.message.createdAt;
        state.chatListData?.generalChatData?[index].lastMessage = event.message.message;
        state.chatListData?.generalChatData?.sort((a, b) {
          DateTime timeA = DateTime.parse(a.messageTime ?? "2000-01-01T00:00:00Z");
          DateTime timeB = DateTime.parse(b.messageTime ?? "2000-01-01T00:00:00Z");
          return timeB.compareTo(timeA); // Descending order (newest first)
        });
        emit(state.copyWith(isFailure: false,isLoading: false));
      }
    }else{
      if(event.message.eventId == null){
        add(TriggerFetchChatList(page: 1, status: state.selectedCatagory, isRefreshRequeired: false));
      }else{
        if(state.eventId != ''){
          add(TriggerFetchChatList(page: 1, status: state.selectedCatagory, isRefreshRequeired: false));
        }
      }
    }
  }

  Future<void> _onTriggerUpdateListOnMessageArrivalEvent(TriggerUpdateEventListOnMessageForEvent event, Emitter<UserChatListState> emit) async {
    if (state.eventId == event.message.eventId) {
      if(state.chatListData?.generalChatData?.any((element) => element.roomId == event.message.roomId) ?? false){
        emit(state.copyWith(isFailure: false,isLoading: true));
        int index = state.chatListData?.generalChatData?.indexWhere(
                (element) => element.roomId == event.message.roomId) ?? -1;
        if (index != -1) {
          if (event.message.receiverId == null){
            // if(state.chatListData?.generalChatData?[index].unreadCount == 0){
            //   BlocProvider.of<StaffChatBloc>(navigatorKey.currentContext!).add(TriggerReduseCount(eventId: state.eventId, isReduse: true));
            // }
            bool isInsideChatView = navigatorKey.currentContext!.read<ChatBloc>().state.isInsideChatView;
            if (!isInsideChatView) {
              state.chatListData?.generalChatData?[index].unreadCount =
                  (state.chatListData?.generalChatData?[index].unreadCount ??
                      0) + 1;
              bool isMatched = false;
              // final updatedList = navigatorKey.currentContext!
              //     .read<StaffChatBloc>()
              //     .state
              //     .eventListResponseData
              //     ?.data
              //     ?.map((element) {
              //     if (element.id == state.eventId) {
              //        isMatched = true;
              //        element.unreadCount = state.chatListData?.generalChatData?.where((element) => element.unreadCount != 0).length; // Update count
              //     }
              //     return element;
              // }).toList();
              // if(!isMatched){
              //   BlocProvider.of<StaffChatBloc>(navigatorKey.currentContext!).add(const TriggerFetchEventsList());
              // }else{
              //   BlocProvider.of<StaffChatBloc>(navigatorKey.currentContext!).add(TriggerUpdateList(data: updatedList ?? []));
              // }

            }
            final unreadCount = state.chatListData?.generalChatData?.where((element) => element.unreadCount != 0).length;
            emit(state.copyWith(unreadCount: unreadCount));
          }
          state.chatListData?.generalChatData?[index].messageTime = event.message.createdAt;
          state.chatListData?.generalChatData?[index].lastMessage = event.message.message;
          emit(state.copyWith(isFailure: false,isLoading: false));
        }
      }else{
        add(TriggerFetchChatList(page: 1, status: state.selectedCatagory, isRefreshRequeired: false));
      }
    }
  }

  Future<void> _onTriggerFetchUnreadCounts(TriggerUnreadFetchUnreadCounts event, Emitter<UserChatListState> emit) async {

    try {
      final response = await GeneralChatRepository.fetchUnreadCounts(eventId: state.eventId);
      response.fold((failure) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: failure.message));
      }, (success) {
          emit(state.copyWith(isLoading: false, isFailure: false, unreadCount: success.responseData?.data?.unreadCount ?? 0, archiveCount: success.responseData?.data?.archiveCount ?? 0, message: AppStrings.global_empty_string));
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }
  Future<void> _onTriggerAddbacktoList(TriggerAddbacktoList event, Emitter<UserChatListState> emit) async {
    if(state.selectedCatagory == ChatType.All){
      state.chatListData?.generalChatData?.insert(state.recentlyArchivedChat?.index ?? 0, state.recentlyArchivedChat ?? GeneralChatData());
      emit(state.copyWith(isLoading: false, isFailure: false, message: AppStrings.global_empty_string));
    }else if (state.selectedCatagory == ChatType.Unread){
      if(state.recentlyArchivedChat?.unreadCount != 0){
        state.chatListData?.generalChatData?.insert(0, state.recentlyArchivedChat ?? GeneralChatData());
        state.chatListData?.generalChatData?.sort((a, b) {
          DateTime timeA = DateTime.parse(a.messageTime ?? "2000-01-01T00:00:00Z");
          DateTime timeB = DateTime.parse(b.messageTime ?? "2000-01-01T00:00:00Z");
          return timeB.compareTo(timeA); // Descending order (newest first)
        });
        emit(state.copyWith(isLoading: false, isFailure: false, message: AppStrings.global_empty_string));
      }
    }else{
      state.chatListData?.generalChatData?.removeWhere((element) => element.roomId == state.recentlyArchivedChat?.roomId);
    }
  }

  FutureOr<void> _onTriggerClearData(TriggerAddClearData event, Emitter<UserChatListState> emit) {
    emit(UserChatListState.initial());
  }

  FutureOr<void> _onTriggerAssignDataToStae(TriggerAssignDataToState event, Emitter<UserChatListState> emit) {
    emit(state.copyWith(eventId: '', isLoading: false, isFailure: false));
    emit(state.copyWith(eventId: event.eventId, isLoading: false, isFailure: false));
  }
}
