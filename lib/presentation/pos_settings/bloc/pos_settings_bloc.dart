import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/data/models/response_models/stripe_readers_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/repository/stripe_repository.dart';
import 'package:rmnevents/di/di.dart';
import 'package:rmnevents/presentation/home/staff_home_bloc/staff_home_bloc.dart';
import 'package:rmnevents/services/shared_preferences_services/stripe_reader_cached_data.dart';
import '../../../data/remote_data_source/socket_data_source.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';

part 'pos_settings_event.dart';

part 'pos_settings_state.dart';

part 'pos_settings_bloc.freezed.dart';

class PosSettingsBloc extends Bloc<PosSettingsEvent, PosSettingsState> {
  PosSettingsBloc() : super(PosSettingsState.initial()) {
    on<TriggerFetchReaders>(_onTriggerFetchReaders);
    on<TriggerConnectToAReader>(_onTriggerConnectToAReader);
    on<TriggerRefreshPosSettings>(_onTriggerRefreshPosSettings);
    on<TriggerDisconnectReader>(_onTriggerDisconnect);
  }

  FutureOr<void> _onTriggerFetchReaders(
      TriggerFetchReaders event, Emitter<PosSettingsState> emit) async {
    StripeReaderData? readerData =
        await GlobalHandlers.extractStripeReaderHandler();
    int selectedIndex = -1;

    try {
      final response = await StripeRepository.getStripeReaders();
      response.fold(
        (failure) => emit(state.copyWith(
            message: failure.message,
            isLoading: false,
            selectedReader: readerData)),
        (success) {

          List<StripeReaderData> readers = success.responseData!.data!;
          for (int i = 0; i < readers.length; i++) {
            StripeReaderData data = success.responseData!.data![i];
            data.isConnectActive = data.status == 'online';
            data.isDisconnectActive = false;
            if(readerData != null && readerData.id == data.id){
              data.isConnectActive = false;
            }
          }
          // BlocProvider.of<StaffHomeBloc>(navigatorKey.currentContext!)
          //     .add(TriggerCheckIfReaderIsExisting());

          emit(state.copyWith(
              readers: readers,
              selectedReader: readerData,
              selectedIndex: selectedIndex,
              isLoading: false));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(), selectedReader: readerData, isLoading: false));
    }
  }

  FutureOr<void> _onTriggerConnectToAReader(
      TriggerConnectToAReader event, Emitter<PosSettingsState> emit) async {
    StripeReaderData? stripeReaderData = await GlobalHandlers.extractStripeReaderHandler();
    StripeReaderData? selectReader = state.selectedReader;
    List<StripeReaderData> readers = List.from(state.readers);
    if(event.isConnect){
      stripeReaderData = readers[event.deviceIndex];
      selectReader = readers[event.deviceIndex];
      readers[event.deviceIndex].isConnectActive = false;
      for (int i = 0; i < readers.length; i++) {
        if(i != event.deviceIndex){
          readers[i].isConnectActive = readers[i].status == 'online';
        }
      }
      instance<StripeReaderCachedData>().removeSharedPreferencesGeneralFunction(StripeReaderManager.stripeReader);
      instance<StripeReaderCachedData>().setStripeReader(value: jsonEncode(stripeReaderData));
      SocketDataSource.emitConnectReader(
          readerId: stripeReaderData.id!
      );
    }else{
      stripeReaderData = null;
      selectReader = null;
      readers[event.deviceIndex].isConnectActive = readers[event.deviceIndex].status == 'online';
      instance<StripeReaderCachedData>().removeSharedPreferencesGeneralFunction(StripeReaderManager.stripeReader);
      if(event.shouldCallDisconnectEmit){
        SocketDataSource.emitDisconnectReader();
      }
    }
    emit(state.copyWith(
        readers: readers,
        selectedReader: stripeReaderData,
        selectedIndex: event.deviceIndex));
  }

  FutureOr<void> _onTriggerRefreshPosSettings(
      TriggerRefreshPosSettings event, Emitter<PosSettingsState> emit) {
    emit(PosSettingsState.initial());
    emit(state.copyWith(isLoading: false));
    add(TriggerFetchReaders());
  }

  Future<void> _onTriggerDisconnect(TriggerDisconnectReader event, Emitter<PosSettingsState> emit) async {
    List<StripeReaderData> readers = List.from(state.readers);
    StripeReaderData? stripeReaderData = await GlobalHandlers.extractStripeReaderHandler();
    StripeReaderData? selectReader = state.selectedReader;
    int index = -1;
    for (var i in readers) {
      index = readers.indexOf(i); // Get the index of the current item
      if (i.isConnectActive!) {
        stripeReaderData = null;
        selectReader = null;
        readers[index].isConnectActive = false;
        instance<StripeReaderCachedData>().removeSharedPreferencesGeneralFunction(StripeReaderManager.stripeReader);
      }
    }
    emit(state.copyWith(
        readers: readers,
        selectedReader: stripeReaderData,
        selectedIndex: index));
  }
}
