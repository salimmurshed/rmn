import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/widgets/bottomsheets/bottom_sheet_checkout.dart';
import '../../../imports/common.dart';
import '../../questionnaire/bloc/questionnaire_bloc.dart';
import '../bloc/purchase_bloc.dart';
import '../../event_details/bloc/event_details_bloc.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';
import 'package:rmnevents/presentation/register_and_sell/bloc/register_and_sell_bloc.dart';
import '../../../imports/data.dart';
import '../../../root_app.dart';
import '../../event_details/widgets/build_list_of_divisions.dart';
import '../widgets/updated_product_widget.dart';
import '../widgets/build_registration_limit_view.dart';

class ClientRegistrationView extends StatefulWidget {
  const ClientRegistrationView({super.key, required this.couponModule});

  final CouponModules couponModule;

  @override
  State<ClientRegistrationView> createState() => _ClientRegistrationViewState();
}

class _ClientRegistrationViewState extends State<ClientRegistrationView> {
  late EventData eventData;

  @override
  void initState() {
    if (widget.couponModule == CouponModules.registration) {
      BlocProvider.of<PurchaseBloc>(context).add(const TriggerReFresh());
      BlocProvider.of<EventDetailsBloc>(context).add(
          TriggerFetchEventWiseAthletes(
              isEnteringPurchaseView: widget.couponModule,
              fetchQuestionnaire: true,
              eventId: globalEventResponseData!.event!.underscoreId!));
      eventData = navigatorKey.currentContext!.read<EventDetailsBloc>().state.eventResponseData!.event!;
    } else if (widget.couponModule == CouponModules.employeeRegistration) {
      List<Athlete> selectedAthletes = navigatorKey.currentContext!
          .read<RegisterAndSellBloc>()
          .state
          .selectedAthletes;
      if (selectedAthletes.isEmpty) {
        BlocProvider.of<PurchaseBloc>(context).add(const TriggerReFresh());
        BlocProvider.of<EventDetailsBloc>(context)
            .add(TriggerFetchEmployeeAthletes());
      }
      eventData = context.read<RegisterAndSellBloc>().state.eventData;
    } else {
      BlocProvider.of<PurchaseBloc>(context).add(const TriggerReFresh());
      BlocProvider.of<PurchaseBloc>(context)
          .add(TriggerFetchEventWiseData(couponModules: widget.couponModule));
      eventData = navigatorKey.currentContext!.read<EventDetailsBloc>().state.eventResponseData!.event!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PurchaseBloc, PurchaseWithInitialState>(

      listener: (context, state) {

        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
        }
      },
      child: BlocBuilder<PurchaseBloc, PurchaseWithInitialState>(
        builder: (context, state) {
          return customScaffold(
            hasForm: true,
            customAppBar: CustomAppBar(
              title: eventData.title!,
              isLeadingPresent: true,
            ),
            persistentFooterButtons: [
              if (state.isProcessingPurchase)
                ...[]
              else ...[
                if (!state.isLoading) ...[
                  if (state.couponModule ==
                      CouponModules.employeeRegistration) ...[
                    buildCustomLargeFooterBtn(
                        hasKeyBoardOpened: true,
                        isActive: true,
                        onTap: () {
                          BlocProvider.of<RegisterAndSellBloc>(context)
                              .add(TriggerAddToCart());
                        },
                        btnLabel: context
                                .read<RegisterAndSellBloc>()
                                .state
                                .isAddToCard
                            ? 'Add to Cart'
                            : 'Update Registration',
                        isColorFilledButton: true)
                  ] else ...[
                    buildCustomLargeFooterBtn(
                        onTap: () {
                          openCheckoutMBS(context);
                        },
                        btnLabel:
                            '${AppStrings.btn_checkout} ${(state.selectedProducts.where((e) => e.quantity! > 0).toList()).length + state.registrationForSummary.length} items | ${StringManipulation.addADollarSign(price: state.couponCode.isNotEmpty ? state.totalWithTransactionWithCouponFee : state.totalWithTransactionWithoutCouponFee)}',
                        hasKeyBoardOpened: true,
                        isColorFilledButton: true),
                  ]
                ]
              ]
            ],
            formOrColumnInsideSingleChildScrollView: null,
            anyWidgetWithoutSingleChildScrollView: state.isLoading
                ? CustomLoader(
                    child: buildListLayout(context, state),
                  )
                : buildListLayout(context, state),
          );
        },
      ),
    );
  }

