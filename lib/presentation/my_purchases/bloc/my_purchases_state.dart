part of 'my_purchases_bloc.dart';

@freezed
class MyPurchasesWithInitialState with _$MyPurchasesWithInitialState {
  const factory MyPurchasesWithInitialState({
    required String message,
    required bool isRefreshRequired,
    required bool isFailure,
    required bool isLoading,
    required List<SeasonData> seasons,
    required List<String> invoiceUrls,
    required int selectTabIndex,
    required String? selectedValue,
    required bool isExpanded,
    required bool isBottomSheetOpen,
    required GlobalKey<State<StatefulWidget>> globalKey,
    required int groupInvoiceIndex,
    required int individualInvoiceIndex,
    required bool isDownloadingInvoice,
    required String invoiceUrl,
    required int indexOfSelectedSeason,
    required List<PurchasedProduct> products,
    required bool isSeasonsCalledFirstTime,
    required bool isProductsCalledFirstTime,
  }) = _MyPurchasesWithInitialState;

  factory MyPurchasesWithInitialState.initial() => MyPurchasesWithInitialState(
        isFailure: false,
        isRefreshRequired: false,
        indexOfSelectedSeason: 0,
        isBottomSheetOpen: false,
        isLoading: true,
        message: AppStrings.global_empty_string,
        seasons: [],
        invoiceUrls: [],
        selectTabIndex: 0,
        selectedValue: null,
        isExpanded: false,
        isDownloadingInvoice: false,
        isSeasonsCalledFirstTime: true,
        isProductsCalledFirstTime: true,
        products: [],
        globalKey: GlobalKey<State<StatefulWidget>>(),
        groupInvoiceIndex: -1,
        individualInvoiceIndex: -1,
        invoiceUrl: AppStrings.global_empty_string,
      );
}
