import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/common/resources/app_enums.dart';
import 'package:rmnevents/common/resources/app_strings.dart';
import 'package:rmnevents/data/repository/staff_chat_repository.dart';



import '../../../../common/functions/global_handlers.dart';
import '../../../../common/resources/app_routes.dart';
import '../../../../data/models/arguments/chat_arguments.dart';
import '../../../../data/models/response_models/chat_response_model.dart';
import '../../../../data/models/response_models/event_list_chat.dart';
import '../../../../data/models/response_models/general_chat_list_response_model.dart';
import '../../../../data/models/response_models/user_response_model.dart';
import '../../../../root_app.dart';



part 'staff_chat_event.dart';
part 'staff_chat_state.dart';
part 'staff_chat_bloc.freezed.dart';

class StaffChatBloc extends Bloc<StaffChatEvent, StaffChatState> {
  initSocket()async {
    DataBaseUser user = await GlobalHandlers.extractUserHandler();

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
    //           print(message.messageData?.createdAt ?? '');
    //         add(TriggerUpdateEventListOnMessage(message: message.messageData!));
    //       }
    //     }
    //   },
    // );

  }

  StaffChatBloc() : super(StaffChatState.initial()){
    on<TriggerFetchEventsList>(_onTriggerFecthEventList);
    on<TriggerPickDivision>(_onTriggerSelectTab);
    on<TriggerRefreshDataOfEvent>(_onTriggerRefreshData);
    on<TriggerMoveToEventChatList>(_onTriggerMoveToEventChatList);

    on<TriggerSearchEvent>(_onTriggerSearchEvent);
    on<TriggerUpdateEventListOnMessage>(_onTriggerUpdateListOnMessageArrival);
    on<TiriggerDisconnectSocket>(_onTriggerDisconnectSocket);
    on<TiriggerSetMessageRead>(_onTriggersetReadMessage);
    on<TriggerReduseCount>(_onTriggerReduceCount);
    on<TriggerUpdateList>(_onUpdateList);
  }
  FutureOr<void> _onTriggerReduceCount(TriggerReduseCount event, Emitter<StaffChatState> emit) {
    print(event.eventId);
    emit(state.copyWith(isLoading: true, isFailure: false));
    state.eventListResponseData?.data?.forEach((element) {
      if (element.id == event.eventId) {
        if(event.isReduse){
          element.unreadCount = (element.unreadCount! > 0) ? element.unreadCount! - event.totalMessageCount : 0;
        }else{
          element.unreadCount = (element.unreadCount! > 0) ? element.unreadCount! + 1 : 0;
        }
      }
    });
    emit(state.copyWith(isLoading: false, isFailure: false));
  }

  Future<void> _onTriggerUpdateListOnMessageArrival(TriggerUpdateEventListOnMessage event, Emitter<StaffChatState> emit) async {
    if (event.message.isNewChat ?? true){
      add(TriggerFetchEventsList());
    }else{
      if (state.eventListResponseData?.data?.any((element) => element.id == event.message.eventId) ?? false) {

        emit(state.copyWith(isFailure: false, isLoading: true));

        int index = state.eventListResponseData?.data?.indexWhere(
                (element) => element.id == event.message.eventId) ?? -1;
        if (index != -1) {
          if (event.message.receiverId == null){
            state.eventListResponseData?.data?[index].unreadCount = (state.eventListResponseData?.data?[index].unreadCount ?? 0) + 1;
            state.eventListResponseData?.data?[index].messageTime = event.message.createdAt;
            state.eventListResponseData?.data?.sort((a, b) {
              DateTime timeA = DateTime.parse(a.messageTime ?? "2000-01-01T00:00:00Z");
              DateTime timeB = DateTime.parse(b.messageTime ?? "2000-01-01T00:00:00Z");
              return timeB.compareTo(timeA); // Descending order (newest first)
            });
          }

          emit(state.copyWith(isFailure: false,isLoading: false));
        }
      }
    }
  }

