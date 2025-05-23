import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/models/request_models/chat_list_request_model.dart';
import 'package:rmnevents/imports/common.dart';

import '../../../../data/models/response_models/general_chat_list_response_model.dart';
import '../../../../data/repository/staff_chat_repository.dart';

part 'event_chat_list_event.dart';
part 'event_chat_list_state.dart';
part 'event_chat_list_bloc.freezed.dart';

class EventChatListBloc extends Bloc<EventChatListEvent, EventChatListState> {
  EventChatListBloc() : super(EventChatListState.initial()) {
    on<TriggerFetchEventListData>(_onTriggerFetchEventListData);
    on<TriggerChangeFillterforEventUserList>(_onTriggerChangeFillter);
    on<TriggerRefreshChatListData>(_onTriggerRefreshData);
    on<TriggerUnreadAllMessage>(_onSetUnreadAllMessage);
    on<TriggerPagination>(_onTriggerGeneralListPagination);
  }
  Future<void> _onTriggerFetchEventListData(TriggerFetchEventListData event, Emitter<EventChatListState> emit) async {
    emit(state.copyWith(isLoading: true, message: AppStrings.global_empty_string, eventId: event.eventId));
    try {
      final response = await GeneralChatRepository.fetchEventChatsData(chatRequestModel: ChatListRequestModel(page: event.page, type: event.type, eventId: event.eventId));
      response.fold((failure) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: failure.message));
      }, (success) async {
        if (success.generalListresponseData!.page!.toInt() == 1){
          emit(state.copyWith(
              isLoading: false,
              isFailure: success.status ?? false, eventChatListData:success.generalListresponseData));
        }else{
          state.eventChatListData!.generalChatData?.addAll(success.generalListresponseData!.generalChatData!);
          emit(state.copyWith(
              isLoading: false,
              isFailure: success.status ?? false));
        }
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }
  FutureOr<void> _onTriggerChangeFillter(TriggerChangeFillterforEventUserList event, Emitter<EventChatListState> emit) {
    emit(state.copyWith(selectedCatagory: event.selectedType));
    add(TriggerFetchEventListData(eventId: event.eventId, page: 1, type: state.selectedCatagory));
  }
  FutureOr<void> _onTriggerRefreshData(TriggerRefreshChatListData event, Emitter<EventChatListState> emit) {
    add(TriggerFetchEventListData(eventId: event.eventId, page: 1, type: state.selectedCatagory));
  }
  FutureOr<void> _onSetUnreadAllMessage(TriggerUnreadAllMessage event, Emitter<EventChatListState> emit) {
    emit(state.copyWith(isLoading: true, isFailure: false));
    state.eventChatListData?.generalChatData?[event.index].unreadCount = 0;
    emit(state.copyWith(isLoading: false, isFailure: false));
  }

  Future<void> _onTriggerGeneralListPagination(TriggerPagination event, Emitter<EventChatListState> emit) async {
    if(state.eventChatListData!.page! < state.eventChatListData!.totalPage!) {
      num page = state.eventChatListData!.page! + 1;
      if(state.eventChatListData!.page! != page) {
        state.eventChatListData?.page = page;
      }
      add(TriggerFetchEventListData(page: page.toInt(), eventId: event.eventId, type: state.selectedCatagory));
    }
  }
}
