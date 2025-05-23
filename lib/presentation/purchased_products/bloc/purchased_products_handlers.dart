import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'purchased_products_bloc.dart';

class PurchasedProductsHandlers {
  static void emitInitialState(
      {required Emitter<PurchasedProductsWithInitialState> emit,
      required PurchasedProductsWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: false,
        isFailure: false,
        isAthleteParameterUpdated: false,
        isLoading: true,
        message: AppStrings.global_empty_string));
  }

  static void emitRefreshState(
      {required Emitter<PurchasedProductsWithInitialState> emit,
      required PurchasedProductsWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        isUpdateWCInactive: false,
        isAthleteParameterUpdated: false,
        orderNo: null,
        isExpanded: false,
        textEditingController: TextEditingController(),
        globalKey: GlobalKey(),
        selectedUrl: AppStrings.global_empty_string,
        message: AppStrings.global_empty_string));
  }

  static List<String> extractWeight(
      {required List<WeightClass> weightClasses}) {
    List<String> weights = [];
    for (WeightClass wc in weightClasses) {
      weights.add(wc.weight.toString());
    }

    weights = GlobalHandlers.sortWeights(weightClasses: weights);
    return weights;
  }

  static List<String> extractTeamNames({required List<Team> teams}) {
    List<String> teamNames = [];
    for (Team team in teams) {
      teamNames.add(team.name!);
    }
    return teamNames;
  }

  static void emitForDownloadingInvoiceState(
      {required Emitter<PurchasedProductsWithInitialState> emit,
      required PurchasedProductsWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: false,
        isDownloadingInvoice: false,
        isFailure: false,
        isLoading: false,
        orderNo: null,
        isExpanded: false,
        globalKey: GlobalKey(),
        selectedUrl: AppStrings.global_empty_string,
        message: AppStrings.global_empty_string));
  }

  static PurchasedProductData updatePurchasedProductsDataParameters(
      {required PurchasedProductData data, required String assetsUrl}) {
    data.title = data.title ?? AppStrings.global_empty_string;
    data.coverImage = '$assetsUrl${data.coverImage}';
    data.mainImage = '$assetsUrl${data.mainImage}';
    data.startDatetime =
        DateFunctions.getMMMMddyyyyFormat(date: data.startDatetime!);
    data.eventRegistrations!
        .map((e) => {
              if (e.team != null)
                {e.team!.name = e.team!.name!}
              else
                {e.team = Team(name: AppStrings.global_no_team, id: '0')},
              e.athlete!.profileImage = '$assetsUrl${e.athlete!.profileImage}'
            })
        .toList();
    for (EventRegistrations eventRegistrations in data.eventRegistrations!) {
      eventRegistrations.isAllScanned = eventRegistrations.registrations!
          .every((element) => element.scanDetails != null);
    }
    for (EventRegistrations eventRegistrations in data.eventRegistrations!) {
      Map<String, RegistrationWithSameDivisionId> registrationWithDivisionMap =
          {};
      for (Registrations registers in eventRegistrations.registrations!) {
        String divId = registers.division!.id!;
        if (registrationWithDivisionMap.containsKey(divId)) {
          if (registrationWithDivisionMap[divId]!.registeredWeightClasses ==
              null) {
            registrationWithDivisionMap[divId]!.registeredWeightClasses = [
              registers.weightClass!.weight!.toString()
            ];
          } else {
            if (!registrationWithDivisionMap[divId]!
                .registeredWeightClasses!
                .contains(registers.weightClass!.weight!.toString())) {
              registrationWithDivisionMap[divId]!
                  .registeredWeightClasses!
                  .add(registers.weightClass!.weight!.toString());

              registrationWithDivisionMap[divId]!.registeredWeightClasses =
                  GlobalHandlers.sortWeights(
                      weightClasses: registrationWithDivisionMap[divId]!
                          .registeredWeightClasses!);
            }
          }
        } else {
          registers.division!.divisionType =
              StringManipulation.capitalizeFirstLetterOfEachWord(
                  value: registers.division!.divisionType!);
          registers.division!.style =
              StringManipulation.capitalizeFirstLetterOfEachWord(
                  value: registers.division!.style!);
          registers.division!.title =
              StringManipulation.capitalizeFirstLetterOfEachWord(
                  value: registers.division!.title!);
          RegistrationWithSameDivisionId registrationWithDivisionId =
              RegistrationWithSameDivisionId(
                  isCancelled: registers.isCancelled,
                  division: registers.division,
                  registeredWeightClasses: [
                registers.weightClass!.weight!.toString()
              ],
                  scannedWeights: [],
                  selectedWeightClasses: [],
                  weightClasses: [],
                  availableWeightClasses: []);
          registrationWithDivisionMap[divId] = registrationWithDivisionId;
        }
      }
      eventRegistrations.registrationWithDivisionIdList =
          registrationWithDivisionMap.values.toList();
    }
    if (data.productPurchases!.isNotEmpty) {
      for (ProductPurchases productPurchases in data.productPurchases!) {
        productPurchases.product!.title =
            StringManipulation.capitalizeFirstLetterOfEachWord(
                value: productPurchases.product!.title!);
        productPurchases.createdAt = DateFunctions.getMMMMddyyyyFormat(
            date: productPurchases.createdAt!);
        productPurchases.product!.image =
            '$assetsUrl${productPurchases.product!.image}';
        productPurchases.qrCodeStatus = productPurchases.scanDetails == null
            ? AppStrings.myPurchases_qrCode_noScanDetails_text
            : (productPurchases.status!.toLowerCase() ==
                    QRCodeStatus.confirmed.name
                ? AppStrings.myPurchases_qrCode_scanDetailsConfirmed_text
                : AppStrings.myPurchases_qrCode_noScanDetailsCancelled_text);
        if (productPurchases.scanDetails == null) {
          productPurchases.qrCodeStatus =
              AppStrings.myPurchases_qrCode_noScanDetails_text;
        } else {
          if (productPurchases.status!.toUpperCase() ==
              AppStrings.myPurchases_qrCode_noScanDetailsCancelled_text
                  .toUpperCase()) {
            productPurchases.qrCodeStatus =
                AppStrings.myPurchases_qrCode_noScanDetailsCancelled_text;
          } else {
            productPurchases.qrCodeStatus =
                AppStrings.myPurchases_qrCode_scanDetailsConfirmed_text;
          }
        }
      }
    }
    return data;
  }

  static List<String> extractInvoices(
      {required String invoiceUrl,
      required List<ProductPurchases>? purchasedProducts,
      required List<EventRegistrations>? eventRegistrations}) {
    List<String> invoices = [];
    if (purchasedProducts != null) {
      for (ProductPurchases productPurchases in purchasedProducts) {
        if (productPurchases.orderNo != null) {
          invoices.add(productPurchases.orderNo!);
        }
      }
    }
    if (eventRegistrations != null) {
      for (EventRegistrations eventRegistration in eventRegistrations) {
        for (Registrations registration in eventRegistration.registrations!) {
          if (registration.orderNo != null) {
            invoices.add(registration.orderNo!);
          }
        }
      }
    }
    for (var i = 0; i < invoices.length; i++) {
      String url = invoiceUrl;
      invoices[i] = url.replaceAll(':orderNo', invoices[i]);
    }
    return invoices;
  }
}
