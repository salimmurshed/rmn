part of 'purchased_products_bloc.dart';

@immutable
sealed class PurchasedProductsEvent extends Equatable {
  const PurchasedProductsEvent();

  @override
  List<Object?> get props => [];
}

class TriggerChangeWC extends PurchasedProductsEvent {
  final ChangeWCRequestModel changeWCRequest;
  final List<WeightClass> weightClasses;
  final List<String> selectedWeights;
  final List<String> scannedWeights;

  const TriggerChangeWC(
      {required this.changeWCRequest,
        required this.weightClasses,
        required this.scannedWeights,
        required this.selectedWeights});

  @override
  List<Object?> get props => [changeWCRequest, scannedWeights, weightClasses, selectedWeights];
}

class TriggerFetchProductDetails extends PurchasedProductsEvent {
  final String eventId;
  final bool isAthleteParameterUpdated;

  const TriggerFetchProductDetails({
    required this.eventId,required this.isAthleteParameterUpdated
  });

  @override
  List<Object?> get props => [eventId, isAthleteParameterUpdated];
}

class TriggerSwitchTab extends PurchasedProductsEvent {
  final int index;
  final String rootInvoiceUrl;

  const TriggerSwitchTab({required this.index, required this.rootInvoiceUrl});

  @override
  List<Object?> get props => [index, rootInvoiceUrl];
}

class TriggerFetchWeightClasses extends PurchasedProductsEvent {
  final PurchasedProductData purchasedProductData;
  final int indexOfEventRegistrations;
  final int indexOfRegistrationWithDivisionId;

  const TriggerFetchWeightClasses(
      {required this.purchasedProductData,
      required this.indexOfRegistrationWithDivisionId,
      required this.indexOfEventRegistrations});

  @override
  List<Object?> get props => [
        indexOfEventRegistrations,
        indexOfRegistrationWithDivisionId,
        purchasedProductData
      ];
}

class TriggerWCReselect extends PurchasedProductsEvent {
  final PurchasedProductData purchasedProductData;
  final int indexOfEventRegistrations;
  final int indexOfRegistrationWithDivisionId;
  final int indexOfWCFromAvailableWC;

  const TriggerWCReselect({
    required this.purchasedProductData,
    required this.indexOfRegistrationWithDivisionId,
    required this.indexOfEventRegistrations,
    required this.indexOfWCFromAvailableWC,
  });

  @override
  List<Object?> get props => [
        indexOfEventRegistrations,
        indexOfRegistrationWithDivisionId,
        indexOfWCFromAvailableWC,
        purchasedProductData
      ];
}

class TriggerOpenBottomSheetForDownloadingPdf extends PurchasedProductsEvent {}

class TriggerInvoiceOrTeamSelection extends PurchasedProductsEvent {
  final String url;
  final List<String> invoiceUrls;
  final List<Team> teams;

  const TriggerInvoiceOrTeamSelection({
    required this.url,
    required this.invoiceUrls,
    required this.teams,
  });

  @override
  List<Object?> get props => [url, invoiceUrls, teams];
}

class TriggerInvoiceDownload extends PurchasedProductsEvent {
  final String url;

  const TriggerInvoiceDownload({
    required this.url,
  });

  @override
  List<Object?> get props => [url];
}

class TriggerDropdownExpand extends PurchasedProductsEvent {
  final bool isExpanded;

  const TriggerDropdownExpand({required this.isExpanded});

  @override
  List<Object?> get props => [isExpanded];
}

class TriggerChangeTeam extends PurchasedProductsEvent {
  final String athleteId;
  final String eventId;
  final String teamId;

  const TriggerChangeTeam({
    required this.athleteId,
    required this.eventId,
    required this.teamId,
  });

  @override
  List<Object?> get props => [athleteId, eventId, teamId];
}

class TriggerDownloadPdf extends PurchasedProductsEvent {
  final String orderNo;
  String? invoiceUrl;
  int? index;
   TriggerDownloadPdf({required this.orderNo, this.invoiceUrl, this.index});
  @override
  List<Object?> get props => [orderNo, invoiceUrl, index];
}

