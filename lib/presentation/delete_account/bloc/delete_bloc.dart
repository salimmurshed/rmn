import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/repository/owner_profile_repository.dart';
import 'package:rmnevents/imports/services.dart';
import 'package:rmnevents/root_app.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';

part 'delete_event.dart';

part 'delete_state.dart';

part 'delete_bloc.freezed.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteAccountWithInitialState> {
  DeleteBloc() : super(DeleteAccountWithInitialState.initial()) {
    on<TriggerDeleteAccountEvent>(_onTriggerDeleteAccountEvent);
  }

  FutureOr<void> _onTriggerDeleteAccountEvent(TriggerDeleteAccountEvent event,
      Emitter<DeleteAccountWithInitialState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await OwnerProfileRepository.deleteAccount();
      response.fold((failure) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: failure.message));
      }, (success) async {
        emit(state.copyWith(
            isLoading: false,
            isFailure: false,
            message: success.responseData!.message!));
        await instance<UserCachedData>().removeUserDataCache();
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!,
            AppRouteNames.routeSignInSignUp,
            arguments: Authentication.signIn,
            (route) => false);
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }
}
