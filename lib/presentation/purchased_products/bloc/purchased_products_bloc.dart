import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/imports/data.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';
import 'package:rmnevents/presentation/purchased_products/bloc/purchased_products_handlers.dart';
import 'package:rmnevents/presentation/qr_scan_view/bloc/qr_scan_bloc.dart';
import 'package:rmnevents/root_app.dart';

import '../../../data/repository/download_pdf_repository.dart';
import '../../../imports/common.dart';

part 'purchased_products_event.dart';

part 'purchased_products_state.dart';

part 'purchased_products_bloc.freezed.dart';

class PurchasedProductsBloc
    extends Bloc<PurchasedProductsEvent, PurchasedProductsWithInitialState> {
  PurchasedProductsBloc() : super(PurchasedProductsWithInitialState.initial()) {
    on<TriggerFetchProductDetails>(_onTriggerFetchProductDetails);
    on<TriggerFetchWeightClasses>(_onTriggerFetchWeightClasses);
    on<TriggerSwitchTab>(_onTriggerSwitchTab);
    on<TriggerDownloadPdf>(_onTriggerDownloadPdf);
    on<TriggerWCReselect>(_onTriggerWCReselect);
    on<TriggerChangeWC>(_onTriggerChangeWC);
    on<TriggerInvoiceOrTeamSelection>(_onTriggerInvoiceOrTeamSelection);
    on<TriggerDropdownExpand>(_onTriggerDropdownExpand);
    on<TriggerChangeTeam>(_onTriggerChangeTeam);
    on<TriggerOpenBottomSheetForDownloadingPdf>(
        _onTriggerOpenBottomSheetForDownloadingPdf);
  }

  FutureOr<void> _onTriggerFetchProductDetails(TriggerFetchProductDetails event,
      Emitter<PurchasedProductsWithInitialState> emit) async {
    if (event.isAthleteParameterUpdated) {
      emit(state.copyWith(
          isRefreshRequired: false,
          isFailure: false,
          isAthleteParameterUpdated: false,
          isLoadingWcs: true,
          message: AppStrings.global_empty_string));
    } else {
      emit(PurchasedProductsWithInitialState.initial());
      emit(state.copyWith(isDownloadingInvoice: true));
    }

    try {
      final response =
          await ProductsRepository.getMyPurchasedProductDetailEventWise(
              eventId: event.eventId);
      response.fold(
        (failure) {
          emit(state.copyWith(
              isFailure: true,
              message: failure.message,
              isLoading: false,
              isLoadingWcs: false,
              isDownloadingInvoice: false));
        },
        (success) {
          PurchasedProductData data =
              PurchasedProductsHandlers.updatePurchasedProductsDataParameters(
                  data: success.responseData?.data ?? PurchasedProductData(),
                  assetsUrl: success.responseData?.assetsUrl ?? '');
          List<String> invoiceNames = [];

          for (EventRegistrations eventRegistration
              in success.responseData!.data!.eventRegistrations!) {
            for (Registrations registration
                in eventRegistration.registrations!) {
              if (registration.orderNo != null) {
                if (!invoiceNames.contains(
                    '${registration.orderNo!} ${DateFunctions.getMMMMddyyyyFormat(date: registration.createdAt!)}')) {
                  invoiceNames.add(
                      '${registration.orderNo!} ${DateFunctions.getMMMMddyyyyFormat(date: registration.createdAt!)}');
                }
              }
            }
          }
          for (ProductPurchases productPurchases
              in data.productPurchases ?? []) {
            if (productPurchases.orderNo != null) {
              if (!invoiceNames.contains(
                  '${productPurchases.orderNo!} ${productPurchases.createdAt!}')) {
                invoiceNames.add(
                    '${productPurchases.orderNo!} ${productPurchases.createdAt!}');
              }
            }
          }

          debugPrint('invoiceNames: $invoiceNames');
          List<String> extractedInvoices =
              PurchasedProductsHandlers.extractInvoices(
            purchasedProducts: data.productPurchases,
            invoiceUrl: success.responseData?.data?.registrationInvoiceUrl ??
                AppStrings.global_empty_string,
            eventRegistrations:
                success.responseData?.data?.eventRegistrations ?? [],
          );
          List<String> teamNames =
              PurchasedProductsHandlers.extractTeamNames(teams: globalTeams);
          emit(state.copyWith(
              data: data,
              isFailure: false,
              message: AppStrings.global_empty_string,
              isLoading: false,
              isLoadingWcs: false,
              dropdownInvoices: invoiceNames,
              productPurchases: data.productPurchases ?? [],
              eventRegistrations: data.eventRegistrations ?? [],
              teams: globalTeams,
              teamNames: teamNames,
              dropdownInvoicesUrls: extractedInvoices,
              isDownloadingInvoice: false));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          isInvoiceDownloading: false,
          isFailure: true,
          isLoadingWcs: false,
          message: e.toString(),
          isLoading: false));
    }
  }

  FutureOr<void> _onTriggerInvoiceOrTeamSelection(
      TriggerInvoiceOrTeamSelection event,
      Emitter<PurchasedProductsWithInitialState> emit) {
    String url = AppStrings.global_empty_string;
    String teamId = AppStrings.global_empty_string;
    String? teamName;

    for (var i = 0; i < event.invoiceUrls.length; i++) {
      if (event.invoiceUrls[i].contains(event.url.split(' ')[0])) {
        url = event.invoiceUrls[i];
        break;
      }
    }
    for (var i = 0; i < event.teams.length; i++) {
      if (event.teams[i].name!.contains(event.url)) {
        teamId = event.teams[i].id!;
        teamName = event.teams[i].name!;
      }
    }

    emit(state.copyWith(
        selectedTeamId: teamId,
        selectedTeam: teamName,
        isRefreshRequired: false,
        orderNo: event.url,
        selectedUrl: url));
  }

  FutureOr<void> _onTriggerOpenBottomSheetForDownloadingPdf(
      TriggerOpenBottomSheetForDownloadingPdf event,
      Emitter<PurchasedProductsWithInitialState> emit) {
    PurchasedProductsHandlers.emitRefreshState(emit: emit, state: state);
    emit(state.copyWith(selectedTeam: null));
  }

  FutureOr<void> _onTriggerDropdownExpand(TriggerDropdownExpand event,
      Emitter<PurchasedProductsWithInitialState> emit) {
    emit(state.copyWith(isExpanded: event.isExpanded));
  }

  FutureOr<void> _onTriggerFetchWeightClasses(TriggerFetchWeightClasses event,
      Emitter<PurchasedProductsWithInitialState> emit) async {
    emit(state.copyWith(
        isRefreshRequired: false,
        isFailure: false,
        isAthleteParameterUpdated: false,
        isLoadingWcs: true,
        message: AppStrings.global_empty_string));

    try {
      final response = await WeightClassRepository.getWeightClasses(
          divId: event
              .purchasedProductData
              .eventRegistrations![event.indexOfEventRegistrations]
              .registrationWithDivisionIdList![
                  event.indexOfRegistrationWithDivisionId]
              .division!
              .id!,
          eventID: state.data!.id!);
      response.fold(
        (failure) {
          emit(state.copyWith(
            isFailure: true,
            message: failure.message,
            isLoading: false,
            isLoadingWcs: false,
          ));
        },
        (success) {
          EventRegistrations eventRegistration = event.purchasedProductData
              .eventRegistrations![event.indexOfEventRegistrations];
          RegistrationWithSameDivisionId registrationWithSameDivisionId = event
                  .purchasedProductData
                  .eventRegistrations![event.indexOfEventRegistrations]
                  .registrationWithDivisionIdList![
              event.indexOfRegistrationWithDivisionId];
          registrationWithSameDivisionId.availableWeightClasses =
              PurchasedProductsHandlers.extractWeight(
                  weightClasses: success.responseData?.data ?? []);
          registrationWithSameDivisionId.weightClasses =
              success.responseData?.data ?? [];
          registrationWithSameDivisionId.selectedWeightClasses = List.from(event
              .purchasedProductData
              .eventRegistrations![event.indexOfEventRegistrations]
              .registrationWithDivisionIdList![
                  event.indexOfRegistrationWithDivisionId]
              .registeredWeightClasses!);

          for (Registrations item in eventRegistration.registrations!) {
            if (item.scanDetails != null) {
              if (item.scanDetails!.scannedAt != null) {
                registrationWithSameDivisionId.scannedWeights!
                    .add(item.weightClass!.weight.toString());
              }
            }
          }

          emit(state.copyWith(
            data: event.purchasedProductData,
            isFailure: false,
            isUpdateWCInactive: true,
            isLoadingWcs: false,
            message: AppStrings.global_empty_string,
            isLoading: false,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          isLoadingWcs: false,
          isFailure: true,
          message: e.toString(),
          isLoading: false));
    }
  }

  FutureOr<void> _onTriggerWCReselect(TriggerWCReselect event,
      Emitter<PurchasedProductsWithInitialState> emit) {
    final int limit = event
        .purchasedProductData
        .eventRegistrations![event.indexOfEventRegistrations]
        .registrationWithDivisionIdList![
            event.indexOfRegistrationWithDivisionId]
        .registeredWeightClasses!
        .length;
    List<String> registeredWeights = event
        .purchasedProductData
        .eventRegistrations![event.indexOfEventRegistrations]
        .registrationWithDivisionIdList![
            event.indexOfRegistrationWithDivisionId]
        .registeredWeightClasses!;
    List<String> availableWeight = event
        .purchasedProductData
        .eventRegistrations![event.indexOfEventRegistrations]
        .registrationWithDivisionIdList![
            event.indexOfRegistrationWithDivisionId]
        .availableWeightClasses!;
    List<String> selectedWeights = event
        .purchasedProductData
        .eventRegistrations![event.indexOfEventRegistrations]
        .registrationWithDivisionIdList![
            event.indexOfRegistrationWithDivisionId]
        .selectedWeightClasses!;
    List<WeightClass> selectedWeightClasses = event
            .purchasedProductData
            .eventRegistrations![event.indexOfEventRegistrations]
            .registrationWithDivisionIdList![
                event.indexOfRegistrationWithDivisionId]
            .weightClasses ??
        [];
    PurchasedProductsHandlers.emitRefreshState(emit: emit, state: state);
    if (selectedWeights
            .contains(availableWeight[event.indexOfWCFromAvailableWC]) &&
        selectedWeightClasses.any((element) =>
            element.weight ==
            availableWeight[event.indexOfWCFromAvailableWC])) {
      selectedWeightClasses = selectedWeightClasses.map((element) {
        if (element.weight == availableWeight[event.indexOfWCFromAvailableWC]) {
          if (element.totalRegistration != null) {
            element.totalRegistration = element.totalRegistration! - 1;
          }
        }
        return element;
      }).toList();
      selectedWeights.remove(availableWeight[event.indexOfWCFromAvailableWC]);
    } else {
      if (selectedWeights.length < limit) {
        selectedWeightClasses = selectedWeightClasses.map((element) {
          if (element.weight ==
              availableWeight[event.indexOfWCFromAvailableWC]) {
            if (element.totalRegistration != null) {
              element.totalRegistration = element.totalRegistration! + 1;
            }
          }
          return element;
        }).toList();
        selectedWeights.add(availableWeight[event.indexOfWCFromAvailableWC]);
      }
    }

    bool isUpdateWCInactive = true;
    if (selectedWeights.length == limit &&
        !listEquals(selectedWeights, registeredWeights)) {
      isUpdateWCInactive = false;
    } else {
      isUpdateWCInactive = true;
    }

    emit(state.copyWith(
        data: event.purchasedProductData,
        isRefreshRequired: false,
        isFailure: false,
        isUpdateWCInactive: isUpdateWCInactive,
        isLoading: false));
  }

  FutureOr<void> _onTriggerChangeWC(TriggerChangeWC event,
      Emitter<PurchasedProductsWithInitialState> emit) async {
    emit(state.copyWith(
        isRefreshRequired: false,
        isFailure: false,
        isAthleteParameterUpdated: false,
        isLoadingWcs: true,
        message: AppStrings.global_empty_string));
    for (WeightClass weightClass in event.weightClasses) {
      for (String selectedWeight in event.selectedWeights) {
        if (weightClass.weight.toString() == selectedWeight) {
          if (!event.scannedWeights.contains(selectedWeight)) {
            event.changeWCRequest.weightClasses.add(weightClass.id!);
          }
        }
      }
    }
    try {
      final response = await WeightClassRepository.changeWc(
          changeWCRequestModel: event.changeWCRequest);
      response.fold(
        (failure) {
          emit(state.copyWith(
            isFailure: true,
            message: failure.message,
            isLoadingWcs: false,
          ));
        },
        (success) {
          emit(state.copyWith(
            isFailure: false,
            isAthleteParameterUpdated: true,
            message:
                success.responseData?.message ?? AppStrings.global_empty_string,
            isLoadingWcs: false,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          isFailure: true, message: e.toString(), isLoadingWcs: false));
    }
  }

  FutureOr<void> _onTriggerChangeTeam(TriggerChangeTeam event,
      Emitter<PurchasedProductsWithInitialState> emit) async {
    Navigator.pop(navigatorKey.currentState!.context);
    emit(state.copyWith(
        isRefreshRequired: false,
        isFailure: false,
        isAthleteParameterUpdated: false,
        isLoadingWcs: true,
        message: AppStrings.global_empty_string));

    try {
      final response = await TeamsRepository.changeTeam(
          athleteId: event.athleteId,
          eventId: event.eventId,
          teamId: event.teamId);
      response.fold((failure) {
        emit(state.copyWith(
          isFailure: true,
          message: failure.message,
          isLoadingWcs: false,
        ));
      }, (success) {
        emit(state.copyWith(
          isFailure: false,
          isAthleteParameterUpdated: true,
          message:
              success.responseData?.message ?? AppStrings.global_empty_string,
          isLoadingWcs: false,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
          isFailure: true, message: e.toString(), isLoadingWcs: false));
    }
  }

  FutureOr<void> _onTriggerSwitchTab(
      TriggerSwitchTab event, Emitter<PurchasedProductsWithInitialState> emit) {
    PurchasedProductsHandlers.emitRefreshState(emit: emit, state: state);
    // List<String> extractedInvoices = PurchasedProductsHandlers.extractInvoices(
    //   purchasedProducts: event.index == 0 ? null : state.productPurchases,
    //   invoiceUrl: event.rootInvoiceUrl,
    //   eventRegistrations: event.index == 1 ? null : state.eventRegistrations,
    // );
    // List<String> invoiceNames = [];
    // if (event.index == 0) {
    //   for (EventRegistrations eventRegistration in state.eventRegistrations) {
    //     for (Registrations registration in eventRegistration.registrations!) {
    //       if (registration.orderNo != null) {
    //         if (!invoiceNames.contains(
    //             '${registration.orderNo!} ${DateFunctions.getMMMMddyyyyFormat(date: registration.createdAt!)}')) {
    //           invoiceNames.add(
    //               '${registration.orderNo!} ${DateFunctions.getMMMMddyyyyFormat(date: registration.createdAt!)}');
    //         }
    //       }
    //     }
    //   }
    // }
    // if (event.index == 1) {
    //   for (ProductPurchases productPurchases in state.productPurchases) {
    //     if (productPurchases.orderNo != null) {
    //       if (!invoiceNames.contains(
    //           '${productPurchases.orderNo!} ${productPurchases.createdAt!}')) {
    //         invoiceNames.add(
    //             '${productPurchases.orderNo!} ${productPurchases.createdAt!}');
    //       }
    //     }
    //   }
    // }
    emit(state.copyWith(
      isRefreshRequired: false,
      selectedIndex: event.index,
      // dropdownInvoicesUrls: extractedInvoices,
      // dropdownInvoices: invoiceNames,
    ));
  }

  FutureOr<void> _onTriggerDownloadPdf(TriggerDownloadPdf event,
      Emitter<PurchasedProductsWithInitialState> emit) async {
    if (event.invoiceUrl != null) {
      BlocProvider.of<QrScanBloc>(navigatorKey.currentState!.context)
          .add(TriggerStartDownload(event.index!));
    } else {
      emit(state.copyWith(
          isRefreshRequired: false,
          isFailure: false,
          isAthleteParameterUpdated: false,
          isDownloadingInvoice: true,
          message: AppStrings.global_empty_string));
    }

    try {
      final response = await DownloadPdfRepository.downloadAndSavePdf(
          url: event.invoiceUrl ?? state.selectedUrl, fileName: event.orderNo);
      response.fold((failure) {
        emit(state.copyWith(
            isFailure: true,
            message: failure.message,
            isDownloadingInvoice: false));
        if (event.invoiceUrl != null) {
          BlocProvider.of<QrScanBloc>(navigatorKey.currentState!.context)
              .add(TriggerStopDownload(event.index!, failure.message, true));
        }
      }, (success) {
        emit(state.copyWith(
            isFailure: false,
            message: AppStrings.myPurchases_invoiceDownloaded_success_text,
            isDownloadingInvoice: false));
        if (event.invoiceUrl != null) {
          BlocProvider.of<QrScanBloc>(navigatorKey.currentState!.context)
              .add(TriggerStopDownload(event.index!,AppStrings.myPurchases_invoiceDownloaded_success_text, false ));
        }
      });
    } catch (e) {
      emit(state.copyWith(
          isFailure: true, message: e.toString(), isDownloadingInvoice: false));
      if (event.invoiceUrl != null) {
        BlocProvider.of<QrScanBloc>(navigatorKey.currentContext!)
            .add(TriggerStopDownload(event.index!, e.toString(), true));
      }
    }
  }
}
