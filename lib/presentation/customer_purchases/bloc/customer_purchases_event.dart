part of 'customer_purchases_bloc.dart';

@immutable
sealed class CustomerPurchasesEvent extends Equatable {
  const CustomerPurchasesEvent();

  @override
  List<Object> get props => [];
}

class TriggerFetchCustomerPurchasesRefresh extends CustomerPurchasesEvent {}

class TriggerFetchCustomerPurchases extends CustomerPurchasesEvent {}

class TriggerSwitchBetweenTabs extends CustomerPurchasesEvent {
  final int selectedTabIndex;

  const TriggerSwitchBetweenTabs({required this.selectedTabIndex});

  @override
  List<Object> get props => [selectedTabIndex];
}

class TriggerFilterPurchases extends CustomerPurchasesEvent {
  final CustomerPurchasesTypes customerPurchasesTypes;

  const TriggerFilterPurchases({required this.customerPurchasesTypes});

  @override
  List<Object> get props => [customerPurchasesTypes];
}

class TriggerMarkAsScanned extends CustomerPurchasesEvent {
  final String purchaseId;
  final int indexOfSelectedItem;

  const TriggerMarkAsScanned({required this.purchaseId, required this.indexOfSelectedItem});

  @override
  List<Object> get props => [purchaseId, indexOfSelectedItem];
}