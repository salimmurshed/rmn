import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';
import 'package:rmnevents/presentation/register_and_sell/bloc/register_and_sell_bloc.dart';
import '../../../common/widgets/cards/build_athlete_visible_athlete_item.dart';
import '../../../common/widgets/tabs/build_custom_underlined_tab_bar.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../root_app.dart';
import '../../buy_season_passes/bloc/buy_season_passes_bloc.dart';
import '../../event_details/bloc/event_details_bloc.dart';
import '../../event_details/widgets/build_list_of_divisions.dart';
import '../../questionnaire/bloc/questionnaire_bloc.dart';
import '../bloc/purchase_bloc.dart';
import '../widgets/build_payment_tab_view.dart';
import '../widgets/build_products_tab_view.dart';
import '../widgets/build_registration_limit_view.dart';
import '../widgets/build_registration_tab_view.dart';
import '../widgets/build_summary_tab_view.dart';

class PurchaseView extends StatefulWidget {
  final CouponModules couponModule;

  const PurchaseView({
    super.key,
    required this.couponModule,
  });

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  @override
  void initState() {
    if (widget.couponModule == CouponModules.registration) {
      BlocProvider.of<PurchaseBloc>(context).add(const TriggerReFresh());
      BlocProvider.of<EventDetailsBloc>(context).add(TriggerFetchEventWiseAthletes(
          isEnteringPurchaseView: widget.couponModule,
          fetchQuestionnaire: true,
          eventId: globalEventResponseData!.event!.underscoreId!));
      // BlocProvider.of<EventDetailsBloc>(context).add(TriggerFetchEventDetails(
      //     eventId: globalEventResponseData!.event!.underscoreId!,
      //     isEnteringPurchaseView: widget.couponModule,
      //     canFetchQuestionnaire: true));
    }
    else if (widget.couponModule == CouponModules.employeeRegistration) {
      List<Athlete> selectedAthletes = navigatorKey.currentContext!
          .read<RegisterAndSellBloc>()
          .state
          .selectedAthletes;
      if (selectedAthletes.isEmpty) {
        BlocProvider.of<PurchaseBloc>(context).add(const TriggerReFresh());
        BlocProvider.of<EventDetailsBloc>(context).add(TriggerFetchEmployeeAthletes());
      }


    }
    else {
      BlocProvider.of<PurchaseBloc>(context)
          .add(TriggerFetchEventWiseData(couponModules: widget.couponModule));
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

          return state.couponModule == CouponModules.seasonPasses
              ? customScaffold(
                  hasForm: true,
                  isPaddingOn: false,
                  persistentFooterButtons: [
                    if (state.paymentModuleTabs ==
                        PaymentModuleTabNames.summary)
                      buildCustomLargeFooterBtn(
                          hasKeyBoardOpened: true,
                          isActive: state.isActivePurchaseButton,
                          onTap: state.isActivePurchaseButton
                              ? () {
                                  BlocProvider.of<PurchaseBloc>(context)
                                      .add(TriggerPurchaseEvent(
                                    couponModule: state.couponModule,
                                  ));
                                }
                              : () {},
                          btnLabel:
                              state.couponModule == CouponModules.registration
                                  ? 'Register & Purchase'
                                  : 'Purchase',
                          isColorFilledButton: true),
                    if (state.paymentModuleTabs !=
                        PaymentModuleTabNames.summary)
                      buildTwinButtons(
                          onLeftTap: () {
                            BlocProvider.of<PurchaseBloc>(context)
                                .add(TriggerMovingBackward(
                              athletesForSeasonPass: const [],
                              // state.athleteForSeasonPass,
                              couponModule: state.couponModule,
                            ));
                          },
                          onRightTap: state.isContinueButtonActive
                              ? () {
                                  BlocProvider.of<PurchaseBloc>(context).add(
                                      TriggerMovingForward(
                                          athletesForSeasonPass:
                                              state.athleteWithSeasonPasses,
                                          couponModule: state.couponModule));
                                }
                              : () {},
                          leftBtnLabel: AppStrings.btn_back,
                          rightBtnLabel: AppStrings.btn_continue,
                          isActive: state.isContinueButtonActive)
                  ],
                  customAppBar: CustomAppBar(
                      navigatorValue: '',
                      //state.athleteForSeasonPass,
                      title: globalCurrentSeason.title!,
                      isLeadingPresent: true),
                  formOrColumnInsideSingleChildScrollView: null,
                  anyWidgetWithoutSingleChildScrollView: state.isLoading
                      ? CustomLoader(child: buildPurchaseLayout(state, context))
                      : buildPurchaseLayout(state, context),
                )
              : state.couponModule == CouponModules.employeeRegistration
                  ? customScaffold(
                      hasForm: true,
                      isPaddingOn: false,
                      persistentFooterButtons: [
                        buildCustomLargeFooterBtn(
                            hasKeyBoardOpened: true,
                            isActive: true,
                            onTap: () {
                              BlocProvider.of<RegisterAndSellBloc>(context)
                                  .add(TriggerAddToCart());
                            },
                            btnLabel: context.read<RegisterAndSellBloc>().state.isAddToCard? 'Add to Cart': 'Update Registration',
                            isColorFilledButton: true),
                      ],
                      customAppBar: CustomAppBar(
                          navigatorValue: '',
                          //state.athleteForSeasonPass,
                          title: 'Register Athletes',
                          isLeadingPresent: true),
                      formOrColumnInsideSingleChildScrollView: null,
                      anyWidgetWithoutSingleChildScrollView: state.isLoading
                          ? CustomLoader(
                              child: buildPurchaseLayout(state, context))
                          : buildPurchaseLayout(state, context),
                    )
                  : customScaffoldForImageBehind(
                      persistentFooterButtons: [
                          if (state.paymentModuleTabs ==
                              PaymentModuleTabNames.summary)
                            buildCustomLargeFooterBtn(
                                hasKeyBoardOpened: true,
                                isActive: state.isActivePurchaseButton,
                                onTap: state.isActivePurchaseButton
                                    ? () {
                                        BlocProvider.of<PurchaseBloc>(context)
                                            .add(TriggerPurchaseEvent(
                                          couponModule: state.couponModule,
                                        ));
                                      }
                                    : () {},
                                btnLabel: state.couponModule ==
                                        CouponModules.registration
                                    ? 'Register & Purchase'
                                    : 'Purchase',
                                isColorFilledButton: true),
                          if (!checkIsEventSoldOut(state))
                            if (state.paymentModuleTabs ==
                                    PaymentModuleTabNames.registrations &&
                                state.isEditRegs &&
                                !state.isLoading)
                              buildCustomLargeFooterBtn(
                                  hasKeyBoardOpened: true,
                                  isActive: true,
                                  onTap: state.isContinueButtonActive
                                      ? () {
                                          if (state.isEditRegs &&
                                              state.couponModule ==
                                                  CouponModules.registration) {
                                            BlocProvider.of<EventDetailsBloc>(
                                                    navigatorKey
                                                        .currentContext!)
                                                .add(
                                                    TriggerToCollectRegistrationList(
                                              divisionTypes: navigatorKey
                                                  .currentContext!
                                                  .read<EventDetailsBloc>()
                                                  .state
                                                  .divisionsTypes,
                                            ));
                                          } else {
                                            BlocProvider.of<PurchaseBloc>(
                                                    context)
                                                .add(TriggerMovingForward(
                                                    athletesForSeasonPass: const [],
                                                    couponModule:
                                                        state.couponModule));
                                          }
                                        }
                                      : () {
                                  },
                                  btnLabel: AppStrings.btn_continue,
                                  isColorFilledButton: true),
                          if ((state.paymentModuleTabs !=
                                      PaymentModuleTabNames.summary &&
                                  !(state.paymentModuleTabs ==
                                          PaymentModuleTabNames.registrations &&
                                      state.isEditRegs)) &&
                              !state.isLoading)
                            buildTwinButtons(
                                onLeftTap: () {
                                  if (state.couponModule ==
                                      CouponModules.registration) {
                                    if (state.paymentModuleTabs ==
                                        PaymentModuleTabNames.registrations) {
                                      if (state.readyForRegistrationAthletes
                                              .isNotEmpty &&
                                          state.isEditRegs) {
                                        buildBottomSheetWithBodyText(
                                            context: context,
                                            title: AppStrings
                                                .bottomSheet_leaveRegistration_title,
                                            subtitle: AppStrings
                                                .bottomSheet_leaveRegistration_subtitle,
                                            isSingeButtonPresent: false,
                                            leftButtonText:
                                                AppStrings.btn_leave,
                                            rightButtonText:
                                                AppStrings.btn_stay,
                                            onLeftButtonPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            onRightButtonPressed: () {
                                              Navigator.pop(context);
                                            });
                                      } else {
                                        BlocProvider.of<PurchaseBloc>(context)
                                            .add(TriggerMovingBackward(
                                          athletesForSeasonPass: const [],
                                          couponModule: state.couponModule,
                                        ));
                                        if (context
                                            .read<QuestionnaireBloc>()
                                            .state
                                            .questions
                                            .isNotEmpty) {
                                          BlocProvider.of<QuestionnaireBloc>(
                                                  navigatorKey.currentContext!)
                                              .add(TriggerResetQuestionnaire());
                                        }
                                      }
                                    } else {
                                      BlocProvider.of<PurchaseBloc>(context)
                                          .add(TriggerMovingBackward(
                                        athletesForSeasonPass: const [],
                                        couponModule: state.couponModule,
                                      ));
                                    }
                                  }
                                  if (state.couponModule ==
                                      CouponModules.tickets) {
                                    if (state.paymentModuleTabs ==
                                        PaymentModuleTabNames.products) {
                                      if (state.products.any(
                                          (product) => product.quantity != 0)) {
                                        buildBottomSheetWithBodyText(
                                            context: context,
                                            title: AppStrings
                                                .bottomSheet_leaveRegistration_title,
                                            subtitle: AppStrings
                                                .bottomSheet_leaveRegistration_subtitle,
                                            isSingeButtonPresent: false,
                                            leftButtonText:
                                                AppStrings.btn_leave,
                                            rightButtonText:
                                                AppStrings.btn_stay,
                                            onLeftButtonPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            onRightButtonPressed: () {
                                              Navigator.pop(context);
                                            });
                                      } else {
                                        BlocProvider.of<PurchaseBloc>(context)
                                            .add(TriggerMovingBackward(
                                          athletesForSeasonPass: const [],
                                          couponModule: state.couponModule,
                                        ));
                                      }
                                    } else {
                                      BlocProvider.of<PurchaseBloc>(context)
                                          .add(TriggerMovingBackward(
                                        athletesForSeasonPass: const [],
                                        couponModule: state.couponModule,
                                      ));
                                    }
                                  }
                                },
                                onRightTap: state.isContinueButtonActive
                                    ? () {
                                        if (state.couponModule ==
                                            CouponModules.registration) {
                                          if (state.isEditRegs) {
                                            BlocProvider.of<EventDetailsBloc>(
                                                    navigatorKey
                                                        .currentContext!)
                                                .add(
                                                    TriggerToCollectRegistrationList(
                                              divisionTypes: navigatorKey
                                                  .currentContext!
                                                  .read<EventDetailsBloc>()
                                                  .state
                                                  .divisionsTypes,
                                            ));
                                          }
                                          else {
                                            if (context
                                                .read<QuestionnaireBloc>()
                                                .state
                                                .canProceedToRegister) {
                                              BlocProvider.of<PurchaseBloc>(
                                                      context)
                                                  .add(TriggerMovingForward(
                                                      athletesForSeasonPass: const [],
                                                      couponModule:
                                                          state.couponModule));
                                            } else {
                                              Navigator.pushNamed(
                                                  context,
                                                  AppRouteNames
                                                      .routeQuestionnaire);
                                            }
                                          }
                                        }
                                        else {
                                          BlocProvider.of<PurchaseBloc>(context)
                                              .add(TriggerMovingForward(
                                                  athletesForSeasonPass: const [],
                                                  couponModule:
                                                      state.couponModule));
                                        }
                                      }
                                    : () {
                                  // print('----------');
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (BuildContext context) {
                                  //     return AlertDialog(
                                  //       backgroundColor:AppColors.colorPrimary,
                                  //       title: Text('Get Giveaway', style: AppTextStyles.bottomSheetTitle(),),
                                  //       content: Text('We need a giveaway to proceed further.', style: AppTextStyles.bottomSheetSubtitle()),
                                  //       actions: [
                                  //         TextButton(
                                  //           onPressed: () {
                                  //             Navigator.of(context).pop(); // Close the dialog
                                  //           },
                                  //           child: Text('OK'),
                                  //         ),
                                  //       ],
                                  //     );
                                  //   },
                                  // );
                                },
                                leftBtnLabel: state.couponModule ==
                                            CouponModules.registration &&
                                        state.paymentModuleTabs ==
                                            PaymentModuleTabNames
                                                .registrations &&
                                        !state.isEditRegs
                                    ? 'Edit Registration'
                                    : AppStrings.btn_back,
                                rightBtnLabel: AppStrings.btn_continue,
                                isActive: state.isContinueButtonActive)
                        ],
                      hasForm: true,
                      appBar: null,
                      body: state.isLoading &&
                              state.paymentModuleTabs !=
                                  PaymentModuleTabNames.summary
                          ? Center(
                              child: SizedBox(
                                height: state.registrationLimit == null
                                    ? Dimensions.getScreenHeight() * 0.3
                                    : Dimensions.getScreenHeight() * 0.5,
                                child: CustomLoader(
                                    child: buildPurchaseLayout(state, context)),
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: state.paymentModuleTabs ==
                                              PaymentModuleTabNames
                                                  .registrations &&
                                          state.isEditRegs
                                      ? state.registrationLimit == null
                                          ? Dimensions.getScreenHeight() * 0.3
                                          : checkIsEventSoldOut(state)
                                              ? Dimensions.getScreenHeight() *
                                                  0.39
                                              : Dimensions.getScreenHeight() *
                                                  0.5
                                      : checkIsEventSoldOut(state) ||
                                              state.paymentModuleTabs ==
                                                  PaymentModuleTabNames
                                                      .registrations
                                          ? state.registrationLimit == null ? Dimensions.getScreenHeight() * 0.3 : Dimensions.getScreenHeight() * 0.39
                                          : Dimensions.getScreenHeight() * 0.3,
                                  width: Dimensions.getScreenWidth(),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      state.coverImage.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              child: Container(
                                                color: Colors.amber,
                                                height: 80.h,
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                  imageUrl: state.coverImage,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : const Center(),
                                      buildOpaqueLayer(),
                                      buildLowerTab(state),
                                      Positioned(
                                          top: Dimensions.getScreenHeight() *
                                              0.053,
                                          child:
                                              buildEventTitleAndDataWithBackButton(
                                                  context, state)),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: SizedBox(
                                      height: state.paymentModuleTabs ==
                                              PaymentModuleTabNames
                                                  .registrations
                                          ? state.registrationLimit == null
                                              ? Dimensions.getScreenHeight() *
                                                  0.4
                                              : (state.couponModule ==
                                                          CouponModules
                                                              .registration &&
                                                      !state.isEditRegs)
                                                  ? Dimensions
                                                          .getScreenHeight() *
                                                      0.5
                                                  : Dimensions
                                                          .getScreenHeight() *
                                                      0.38
                                          : state.paymentModuleTabs ==
                                                  PaymentModuleTabNames
                                                      .registrations
                                              ? Dimensions.getScreenHeight() *
                                                  0.4
                                              : Dimensions.getScreenHeight() *
                                                  0.55,
                                      child:
                                          buildPurchaseLayout(state, context)),
                                ),
                              ],
                            ));
        },
      ),
    );
  }

  Widget buildEventTitleAndDataWithBackButton(
      BuildContext context, PurchaseWithInitialState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            debugPrint('Back button pressed');
            buildBottomSheetWithBodyText(
                context: context,
                title: AppStrings.bottomSheet_leaveRegistration_title,
                subtitle: AppStrings.bottomSheet_leaveRegistration_subtitle,
                isSingeButtonPresent: false,
                leftButtonText: AppStrings.btn_leave,
                rightButtonText: AppStrings.btn_stay,
                onLeftButtonPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                onRightButtonPressed: () {
                  Navigator.pop(context);
                });
          },
          child: Container(
            width: 45.w,
            height: 42.h,
            margin: EdgeInsets.only(
              left: Dimensions.appBarToolHorizontalGap,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.appBarToolRadius),
              color: AppColors.colorSecondary,
            ),
            child: Center(
              child: SvgPicture.asset(
                  height: 18.h,
                  AppAssets.icAppbarBackButton,
                  fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(
          width: 18.w,
        ),
        buildTitleAndDate(state),
      ],
    );
  }

  Column buildTitleAndDate(PurchaseWithInitialState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.eventTitle,
          style: AppTextStyles.smallTitle(),
          maxLines: 2,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(state.eventDateTime,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.start,
            style: AppTextStyles.normalNeutral(isBold: true)),
      ],
    );
  }

  Widget buildLowerTab(PurchaseWithInitialState purchaseState) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment(0, Dimensions.getScreenHeight() * 0.0015),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(!context.read<RegisterAndSellBloc>().state.isStaffRegistration)...[
              if (purchaseState.registrationLimit != null &&
                  purchaseState.paymentModuleTabs ==
                      PaymentModuleTabNames.registrations)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildRegistrationLimitView(
                      totalRegistration: purchaseState.totalRegistration,
                      registrationLimit: purchaseState.registrationLimit),
                ),
              SizedBox(
                height: 1.h,
              ),
            ],

            if (!checkIsEventSoldOut(purchaseState))
              buildCustomUnderlinedTabBar(
                  paymentModuleTabs: purchaseState.paymentModuleTabs,
                  tabNames: purchaseState.tabNames,
                  onTapToSelectTab: (paymentModuleTabs) {}),
            if (purchaseState.paymentModuleTabs ==
                    PaymentModuleTabNames.registrations &&
                purchaseState.isEditRegs) ...[
              if (!checkIsEventSoldOut(purchaseState))
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: 10.w,
                  ),
                  child: Text(
                    AppStrings
                        .purchase_registrationAthlete_selectCategory_title,
                    style: AppTextStyles.smallTitle(
                        fontSize: AppFontSizes.titleSmallLinedThrough),
                  ),
                ),
              BlocBuilder<EventDetailsBloc, EventDetailsWithInitialState>(
                builder: (context, state) {
                  return (!checkIsEventSoldOut(purchaseState))
                      ? Container(
                          height: 35.h,
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              top: 8.h, bottom: 8.h, left: 10.w, right: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: AppColors.colorSecondary,
                          ),
                          padding: EdgeInsets.all(3.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (var i = 0;
                                  i < state.divisionsTypes.length;
                                  i++)
                                buildCustomTabBarButton(
                                  isRequestTab: false,
                                  isSmallButtonTitle: false,
                                  count: 0,
                                  isScrollRequired: false,
                                  tabButtonTitle:
                                      state.divisionsTypes[i].divisionType!,
                                  color: i == state.selectedDivisionIndex
                                      ? AppColors.colorPrimaryAccent
                                      : AppColors.colorSecondary,
                                  onTap: () {
                                    BlocProvider.of<EventDetailsBloc>(context)
                                        .add(
                                      TriggerPickDivision(
                                        divisionType: state.divisionsTypes,
                                        divIndex: i,
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        )
                      : const Center();
                },
              ),
              if (!checkIsEventSoldOut(purchaseState))
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
                    left: 10.w,
                    bottom: 5.h,
                  ),
                  child: Text(
                    globalEventResponseData!.event!.hasGradeBrackets!
                        ? AppStrings.purchase_registrationAthlete_grade_title
                        : AppStrings
                            .purchase_registrationAthlete_ageGroup_title,
                    style: AppTextStyles.smallTitle(
                        fontSize: AppFontSizes.titleSmallLinedThrough),
                  ),
                ),
            ] else ...[
              if (!checkIsEventSoldOut(purchaseState))
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      spreadRadius: 10,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ]),
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: 10.w,
                  ),
                  child: Text(
                    purchaseState.paymentModuleTabs ==
                            PaymentModuleTabNames.products
                        ? AppStrings.purchase_tab_productSelect_title
                        : purchaseState.paymentModuleTabs ==
                                PaymentModuleTabNames.athletes
                            ? AppStrings.purchase_tab_athleteSelect_title
                            : purchaseState.paymentModuleTabs ==
                                    PaymentModuleTabNames.payment
                                ? AppStrings.purchase_tab_paymentSelect_title
                                : purchaseState.paymentModuleTabs ==
                                        PaymentModuleTabNames.summary
                                    ? AppStrings.purchase_tab_summary_title
                                    : 'Registration Summary',
                    style: AppTextStyles.smallTitle(
                        fontSize: AppFontSizes.titleSmallLinedThrough),
                  ),
                ),
            ]
          ],
        ));
  }

  Container buildOpaqueLayer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black26,
            Colors.black.withOpacity(0.6),
            Colors.black, // End with dark at the bottom
          ],
        ),
      ),
    );
  }

  Widget buildPurchaseLayout(
      PurchaseWithInitialState state, BuildContext context) {
    return checkIsEventSoldOut(state)
        ? const Center()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (state.couponModule == CouponModules.seasonPasses) ...[
                SizedBox(
                  height: 10.h,
                ),
                buildCustomUnderlinedTabBar(
                    paymentModuleTabs: state.paymentModuleTabs,
                    tabNames: state.tabNames,
                    onTapToSelectTab: (paymentModuleTabs) {})
              ],
              if (state.couponModule == CouponModules.employeeRegistration) ...[

                BlocBuilder<EventDetailsBloc, EventDetailsWithInitialState>(
                  builder: (context, state) {
                    return (!checkIsEventSoldOut(context.read<PurchaseBloc>().state))
                        ? Container(
                      height: 35.h,
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          top: 8.h, bottom: 8.h, left: 10.w, right: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: AppColors.colorSecondary,
                      ),
                      padding: EdgeInsets.all(3.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (var i = 0;
                          i < state.divisionsTypes.length;
                          i++)
                            buildCustomTabBarButton(
                              isRequestTab: false,
                              isSmallButtonTitle: false,
                              count: 0,
                              isScrollRequired: false,
                              tabButtonTitle:
                              state.divisionsTypes[i].divisionType!,
                              color: i == state.selectedDivisionIndex
                                  ? AppColors.colorPrimaryAccent
                                  : AppColors.colorSecondary,
                              onTap: () {
                                BlocProvider.of<EventDetailsBloc>(context)
                                    .add(
                                  TriggerPickDivision(
                                    divisionType: state.divisionsTypes,
                                    divIndex: i,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    )
                        : const Center();
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                if (state.isEditRegs)
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
              ]
              else...[Flexible(
                child: Column(
                  children: [
                    if (state.couponModule != CouponModules.seasonPasses)
                      SizedBox(
                        height: 24.h,
                      ),
                    if (state.couponModule == CouponModules.registration &&
                        state.isEditRegs)
                      BlocListener<EventDetailsBloc,
                          EventDetailsWithInitialState>(
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
                    if (state.couponModule == CouponModules.registration &&
                        state.paymentModuleTabs ==
                            PaymentModuleTabNames.registrations &&
                        !state.isEditRegs)
                      ...buildRegistrationTabView(
                          isEdit: state.isEditRegs,
                          context: context,
                          teams: globalTeams,
                          state: state),
                    // if (state.paymentModuleTabs ==
                    //     PaymentModuleTabNames.products &&
                    //     !state.isLoading)
                    //   ...buildProductsTabView(
                    //     state: state,
                    //   ),
                    if (state.paymentModuleTabs ==
                        PaymentModuleTabNames.athletes) ...[
                      if (state.athleteWithSeasonPasses.isNotEmpty)
                        Expanded(
                            child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                itemBuilder: (context, index) {
                                  return buildVisibleAthleteItem(
                                    removeAthlete: () {
                                      BlocProvider.of<PurchaseBloc>(context)
                                          .add(TriggerRemoveSeasonPassAthlete(
                                        isFromPurchaseView: true,
                                        athleteIndex: index,
                                      ));
                                    },
                                    openBottomSheet: () {
                                      BlocProvider.of<BuySeasonPassesBloc>(
                                          context)
                                          .add(
                                          TriggerRefreshSeasonPassBottomSheet(
                                              index: index));
                                      buildCustomShowModalBottomSheetParent(
                                          isNavigationRequired: false,
                                          ctx: navigatorKey.currentContext!,
                                          child: BlocListener<
                                              BuySeasonPassesBloc,
                                              SeasonPassesWithInitialState>(
                                            listener: (context, state) {},
                                            child: BlocBuilder<PurchaseBloc,
                                                PurchaseWithInitialState>(
                                              builder: (context, state) {
                                                return buildBottomSheetWithBodyCheckboxList(
                                                  disclaimer: '',
                                                  isLoading: false,
                                                  isCheckListForWeightClass:
                                                  false,
                                                  isUpdateWCInactive: false,
                                                  onTapForUpdate: () {
                                                    Navigator.pop(context);
                                                    BlocProvider.of<
                                                        PurchaseBloc>(
                                                        context)
                                                        .add(
                                                      TriggerUpdateAthleteTier(
                                                          athleteIndex: index,
                                                          seasonPassTitle: state
                                                              .currentSeasonPassTitle),
                                                    );
                                                  },
                                                  onTapToSelectTile: (value) {
                                                    BlocProvider.of<
                                                        PurchaseBloc>(
                                                        context)
                                                        .add(
                                                      TriggerSelectSeasonPassTier(
                                                        athleteIndex: index,
                                                        seasonPassTitle: state
                                                            .seasonPasses[value]
                                                            .title!,
                                                      ),
                                                    );
                                                  },
                                                  context: context,
                                                  isFromPurchaseHistory: true,
                                                  listOfAllRegisteredOptions: [],
                                                  listOfAllOptions: state
                                                      .seasonPasses
                                                      .map((e) => e.title!)
                                                      .toList(),
                                                  listOfAllSelectedOption: [
                                                    state
                                                        .athleteWithSeasonPasses[
                                                    index]
                                                        .temporarySeasonPassTitle!
                                                  ],
                                                  listOfStyleTitles: [],
                                                  athleteAge: state
                                                      .athleteWithSeasonPasses[
                                                  index]
                                                      .age
                                                      .toString(),
                                                  athleteWeight: state
                                                      .athleteWithSeasonPasses[
                                                  index]
                                                      .weightClass
                                                      .toString(),
                                                  athleteImageUrl: state
                                                      .athleteWithSeasonPasses[
                                                  index]
                                                      .profileImage!,
                                                  athleteNameAsTheTitle: StringManipulation
                                                      .combineFirstNameWithLastName(
                                                      firstName: state
                                                          .athleteWithSeasonPasses[
                                                      index]
                                                          .firstName!,
                                                      lastName: state
                                                          .athleteWithSeasonPasses[
                                                      index]
                                                          .lastName!),
                                                  checkBoxForWeightClassSelection:
                                                      (value) {},
                                                  selectedStyleIndex: 0,
                                                  selectStyle: (styleIndex) {},
                                                );
                                              },
                                            ),
                                          ));
                                    },
                                    noMembership: state
                                        .athleteWithSeasonPasses[index]
                                        .membership !=
                                        null,
                                    weightClass: state
                                        .athleteWithSeasonPasses[index]
                                        .weightClass
                                        .toString(),
                                    age: state
                                        .athleteWithSeasonPasses[index].age
                                        .toString(),
                                    imageUrl: state
                                        .athleteWithSeasonPasses[index]
                                        .profileImage!,
                                    firstName: state
                                        .athleteWithSeasonPasses[index]
                                        .firstName!,
                                    lastName: state
                                        .athleteWithSeasonPasses[index]
                                        .lastName!,
                                    index: index,
                                    selectedSeasonPassTitle: state
                                        .athleteWithSeasonPasses[index]
                                        .selectedSeasonPassTitle!
                                        .isEmpty
                                        ? AppStrings
                                        .buySeasonPasses_athleteWithoutSeasonPass_bottomSheetButton_title
                                        : state.athleteWithSeasonPasses[index]
                                        .selectedSeasonPassTitle!,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Container(
                                    height: Dimensions.generalGap,
                                  );
                                },
                                itemCount:
                                state.athleteWithSeasonPasses.length)),
                      if (state.athleteWithSeasonPasses.isEmpty)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: Dimensions.getScreenHeight() * 0.3),
                              Text(
                                AppStrings.purchase_athletesTab_emptyList,
                                style: AppTextStyles.smallTitleForEmptyList(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                    ],
                    if (state.paymentModuleTabs ==
                        PaymentModuleTabNames.payment)
                      ...buildPaymentTabView(state: state),
                    if (state.paymentModuleTabs ==
                        PaymentModuleTabNames.summary)
                      ...buildSummaryTabView(
                        module: state.couponModule == CouponModules.registration
                            ? 'registrations'
                            : state.couponModule == CouponModules.tickets
                            ? 'tickets'
                            : 'season-pass',
                        state: state,
                      )
                  ],
                ),
              )]
            ],
          );
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
                        .ageGroups![childIndex].styles?[state.styleIndex].disclaimer ?? '',
                    isCheckListForWeightClass: true,
                    styles: state
                        .divisionsTypes[parentIndex]
                        .ageGroups![childIndex]
                        .expansionPanelAthlete![athleteIndex]
                        .athleteStyles!,
                    context: context,
                    athleteImageUrl: athlete.profileImage ?? AppStrings.global_empty_string,
                    athleteAge: athlete.age.toString(),
                    athleteWeight: athlete.weightClass.toString(),
                    athleteNameAsTheTitle:
                        StringManipulation.combineFirstNameWithLastName(
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
                    listOfAllRegisteredOptions: state
                            .divisionsTypes[parentIndex]
                            .ageGroups![childIndex]
                            .expansionPanelAthlete![athleteIndex]
                            .athleteStyles![state.styleIndex]
                            .registeredWeights ??
                        [],
                    weightClass: state
                            .divisionsTypes[parentIndex]
                            .ageGroups![childIndex]
                            .expansionPanelAthlete![athleteIndex]
                            .athleteStyles?[state.styleIndex]
                            .division
                            ?.weightClasses ??
                        [],
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

  bool checkIsEventSoldOut(PurchaseWithInitialState state) {
    if ( !context.read<RegisterAndSellBloc>().state.isStaffRegistration &&
    state.registrationLimit != null &&
        (state.registrationLimit ?? 0) <= state.totalRegistration &&
        state.paymentModuleTabs == PaymentModuleTabNames.registrations) {
      return true;
    }
    return false;
  }
}
