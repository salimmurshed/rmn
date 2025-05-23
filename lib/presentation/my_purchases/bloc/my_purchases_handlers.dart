import 'package:bloc/bloc.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'my_purchases_bloc.dart';

class MyPurchasesHandlers {
  static void emitInitialState(
      {required Emitter<MyPurchasesWithInitialState> emit,
      required MyPurchasesWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: false,
        isFailure: false,
        isLoading: true,
        message: AppStrings.global_empty_string));
  }

  static void emitRefreshState(
      {required Emitter<MyPurchasesWithInitialState> emit,
      required MyPurchasesWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        selectedValue: null,
        invoiceUrl: AppStrings.global_empty_string,
        message: AppStrings.global_empty_string));
  }

  static void emitForInvoiceDownload(
      {required Emitter<MyPurchasesWithInitialState> emit,
      required MyPurchasesWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: false,
        isFailure: false,
        isLoading: false,
        selectedValue: null,
        invoiceUrl: AppStrings.global_empty_string,
        message: AppStrings.global_empty_string));
  }

  static List<SeasonData> updateSeasonDataParameters(
      {required List<SeasonData> data, required String assetsUrl}) {
    List<SeasonData> updatedData = data;
    if (updatedData.isNotEmpty) {
      for (SeasonData season in updatedData) {
        DateTime start = DateTime.parse(season.season!.startDate!);
        DateTime end = DateTime.parse(season.season!.endDate!);
        int startYear = start.year;
        int endYear = end.year;

        season.season!.title = updatedData.indexOf(season) == 0 ? 'Current Season':
            '$startYear/${endYear.toString().substring(2)}';
        List<Memberships> updatedMemberships = season.memberships ?? [];
        if (updatedMemberships.isNotEmpty) {
          for (Memberships memberships in updatedMemberships) {
            memberships.athlete!.profileImage =
                '$assetsUrl${memberships.athlete!.profileImage}';
            memberships.purchaseDate = DateFunctions.getMMMMddyyyyFormat(
                date: memberships.purchaseDate!);
            memberships.product!.title =
                StringManipulation.capitalizeFirstLetterOfEachWord(
                    value: memberships.product!.title!);
          }
        }
      }
    }
    return updatedData;
  }

  static List<String> extractUrls({required List<Memberships> data}) {
    List<Memberships> updatedData = data;
    List<String> invoiceUrls = [];
    List<String> invoiceIds = [];
    for (Memberships memberships in updatedData) {
     if(!invoiceIds.contains(memberships.invoiceUrl)){
       if(memberships.orderNo != null){
         invoiceIds.add(memberships.invoiceUrl!);
         invoiceUrls.add('${memberships.orderNo!} ${memberships.purchaseDate!}');
       }
     }
    }
    return invoiceUrls;
  }

  static List<PurchasedProduct> updateProductsDataParameters(
      {required List<PurchasedProduct> data, required String assetsUrl}) {
    List<PurchasedProduct> updatedData = data;
    if (updatedData.isNotEmpty) {
      for (PurchasedProduct product in updatedData) {
        product.coverImage = '$assetsUrl${product.coverImage}';
        product.mainImage = '$assetsUrl${product.mainImage}';
        product.purchaseDatetime = DateFunctions.getMMMMddyyyyFormat(date:
        product.purchaseDatetime!);
        product.title = StringManipulation.capitalizeFirstLetterOfEachWord(
            value: product.title!);
      }
    }
    return updatedData;
  }
}
