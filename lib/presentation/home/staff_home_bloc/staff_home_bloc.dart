import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/presentation/pos_settings/bloc/pos_settings_bloc.dart';
import 'package:rmnevents/root_app.dart';
import 'package:rmnevents/services/shared_preferences_services/stripe_reader_cached_data.dart';
import '../../../data/models/response_models/stripe_readers_response_model.dart';
import '../../../data/remote_data_source/socket_data_source.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../services/shared_preferences_services/staff_event_cached_data.dart';

part 'staff_home_event.dart';

part 'staff_home_state.dart';

part 'staff_home_bloc.freezed.dart';

class StaffHomeBloc extends Bloc<StaffHomeEvent, StaffHomeWithInitialState> {
  StaffHomeBloc() : super(StaffHomeWithInitialState.initial()) {
    on<TriggerFetchStaffHomeInfo>(_onTriggerFetchStaffHomeInfo);
    on<TriggerFetchEventList>(_onTriggerFetchEventList);
    on<TriggerChooseEvent>(_onTriggerChooseEvent);
    on<TriggerRefreshHome>(_onTriggerRefreshHome);
    on<TriggerCheckIfReaderIsExisting>(_onTriggerCheckIfReaderIsExisting);
    on<TriggerCheckOnAppRestart>(_onTriggerCheckOnAppRestart);
    on<TriggerGetBackReader>(_onTriggerGetBackReader);
  }

  FutureOr<void> _onTriggerFetchStaffHomeInfo(TriggerFetchStaffHomeInfo event,
      Emitter<StaffHomeWithInitialState> emit) async {
    emit(state.copyWith(
      isLoading: true,
    ));
    DataBaseUser user = await GlobalHandlers.extractUserHandler();

    emit(state.copyWith(
      isFailure: false,
      isLoading: false,
      imageUrl: user.profile ?? AppStrings.global_empty_string,
      name: '${user.firstName} ${user.lastName}',
    ));
  }

  FutureOr<void> _onTriggerFetchEventList(TriggerFetchEventList event,
      Emitter<StaffHomeWithInitialState> emit) async {
    try {
      final List<EventData> eventList = [];
      final response = await EventsRepository.getEmployeeEventList();
      response.fold((failure) {
        emit(state.copyWith(
            isFailure: true, isLoading: false, message: failure.message));
      }, (success) {
        eventList.addAll(success.responseData!.data!);

        if (state.eventData != null) {
          bool isEventDataExisting = eventList.any((e) =>
              e.title!.toLowerCase() == state.eventData!.title!.toLowerCase());
          if (!isEventDataExisting) {
            instance<StaffEventCachedData>()
                .removeSharedPreferencesGeneralFunction(
                    EventDataManager.eventData);
            emit(state.copyWith(eventData: null));
          }
        }

        emit(state.copyWith(
          assetUrl: success.responseData!.assetsUrl ?? AppStrings.global_empty_string,
            isFailure: false, isLoading: false, eventList: eventList));
      });
    } catch (e) {
      emit(state.copyWith(
          isFailure: true, isLoading: false, message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerChooseEvent(
      TriggerChooseEvent event, Emitter<StaffHomeWithInitialState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string, isRefreshedRequired: true));
    EventData? eventData = state.eventList.firstWhere(
        (element) => element.title == event.eventName,
        orElse: () => EventData());

    if (eventData.title != null) {
      String eventDataJson = jsonEncode(eventData.toJson());

      instance<StaffEventCachedData>()
          .removeSharedPreferencesGeneralFunction(EventDataManager.eventData);
      instance<StaffEventCachedData>().setEventData(value: eventDataJson);
    }
    emit(state.copyWith(eventData: eventData, isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerRefreshHome(
      TriggerRefreshHome event, Emitter<StaffHomeWithInitialState> emit) {
    emit(StaffHomeWithInitialState.initial());
    emit(state.copyWith(isLoading: false));
    debugPrint('Refreshed ${state.readerData}');
  }

  FutureOr<void> _onTriggerCheckIfReaderIsExisting(
      TriggerCheckIfReaderIsExisting event,
      Emitter<StaffHomeWithInitialState> emit) {
    emit(state.copyWith(
      isRefreshedRequired: true,
      message: AppStrings.global_empty_string,
    ));
    StripeReaderData? stripeReaderData = state.readerData;
    List<StripeReaderData> readerData =
        navigatorKey.currentContext!.read<PosSettingsBloc>().state.readers;
    bool isReaderExisting =
        readerData.any((element) => element.id == state.readerData?.id && element.status == 'online' && element.isConnectActive!);
    if (!isReaderExisting) {
      instance<StripeReaderCachedData>().removeSharedPreferencesGeneralFunction(
          StripeReaderManager.stripeReader);
    } else {
      stripeReaderData = readerData
          .firstWhere((element) => element.id == state.readerData?.id);
      if (stripeReaderData.status == 'online') {
        if (stripeReaderData.isAvailable!) {
          SocketDataSource.emitConnectReader(readerId: stripeReaderData.id!);
        } else {
          instance<StripeReaderCachedData>()
              .removeSharedPreferencesGeneralFunction(
                  StripeReaderManager.stripeReader);
        }
      } else {
        instance<StripeReaderCachedData>()
            .removeSharedPreferencesGeneralFunction(
                StripeReaderManager.stripeReader);
      }
    }
    emit(state.copyWith(
      isRefreshedRequired: false,
      readerData: isReaderExisting ? stripeReaderData : null,
    ));
  }

  FutureOr<void> _onTriggerCheckOnAppRestart(TriggerCheckOnAppRestart event,
      Emitter<StaffHomeWithInitialState> emit) async {
    StripeReaderData? stripeReaderData =
        await GlobalHandlers.extractStripeReaderHandler();
    EventData? eventData =
        await instance<StaffEventCachedData>().getEventData();
    if (stripeReaderData != null) {
      BlocProvider.of<PosSettingsBloc>(navigatorKey.currentContext!)
          .add(TriggerFetchReaders());
    }
    add(TriggerFetchEventList());
    emit(state.copyWith(
      isFailure: false,
      eventData: eventData,
      readerData: stripeReaderData,
    ));
  }

  FutureOr<void> _onTriggerGetBackReader(TriggerGetBackReader event,
      Emitter<StaffHomeWithInitialState> emit) async {
    emit(state.copyWith(
      isRefreshedRequired: true,
      message: AppStrings.global_empty_string,
    ));
    StripeReaderData? stripeReaderData =
        await GlobalHandlers.extractStripeReaderHandler();
    emit(state.copyWith(
      isRefreshedRequired: false,
      readerData: stripeReaderData,
    ));
  }
}
