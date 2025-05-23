import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmnevents/presentation/create_edit_profile/widgets/build_zip_code_field.dart';

import '../../../common/widgets/bottomsheets/bottom_sheet_checkout.dart';
import '../../../common/widgets/cards/build_athlete_visible_athlete_item.dart';
import '../../../data/models/arguments/athlete_argument.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../root_app.dart';
import '../../create_edit_profile/widgets/build_name_section.dart';
import '../../purchase/bloc/purchase_bloc.dart';
import '../../purchase/widgets/build_products_widget.dart';
import '../../purchase/widgets/updated_product_widget.dart';
import '../bloc/register_and_sell_bloc.dart';
import '../widgets/mbs_for_staff_product_checkout.dart';
import '../widgets/show_payment_success_dialog.dart';
import 'package:flutter/cupertino.dart';

class RegisterAndSellView extends StatefulWidget {
  const RegisterAndSellView({super.key, required this.eventData});

  final EventData eventData;

  @override
  State<RegisterAndSellView> createState() => _RegisterAndSellViewState();
}

class _RegisterAndSellViewState extends State<RegisterAndSellView> {
  @override
  void initState() {
    BlocProvider.of<RegisterAndSellBloc>(context)
        .add(TriggerInitialize(isInit: true));
    BlocProvider.of<RegisterAndSellBloc>(context)
        .add(TriggerFetchEmployeeEventDetails(eventId: widget.eventData.id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterAndSellBloc, RegisterAndSellState>(
      builder: (context, state) {
        return customScaffold(
          hasForm: true,
          persistentFooterButtons: [
            if (state.isProcessingPurchase)
              ...[]
            else ...[
              if (!state.isLoading)
                buildCustomLargeFooterBtn(
                    isFromCancel: state.isFromCancel,
                    color: AppColors.colorTertiary,
                    onTap: () {
                      openRegisterCheckout(context);

                      // buildCustomShowModalBottomSheetParent(
                      //     ctx: context,
                      //     isNavigationRequired: false,
                      //     child: BlocBuilder<RegisterAndSellBloc,
                      //         RegisterAndSellState>(
                      //       builder: (context, state) {
                      //         return MBSForStaffProductCheckOut(
                      //           isFix: state.isFix,
                      //           isActive: state.isApplyActive,
                      //           couponAmount: state.couponAmount,
                      //           couponController: state.couponController,
                      //           couponFocusNode: state.couponFocusNode,
                      //           isLoeaderVisible: state.isProcessingPurchase,
                      //           removeCoupon: () {
                      //             BlocProvider.of<RegisterAndSellBloc>(context)
                      //                 .add(TriggerRemoveCoupon());
                      //           },
                      //           applyCoupon: (code) {
                      //             BlocProvider.of<PurchaseBloc>(context).add(
                      //                 TriggerCouponApplication(
                      //                     code: code.trim(),
                      //                     module: state.registrations.isNotEmpty
                      //                         ? 'registrations'
                      //                         : 'tickets'));
                      //             FocusManager.instance.primaryFocus?.unfocus();
                      //           },
                      //           removeItems: () {
                      //             BlocProvider.of<RegisterAndSellBloc>(context)
                      //                 .add(TriggerRemoveAllItems());
                      //           },
                      //           reduce: (i) {
                      //             BlocProvider.of<RegisterAndSellBloc>(context)
                      //                 .add(TriggerChangeCartQuantity(
                      //                     reduce: true, index: i));
                      //           },
                      //           increase: (i) {
                      //             BlocProvider.of<RegisterAndSellBloc>(context)
                      //                 .add(TriggerChangeCartQuantity(
                      //                     reduce: false, index: i));
                      //           },
                      //           eventTitle: widget.eventData.title!,
                      //           products: state.selectedProducts.isNotEmpty
                      //               ? state.selectedProducts
                      //                   .map((e)
                      //           {
                      //                      return   StaffCheckoutProducts(
                      //                           isGiveAway: e.productDetails
                      //                                   ?.isGiveaway ??
                      //                               false,
                      //                           absolutePrice: e.price!,
                      //                           giveAwayCounts:
                      //                               e.giveAwayCounts ?? e.availableGiveaways!,
                      //                           productName:
                      //                               e.productDetails!.title!,
                      //                           variantName: e
                      //                                   .selectedVariant ??
                      //                               AppStrings
                      //                                   .global_empty_string,
                      //                           quantity: e.quantity!,
                      //                           // Ensure you're passing a new value
                      //                           totalPrice:
                      //                               e.price! * e.quantity!,
                      //                         );
                      //                       })
                      //                   .toList()
                      //               : [],
                      //           registrations: state.registrations,
                      //           totalSum: state.productSum + state.athleteSum,
                      //         );
                      //       },
                      //     ));
                    },
                    btnLabel:
                        '${AppStrings.btn_checkout} ${(state.selectedProducts.where((e) => e.quantity! > 0).toList()).length + state.registrations.length} items | ${StringManipulation.addADollarSign(price: state.productSum + state.athleteSum)}',
                    hasKeyBoardOpened: true,
                    isColorFilledButton: true),
            ]
          ],
          customAppBar: state.isProcessingPurchase
              ? null
              : CustomAppBar(
                  title:
                      widget.eventData.title ?? AppStrings.global_empty_string,
                  isLeadingPresent: true,
                  goBack: () {
                    if (state.selectedProducts.isNotEmpty ||
                        state.registrations.isNotEmpty ||
                        state.firstNameController.text.isNotEmpty ||
                        state.lastNameController.text.isNotEmpty ||
                        state.emailController.text.isNotEmpty ||
                        state.postalAddressController.text.isNotEmpty ||
                        state.zipCodeController.text.isNotEmpty) {
                      buildBottomSheetWithBodyText(
                          context: context,
                          title: state.showCancelButton
                              ? AppStrings
                                  .bottomSheet_leaveRegistration_for_cancel_payment_title
                              : AppStrings.bottomSheet_leaveRegistration_title,
                          subtitle: state.showCancelButton
                              ? AppStrings.bottomSheet_leavePayment_subtitle
                              : AppStrings
                                  .bottomSheet_leaveRegistration_subtitle,
                          isSingeButtonPresent: false,
                          leftButtonText: state.showCancelButton
                              ? AppStrings.btn_cancel
                              : AppStrings.btn_leave,
                          rightButtonText: AppStrings.btn_stay,
                          onLeftButtonPressed: () {
                            if (state.showCancelButton) {
                              Navigator.pop(context);
                              BlocProvider.of<RegisterAndSellBloc>(context)
                                  .add(TriggerOnClickOfBack());
                            } else {
                              BlocProvider.of<RegisterAndSellBloc>(context)
                                  .add(TriggerRefreshRegistrationAndSellForm());
                              BlocProvider.of<RegisterAndSellBloc>(context)
                                  .add(TriggerMakeItAtToCart());
                              Navigator.pop(context);
                              Navigator.pop(context);
                              BlocProvider.of<RegisterAndSellBloc>(context)
                                  .add(TriggerInitialize(isInit: false));
                            }
                          },
                          onRightButtonPressed: () {
                            Navigator.pop(context);
                          });
                    } else {
                      BlocProvider.of<RegisterAndSellBloc>(context)
                          .add(TriggerRefreshRegistrationAndSellForm());
                      BlocProvider.of<RegisterAndSellBloc>(context)
                          .add(TriggerMakeItAtToCart());
                      BlocProvider.of<RegisterAndSellBloc>(context)
                          .add(TriggerInitialize(isInit: false));
                      Navigator.pop(context);
                    }
                  },
                ),
          formOrColumnInsideSingleChildScrollView: null,
          anyWidgetWithoutSingleChildScrollView: state.showCancelButton
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorTertiary,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 16.h),
                      child: Column(
                        children: [
                          //
                          CupertinoActivityIndicator(
                            radius: 28.r,
                            color: AppColors.colorPrimaryInverse,
                          ),
                          SizedBox(height: 15.h),
                          Center(
                              child: Text(
                            'Payment Processing...',
                            style: AppTextStyles.largeTitle(),
                          )),
                          Center(
                              child: Text(
                                'Proceed with payment using the connected S700 device.',
                                style: AppTextStyles.regularNeutralOrAccented(isOutfit: false),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    if (state.showCancelButton)
                      buildCustomLargeFooterBtn(
                          onTap: () {
                            buildBottomSheetWithBodyText(
                                context: context,
                                title: AppStrings
                                    .bottomSheet_leaveRegistration_for_cancel_payment_title,
                                subtitle: AppStrings
                                    .bottomSheet_leavePayment_subtitle,
                                isSingeButtonPresent: false,
                                leftButtonText: AppStrings.btn_cancel,
                                rightButtonText: AppStrings.btn_stay,
                                onLeftButtonPressed: () {
                                  Navigator.pop(context);
                                  BlocProvider.of<RegisterAndSellBloc>(context)
                                      .add(TriggerCancelPurchase(
                                          readerId: state.readerId,
                                          paymentId: state.paymentId));
                                },
                                onRightButtonPressed: () {
                                  Navigator.pop(context);
                                });
                          },
                          btnLabel: 'Cancel Payment',
                          hasKeyBoardOpened: false,
                          isColorFilledButton: false)
                  ],
                )
              : (state.isLoading
                  ? CustomLoader(child: buildViewLayout(context, state))
                  : buildViewLayout(context, state)),
        );
      },
    );
  }



  Column buildViewLayout(BuildContext context, RegisterAndSellState state) {
    return Column(
      children: [
        buildCustomTabBar(isScrollRequired: false, tabElements: [
          TabElements(
              title: 'Products',
              onTap: () {
                BlocProvider.of<RegisterAndSellBloc>(context).add(
                  const TriggerSwitchTab(index: 0),
                );
              },
              isSelected: state.selectedTabIndex == 0),
          TabElements(
              title: 'Registrations',
              onTap: () {
                BlocProvider.of<RegisterAndSellBloc>(context).add(
                  const TriggerSwitchTab(index: 1),
                );
              },
              isSelected: state.selectedTabIndex == 1),
        ]),
        if (state.selectedTabIndex == 0) ...[
          if (state.products.isNotEmpty)
            Expanded(
                child: ListView.separated(
                    itemBuilder: (context, i) {
                      debugPrint('Max: ${state.products[i].isMaxGiveawayAdded} title: ${state.products[i].productDetails?.title} isGiveAway: ${state.products[i].productDetails?.isGiveaway} isGiveAwayMandatory: ${state.products[i].productDetails?.isGiveawayMandatory} giveAwayType: ${state.products[i].productDetails?.giveAwayType} available: ${state.products[i].availableGiveaways} counts: ${state.products[i].giveAwayCounts} selected: ${state.products[i].selectedVariant} isAdded: ${state.products[i].isAddedToCart}');
                      return UpdatedProductWidget(
                        isEmployeProduct: true,
                        context: context,
                        add: () {
                          if (state.products[i].isAddedToCart!) {

                          } else {
                            BlocProvider.of<RegisterAndSellBloc>(context).add(
                                TriggerAddSelectedProductToCart(
                                    product: state.products[i]));
                          }
                        },
                        onChanged: (val) {
                          BlocProvider.of<RegisterAndSellBloc>(context).add(
                              TriggerSelectVariant(
                                  isFromMBS: false,
                                  selectedValue: val,
                                  index: i,
                                  product: state.products));
                        },
                        products: state.products[i],
                        onMenuStateChange: (isOpen) {},
                        selectedValueProduct: state.products[i].selectedVariant,
                        dropDownKeyForProducts:
                            state.products[i].dropDownKeyForProduct!,
                        isProductDropDownOpened: state.products[i].isOpen!,
                        reduce: () {
                          BlocProvider.of<RegisterAndSellBloc>(context).add(
                              TriggerChangeProductQuantity(
                                  isFromMBS: false,
                                  isMinus: true,
                                  index: i,
                                  quantity: state.products[i].quantity!,
                                  product: state.products));
                        },
                        increase: () {
                          BlocProvider.of<RegisterAndSellBloc>(context).add(
                              TriggerChangeProductQuantity(
                                  isFromMBS: false,
                                  isMinus: false,
                                  index: i,
                                  quantity: state.products[i].quantity!,
                                  product: state.products));
                        },
                      );
                    },
                    separatorBuilder: (context, i) {
                      return SizedBox(
                        height: 10.h,
                      );
                    },
                    itemCount: state.products.length)),
          if (state.products.isEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Dimensions.getScreenHeight() * 0.3),
                Center(
                  child: Text(
                    'No products available',
                    style: AppTextStyles.smallTitleForEmptyList(),
                  ),
                ),
              ],
            )
        ],
        if (state.selectedTabIndex == 1)
          buildRegistrationsTabView(state, context)
      ],
    );
  }

  Expanded buildRegistrationsTabView(
      RegisterAndSellState state, BuildContext context) {
    if(state.athletes.isNotEmpty) {
      print('--${state.athletes.first.selectedTeam?.id} ${state.athletes.first.selectedTeam?.name}');
    }
    return Expanded(
      // color: Colors.blue,
      // height: Dimensions.getScreenHeight() * 0.76,
      child: ListView(
        children: [

          if (state.isFromOnBehalf == null) ...[
            Text(
              AppStrings.registerAndSell_form_title,
              style: AppTextStyles.largeTitle(),
            ),
            SizedBox(height: 10.h),
            if (state.isFormExpanded)
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Coach/Parent Information',
                      style: AppTextStyles.smallTitle(isOutFit: false),
                    ),
                    buildNameSection(
                      onChangedFirstName: (value) {
                        BlocProvider.of<RegisterAndSellBloc>(context).add(
                          TriggerToCheckSaveButtonStatus(),
                        );
                      },
                      onChangedLastName: (value) {
                        BlocProvider.of<RegisterAndSellBloc>(context).add(
                          TriggerToCheckSaveButtonStatus(),
                        );
                      },
                      firstNameEditingController: state.firstNameController,
                      firstNameFocusNode: state.firstNameFocusNode,
                      lastNameEditingController: state.lastNameController,
                      lastNameFocusNode: state.lastNameFocusNode,
                      lastNameValidator: (value) {
                        return TextFieldValidators.validateName(
                          value: value ?? AppStrings.global_empty_string,
                          nameTypes: NameTypes.lastName,
                        );
                      },
                      firstNameValidator: (value) {
                        return TextFieldValidators.validateName(
                          value: value ?? AppStrings.global_empty_string,
                          nameTypes: NameTypes.firstName,
                        );
                      },
                    ),
                    buildCustomEmailField(
                        onChanged: (value) {
                          BlocProvider.of<RegisterAndSellBloc>(context).add(
                            TriggerToCheckSaveButtonStatus(),
                          );
                        },
                        emailAddressController: state.emailController,
                        emailFocusNode: state.emailFocusNode,
                        validator: (value) {
                          return TextFieldValidators.validateEmail(value!);
                        }),
                    buildCustomPhoneField(
                        isContactNumberValid: state.isContactNumberValid,
                        phoneNumberController: state.phoneController,
                        phoneNumberFocusNode: state.phoneFocusNode,
                        context: context,
                        validator: (value) {
                          return TextFieldValidators.validateContactNumber(
                              value: value ?? AppStrings.global_empty_string);
                        },
                        onChanged: (v) {
                          BlocProvider.of<RegisterAndSellBloc>(context)
                              .add(TriggerInteractWithContactField());
                        }),
                    buildCustomGooglePlacesTextFormField(
                        validator: (value) {
                          return TextFieldValidators.validatePostalAddress(
                              city: state.city,
                              address: state.postalAddressController.text);
                        },
                        textEditingController: state.postalAddressController,
                        onChanged: (value) {
                          BlocProvider.of<RegisterAndSellBloc>(context).add(
                            TriggerToCheckSaveButtonStatus(),
                          );
                        },
                        itmClick: (item) {
                          BlocProvider.of<RegisterAndSellBloc>(context).add(
                            TriggerClickGoogleCity(item: item),
                          );
                        }),
                    buildZipCodeField(
                        zipCodeEditingController: state.zipCodeController,
                        onChanged: (value) {
                          BlocProvider.of<RegisterAndSellBloc>(context).add(
                            TriggerToCheckSaveButtonStatus(),
                          );
                        },
                        zipError: state.zipCodeError,
                        zipCodeFocusNode: state.zipCodeFocusNode),
                    SizedBox(height: 15.h),
                    buildCustomLargeFooterBtn(
                        onTap: state.isFormFilled
                            ? () {
                                BlocProvider.of<RegisterAndSellBloc>(context)
                                    .add(
                                  TriggerSaveAndContinue(),
                                );
                              }
                            : () {},
                        isActive: state.isFormFilled,
                        btnLabel: state.isButtonLabelledSaved
                            ? AppStrings.btn_save
                            : AppStrings.btn_saveNcontinue,
                        hasKeyBoardOpened: true,
                        isColorFilledButton: true),
                  ],
                ),
              ),
            if (!state.isFormExpanded)
              GestureDetector(
                onTap: () {
                  BlocProvider.of<RegisterAndSellBloc>(context).add(
                    TriggerFormExpansion(),
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.colorSecondary,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            StringManipulation.combineFirstNameWithLastName(
                                firstName: state.firstNameController.text,
                                lastName: state.lastNameController.text),
                            maxLines: 1,
                            style: AppTextStyles.smallTitle(isOutFit: false),
                          ),
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          AppAssets.icEdit,
                          height: 18.h,
                          width: 18.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20.h),
          ],
          if (state.isButtonLabelledSaved || state.isFromOnBehalf != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        'Athletes',
                        style: AppTextStyles.largeTitle(),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context,
                              AppRouteNames.routeCreateOrEditAthleteProfile,
                              arguments: AthleteArgument(
                                  createProfileType:
                                      CreateProfileTypes.createAthleteLocally));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 13.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.colorSecondaryAccent,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Center(
                            child: Text('Add Athlete',
                                style: AppTextStyles.regularPrimary(
                                    isOutFit: false)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    children: [
                      for (int i = 0; i < state.athletes.length; i++)
                        GestureDetector(
                          onTap: BlocProvider.of<RegisterAndSellBloc>(context)
                                  .checkForSelectedAthlete(
                                      id: state.athletes[i].underscoreId ?? '')
                              ? () {}
                              : () {
                            if(state.athletes[i].isLocal == null){
                                  Navigator.pushNamed(
                                      context,
                                      AppRouteNames
                                          .routeCreateOrEditAthleteProfile,
                                      arguments: AthleteArgument(
                                        createProfileType: CreateProfileTypes
                                            .editAthleteLocally,
                                        athleteId:
                                            state.athletes[i].underscoreId,
                                      ));}
                                },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            child: buildAthleteCardGeneral(
                              isLocal: state.athletes[i].isLocal == null,

                              isActive: !BlocProvider.of<RegisterAndSellBloc>(
                                      context)
                                  .checkForSelectedAthlete(
                                      id: state.athletes[i].underscoreId ?? ''),
                              removeAthlete:
                                  BlocProvider.of<RegisterAndSellBloc>(context)
                                          .checkForSelectedAthlete(
                                              id: state.athletes[i]
                                                      .underscoreId ??
                                                  '')
                                      ? () {}
                                      : () {
                                          BlocProvider.of<RegisterAndSellBloc>(
                                                  context)
                                              .add(TriggerRemoveAthlete(
                                                  athleteId: state.athletes[i]
                                                      .underscoreId!));
                                        },
                              edit: BlocProvider.of<RegisterAndSellBloc>(
                                          context)
                                      .checkForSelectedAthlete(
                                          id: state.athletes[i].underscoreId ??
                                              '')
                                  ? () {}
                                  : () {
                                      Navigator.pushNamed(
                                          context,
                                          AppRouteNames
                                              .routeCreateOrEditAthleteProfile,
                                          arguments: AthleteArgument(
                                            createProfileType:
                                                CreateProfileTypes
                                                    .editAthleteLocally,
                                            athleteId:
                                                state.athletes[i].underscoreId,
                                          ));
                                    },
                              openBottomSheet: () {},
                              selectedDivision: null,
                              weightClass: state.athletes[i].weight.toString(),
                              age: state.athletes[i].age.toString(),
                              imageUrl: state.athletes[i].profileImage ??
                                  AppStrings.global_empty_string,
                              firstName: state.athletes[i].firstName!,
                              lastName: state.athletes[i].lastName!,
                              index: i,
                            ),
                          ),
                        ),
                      if (state.athletes.isNotEmpty)
                        buildCustomLargeFooterBtn(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRouteNames.routePurchaseRegs,
                                  arguments:
                                      CouponModules.employeeRegistration);
                            },
                            btnLabel: AppStrings.btn_register,
                            hasKeyBoardOpened: true,
                            isColorFilledButton: true),
                    ],
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}

Widget buildDetailRow(String label, String value, {bool isAmount = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            color: isAmount ? Colors.red : Colors.white,
            fontWeight: isAmount ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

void openRegisterCheckout(BuildContext context) {
  buildCustomShowModalBottomSheetParent(
      ctx: context,
      isNavigationRequired: false,
      child: BlocBuilder<RegisterAndSellBloc, RegisterAndSellState>(
        builder: (context, state) {
          return bottomSheetCheckout(
            goToProd: (){
              BlocProvider.of<RegisterAndSellBloc>(context).add(
                const TriggerSwitchTab(index: 0),
              );
              Navigator.pop(context);
            },
            gotoReg: (){
              BlocProvider.of<RegisterAndSellBloc>(context).add(
                const TriggerSwitchTab(index: 1),
              );
              Navigator.pop(context);
            },
            isLoading: state.isLoading,
            checkout: () {
              BlocProvider.of<RegisterAndSellBloc>(context)
                  .add(TriggerCheckMandatoryT());
            },
            apiCouponAmount: state.apiCouponAmount,
            error: state.couponMessage.isEmpty
                ? AppStrings.global_empty_string
                : state.couponMessage,
            removeCoupon: () {
              BlocProvider.of<RegisterAndSellBloc>(navigatorKey.currentContext!)
                  .add(TriggerCouponRemovalT());
            },
            athleteSum: state.athleteSum,
            productSum: state.productSum,
            isActive: state.isApplyButtonActive,
            checkApplyButton: () {
              BlocProvider.of<RegisterAndSellBloc>(context)
                  .add(TriggerCheckIfApplyActiveT());
            },
            isFix: state.isFix,
            applyCoupon: () {
              BlocProvider.of<RegisterAndSellBloc>(context)
                  .add(TriggerCouponApplicationT(
              ));
            },
            couponController: state.couponEditingController,
            couponNode: state.couponNode,
            isCodePresent: state.couponCode.isNotEmpty,
            removeAllItems: () {
              BlocProvider.of<RegisterAndSellBloc>(context).add(TriggerRemoveItemsT());
            },
            add: (i) {
              BlocProvider.of<RegisterAndSellBloc>(context).add(
                  TriggerChangeProductCartQuantity(
                      product: state.selectedProducts[i], isMinus: false));
            },
            minus: (i) {
              BlocProvider.of<RegisterAndSellBloc>(context).add(
                  TriggerChangeProductCartQuantity(
                      product: state.selectedProducts[i], isMinus: true));
            },
            totalPrice: state.couponCode.isNotEmpty
                ? state.totalWithTransactionWithCouponFee
                : state.totalWithTransactionWithoutCouponFee,
            totalSum: state.productSum + state.athleteSum,
            typeOfPurchase: TypeOfPurchase.staff,
            eventTitle: AppStrings.global_empty_string,
            registrationsClient: [],
            registrationsStaff: state.registrations,
            selectedProducts: state.selectedProducts,
          );
        },
      ));
}