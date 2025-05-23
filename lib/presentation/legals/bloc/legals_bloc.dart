import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/repository/legals_repository.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

part 'legals_event.dart';

part 'legals_state.dart';

part 'legals_bloc.freezed.dart';

class LegalsBloc extends Bloc<LegalsEvent, LegalsWithInitialState> {
  LegalsBloc() : super(LegalsWithInitialState.initial()) {

    on<TriggerCMSFetch>(_onTriggerCMSFetch);
  }


  FutureOr<void> _onTriggerCMSFetch(
      TriggerCMSFetch event, Emitter<LegalsWithInitialState> emit) async {

    try {
      final response = await LegalsRepository.listCms();
      response.fold(
          (failure) => emit(state.copyWith(
              isFailure: true,
              isLoading: false,
              message: failure.message)), (success) {
        emit(state.copyWith(
          data: success.responseData?.data ?? [],
          isFailure: false,
          isLoading: false,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
          isFailure: true, isLoading: false, message: e.toString()));
    }
  }
}
