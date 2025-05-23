part of 'find_customer_bloc.dart';

@freezed
class FindCustomerState with _$FindCustomerState {
  const factory FindCustomerState({
    required String message,
    required bool isLoading,
    required bool isBottomLoading,
    required bool isRefreshedRequired,
    required bool isFailure,
    required bool isOpened,
    required ScrollController scrollController,
    required TextEditingController searchController,
    required List<DataBaseUser> customerList,
    required DataBaseUser? selectedCustomer,
    required String? selectedCustomerName,
    required int page,
    required int totalPage,
    required bool isFetching
  }) = _FindCustomerState;

  factory FindCustomerState.initial() => FindCustomerState(
        isFailure: false,
        isLoading: true,
        isFetching: false,
        isRefreshedRequired: false,
        message: AppStrings.global_empty_string,
        customerList: [],
        isOpened: false,
        isBottomLoading: false,
        scrollController: ScrollController(),
        selectedCustomer: null,
        selectedCustomerName: null,
        page: 1,
        totalPage: 1,
        searchController: TextEditingController(),
      );
}
