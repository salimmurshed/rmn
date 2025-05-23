part of 'customer_purchases_bloc.dart';

@freezed
class CustomerPurchasesState with _$CustomerPurchasesState {
  const factory CustomerPurchasesState({
    required String message,
    required bool isLoading,
    required bool isRefreshedRequired,
    required bool isFailure,
    required CustomerPurchasesTypes customerPurchasesTypes,
    required int selectedTab,
    required String userName,
    required int indexOfSelectedItem,
    required List<CustomerProducts> products,
    required List<CustomerProducts> allProducts,
    required  List<CustomerRegistrations> registrations,
    required  List<CustomerRegistrations> allRegistrations,
  }) = _CustomerPurchasesState;

  factory CustomerPurchasesState.initial() => const CustomerPurchasesState(
      isFailure: false,
      isLoading: true,
      isRefreshedRequired: false,
      customerPurchasesTypes: CustomerPurchasesTypes.all,
      selectedTab: 0,
      indexOfSelectedItem: -1,
      userName: AppStrings.global_empty_string,
      message: AppStrings.global_empty_string,
      products: [],
      registrations: [],
      allProducts: [],
      allRegistrations: []
      );
}
