import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/presentation/pos_settings/bloc/pos_settings_bloc.dart';

import '../../../data/models/response_models/event_details_response_model.dart';
import '../../../imports/common.dart';
import '../../../presentation/base/bloc/base_bloc.dart';
import '../../../presentation/purchase/bloc/purchase_bloc.dart';
import '../../../presentation/purchase/bloc/purchase_handlers.dart';
import '../../../presentation/register_and_sell/bloc/register_and_sell_bloc.dart';
import '../../../root_app.dart';
import '../tab_views/custom_summary_tab_view.dart';

Widget bottomSheetCheckout({
  String eventTitle = AppStrings.global_empty_string,
  required num totalSum,
  required void Function() removeAllItems,
  required TypeOfPurchase typeOfPurchase,
  List<StaffCheckoutRegistrations> registrationsStaff = const [],
  List<SummaryCardTypeForRegistration> registrationsClient = const [],
  List<Products> selectedProducts = const [],
  required num totalPrice,
  required num athleteSum,
  required num productSum,
  required void Function(int i) minus,
  required void Function(int i) add,
  required FocusNode couponNode,
  required TextEditingController couponController,
  required bool isActive,
  required void Function() applyCoupon,
  required void Function() checkout,
  required void Function() removeCoupon,
  required void Function() checkApplyButton,
  required bool isCodePresent,
  required String? error,
  required bool isFix,
  required bool isLoading,
  required num apiCouponAmount,
  required void Function() gotoReg,
  required void Function() goToProd,
}) {
  List<SummaryCardTypeForRegistration> registrationsGuests = registrationsClient
      .where((element) =>
          element.type == AppStrings.purchase_registrationAthlete_guest_type)
      .toList();
  List<SummaryCardTypeForRegistration> registrationsPass = registrationsClient
      .where((element) =>
          element.type != AppStrings.purchase_registrationAthlete_guest_type)
      .toList();

  num seasonPassPrice = 0;
  for (SummaryCardTypeForRegistration s in registrationsPass) {
    seasonPassPrice = seasonPassPrice + (s.price * s.quantity);
  }
  num guestPrice = 0;
  for (SummaryCardTypeForRegistration s in registrationsGuests) {
    guestPrice =guestPrice + (s.price * s.quantity);
  }
  num staffPrice = 0;
  for (StaffCheckoutRegistrations s in registrationsStaff) {
    staffPrice = staffPrice + (s.absolutePrice * s.quantity);
  }
  num productPrice = 0;
  for(Products s in selectedProducts) {
    productPrice = productPrice + ((s.price ?? 0) * (s.quantity ?? 0));
  }
  num subTotal = seasonPassPrice + guestPrice + staffPrice + productPrice;
  final double maxHeight = Dimensions.getScreenHeight() * 0.8;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    constraints: BoxConstraints(
      maxHeight: maxHeight,
    ),
    decoration: BoxDecoration(
      color: AppColors.colorTertiary,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...buildHeader(eventTitle, selectedProducts,
            registrationsClient, registrationsStaff, removeAllItems),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.colorTertiary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: [
                            ...buildRegsSection(
                                gotoReg,
                                typeOfPurchase,
                                registrationsStaff,
                                totalPrice,
                                minus,
                                add,
                                registrationsClient,
                                registrationsGuests,
                                registrationsPass),
                            ...buildProdSection(goToProd, selectedProducts,
                                totalPrice, minus, add),
                            ...buildTotalSum(subTotal),
                            ...buildCouponSection(
                                isCodePresent,
                                couponController,
                                couponNode,
                                checkApplyButton,
                                isActive,
                                selectedProducts,
                                registrationsClient,
                                registrationsStaff,
                                applyCoupon,
                                removeCoupon,
                                error,
                                isFix,
                                apiCouponAmount,
                                totalSum),
                            buildTransaction(
                              seasonPassPrice: seasonPassPrice,
                              isCodePresent: isCodePresent,
                              totalSum: totalSum,
                              apiCouponAmount: apiCouponAmount,
                              couponDiscount: isFix
                                  ? '-${apiCouponAmount}'
                                  : '-${apiCouponAmount}%',
                              couponAmount: isFix
                                  ? '-${StringManipulation.addADollarSign(price: apiCouponAmount)}'
                                  : '-${StringManipulation.addADollarSign(price: totalSum * (apiCouponAmount / 100))}',
                              registrationsPass: registrationsPass,
                            ),
                            buildTotal(totalPrice),
                            ...buildPaymentSection(
                                selectedProducts,
                                registrationsClient,
                                registrationsStaff,
                                typeOfPurchase),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        // LayoutBuilder(builder: (context, constraints) {
        //   //final double maxHeight = Dimensions.getScreenHeight() * 0.8;
        //
        //   return Container(
        //     // constraints: BoxConstraints(
        //     //   maxHeight: maxHeight,
        //     // ),
        //     child:
        //   );
        // }),
        checkOutSection(totalPrice, isLoading, checkout, registrationsClient,
            registrationsStaff, selectedProducts),
        SizedBox(height: 25.h),
      ],
    ),
  );
}