  SizedBox buildListLayout(
      BuildContext context, PurchaseWithInitialState state) {
    return SizedBox(
      height: Dimensions.getScreenHeight(),
      child: Column(
        children: [
          if(state.couponModule == CouponModules.registration)
          buildCustomTabBar(isScrollRequired: false, tabElements: [
            TabElements(
                title: AppStrings.myPurchases_tab_registration_title,
                onTap: () {
                  BlocProvider.of<PurchaseBloc>(context)
                      .add(const TriggerSwitchTabs(index: 0));
                },
                isSelected: state.tabIndex == 0),
            TabElements(
                title: AppStrings.myPurchases_tab_products_title,
                onTap: () {
                  BlocProvider.of<PurchaseBloc>(context)
                      .add(const TriggerSwitchTabs(index: 1));
                },
                isSelected: state.tabIndex == 1),
          ]),

         if(!state.isLoading)...[ SizedBox(
           height: 15.h,
         ),
           if (state.tabIndex == 0) ...[
             BlocBuilder<EventDetailsBloc, EventDetailsWithInitialState>(
               builder: (context, state) {
                 return (!checkIsEventSoldOut(
                     context.read<PurchaseBloc>().state))
                     ? SizedBox(
                   height: 32.h,
                   child: ListView.separated(
                       scrollDirection: Axis.horizontal,
                       itemBuilder: (context, i) {
                         return GestureDetector(
                           onTap: () {
                             BlocProvider.of<EventDetailsBloc>(context)
                                 .add(TriggerPickDivision(
                               divisionType: state.divisionsTypes,
                               divIndex: i,
                             ));
                           },
                           child: Container(
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(5.r),
                               border: Border.all(
                                   width: 1.w,
                                   color: i == state.selectedDivisionIndex
                                       ? AppColors.colorPrimary
                                       : AppColors.colorDisabled
                               ),
                               color: i == state.selectedDivisionIndex
                                   ? AppColors.colorPrimaryInverse
                                   : AppColors.colorPrimary,

                             ),
                             padding: EdgeInsets.symmetric(
                                 horizontal: 13.w, vertical: 2.h),
                             child: IntrinsicWidth(
                               child: Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.center,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   Text(
                                     state.divisionsTypes[i].divisionType!,
                                     style: AppTextStyles.normalPrimary(
                                         fontWeight: FontWeight.w400,
                                         isOutfit: false,
                                         color: i ==
                                             state
                                                 .selectedDivisionIndex
                                             ? AppColors.colorPrimary
                                             : AppColors
                                             .colorPrimaryInverseText),
                                   ),
                                   SizedBox(
                                     width: 10.w,
                                   ),
                                   Container(
                                     height: 20.h,
                                     width: 20.w,
                                     decoration: BoxDecoration(
                                         color: i ==
                                             state
                                                 .selectedDivisionIndex
                                             ? AppColors.colorPrimary
                                             : AppColors
                                             .colorSecondaryAccent,
                                         borderRadius:
                                         BorderRadius.circular(200.r)),
                                     child: Center(
                                       child: Text(
                                         '${state.divisionsTypes[i].ageGroups!.length}',
                                         style: AppTextStyles.componentLabels(
                                             isBold: true,
                                             isOutFit: false,
                                             isNormal: false,
                                             color: AppColors
                                                 .colorPrimaryInverseText),
                                       ),
                                     ),
                                   )
                                 ],
                               ),
                             ),
                           ),
                         );
                       },
                       separatorBuilder: (context, i) {
                         return SizedBox(width: 20.w);
                       },
                       itemCount: state.divisionsTypes.length),
                 )
                     : const Center();
               },
             ),

             if (!checkIsEventSoldOut(state))
               ...[
                 SizedBox(
                   height: 20.h,
                 ),
                 Container(
                   decoration: BoxDecoration(boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.99),
                       spreadRadius: 10,
                       blurRadius: 7,
                       offset: const Offset(0, 8), // changes position of shadow
                     ),
                   ]),
                   width: double.infinity,
                   padding: EdgeInsets.only(
                     left: 2.w,
                     bottom: 5.h,
                   ),
                   child: Text(
                     eventData.hasGradeBrackets!
                         ? AppStrings.purchase_registrationAthlete_grade_title
                         : AppStrings.purchase_registrationAthlete_ageGroup_title,
                     style: AppTextStyles.smallTitle(
                         fontSize: AppFontSizes.titleSmallLinedThrough),
                   ),
                 )],
             SizedBox(
               height: 10.h,
             ),
             if(!context.read<RegisterAndSellBloc>().state.isStaffRegistration)...[
               if (state.registrationLimit != null &&
                   state.paymentModuleTabs ==
                       PaymentModuleTabNames.registrations)
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: buildRegistrationLimitView(
                       totalRegistration: state.totalRegistration,
                       registrationLimit: state.registrationLimit
                   ),
                 ),
               SizedBox(
                 height: 1.h,
               ),
               SizedBox(
                 height: 10.h,
               )
             ],

             if(!checkIsEventSoldOut(state))
               Expanded(
                   child: Column(
                     children: [
                       BlocListener<EventDetailsBloc, EventDetailsWithInitialState>(
                         listener: (context, state) {
                           if (state.message.isNotEmpty) {
                             buildCustomToast(
                                 msg: state.message, isFailure: state.isFailure);
                           }
                         },
                         child: BlocBuilder<EventDetailsBloc,
                             EventDetailsWithInitialState>(
                           builder: (context, state) {
                             return buildDivisionsLayout(context, state);
                           },
                         ),
                       ),
                     ],
                   )),
           ],
           if (state.tabIndex == 1) ...[
             Container(
               decoration: BoxDecoration(boxShadow: [
                 BoxShadow(
                   color: Colors.black.withOpacity(0.99),
                   spreadRadius: 10,
                   blurRadius: 7,
                   offset: const Offset(0, 8), // changes position of shadow
                 ),
               ]),
               width: double.infinity,
               padding: EdgeInsets.only(
                 left: 2.w,
                 bottom: 5.h,
               ),
               child: Text(
                 AppStrings.purchase_tab_productSelect_title,
                 style: AppTextStyles.smallTitle(
                     fontSize: AppFontSizes.titleSmallLinedThrough),
               ),
             ),
             SizedBox(
               height: 10.h,
             ),
             Expanded(
               child: ListView.separated(
                   itemCount: state.products.length,
                   shrinkWrap: true,
                   separatorBuilder: (context, index) {
                     return SizedBox(
                       height: 10.h,
                     );
                   },
                   itemBuilder: (context, index) {
                     print('sssss ${state.products[index].giveAwayCounts} ${state.products[index].productDetails?.isGiveaway}');
                     return state.products[index].dropDownKeyForProduct == null? SizedBox():
                       UpdatedProductWidget(
                       context: context,
                       onChanged: (val) {
                         BlocProvider.of<PurchaseBloc>(context).add(
                             TriggerSelectVariantP(
                                 isFromMBS: false,
                                 selectedValue: val,
                                 index: index,
                                 product: state.products));
                       },
                       products: state.products[index],
                       onMenuStateChange: (isOpen) {
                         BlocProvider.of<PurchaseBloc>(context)
                             .add(TriggerOpenDropDownP(
                           // products: state.products,
                           // index: index,
                             isAthlete: false,
                             isOpened: isOpen ?? false));
                       },
                       add: () {
                         BlocProvider.of<PurchaseBloc>(context).add(
                             TriggerAddSelectedProductToCartP(
                                 product: state.products[index]));
                       },
                       selectedValueProduct:
                       state.products[index].selectedVariant,
                       dropDownKeyForProducts:
                       state.products[index].dropDownKeyForProduct!,
                       isProductDropDownOpened: state.isProductDropDownOpened,
                       reduce: () {
                         BlocProvider.of<PurchaseBloc>(context).add(
                             TriggerChangeProductQuantityP(
                                 isFromMBS: false,
                                 isMinus: true,
                                 index: index,
                                 quantity: state.products[index].quantity!,
                                 product: state.products));
                       },
                       increase: () {
                         BlocProvider.of<PurchaseBloc>(context).add(
                             TriggerChangeProductQuantityP(
                                 isFromMBS: false,
                                 isMinus: false,
                                 index: index,
                                 quantity: state.products[index].quantity!,
                                 product: state.products));
                       },
                     );
                   }),
             )
           ]]
        ],
      ),
    );
  }

  bool checkIsEventSoldOut(PurchaseWithInitialState state) {
    if (!context.read<RegisterAndSellBloc>().state.isStaffRegistration &&
        state.registrationLimit != null &&
        (state.registrationLimit ?? 0) <= state.totalRegistration &&
        state.paymentModuleTabs == PaymentModuleTabNames.registrations) {
      return true;
    }
    return false;
  }

  Widget buildDivisionsLayout(
      BuildContext context, EventDetailsWithInitialState state) {
    return buildListOfDivisions(
      isFromRegs: true,
      parentIndex: state.selectedDivisionIndex,
      openAthlete:
          (Athlete athlete, int parentIndex, int childIndex, int athleteIndex) {
        BlocProvider.of<EventDetailsBloc>(context).add(TriggerResetStyleIndex(
            ageGroup: state.divisionsTypes[parentIndex].ageGroups![childIndex],
            athlete: state.divisionsTypes[parentIndex].ageGroups![childIndex]
                .expansionPanelAthlete![athleteIndex]));

        buildCustomShowModalBottomSheetParent(
            ctx: context,
            isNavigationRequired: false,
            child: BlocBuilder<EventDetailsBloc, EventDetailsWithInitialState>(
              builder: (context, state) {
                return buildBottomSheetWithBodyCheckboxList(
                    disclaimer: state
                            .divisionsTypes[parentIndex]
                            .ageGroups![childIndex]
                            .styles?[state.styleIndex]
                            .disclaimer ??
                        '',
                    isCheckListForWeightClass: true,
                    styles: state
                        .divisionsTypes[parentIndex]
                        .ageGroups![childIndex]
                        .expansionPanelAthlete![athleteIndex]
                        .athleteStyles!,
                    context: context,
                    athleteImageUrl:
                        athlete.profileImage ?? AppStrings.global_empty_string,
                    athleteAge: athlete.age.toString(),
                    athleteWeight: athlete.weightClass.toString(),
                    athleteNameAsTheTitle: StringManipulation.combineFirstNameWithLastName(
                        firstName: athlete.firstName!,
                        lastName: athlete.lastName!),
                    listOfStyleTitles: state
                        .divisionsTypes[parentIndex]
                        .ageGroups![childIndex]
                        .expansionPanelAthlete![athleteIndex]
                        .athleteStyles!
                        .map((e) => e.style!)
                        .toList(),
                    listOfAllOptions: state
                            .divisionsTypes[parentIndex]
                            .ageGroups![childIndex]
                            .expansionPanelAthlete![athleteIndex]
                            .athleteStyles?[state.styleIndex]
                            .division
                            ?.availableWeightsPerStyle ??
                        [],
                    listOfAllSelectedOption: state
                        .divisionsTypes[parentIndex]
                        .ageGroups![childIndex]
                        .expansionPanelAthlete![athleteIndex]
                        .athleteStyles![state.styleIndex]
                        .temporarilySelectedWeights!,
                    listOfAllRegisteredOptions:
                        state.divisionsTypes[parentIndex].ageGroups![childIndex].expansionPanelAthlete![athleteIndex].athleteStyles![state.styleIndex].registeredWeights ?? [],
                    weightClass: state.divisionsTypes[parentIndex].ageGroups![childIndex].expansionPanelAthlete![athleteIndex].athleteStyles?[state.styleIndex].division?.weightClasses ?? [],
                    selectedStyleIndex: state.styleIndex,
                    selectStyle: (styleIndex) {
                      BlocProvider.of<EventDetailsBloc>(context)
                          .add(TriggerSelectStyleIndex(
                        index: styleIndex,
                      ));
                    },
                    isUpdateWCInactive: false,
                    isFromPurchaseHistory: false,
                    onTapToSelectTile: (indexForWeight) {
                      BlocProvider.of<EventDetailsBloc>(context)
                          .add(TriggerWCSelectionTemporarily(
                        divisionType: state.divisionsTypes[parentIndex],
                        athleteSelectionTabs:
                            AthleteSelectionTabs.expansionPanel,
                        ageGroup: state
                            .divisionsTypes[parentIndex].ageGroups![childIndex],
                        weightIndex: indexForWeight,
                        athlete: state
                            .divisionsTypes[parentIndex]
                            .ageGroups![childIndex]
                            .expansionPanelAthlete![athleteIndex],
                      ));
                    },
                    checkBoxForWeightClassSelection: (value) {},
                    onTapForUpdate: () {
                      Navigator.pop(context);
                    },
                    isLoading: false);
              },
            ));
      },
      divisionsTypes: state.divisionsTypes,
      openParent: (bool isExpanded, int index) {
        BlocProvider.of<EventDetailsBloc>(context).add(
            TriggerExpandTileDivisionTab(
                sublistIndex: -1,
                index: index,
                divisionsTypes: state.divisionsTypes,
                isExpanded: isExpanded));
      },
      openChild: (bool isExpanded, int parentIndex, int childIndex) {
        BlocProvider.of<EventDetailsBloc>(context).add(
            TriggerExpandTileDivisionTab(
                sublistIndex: childIndex,
                index: parentIndex,
                divisionsTypes: state.divisionsTypes,
                isExpanded: isExpanded));
      },
    );
  }
}

