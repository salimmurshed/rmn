part of 'register_and_sell_bloc.dart';


@freezed
class RegisterAndSellState
    with _$RegisterAndSellState {
  const factory RegisterAndSellState({
    required String message,
    required bool isRefreshRequired,
    required bool isFailure,
    required bool isLoadingCoupon,
    required bool isContactNumberValid,
    required bool isLoading,
    required bool showCancelButton,
    required bool isCancelled,
    required bool isProcessingPurchase,
    required bool isLoadingPdf,
    required bool isFix,
    required bool willRegister,
    required bool isApplyActive,
    required num productSum,
    required num athleteSum,
    required bool isAddToCard,
    required bool isStaffRegistration,
    required bool isFromCancel,
    required bool isApplyButtonActive,
    required bool isCouponLoading,
    required String? couponAmount,
    required num apiCouponAmount,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailController,
    required TextEditingController postalAddressController,
    required TextEditingController zipCodeController,
    required TextEditingController phoneController,
    required TextEditingController couponEditingController,
    required FocusNode couponNode,
    required FocusNode phoneFocusNode,
    required String city,
    required String invoiceUrl,
    required int selectedTabIndex,
    required String stateName,
    required num totalWithCoupon,
    required String paymentId,
    required String readerId,
    required String couponCode,
    required String productSubTotal,
    required String registrationSubTotal,
    required FocusNode firstNameFocusNode,
    required FocusNode lastNameFocusNode,
    required FocusNode emailFocusNode,
    required FocusNode postalAddressFocusNode,
    required FocusNode zipCodeFocusNode,
    required String? zipCodeError,
    required String? couponError,
    required String? selectedValue,
    required String couponMessage,
    required CouponModules couponModule,
    required bool isFormFilled,
    required bool isFormExpanded,
    required bool isDropDownOpened,
    required bool isProductDropDownOpened,
    required bool isButtonLabelledSaved,
    required bool isProductsSelected,
    required bool? isFromOnBehalf,
    required num totalWithTransactionWithoutCouponFee,
    required num totalWithTransactionWithCouponFee,
    required num totalWithOutCoupon,
    required String? selectedValueProduct,
    required EventData eventData,
    required List<Athlete> athletes,
    required List<Athlete> selectedAthletes,
    required List<Products> products,
    required num couponAmountInNum,
    required String transactionFee,
    required List<Products> needsUpdate,
    required List<Products> selectedProducts,
    required List<DivisionTypes> divisionTypes,
    required List<StaffCheckoutRegistrations> registrations,
    required TextEditingController searchController,
    required TextEditingController otherTeamController,
  }) = _RegisterAndSellState;

  factory RegisterAndSellState.initial() =>
      RegisterAndSellState(
          isFailure: false,
          isRefreshRequired: false,
          isLoading: true,
          totalWithOutCoupon: 0,
          couponAmountInNum: 0,
          totalWithCoupon: 0,
          productSubTotal: AppStrings.global_empty_string,
          registrationSubTotal: AppStrings.global_empty_string,
          isProductsSelected: false,
          transactionFee: AppStrings.global_empty_string,
          isCouponLoading: false,
          selectedValueProduct: null,selectedValue: null,
          isDropDownOpened:false,
          otherTeamController: TextEditingController(),
          searchController: TextEditingController(),
          isProductDropDownOpened: false,
          willRegister: false,
          isContactNumberValid: true,
          isCancelled: false,
          isLoadingCoupon: false,
          isApplyButtonActive:false,
          couponModule:  CouponModules.none,
          couponCode: AppStrings.global_empty_string,
          productSum: 0,
          apiCouponAmount:0,
          couponMessage: AppStrings.global_empty_string,
          showCancelButton: false,
          isProcessingPurchase: false,
          isStaffRegistration: false,
          isFromOnBehalf: null,
          couponAmount: null,
          athleteSum: 0,
          couponError: null,
          isApplyActive: true,
          isAddToCard: true,
          invoiceUrl: AppStrings.global_empty_string,
          paymentId: AppStrings.global_empty_string,
          readerId: AppStrings.global_empty_string,
          totalWithTransactionWithCouponFee: 0,
          totalWithTransactionWithoutCouponFee: 0,
          athletes: [],
          products: [],
          isFix: false,
          registrations: [],
          selectedAthletes: [],
          selectedProducts: [],
          needsUpdate: [],
          isLoadingPdf: false,
          divisionTypes: [],
          eventData: EventData(),
          selectedTabIndex: 0,
          message: AppStrings.global_empty_string,
          city: AppStrings.global_empty_string,
          stateName: AppStrings.global_empty_string,
          firstNameController: TextEditingController(),
          lastNameController: TextEditingController(),
          emailController: TextEditingController(),
          phoneController: TextEditingController(),
          phoneFocusNode: FocusNode(),
          postalAddressController: TextEditingController(),
          zipCodeController: TextEditingController(),
          firstNameFocusNode: FocusNode(),
          lastNameFocusNode: FocusNode(),
          emailFocusNode: FocusNode(),
          postalAddressFocusNode: FocusNode(),
          zipCodeFocusNode: FocusNode(),
          couponEditingController: TextEditingController(),
          couponNode: FocusNode(),
          zipCodeError: null,
          isFormFilled: false,
          isFormExpanded: true,
          isButtonLabelledSaved: false,
          isFromCancel: false
        );
}
class StaffCheckoutRegistrations {
   String divisionName;
   String styleName;
   String ageGroup;
   String divId;
   String styleId;
   String athleteName;
   String wc;
   List<String> wcList;
   List<String> wcNumbers;
   num absolutePrice;
   num quantity;
   num totalPrice;
   String id;
   String athleteId;

   StaffCheckoutRegistrations({
    required this.divisionName,
    required this.styleName,
    required this.ageGroup,
    required this.wcNumbers,
    required this.id,
    required this.styleId,
     required this.divId,
    required this.athleteId,
    required this.athleteName,
    required this.wc,
    required this.wcList,
    required this.absolutePrice,
    required this.quantity,
    required this.totalPrice,
  });
}

class StaffCheckoutProducts {
   String productName;
   String variantName;
   num absolutePrice;
   num quantity;
   num totalPrice;
   bool isGiveAway;
  int giveAwayCounts;
   StaffCheckoutProducts({
    required this.productName,
    required this.absolutePrice,
    required this.quantity,
    required this.variantName,
    required this.giveAwayCounts,
    required this.totalPrice,
    required this.isGiveAway,
  });
}