SizedBox buildTotal(num totalPrice) {
  return SizedBox(
      width: Dimensions.getScreenWidth(),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColors.colorPrimary,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.colorPrimaryNeutral,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.largeTitle(),
              ),
              const Spacer(),
              Text(
                StringManipulation.addADollarSign(price: totalPrice),
                style: AppTextStyles.largeTitle(
                    color: AppColors.colorPrimaryAccent),
              )
// Center(
//   child: RichText(
//       text: TextSpan(
//         text: 'Total   ',
//         style: AppTextStyles.largeTitle(),
//         children: [
//           TextSpan(
//             text: StringManipulation.addADollarSign(
//                 price: totalPrice),
//             style: AppTextStyles.largeTitle(
//                 color: AppColors.colorPrimaryAccent),
//           ),
//         ],
//       )),
// ),
            ],
          )));
}

List<Widget> buildPaymentSection(
    List<Products> selectedProducts,
    List<SummaryCardTypeForRegistration> registrationsClient,
    List<StaffCheckoutRegistrations> registrationsStaff,
    TypeOfPurchase typeOfPurchase) {
  return [
    SizedBox(height: 10.h),
    if (selectedProducts.isNotEmpty ||
        registrationsClient.isNotEmpty ||
        registrationsStaff.isNotEmpty) ...[
      Row(
        children: [
          Text(
            'Select Payment Method',
            style: AppTextStyles.smallTitle(),
          ),
          const Spacer(),
          if (typeOfPurchase != TypeOfPurchase.staff)
            GestureDetector(
              onTap: () {
                Navigator.of(navigatorKey.currentContext!)
                    .pushNamed(AppRouteNames.routeCardForm);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.colorSecondaryAccent,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                padding: EdgeInsets.all(2.w),
                child: SvgPicture.asset(
                  AppAssets.icAdd,
                  height: 15.h,
                  width: 15.w,
                ),
              ),
            ),
        ],
      ),
      SizedBox(height: 15.h),
      if (typeOfPurchase != TypeOfPurchase.staff)
        SizedBox(
            width: Dimensions.getScreenWidth(),
            child: buildCustomCardCarousel(
                isSquare: false,
                delete: (cardIndex) {
                  buildBottomSheetWithBodyText(
                    context: navigatorKey.currentContext!,
                    subtitle: navigatorKey.currentContext!
                                .read<PurchaseBloc>()
                                .state
                                .selectedCardIndex !=
                            -1
                        ? AppStrings
                            .payment_addCard_deleteCard_selectedCard_bottomSheet_subtitle
                        : AppStrings
                            .payment_addCard_deleteCard_empty_bottomSheet_subtitle,
                    onLeftButtonPressed: () {
                      Navigator.pop(navigatorKey.currentContext!);
                    },
                    onRightButtonPressed: () {
                      Navigator.pop(navigatorKey.currentContext!);
                      BlocProvider.of<PurchaseBloc>(
                              navigatorKey.currentContext!)
                          .add(TriggerRemoveCard(index: cardIndex));
                    },
                    isSingeButtonPresent: navigatorKey.currentContext!
                            .read<PurchaseBloc>()
                            .state
                            .selectedCardIndex ==
                        -1,
                    singleButtonFunction: () {
                      Navigator.pop(navigatorKey.currentContext!);
                    },
                    title:
                        AppStrings.payment_addCard_deleteCard_bottomSheet_title,
                    highLightedAthleteName: AppStrings.global_empty_string,
                    rightButtonText: AppStrings.btn_yes,
                    leftButtonText: AppStrings.btn_no,
                    isSingleButtonColorFilled: true,
                    singleButtonText: AppStrings.btn_ok,
                  );
                },
                cardList: navigatorKey.currentContext!
                    .read<PurchaseBloc>()
                    .state
                    .cardList,
                cardPageController: navigatorKey.currentContext!
                    .read<PurchaseBloc>()
                    .state
                    .cardPageController,
                currentCardIndex: navigatorKey.currentContext!
                    .read<PurchaseBloc>()
                    .state
                    .currentCardIndex,
                selectedCardIndex: navigatorKey.currentContext!
                    .read<PurchaseBloc>()
                    .state
                    .selectedCardIndex,
                selectCard: (cardIndex) {
                  BlocProvider.of<PurchaseBloc>(navigatorKey.currentContext!)
                      .add(TriggerSelectCard(index: cardIndex));
                })),
      if (typeOfPurchase == TypeOfPurchase.staff)
        SizedBox(
            width: Dimensions.getScreenWidth(),
            child: Container(
              margin: EdgeInsets.only(left: 10.w, right: 10.w),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 60.h,
                            child: PageView.builder(
                              padEnds: true,
                              controller: PageController(),
                              itemCount: 1,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {},
                                    child: Container(
                                      width: Dimensions.getScreenWidth(),
                                      decoration: BoxDecoration(
                                        color: AppColors.colorPrimary,
                                        border: Border.all(
                                          color: AppColors.colorPrimaryAccent,
                                          width: 1.w,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 3.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Image.asset(
                                              //   cardList[index].brand!.toLowerCase() == "visa"
                                              //       ? AppAssets.imgVisa
                                              //       : cardList[index].brand!.toLowerCase() == "mastercard"
                                              //       ? AppAssets.imgMastercard
                                              //       : AppAssets.imgAmex,
                                              //   fit: BoxFit.contain,
                                              // ),

                                              Container(
                                                height: 20.h,
                                                width: 20.w,
                                                decoration: BoxDecoration(
                                                  color: AppColors.colorSuccess,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          300.r),
                                                ),
                                              ),
                                              SizedBox(width: 15.w),
                                              Text(
                                                "S700 Device ${navigatorKey.currentContext!.read<PosSettingsBloc>().state.selectedReader!.label}",
                                                textAlign: TextAlign.start,
                                                textHeightBehavior:
                                                    const TextHeightBehavior(
                                                        applyHeightToFirstAscent:
                                                            false),
                                                style: AppTextStyles.smallTitle(
                                                    isOutFit: false),
                                              ),
                                              //  SizedBox(width: 10.w),
                                              // Text(
                                              //   "* * * *",
                                              //   style: AppTextStyles.smallTitle(isOutFit: false),                      ),
                                              // SizedBox(width: 10.w),
                                              // Text(
                                              //   "* * * *",
                                              //   style: AppTextStyles.smallTitle(isOutFit: false),                      ),
                                              // SizedBox(width: 10.w),
                                              // Text(
                                              //   cardList[index].last4!,
                                              //   textAlign: TextAlign.start,
                                              //   style: AppTextStyles.smallTitle(isOutFit: false),                      ),
                                            ],
                                          ),
                                          const Spacer(),
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     //delete(index);
                                          //   },
                                          //   child: SvgPicture.asset(
                                          //     AppAssets.icBin,
                                          //     fit: BoxFit.contain,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    )
                                    // Stack(
                                    //   fit: StackFit.expand,
                                    //   children: [
                                    //     SvgPicture.asset(
                                    //       selectedCardIndex == index
                                    //           ? AppAssets.icCardSelected
                                    //           : AppAssets.icCardUnSelected,
                                    //       fit: BoxFit.contain,
                                    //     ),
                                    //     Positioned(
                                    //         top: isTablet? 50.h:20.h,
                                    //         right: 10.w,
                                    //         child: IconButton(
                                    //           onPressed: () {
                                    //             delete(index);
                                    //           },
                                    //           icon: Icon(
                                    //             color: AppColors.colorPrimaryAccent,
                                    //             Icons.highlight_remove,
                                    //             size: 40,
                                    //           ),
                                    //         )),
                                    //     Positioned(
                                    //         top: isTablet ? 80.h: 50.h,
                                    //         left: 0,
                                    //         right: 0,
                                    //         child: Container(
                                    //           height: isTablet? 160.h: 120.h,
                                    //           padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    //           child: Column(
                                    //             crossAxisAlignment: CrossAxisAlignment.center,
                                    //             children: [
                                    //               Container(
                                    //                 margin: EdgeInsets.only(top: 10.h),
                                    //                 alignment: Alignment.topLeft,
                                    //                 child: Text(
                                    //                   cardList[index].brand!,
                                    //                   style: AppTextStyles.smallTitle(isOutFit: true),
                                    //                 ),
                                    //               ),
                                    //               Align(
                                    //                 alignment: Alignment.topLeft,
                                    //                 child: SizedBox(
                                    //                   width: Dimensions.getScreenWidth() * 0.7,
                                    //                   child: Row(
                                    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //                     children: [
                                    //                       Text(
                                    //                         "• • • •",
                                    //                         style: AppTextStyles.smallTitle(),
                                    //                       ),
                                    //                       const SizedBox(width: 28.0),
                                    //                       Text(
                                    //                         "• • • •",
                                    //                         style:
                                    //                             AppTextStyles.smallTitle(isOutFit: true),
                                    //                       ),
                                    //                       const SizedBox(width: 28.0),
                                    //                       Text(
                                    //                         "• • • •",
                                    //                         style:
                                    //                             AppTextStyles.smallTitle(isOutFit: true),
                                    //                       ),
                                    //                       const SizedBox(width: 28.0),
                                    //                       Text(
                                    //                         cardList[index].last4!,
                                    //                         style:
                                    //                             AppTextStyles.smallTitle(isOutFit: true),
                                    //                       ),
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //               const Spacer(),
                                    //               SizedBox(
                                    //                 width: Dimensions.getScreenWidth() * 0.9,
                                    //                 child: Row(
                                    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //                   children: [
                                    //                     Column(
                                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                                    //                       children: [
                                    //                         Text(
                                    //                           'Card Holder Name',
                                    //                           style: AppTextStyles.normalNeutral(),
                                    //                         ),
                                    //                         Text(
                                    //                           cardList[index].name!,
                                    //                           style:
                                    //                               AppTextStyles.subtitle(isOutFit: true),
                                    //                         )
                                    //                       ],
                                    //                     ),
                                    //                     Column(
                                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                                    //                       children: [
                                    //                         Text(
                                    //                           'Expire',
                                    //                           style: AppTextStyles.normalNeutral(),
                                    //                         ),
                                    //                         Text(
                                    //                           cardList[index].expMonthYear!,
                                    //                           style:
                                    //                               AppTextStyles.subtitle(isOutFit: true),
                                    //                         )
                                    //                       ],
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               )
                                    //             ],
                                    //           ),
                                    //         ))
                                    //   ],
                                    // ),
                                    );
                              },
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      SizedBox(height: 10.h),
    ]
  ];
}

Widget buildTransaction(
    {required List<SummaryCardTypeForRegistration> registrationsPass,
    required bool isCodePresent,
    required num seasonPassPrice,
    required num totalSum,
    required num apiCouponAmount,
    required String couponDiscount,
    required String couponAmount,
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(
        thickness: 1.w,
        color: AppColors.colorPrimaryDivider,
      ),
      if (registrationsPass.isNotEmpty)
        rowOfDistributions(
            noOfSeasonPasses: registrationsPass.length,
            index: 1,
            isCodePresent: isCodePresent,
            totalSum: totalSum,
            seasonPassPrice: seasonPassPrice,
            couponAmount: couponAmount,
            couponDiscount: couponDiscount,
            apiCouponAmount: apiCouponAmount),
      rowOfDistributions(
        couponAmount: couponAmount,
        seasonPassPrice: seasonPassPrice,
        noOfSeasonPasses: registrationsPass.length,
        index: 2,
        isCodePresent: isCodePresent,
        totalSum: totalSum,
        couponDiscount: couponDiscount,
        apiCouponAmount: apiCouponAmount,
      ),
      rowOfDistributions(
        couponAmount: couponAmount,
        seasonPassPrice: seasonPassPrice,
        noOfSeasonPasses: registrationsPass.length,
        index: 3,
        isCodePresent: isCodePresent,
        totalSum: totalSum,
        couponDiscount: couponDiscount,
        apiCouponAmount: apiCouponAmount,
      ),
      SizedBox(
        height: 10.h,
      )
    ],
  );
}

