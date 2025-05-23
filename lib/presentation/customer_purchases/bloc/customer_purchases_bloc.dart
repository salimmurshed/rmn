import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/models/response_models/staff_customer_purchases.dart';
import 'package:rmnevents/presentation/find_customer/bloc/find_customer_bloc.dart';
import 'package:rmnevents/presentation/home/staff_home_bloc/staff_home_bloc.dart';

import '../../../data/repository/staff_customer_purchases_repository.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';

part 'customer_purchases_event.dart';

part 'customer_purchases_state.dart';

part 'customer_purchases_bloc.freezed.dart';

class CustomerPurchasesBloc
    extends Bloc<CustomerPurchasesEvent, CustomerPurchasesState> {
  CustomerPurchasesBloc() : super(CustomerPurchasesState.initial()) {
    on<TriggerFetchCustomerPurchasesRefresh>(
        _onTriggerFetchCustomerPurchasesRefresh);
    on<TriggerFetchCustomerPurchases>(_onTriggerFetchCustomerPurchases);
    on<TriggerFilterPurchases>(_onTriggerFilterPurchases);
    on<TriggerSwitchBetweenTabs>(_onTriggerSwitchBetweenTabs);
    on<TriggerMarkAsScanned>(_onTriggerMarkAsScanned);
  }

  FutureOr<void> _onTriggerFetchCustomerPurchasesRefresh(
      TriggerFetchCustomerPurchasesRefresh event,
      Emitter<CustomerPurchasesState> emit) {
    emit(CustomerPurchasesState.initial());
  }

  FutureOr<void> _onTriggerFetchCustomerPurchases(
      TriggerFetchCustomerPurchases event,
      Emitter<CustomerPurchasesState> emit) async {
    String eventId =
    navigatorKey.currentContext!.read<StaffHomeBloc>().state.eventData!.id!;
    String userId = navigatorKey.currentContext!
        .read<FindCustomerBloc>()
        .state
        .selectedCustomer!
        .underScoreId!;
    String name = StringManipulation.combineFirstNameWithLastName(
        firstName: navigatorKey.currentContext!
            .read<FindCustomerBloc>()
            .state
            .selectedCustomer!
            .firstName ??
            AppStrings.global_empty_string,
        lastName: navigatorKey.currentContext!
            .read<FindCustomerBloc>()
            .state
            .selectedCustomer!
            .lastName ??
            AppStrings.global_empty_string);
    emit(state.copyWith(
        isRefreshedRequired: true, message: AppStrings.global_empty_string));
    try {
      final response = await StaffCustomerPurchasesRepository.getUsers(
          eventId: eventId, userId: userId);
      response.fold(
            (l) =>
            emit(state.copyWith(
                isRefreshedRequired: false,
                isLoading: false,
                message: l.message,
                isFailure: true)),
            (r) {
          List<CustomerProducts> products =
              r.responseData?.data?.products ?? [];
          List<CustomerRegistrations> registrations =
              r.responseData?.data?.registrations ?? [];

          for (var item in r.responseData!.data!.products!) {
            item.product!.image =
                r.responseData!.assetsUrl! + item.product!.image!;
          }
          for (var item in r.responseData!.data!.registrations!) {
            item.athlete!.profileImage =
                r.responseData!.assetsUrl! + item.athlete!.profileImage!;
          }
          emit(state.copyWith(
              isLoading: false,
              isRefreshedRequired: false,
              products: products,
              registrations: registrations,
              allProducts: List.from(products),
              allRegistrations: List.from(registrations),
              userName: name));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          isRefreshedRequired: false,
          isLoading: false,
          message: e.toString(),
          isFailure: true));
    }
  }

  FutureOr<void> _onTriggerFilterPurchases(TriggerFilterPurchases event,
      Emitter<CustomerPurchasesState> emit) {
    emit(state.copyWith(
        isRefreshedRequired: true, message: AppStrings.global_empty_string));
    switch (event.customerPurchasesTypes) {
      case CustomerPurchasesTypes.all:
        if(state.selectedTab == 0) {
          emit(state.copyWith(
            isRefreshedRequired: false,
            customerPurchasesTypes: CustomerPurchasesTypes.all,
            products: List.from(state.allProducts),
          ));
        }else{
          emit(state.copyWith(
            isRefreshedRequired: false,
            customerPurchasesTypes: CustomerPurchasesTypes.all,
            registrations: List.from(state.allRegistrations),
          ));
        }

      case CustomerPurchasesTypes.scanned:
        List<CustomerProducts> scannedProducts = [];
        List<CustomerRegistrations> scannedRegistrations = [];
        if (state.selectedTab == 0) {
          if (state.allProducts.isNotEmpty) {
            for (var item in state.allProducts) {
              if (item.scanDetails != null) {
                scannedProducts.add(item);
              }
            }
          }
          emit(state.copyWith(
            isRefreshedRequired: false,
            customerPurchasesTypes: CustomerPurchasesTypes.scanned,
            products: scannedProducts,));
        }
        else {
          if (state.allRegistrations.isNotEmpty) {
            for (var item in state.allRegistrations) {
              if (item.scanDetails != null) {
                  scannedRegistrations.add(item);
              }
            }
          }
          emit(state.copyWith(
            isRefreshedRequired: false,
            customerPurchasesTypes: CustomerPurchasesTypes.scanned,
            registrations: scannedRegistrations,));
        }
        break;
      case CustomerPurchasesTypes.unScanned:
        List<CustomerProducts> unScannedProducts = [];
        List<CustomerRegistrations> unScannedRegistrations = [];
        if (state.selectedTab == 0) {
          if (state.allProducts.isNotEmpty) {
            for (var item in state.allProducts) {
              if (item.scanDetails == null) {
                unScannedProducts.add(item);
              }
            }
          }
          emit(state.copyWith(
            isRefreshedRequired: false,
            customerPurchasesTypes: CustomerPurchasesTypes.unScanned,
            products: unScannedProducts,));
        }
        else {
          if (state.allRegistrations.isNotEmpty) {
            for (var item in state.allRegistrations) {
              if (item.scanDetails == null) {
                unScannedRegistrations.add(item);
              }
            }
          }
          emit(state.copyWith(
            isRefreshedRequired: false,
            customerPurchasesTypes: CustomerPurchasesTypes.unScanned,
            registrations: unScannedRegistrations,));
        }
        break;
      default:
        break;
    }
  }

  FutureOr<void> _onTriggerSwitchBetweenTabs(TriggerSwitchBetweenTabs event, Emitter<CustomerPurchasesState> emit) {
    emit(state.copyWith(
        isRefreshedRequired: true, message: AppStrings.global_empty_string));
    emit(state.copyWith(
      customerPurchasesTypes: CustomerPurchasesTypes.all,
        isRefreshedRequired: false,
        selectedTab: event.selectedTabIndex));

  }

  FutureOr<void> _onTriggerMarkAsScanned(TriggerMarkAsScanned event, Emitter<CustomerPurchasesState> emit) async {
    emit(state.copyWith(
      indexOfSelectedItem:  event.indexOfSelectedItem,
      isRefreshedRequired: true,
      message: AppStrings.global_empty_string,
      isLoading: false
    ));
    try{
      final response = await StaffCustomerPurchasesRepository.markAsScanned(
          purchaseId: event.purchaseId);
      response.fold(
              (l) =>
              emit(state.copyWith(
                message: l.message,
                indexOfSelectedItem: -1,
                isLoading: false,
                isRefreshedRequired: false,
              )), (r) {
                List<CustomerProducts> products = state.products;
                List<CustomerRegistrations> registrations = state.registrations;

                if(state.selectedTab == 0) {
                  products[event.indexOfSelectedItem].scanDetails = r.responseData!.data!.scanDetails;
                }else{
                  registrations[event.indexOfSelectedItem].scanDetails = r.responseData!.data!.scanDetails;
                }
        emit(state.copyWith(
          message: r.responseData!.message!,
          isLoading: false,
          products: products,
          registrations: registrations,
          allProducts: List.from(products),
          allRegistrations: List.from(registrations),
          indexOfSelectedItem: -1,
          isRefreshedRequired: false,
        ));
      });
    }catch(e){
      emit(state.copyWith(
        message: e.toString(),
        isLoading: false,
        indexOfSelectedItem: -1,
        isRefreshedRequired: false,
      ));
    }
  }
}