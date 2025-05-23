part of 'my_purchases_bloc.dart';

@immutable
sealed class MyPurchasesEvent extends Equatable {
  const MyPurchasesEvent();

  @override
  List<Object> get props => [];
}

class TriggerSeasonsEvent extends MyPurchasesEvent {
  final MyPurchases myPurchases;
  const TriggerSeasonsEvent({required this.myPurchases});
  @override
  List<Object> get props => [myPurchases];
}

class TriggerProductsEvent extends MyPurchasesEvent {}
class TriggerDropDownExpand extends MyPurchasesEvent {
  final bool isExpanded;
  const TriggerDropDownExpand({required this.isExpanded});
  @override
  List<Object> get props => [isExpanded];
}

class TriggerDownloadFromDropDown extends MyPurchasesEvent {}

class TriggerDownloadSingleInvoice extends MyPurchasesEvent {
  final String invoiceUrl;
  final String orderNo;
  final int individualInvoiceIndex;
  final bool isIndividualInvoiceDownload;
  const TriggerDownloadSingleInvoice({required this.invoiceUrl,
    required this.isIndividualInvoiceDownload,
     required this.individualInvoiceIndex,required this.orderNo});
  @override
  List<Object> get props => [invoiceUrl, orderNo, individualInvoiceIndex, TriggerDownloadSingleInvoice];
}

class TriggerSelectInvoice extends MyPurchasesEvent {
  final String invoiceOrderNumber;
  final List<Memberships> memberships;

  const TriggerSelectInvoice(
      {required this.invoiceOrderNumber, required this.memberships});
  @override
  List<Object> get props => [invoiceOrderNumber, memberships];
}

class TriggerOpenBottomSheetForDownload extends MyPurchasesEvent{
  final List<Memberships> memberships;
  const TriggerOpenBottomSheetForDownload({required this.memberships});
  @override
  List<Object> get props => [memberships];
}

class TriggerSelectSeason extends MyPurchasesEvent {
  final int indexOfSelectedSeason;
  const TriggerSelectSeason({required this.indexOfSelectedSeason});
  @override
  List<Object> get props => [indexOfSelectedSeason];
}
class TriggerInitialize extends MyPurchasesEvent{}