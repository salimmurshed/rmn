import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rmnevents/data/models/response_models/user_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/repository/users_repository.dart';
import 'package:rmnevents/presentation/find_customer/bloc/find_customer_handlers.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';

part 'find_customer_event.dart';

part 'find_customer_state.dart';

part 'find_customer_bloc.freezed.dart';

class FindCustomerBloc extends Bloc<FindCustomerEvent, FindCustomerState> {
  FindCustomerBloc() : super(FindCustomerState.initial()) {
    on<TriggerRefreshScreen>(_onTriggerRefreshScreen);
    on<TriggerFetchUsersList>(_onTriggerFetchUsersList);
    on<TriggerSearchForCustomer>(_onTriggerSearchForCustomer);
    on<TriggerSearchForCustomerRemotely>(_onTriggerSearchForCustomerRemotely);
    on<TriggerOpenDropDown>(_onTriggerOpenDropDown);
    on<TriggerMoreUserFetch>(_onTriggerMoreUserFetch);
    on<TriggerSelectCustomer>(_onTriggerSelectCustomer);
    on<TriggerResetCustomer>(_onTriggerResetCustomer);
  }

  FutureOr<void> _onTriggerRefreshScreen(
      TriggerRefreshScreen event, Emitter<FindCustomerState> emit) {
    emit(FindCustomerState.initial());
  }

  FutureOr<void> _onTriggerFetchUsersList(
      TriggerFetchUsersList event, Emitter<FindCustomerState> emit) async {
    emit(state.copyWith(
        isLoading: true, message: AppStrings.global_empty_string));
    final response = await UsersRepository.getUsers(
      page: 1,
      searchKey: AppStrings.global_empty_string,
    );
    response.fold(
      (l) {
        emit(state.copyWith(
            isLoading: false, isFailure: true, message: l.message));
      },
      (r) {
        List<DataBaseUser> customers = r.responseData?.data ?? [];
        if (customers.isNotEmpty) {
          customers = FindCustomerHandlers.getUsers(
              customers: customers, assetsUrl: r.responseData!.assetsUrl!);
        }
        emit(state.copyWith(
            isLoading: false,
            page: r.responseData!.page!.toInt(),
            totalPage: r.responseData!.totalPage!.toInt(),
            message: AppStrings.global_empty_string,
            customerList: customers));
      },
    );
  }

  FutureOr<void> _onTriggerSearchForCustomer(
      TriggerSearchForCustomer event, Emitter<FindCustomerState> emit) async {
    List<DataBaseUser> foundCustomers = [];
   // emit(state.copyWith(
    //     isRefreshedRequired: true, message: AppStrings.global_empty_string));
    // if (foundCustomers.isNotEmpty) {
    //   bool isExisting = state.customerList.any((element) =>
    //       element.firstName!.contains(state.searchController.text) ||
    //       element.lastName!.contains(state.searchController.text) ||
    //       element.email!.contains(state.searchController.text));
    //   if (isExisting) {
    //     foundCustomers = foundCustomers
    //         .where((element) =>
    //             element.firstName!.contains(state.searchController.text) ||
    //             element.lastName!.contains(state.searchController.text) ||
    //             element.email!.contains(state.searchController.text))
    //         .toList(); // Convert Iterable to List
    //     emit(state.copyWith(
    //         customerList: foundCustomers,
    //         isOpened: true,
    //         isRefreshedRequired: false));
    //   } else {
    //     add(TriggerSearchForCustomerRemotely());
    //   }
    // } else {
      add(TriggerSearchForCustomerRemotely());
   // }
  }

  FutureOr<void> _onTriggerSearchForCustomerRemotely(
      TriggerSearchForCustomerRemotely event,
      Emitter<FindCustomerState> emit) async {
    emit(state.copyWith(
        isBottomLoading: true,
        isOpened: true,
        message: AppStrings.global_empty_string));
    try {
      final response = await UsersRepository.getUsers(
          searchKey: state.searchController.text, page: 1);
      response.fold(
          (l) => emit(state.copyWith(
                message: l.message,
                isLoading: false,
                isBottomLoading: false,
              )), (r) {
        List<DataBaseUser> customers = r.responseData?.data ?? [];
        if (customers.isNotEmpty) {
          customers = FindCustomerHandlers.getUsers(
              customers: customers, assetsUrl: r.responseData!.assetsUrl!);
        }
        emit(state.copyWith(
            customerList: customers,
            isBottomLoading: false,
            isLoading: false,
            message: AppStrings.global_empty_string, isOpened: true));
      });
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        isLoading: false,
        isBottomLoading: false,
      ));
    }
  }

  FutureOr<void> _onTriggerOpenDropDown(
      TriggerOpenDropDown event, Emitter<FindCustomerState> emit) {
    emit(state.copyWith(
      isRefreshedRequired: true,
      message: AppStrings.global_empty_string,
    ));
    emit(state.copyWith(isRefreshedRequired: false, isOpened: !state.isOpened));
    debugPrint('isOpened: ${state.isOpened}');
  }

  FutureOr<void> _onTriggerMoreUserFetch(
      TriggerMoreUserFetch event, Emitter<FindCustomerState> emit) async {
    emit(state.copyWith(
        isBottomLoading: true,
        isFetching: true,
        isOpened: true,
        message: AppStrings.global_empty_string));
    try {
      final response = await UsersRepository.getUsers(
          searchKey: state.searchController.text, page: state.page + 1);
      response.fold(
          (l) => emit(state.copyWith(
                message: l.message,
                isLoading: false,
                isFetching: false,
                isBottomLoading: false,
              )), (r) {
        List<DataBaseUser> customers = r.responseData?.data ?? [];
        if (customers.isNotEmpty) {
          customers = FindCustomerHandlers.getUsers(
              customers: customers, assetsUrl: r.responseData!.assetsUrl!);
        }
        emit(state.copyWith(
            isFetching: false,
            customerList: [...state.customerList, ...customers],
            isBottomLoading: false,
            isLoading: false,
            message: AppStrings.global_empty_string,
            page: r.responseData!.page!.toInt(),
            totalPage: r.responseData!.totalPage!.toInt()));
      });
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        isLoading: false,
        isFetching: false,
        isBottomLoading: false,
      ));
    }
  }

  FutureOr<void> _onTriggerSelectCustomer(
      TriggerSelectCustomer event, Emitter<FindCustomerState> emit) {
    emit(state.copyWith(
        isRefreshedRequired: true,
        isOpened: true,
        message: AppStrings.global_empty_string));
    emit(state.copyWith(
        selectedCustomer: state.customerList[event.index],
        selectedCustomerName: StringManipulation.combineFirstNameWithLastName(
            firstName: state.customerList[event.index].firstName ??
                AppStrings.global_empty_string,
            lastName: state.customerList[event.index].lastName ??
                AppStrings.global_empty_string),
        isRefreshedRequired: false));
    Navigator.pushNamed(
        navigatorKey.currentContext!, AppRouteNames.routeSelectedCustomer);
  }

  FutureOr<void> _onTriggerResetCustomer(TriggerResetCustomer event, Emitter<FindCustomerState> emit) {
    emit(FindCustomerState.initial());
  }
}