Widget rowOfDistributions(
    {required bool isCodePresent,
    required int index,
    required String couponDiscount,
    required String couponAmount,
    required num seasonPassPrice,
    required int noOfSeasonPasses,
    required num totalSum,
    required num apiCouponAmount}) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 2.h,
    ),
    child: Row(
      children: [
        if(index == 1|| index == 3 || (index==2 && isCodePresent))
          Container(
            // color:Colors.purple,
          width: Dimensions.getScreenWidth() * 0.45,
          child: Text(
            index == 1
                ? 'Season Pass Discount'
                : index == 2 && isCodePresent
                    ? 'Discount (Season 2024 Coupon Code)'
                    : index == 3?'Transaction Fees': AppStrings.global_empty_string,
            maxLines: 5,
            style: AppTextStyles.normalPrimary(fontWeight: FontWeight.w700),
          ),
        ),
        const Spacer(),
        if(index == 1|| index == 3 || (index==2 && isCodePresent))
        Container(
          // color:Colors.red,
          width:40.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                index == 1
                    ? '$noOfSeasonPasses' 'x'
                    : index == 2 && isCodePresent
                        ? couponDiscount: index==3?
                        '$globalTransactionFee%': AppStrings.global_empty_string,
                style: AppTextStyles.normalNeutral(isSquada: true),
              ),
            ],
          ),
        ),
        const Spacer(),
        if( index == 2 && isCodePresent)...[
          Text(
             couponAmount,
            style: AppTextStyles.regularPrimary(isOutFit: false),
          ),
        ],
        if(index == 1|| index==3)...[ Text(
          index == 3
              ? '+${StringManipulation.addADollarSign(
              price: isCodePresent
                  ? (totalSum - apiCouponAmount) *
                  (globalTransactionFee / 100)
                  : globalTransactionFee * totalSum / 100)}'
              :  '-${StringManipulation.addADollarSign(price: seasonPassPrice)}',

          style: AppTextStyles.regularPrimary(isOutFit: false),
        ),]
      ],
    ),
  );
}

