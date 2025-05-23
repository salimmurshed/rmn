import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/models/response_models/faq_response_model.dart';
import 'package:rmnevents/imports/services.dart';
import 'package:rmnevents/root_app.dart';

import '../../../data/repository/faq_repository.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';

part 'get_in_touch_event.dart';

part 'get_in_touch_state.dart';

part 'get_in_touch_bloc.freezed.dart';

class GetInTouchBloc extends Bloc<GetInTouchEvent, GetInTouchWithInitial> {
  UserCachedData userCachedData = instance<UserCachedData>();

  GetInTouchBloc() : super(GetInTouchWithInitial.initial()) {
    on<TriggerCheckContactNumberValidity>(_onTriggerCheckContactNumberValidity);
    on<TriggerSubmitData>(_onTriggerSubmitData);
    on<TriggerFaqFetch>(_onTriggerFaqFetch);
    on<TriggerFetchUserCachedData>(_onTriggerFetchUserCachedData);
  }

  FutureOr<void> _onTriggerCheckContactNumberValidity(
      TriggerCheckContactNumberValidity event,
      Emitter<GetInTouchWithInitial> emit) {
    emit(state.copyWith(isRefreshedRequired: true));
    String? isValid =
        TextFieldValidators.validateContactNumber(value: event.phoneNumber);
    emit(state.copyWith(
        isRefreshedRequired: false, isContactNumberValid: isValid == null));
  }

  FutureOr<void> _onTriggerSubmitData(
      TriggerSubmitData event, Emitter<GetInTouchWithInitial> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await GetInTouchRepository.postContact(
          getInTouchRequestModel: GetInTouchRequestModel(
              firstName: event.firstName,
              lastName: event.lastName,
              email: event.emailAddress,
              phone: event.phoneNumber,
              message: event.message));
      response.fold((failure) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: failure.message));
      }, (success) {
        emit(state.copyWith(
            isLoading: false,
            isFailure: false,
            message: success.responseData!.message!));

        Navigator.pop(navigatorKey.currentContext!);
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerFetchUserCachedData(TriggerFetchUserCachedData event,
      Emitter<GetInTouchWithInitial> emit) async {
    emit(GetInTouchWithInitial.initial());
    try {
      DataBaseUser user = await GlobalHandlers.extractUserHandler();
      emit(
        state.copyWith(
          isLoading: false,
          firstNameController: TextEditingController(text: user.firstName),
          lastNameController: TextEditingController(text: user.lastName),
          emailAddressController: TextEditingController(text: user.email),
          phoneNumberController: TextEditingController(
              text: user.phoneNumber ?? AppStrings.global_empty_string),
          messageController:
              TextEditingController(text: AppStrings.global_empty_string),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }

  FutureOr<void> _onTriggerFaqFetch(
      TriggerFaqFetch event, Emitter<GetInTouchWithInitial> emit) async {
    emit(state.copyWith(
        isLoading: true, message: AppStrings.global_empty_string));
    try {
      final response = await FaqRepository.getFaqs();
      response.fold((failure) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: failure.message));
      }, (success) {
        emit(state.copyWith(
          isLoading: false,
          isFailure: false,
          faqData: success.responseData?.data ?? [],
        ));
      });
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, message: e.toString()));
    }
  }
}
