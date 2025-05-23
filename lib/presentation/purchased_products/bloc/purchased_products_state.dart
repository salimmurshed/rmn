part of 'purchased_products_bloc.dart';

@freezed
class PurchasedProductsWithInitialState
    with _$PurchasedProductsWithInitialState {
  const factory PurchasedProductsWithInitialState({
    required String message,
    required bool isRefreshRequired,
    required bool isFailure,
    required bool isAthleteParameterUpdated,
    required bool isLoading,
    required bool isLoadingWCChange,
    required bool isInvoiceDownloading,
    required String? selectedTeam,
    required PurchasedProductData? data,
    required int selectedIndex,
    required List<String> dropdownInvoices,
    required List<String> teamNames,
    required List<String> dropdownInvoicesUrls,
    required GlobalKey<State<StatefulWidget>> globalKey,
    required bool isExpanded,
    required String? orderNo,
    required String selectedUrl,
    required String selectedTeamId,
    required bool isDownloadingInvoice,
    required bool isLoadingWcs,
    required List<Team> teams,
    required bool isUpdateWCInactive,
    required List<EventRegistrations> eventRegistrations,
    required List<ProductPurchases> productPurchases,
    required TextEditingController textEditingController,
  }) = _PurchasedProductsWithInitialState;

  factory PurchasedProductsWithInitialState.initial() =>
      PurchasedProductsWithInitialState(
          isFailure: false,
          isAthleteParameterUpdated: false,
          isInvoiceDownloading: true,
          isLoadingWcs: false,
          isLoadingWCChange: false,
          selectedUrl: AppStrings.global_empty_string,
          selectedTeamId: AppStrings.global_empty_string,
          dropdownInvoices: [],
          dropdownInvoicesUrls: [],
          teams: [],
          teamNames: [],
          eventRegistrations: [],
          productPurchases: [],
          isUpdateWCInactive: true,
          isRefreshRequired: false,
          isLoading: true,
          message: AppStrings.global_empty_string,
          data: null,
          selectedIndex: 0,
          isExpanded: false,
          globalKey: GlobalKey(),
          textEditingController: TextEditingController(),
          orderNo: null,
          selectedTeam: null,
          isDownloadingInvoice: false);
}