List<Widget> buildCouponSection(
    bool isCodePresent,
    TextEditingController couponController,
    FocusNode couponNode,
    void Function() checkApplyButton,
    bool isActive,
    List<Products> selectedProducts,
    List<SummaryCardTypeForRegistration> registrationsClient,
    List<StaffCheckoutRegistrations> registrationsStaff,
    void Function() applyCoupon,
    void Function() removeCoupon,
    String? error,
    bool isFix,
    num apiCouponAmount,
    num totalSum) {
  return [
    if (!isCodePresent)
      Container(
        margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apply Coupon',
              style: AppTextStyles.smallTitle(),
            ),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: Dimensions.getScreenWidth() * 0.65,
// height: 40.h,
                  child: TextFormField(
                    controller: couponController,
                    focusNode: couponNode,
                    style: AppTextStyles.textFormFieldELabelStyle(),
                    onChanged: (value) {
                      checkApplyButton();
// if (value.isNotEmpty) {
//   setState(() {
//     isActive =
//         widget.registrations.isNotEmpty ||
//             widget.products.isNotEmpty;
//   });
// } else {
//   setState(() {
//     isActive = false;
//   });
// }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.colorPrimary,
                      hintText: 'Enter Coupon Code',
                      hintStyle: AppTextStyles.textFormFieldEHintStyle(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      errorStyle: AppTextStyles.textFormFieldErrorStyle(),
                      enabledBorder: AppWidgetStyles.textFormFieldEnabledBorder(
                          isDisabled: false),
                      focusedBorder: AppWidgetStyles.textFormFieldFocusedBorder(
                          isReadOnly: false),
                      errorBorder: AppWidgetStyles.textFormFieldErrorBorder(),
                      focusedErrorBorder:
                          AppWidgetStyles.textFormFieldFocusedErrorBorder(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: GestureDetector(
                    onTap: isActive
                        ? ((selectedProducts.isNotEmpty ||
                                registrationsClient.isNotEmpty ||
                                registrationsStaff.isNotEmpty)
                            ? applyCoupon
                            : () {
                                buildCustomToast(
                                    msg:
                                        'Please add items to cart to enjoy coupon',
                                    isFailure: true);
                              })
                        : () {},
                    child: Container(
                      height: 36.h,
                      margin: EdgeInsets.only(bottom: 3.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.colorSecondaryAccent
                            : AppColors.colorBlueOpaque,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Center(
                        child: Text(
                          'Apply',
                          style: AppTextStyles.buttonTitle(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    if (isCodePresent)
      Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Applied Coupon',
              style: AppTextStyles.smallTitle(),
            ),
            SizedBox(height: 10.h),
            IntrinsicWidth(
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 1.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.colorPrimaryAccent,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        couponController.text,
                        style: AppTextStyles.regularPrimary(
                            color: AppColors.colorPrimaryInverseText),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () {
                          removeCoupon();
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.colorPrimaryInverseText,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    if (error != null)
      Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            error,
            style: AppTextStyles.textFormFieldErrorStyle(),
          )),

  ];
}

List<Widget> buildTotalSum(num subTotal) {
  return [
    Divider(
      thickness: 1.w,
      color: AppColors.colorPrimaryDivider,
    ),
    Container(
      margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
      width: Dimensions.getScreenWidth(),
      child: Row(
        children: [
          Text(
            'Subtotal Purchase',
            style: AppTextStyles.smallTitle(),
          ),
          const Spacer(),
          Text(
            StringManipulation.addADollarSign(price: subTotal),
            style: AppTextStyles.smallTitle(
                isOutFit: false, color: AppColors.colorPrimaryNeutralText),
          ),
        ],
      ),
    ),
    Divider(
      thickness: 1.w,
      color: AppColors.colorPrimaryDivider,
    )
  ];
}

List<Widget> buildProdSection(
    void Function() goToProd,
    List<Products> selectedProducts,
    num totalPrice,
    void Function(int i) minus,
    void Function(int i) add) {
  return [
    Container(
      margin: EdgeInsets.only(top: 5.h, bottom: 15.h),
      width: Dimensions.getScreenWidth(),
      child: Row(
        children: [
          Text(
            'Products',
            style: AppTextStyles.smallTitle(isOutFit: false),
          ),
          const Spacer(),
          GestureDetector(
            onTap: goToProd,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.colorSecondaryAccent,
                borderRadius: BorderRadius.circular(5.r),
              ),
              padding: EdgeInsets.all(2.w),
              child: SvgPicture.asset(
                AppAssets.icEdit,
                height: 15.h,
                width: 15.w,
              ),
            ),
          ),
        ],
      ),
    ),
    if (selectedProducts.any((element) => element.quantity! > 0)) ...[
      for (int i = 0; i < selectedProducts.length; i++)
        if (selectedProducts[i].quantity! > 0)
          buildCartItem(
            isMaxedOut: selectedProducts[i].isMaxGiveawayAdded != null,
            ageGroup: AppStrings.global_empty_string,
            wc: AppStrings.global_empty_string,
            typeOfRegs: TypeOfPurchase.prods,
            variant: selectedProducts[i].selectedVariant,
            giveAwayCounts: selectedProducts[i].giveAwayCounts!,
            isGiveaway: selectedProducts[i].productDetails!.isGiveaway!,
            totalPrice: totalPrice,
            quantity: selectedProducts[i].quantity!,
            minus: () {
              minus(i);
            },
            add: () {
              add(i);
            },
            cartItemTitle: selectedProducts[i].productDetails!.title!,
            divisionName: AppStrings.global_empty_string,
            styleName: AppStrings.global_empty_string,
            absolutePrice: selectedProducts[i].price!,
          ),
    ] else ...[
      SizedBox(height: 6.h),
      Center(
        child: Text(
          'No products added',
          style: AppTextStyles.smallTitle(
              isOutFit: false, color: AppColors.colorPrimaryNeutralText),
        ),
      ),
      SizedBox(height: 6.h),
    ]
  ];
}

List<Widget> buildRegsSection(
    void Function() gotoReg,
    TypeOfPurchase typeOfPurchase,
    List<StaffCheckoutRegistrations> registrationsStaff,
    num totalPrice,
    void Function(int i) minus,
    void Function(int i) add,
    List<SummaryCardTypeForRegistration> registrationsClient,
    List<SummaryCardTypeForRegistration> registrationsGuests,
    List<SummaryCardTypeForRegistration> registrationsPass) {
  return [
    SizedBox(
      width: Dimensions.getScreenWidth(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Registrations',
            style: AppTextStyles.smallTitle(isOutFit: false),
          ),
          const Spacer(),
// if (typeOfPurchase == TypeOfPurchase.client)
          GestureDetector(
            onTap: gotoReg,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.colorSecondaryAccent,
                borderRadius: BorderRadius.circular(5.r),
              ),
              padding: EdgeInsets.all(2.w),
              child: SvgPicture.asset(
                AppAssets.icEdit,
                height: 15.h,
                width: 15.w,
              ),
            ),
          ),
        ],
      ),
    ),
    SizedBox(height: 6.h),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (typeOfPurchase == TypeOfPurchase.staff) ...[
          if (registrationsStaff.isNotEmpty) ...[
            for (int i = 0; i < registrationsStaff.length; i++)
              if (registrationsStaff[i].quantity > 0)
                buildCartItem(
                  isMaxedOut: false,
                  typeOfRegs: typeOfPurchase,
                  giveAwayCounts: 0,
                  isGiveaway: false,
                  totalPrice: totalPrice,
                  ageGroup: registrationsStaff[i].ageGroup,
                  quantity: registrationsStaff[i].quantity,
                  minus: () {
                    minus(i);
                  },
                  add: () {
                    add(i);
                  },
                  cartItemTitle: registrationsStaff[i].athleteName,
                  divisionName:
                      StringManipulation.capitalizeFirstLetterOfEachWord(
                          value: registrationsStaff[i].divisionName),
                  styleName: StringManipulation.capitalizeFirstLetterOfEachWord(
                      value: registrationsStaff[i].styleName),
                  absolutePrice: registrationsStaff[i].absolutePrice,
                  wc: formatFinalizedWeights(registrationsStaff[i].wcNumbers),
                ),
            Divider(
              thickness: 1.w,
              color: AppColors.colorPrimaryDivider,
            ),
          ] else ...[
            SizedBox(height: 6.h),
            Center(
              child: Text(
                'No registrations added',
                style: AppTextStyles.smallTitle(
                    isOutFit: false, color: AppColors.colorPrimaryNeutralText),
              ),
            ),
            SizedBox(height: 6.h),
          ]
        ],
        if (typeOfPurchase == TypeOfPurchase.client) ...[
          if (registrationsClient.isNotEmpty) ...[
            if (registrationsGuests.isNotEmpty) ...[
              Container(
                margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                child: Text(
                  'Guest Registrations',
                  style: AppTextStyles.regularNeutralOrAccented(
                      isOutfit: false,
                      color: AppColors.colorPrimaryNeutralText),
                ),
              ),
              for (int i = 0; i < registrationsGuests.length; i++) ...[
                buildCartItem(
                  isMaxedOut: false,
                  ageGroup: registrationsGuests[i].ageGroup,
                  wc: registrationsGuests[i].wcList,
                  typeOfRegs: typeOfPurchase,
                  giveAwayCounts: 0,
                  isGiveaway: false,
                  totalPrice: totalPrice,
                  quantity: registrationsGuests[i].quantity,
                  minus: () {
                    minus(i);
                  },
                  add: () {
                    add(i);
                  },
                  cartItemTitle: registrationsGuests[i].title,
                  divisionName:
                      StringManipulation.capitalizeFirstLetterOfEachWord(
                          value: registrationsGuests[i].division),
                  styleName: StringManipulation.capitalizeFirstLetterOfEachWord(
                      value: registrationsGuests[i].style),
                  absolutePrice: registrationsGuests[i].price,
                )
              ]
            ],
            if (registrationsPass.isNotEmpty) ...[
              Container(
                margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
                child: Text(
                  'Season Pass Registrations',
                  style: AppTextStyles.regularNeutralOrAccented(
                      isOutfit: false,
                      color: AppColors.colorPrimaryNeutralText),
                ),
              ),
              for (int i = 0; i < registrationsPass.length; i++) ...[
                buildCartItem(
                  isMaxedOut: false,
                  ageGroup: registrationsPass[i].ageGroup,
                  wc: registrationsPass[i].wcList,
                  seasonPassCounter: GestureDetector(
                    onTap: () {
                      showDialogForAthleteSeasonPass(
                          registrationsPass[i].nominator,
                          registrationsPass[i].denominator,
                          registrationsPass[i].tierName,
                          registrationsPass[i].max.toInt());
                    },
                    child: IntrinsicWidth(
                      child: Container(
                          margin: EdgeInsets.only(right: 20.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 2.h),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.colorPrimaryNeutralText,
                                  width: 1),
                              color: AppColors.colorPrimary,
                              borderRadius: BorderRadius.circular(5.r)),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: registrationsPass[i].nominator.toString(),
                                style: AppTextStyles.subtitle(
                                    isOutFit: false,
                                    color: registrationsPass[i].nominator >
                                            registrationsPass[i].denominator
                                        ? AppColors.colorPrimaryAccent
                                        : AppColors.colorPrimaryInverseText),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        ' / ${registrationsPass[i].denominator}',
                                    style:
                                        AppTextStyles.subtitle(isOutFit: false),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                  typeOfRegs: typeOfPurchase,
                  giveAwayCounts: 0,
                  isGiveaway: false,
                  totalPrice: totalPrice,
                  reducedPrice: registrationsPass[i].reducedPrice,
                  quantity: registrationsPass[i].quantity,
                  minus: () {
                    minus(i);
                  },
                  add: () {
                    add(i);
                  },
                  cartItemTitle: registrationsPass[i].title,
                  divisionName:
                      StringManipulation.capitalizeFirstLetterOfEachWord(
                          value: registrationsPass[i].division),
                  styleName: StringManipulation.capitalizeFirstLetterOfEachWord(
                      value: registrationsPass[i].style),
                  absolutePrice: registrationsPass[i].price,
                )
              ]
            ],
            Divider(
              thickness: 1.w,
              color: AppColors.colorPrimaryDivider,
            ),
            SizedBox(height: 8.h),
          ] else ...[
            SizedBox(height: 6.h),
            Center(
              child: Text(
                'No registrations added',
                style: AppTextStyles.smallTitle(
                    isOutFit: false, color: AppColors.colorPrimaryNeutralText),
              ),
            ),
            SizedBox(height: 6.h),
          ]
        ]
      ],
    )
  ];
}

List<Widget> buildHeader(
    String eventTitle,
    List<Products> selectedProducts,
    List<SummaryCardTypeForRegistration> registrationsClient,
    List<StaffCheckoutRegistrations> registrationsStaff,
    void Function() removeAllItems) {
  return [
    SizedBox(height: 15.h),
    Container(
      margin: EdgeInsets.symmetric(horizontal: 100.w),
      child: Divider(
        thickness: 2.w,
        color: AppColors.colorPrimaryInverse,
      ),
    ),
    if (eventTitle.isNotEmpty) ...[
      SizedBox(height: 15.h),
      Padding(
        padding: EdgeInsets.only(bottom: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(eventTitle,
                    style: AppTextStyles.largeTitle(
                        color: AppColors.colorPrimaryNeutralText),
                    maxLines: 1),
              ),
            ),
          ],
        ),
      ),
      Divider(
        thickness: 1.w,
        color: AppColors.colorPrimaryDivider,
      ),
    ],
    Padding(
      padding: EdgeInsets.only(bottom: 10.h, top: 8.h),
      child: Row(
        children: [
          Text(
            'Purchase Summary',
            style: AppTextStyles.largeTitle(),
          ),
          const Spacer(),
          if (selectedProducts.isNotEmpty ||
              registrationsClient.isNotEmpty ||
              registrationsStaff.isNotEmpty)
            GestureDetector(
              onTap: removeAllItems,
              child: Text(
                'Remove all items',
                style: AppTextStyles.smallTitle(isUnderlined: true),
              ),
            ),
        ],
      ),
    )
  ];
}