openCheckoutMBS(BuildContext context) {
  buildCustomShowModalBottomSheetParent(
      ctx: context,
      isNavigationRequired: false,
      child: BlocBuilder<PurchaseBloc, PurchaseWithInitialState>(
        builder: (context, state) {
          return bottomSheetCheckout(
            goToProd: (){
              BlocProvider.of<PurchaseBloc>(context).add(const TriggerSwitchTabs(index: 1, isEdit: true));
              Navigator.pop(context);
            },
            gotoReg: (){
              BlocProvider.of<PurchaseBloc>(context).add(const TriggerSwitchTabs(index: 0, isEdit: true));
              Navigator.pop(context);
            },
            isLoading: state.isLoading,
            checkout: () {
              if (state.registrationForSummary.isNotEmpty) {
                if (context
                    .read<QuestionnaireBloc>()
                    .state
                    .canProceedToRegister) {
                  BlocProvider.of<PurchaseBloc>(context)
                      .add(TriggerCheckForMandatory());
                } else {
                  Navigator.pushNamed(
                      context, AppRouteNames.routeQuestionnaire);
                }
              } else {
                BlocProvider.of<PurchaseBloc>(context)
                    .add(TriggerCheckForMandatory());
              }
            },
            apiCouponAmount: state.apiCouponAmount,
            error: state.couponMessage.isEmpty
                ? AppStrings.global_empty_string
                : state.couponMessage,
            removeCoupon: () {
              BlocProvider.of<PurchaseBloc>(navigatorKey.currentContext!)
                  .add(TriggerCouponRemoval());
            },
            athleteSum: state.athleteSum,
            productSum: state.productSum,
            isActive: state.isApplyButtonActive,
            checkApplyButton: () {
              BlocProvider.of<PurchaseBloc>(context)
                  .add(TriggerCheckIfApplyActive());
            },
            isFix: state.isFix,
            applyCoupon: () {
              BlocProvider.of<PurchaseBloc>(context)
                  .add(TriggerCouponApplication(
                module: state.couponModule == CouponModules.registration
                    ? 'registrations'
                    : state.couponModule == CouponModules.tickets
                        ? 'tickets'
                        : 'season-pass',
              ));
            },
            couponController: state.couponEditingController,
            couponNode: state.couponNode,
            isCodePresent: state.couponCode.isNotEmpty,
            removeAllItems: () {
              BlocProvider.of<PurchaseBloc>(context).add(TriggerRemoveItems());
            },
            add: (i) {
              BlocProvider.of<PurchaseBloc>(context).add(
                  TriggerChangeProductCartQuantityP(
                      product: state.selectedProducts[i], isMinus: false));
            },
            minus: (i) {
              BlocProvider.of<PurchaseBloc>(context).add(
                  TriggerChangeProductCartQuantityP(
                      product: state.selectedProducts[i], isMinus: true));
            },
            totalPrice: state.couponCode.isNotEmpty
                ? state.totalWithTransactionWithCouponFee
                : state.totalWithTransactionWithoutCouponFee,
            totalSum: state.productSum + state.athleteSum,
            typeOfPurchase: TypeOfPurchase.client,
            eventTitle: AppStrings.global_empty_string,
            registrationsClient: state.registrationForSummary,
            registrationsStaff: [],
            selectedProducts: state.selectedProducts,
          );
        },
      ));
}