  FutureOr<void> _onTriggersetReadMessage(TiriggerSetMessageRead event, Emitter<StaffChatState> emit) {
    emit(state.copyWith(isLoading: true, isFailure: false));
    state.eventListResponseData?.data?[event.index].unreadCount = 0;
    emit(state.copyWith(isLoading: false, isFailure: false));
  }

  FutureOr<void> _onTriggerDisconnectSocket(TiriggerDisconnectSocket event, Emitter<StaffChatState> emit) {

  }
  Future<void> _onTriggerSearchEvent(TriggerSearchEvent event, Emitter<StaffChatState> emit) async {
    // Ensure that the state is not null before accessing its properties
    if (state.tempEventListResponseData?.data != null) {
      // Filter the data based on the search text
      if (event.searchText.isNotEmpty){
            List<EventListEventData> filteredData = state.tempEventListResponseData!.data!.where((element) =>
        element.title?.toLowerCase().contains(event.searchText.toLowerCase()) ?? false)
            .toList();

        // Clear the existing data and update with filtered data
        state.eventListResponseData?.data = filteredData.toList(); // Use addAll to add filtered data

        // Emit the new state
        emit(state.copyWith(isLoading: false, isFailure: false));
      }else{
        state.eventListResponseData?.data = state.tempEventListResponseData!.data!.toList();
        emit(state.copyWith(isLoading: false, isFailure: false));
      }

    } else {
      // Handle the case where tempEventListResponseData is null
      emit(state.copyWith(isLoading: false, isFailure: true)); // Emit failure state if needed
    }
  }






  Future<void> _onTriggerFecthEventList(StaffChatEvent event, Emitter<StaffChatState> emit) async {
    emit(state.copyWith(isLoading: true, message: AppStrings.global_empty_string));
    try {
      final response = await GeneralChatRepository.getEventList();
      response.fold((failure) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: failure.message));
      }, (success) async {
        emit(state.copyWith(
          isLoading: false,
          isFailure: success.status ?? false,
          eventListResponseData: ChatEventListResponseData(
            assetsUrl: success.responseData?.assetsUrl!,
            data: List.from(success.responseData?.data ?? []), // Creates a new instance
          ),
          tempEventListResponseData: ChatEventListResponseData(
            assetsUrl: success.responseData?.assetsUrl!,
            data: List.from(success.responseData?.data ?? []), // Ensures no reference issue
          ),
        ));

      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }
  FutureOr<void> _onTriggerMoveToEventChatList(TriggerMoveToEventChatList event, Emitter<StaffChatState> emit) {
    Navigator.pushNamed(navigatorKey.currentContext!,
        AppRouteNames.eventChatList, arguments: ChatArguments(eventId: event.eventId, profileImage: event.coverImage, roomId: ''));
  }
  FutureOr<void> _onTriggerRefreshData(TriggerRefreshDataOfEvent event, Emitter<StaffChatState> emit) {
    if (state.selectedTabIndex == 0){
      BlocProvider.of<StaffChatBloc>(navigatorKey.currentContext!)
          .add(const TriggerFetchEventsList());
    }
  }


  FutureOr<void> _onTriggerSelectTab(TriggerPickDivision event, Emitter<StaffChatState> emit) {
    state.searchController.clear();
    emit(state.copyWith(selectedTabIndex: event.divIndex,message: AppStrings.global_empty_string));
    if (event.divIndex == 0){
      BlocProvider.of<StaffChatBloc>(navigatorKey.currentContext!)
          .add(const TriggerFetchEventsList());
    }
  }



  FutureOr<void> _onUpdateList(TriggerUpdateList event, Emitter<StaffChatState> emit) {
    ChatEventListResponseData data;
    data = ChatEventListResponseData();
    data.data = event.data;
    data.assetsUrl = state.eventListResponseData?.assetsUrl ?? '';
    emit(state.copyWith(isLoading: false, isFailure: false, eventListResponseData:data));
  }
}