Padding checkOutSection(
    num totalPrice,
    bool isLoading,
    void Function() checkout,
    List<SummaryCardTypeForRegistration> registrationsClient,
    List<StaffCheckoutRegistrations> registrationsStaff,
    List<Products> selectedProducts) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: SizedBox(
      width: Dimensions.getScreenWidth(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: isLoading ? () {} : checkout,
              child: Container(
//margin: EdgeInsets.only(bottom: 3.h),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isLoading
                      ? AppColors.colorBlueOpaque
                      : (registrationsClient.isNotEmpty ||
                              registrationsStaff.isNotEmpty ||
                              selectedProducts.isNotEmpty
                          ? AppColors.colorSecondaryAccent
                          : AppColors.colorBlueOpaque),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Center(
                  child: Text(
                    'Checkout',
                    style: AppTextStyles.buttonTitle(),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget buildCartItem(
    {required TypeOfPurchase typeOfRegs,
    String? wc,
    required num giveAwayCounts,
    required bool isGiveaway,
    required bool isMaxedOut,
    required num totalPrice,
    required num quantity,
    required void Function() minus,
    required void Function() add,
    required String cartItemTitle,
    required String divisionName,
    required String ageGroup,
    required String styleName,
    required num absolutePrice,
    Widget? seasonPassCounter,
    num? reducedPrice,
    String? variant}) {
  double allWidth = Dimensions.getScreenWidth();
  double firstColumn = Dimensions.getScreenWidth() * 0.38;
  double secondColumn = Dimensions.getScreenWidth() * 0.16;
  double thirdColumn = Dimensions.getScreenWidth() * 0.3;

  double remaing = allWidth - (firstColumn + secondColumn + thirdColumn);
  print(remaing);
  return SizedBox(
    width: allWidth,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(right: 1.5.w),
          width: firstColumn,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      maxLines: 1000,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: variant == null
                            ? '$cartItemTitle  '
                            : '$cartItemTitle ($variant) ',
                        style: AppTextStyles.normalPrimary(),
                        children: <InlineSpan>[
                          if (seasonPassCounter != null)
                            WidgetSpan(
                              child: seasonPassCounter,
                              alignment: PlaceholderAlignment.middle,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              if (typeOfRegs == TypeOfPurchase.staff)
                Container(
                  margin: EdgeInsets.only(bottom: 5.h),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          '($divisionName $ageGroup/$styleName/$wc)',
                          style: AppTextStyles.normalNeutral(),
                        ),
                      ),
                    ],
                  ),
                ),
              if (typeOfRegs == TypeOfPurchase.client)
                Container(
                  margin: EdgeInsets.only(bottom: 5.h),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          '($divisionName $ageGroup/$styleName/$wc)',
                          style: AppTextStyles.normalNeutral(),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 1.5.w),
            width: secondColumn,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    StringManipulation.addADollarSign(price: absolutePrice),
                    style: AppTextStyles.regularPrimary(
                        isOutFit: false,
                        isBold: true,
                        color: AppColors.colorPrimaryNeutralText),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 1.5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: typeOfRegs == TypeOfPurchase.prods ? 10.w : 20.w),
              if (typeOfRegs == TypeOfPurchase.prods && quantity > 0)
                GestureDetector(
                  onTap: minus,
                  child: SvgPicture.asset(
                    colorFilter: typeOfRegs == TypeOfPurchase.prods
                        ? null
                        : const ColorFilter.mode(
                            Colors.transparent, BlendMode.srcIn),
                    AppAssets.icStaffMinus,
                    height: 18.h,
                    width: typeOfRegs == TypeOfPurchase.prods ? 12.w : 5.w,
                  ),
                ),
              SizedBox(
                width: typeOfRegs == TypeOfPurchase.prods ? 20.w : 30.w,
                child: Text(
                  typeOfRegs == TypeOfPurchase.prods
                      ? quantity.toString()
                      : '${quantity}x',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle(),
                ),
              ),
              GestureDetector(
                onTap: ((typeOfRegs == TypeOfPurchase.prods && !isGiveaway) ||
                        (typeOfRegs == TypeOfPurchase.prods &&
                            isGiveaway &&
                            !isMaxedOut))
                    ? add
                    : () {},
                child: SvgPicture.asset(
                  colorFilter:
                      ((typeOfRegs == TypeOfPurchase.prods && !isGiveaway) ||
                              (typeOfRegs == TypeOfPurchase.prods &&
                                  isGiveaway &&
                                  !isMaxedOut))
                          ? null
                          : const ColorFilter.mode(
                              Colors.transparent, BlendMode.srcIn),
                  AppAssets.icStaffPlus,
                  height: 18.h,
                  width: typeOfRegs == TypeOfPurchase.prods ? 12.w : 5.w,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        StringManipulation.addADollarSign(
                            price: quantity * absolutePrice),
                        textAlign: TextAlign.end,
                        style: AppTextStyles.subtitle(
                            isOutFit: false,
                            isLinedThrough: reducedPrice != null),
                      ),
                    ),
                  ],
                ),
                if (reducedPrice != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          StringManipulation.addADollarSign(
                              price: reducedPrice),
                          textAlign: TextAlign.end,
                          style: AppTextStyles.subtitle(isOutFit: false),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
