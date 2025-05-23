import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/imports/common.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';
import '../../../common/widgets/bottomsheets/bottom_sheet_for_no_edit_registration.dart';
import '../../../imports/data.dart';
import '../../my_purchases/widgets/build_product_image.dart';
import '../../my_purchases/widgets/build_product_info.dart';
import '../bloc/purchased_products_bloc.dart';
import '../widgets/build_card_container.dart';
import '../widgets/build_list_of_season_passess.dart';
import '../widgets/build_price_information.dart';

class PurchasedProductsView extends StatefulWidget {
  const PurchasedProductsView({super.key, required this.eventId});

  final String eventId;

  @override
  State<PurchasedProductsView> createState() => _PurchasedProductsViewState();
}

class _PurchasedProductsViewState extends State<PurchasedProductsView> {
  final ScrollController _scrollController = ScrollController();
  bool isShorten = false;

  @override
  void initState() {
    BlocProvider.of<PurchasedProductsBloc>(context).add(
        TriggerFetchProductDetails(
            eventId: widget.eventId, isAthleteParameterUpdated: false));
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // Scrolling down
      if (!isShorten) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          setState(() {
            isShorten = true; // Increase the height and padding
          });
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      // Scrolling up
      if (isShorten) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          setState(() {
            isShorten = false; // Decrease the height and padding
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PurchasedProductsBloc,
        PurchasedProductsWithInitialState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
          if (state.isAthleteParameterUpdated) {
            BlocProvider.of<PurchasedProductsBloc>(context).add(
                TriggerFetchProductDetails(
                    eventId: widget.eventId,
                    isAthleteParameterUpdated:
                        state.isAthleteParameterUpdated));
          }
        }
      },
      child:
          BlocBuilder<PurchasedProductsBloc, PurchasedProductsWithInitialState>(
        builder: (context, state) {
          return customScaffoldForImageBehind(
            hasForm: true,
            appBar: customAppBarForImageBehind(context: context, actions: [
              InkWell(
                splashColor: Colors.transparent,
                onTap: state.isDownloadingInvoice||state.dropdownInvoices.isEmpty
                    ? () {}
                    : () {
                        buildCustomShowModalBottomSheetParent(
                            ctx: context,
                            isNavigationRequired: true,
                            navigatorFunction: () {},
                            child: BlocBuilder<PurchasedProductsBloc,
                                PurchasedProductsWithInitialState>(
                              bloc: BlocProvider.of<PurchasedProductsBloc>(
                                  context)
                                ..add(
                                    TriggerOpenBottomSheetForDownloadingPdf()),
                              builder: (context, state) {
                                return buildBottomSheetWithDropDown(
                                    isInvoice: true,
                                    context: context,
                                    onRightTap: () {},
                                    onLeftTap: () {},
                                    isCancelBtnRequired: false,
                                    prompt: AppStrings
                                        .myPurchases_bottomSheet_invoiceDownload_prompt,
                                    onMenuStateChange: (value) {
                                      BlocProvider.of<PurchasedProductsBloc>(
                                              context)
                                          .add(TriggerDropdownExpand(
                                              isExpanded: value));
                                    },
                                    footerBtnLabel: AppStrings
                                        .myPurchases_bottomSheet_invoiceDownload_btn_text,
                                    globalKey: state.globalKey,
                                    highlightedTitle:
                                        AppStrings.global_empty_string,
                                    hint: AppStrings
                                        .myPurchases_bottomSheet_invoiceDownload_hint,
                                    isExpanded: state.isExpanded,
                                    selectedValue: state.orderNo,
                                    title: AppStrings
                                        .myPurchases_bottomSheet_invoiceDownload_title,
                                    items: customDropDownMenuItems(
                                        items: state.dropdownInvoices),
                                    onChanged: (value) {
                                      BlocProvider.of<PurchasedProductsBloc>(
                                              context)
                                          .add(TriggerInvoiceOrTeamSelection(
                                              teams: globalTeams,
                                              url: value ??
                                                  AppStrings
                                                      .global_empty_string,
                                              invoiceUrls:
                                                  state.dropdownInvoicesUrls));
                                    },
                                    onTap: state.orderNo != null
                                        ? () {
                                            BlocProvider.of<
                                                        PurchasedProductsBloc>(
                                                    context)
                                                .add(TriggerDownloadPdf(
                                                    orderNo: state.orderNo!));
                                            Navigator.pop(context);
                                          }
                                        : () {});
                              },
                            ));
                      },
                child: Container(
                  height: Dimensions.appBarActionsHeight,
                  width: Dimensions.appBarActionsWidth,
                  margin: EdgeInsets.only(
                      right: Dimensions.appBarToolHorizontalGap,
                      left: Dimensions.appBarToolHorizontalGap,
                      top: 10.h,
                      bottom: 2.h),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.appBarToolRadius),
                      color: state.dropdownInvoices.isEmpty? AppColors.colorSecondaryAccent.withOpacity(0.6): AppColors.colorSecondaryAccent),
                  child: Center(
                      child: SizedBox(
                          height: 16.h,
                          width: 16.w,
                          child: state.isDownloadingInvoice
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.colorPrimaryNeutralText),
                                )
                              : SvgPicture.asset(AppAssets.icDownloadInvoice,
                                  fit: BoxFit.cover))),
                ),
              )
            ]),
            body: state.isLoading
                ? CustomLoader(child: Container())
                : Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3.r),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          height: 180.h,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: state.data?.coverImage ??AppStrings.global_empty_string,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 100),
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            top: 0,
                            right: 0,
                            left: 0,
                            bottom: 0,
                          ),
                          controller: _scrollController,
                          child: buildContent(state),
                        ),
                      ),
                  ],
                ),
            // : DynamicSliverAppBar(
            //     isLoading: state.isLoading,
            //     subtitle: AppStrings.global_empty_string,
            //     title: state.data?.title ?? AppStrings.global_empty_string,
            //     location:
            //         state.data?.address ?? AppStrings.global_empty_string,
            //     date: state.data?.startDatetime ??
            //         AppStrings.global_empty_string,
            //     purchaseMetrics: Container(
            //       margin: EdgeInsets.only(top: 5.h),
            //       child: Text(
            //         '${state.data?.totalCount} Purchases | ${StringManipulation.addADollarSign(price: state.data!.totalAmount!)}',
            //         style: AppTextStyles.normalPrimary(isBold: true),
            //       ),
            //     ),
            //     coverImage: state.data?.coverImage ??
            //         AppStrings.global_empty_string,
            //     eventStatus: EventStatus.none,
            //     body: Container(
            //       margin: EdgeInsets.symmetric(
            //         vertical: 10.h,
            //         horizontal: 10.w,
            //       ),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           SizedBox(
            //             height: 10.h,
            //             width: double.infinity,
            //           ),
            //           buildCustomTabBar(
            //             isSmallButtonTitle: false,
            //               isScrollRequired: false,
            //               tabElements: [
            //                 TabElements(
            //                     title: AppStrings
            //                         .myPurchases_tab_registration_title,
            //                     onTap: () {
            //                       BlocProvider.of<PurchasedProductsBloc>(
            //                               context)
            //                           .add(TriggerSwitchTab(
            //                               rootInvoiceUrl: state.data!
            //                                   .registrationInvoiceUrl!,
            //                               index: 0));
            //                     },
            //                     isSelected: state.selectedIndex == 0),
            //                 TabElements(
            //                     title: AppStrings
            //                         .myPurchases_tab_products_title,
            //                     onTap: () {
            //                       BlocProvider.of<PurchasedProductsBloc>(
            //                               context)
            //                           .add(TriggerSwitchTab(
            //                               rootInvoiceUrl: state
            //                                   .data!.productInvoiceUrl!,
            //                               index: 1));
            //                     },
            //                     isSelected: state.selectedIndex == 1),
            //               ]),
            //           if (state.selectedIndex == 0 &&
            //               state.eventRegistrations.isNotEmpty)
            //             ...[
            //               buildListOfSeasonPasses(
            //                 isLoading: state.isLoadingWcs,
            //                   productCardType: ProductCardType.eventRegs,
            //                   purchasedProductData: state.data,
            //                   eventRegistrations: state.eventRegistrations,
            //                   openBottomSheetWithDropDown: (index) {
            //                     buildCustomShowModalBottomSheetParent(
            //                         ctx: context,
            //                         isNavigationRequired: false,
            //                         child: BlocBuilder<PurchasedProductsBloc,
            //                             PurchasedProductsWithInitialState>(
            //                           bloc: BlocProvider.of<
            //                               PurchasedProductsBloc>(context)
            //                             ..add(
            //                                 TriggerOpenBottomSheetForDownloadingPdf()),
            //                           builder: (context, state) {
            //                             return buildBottomSheetWithDropDown(
            //                               isInvoice: false,
            //                               context: context,
            //                               onRightTap: () {
            //                                 BlocProvider.of<
            //                                     PurchasedProductsBloc>(
            //                                     context)
            //                                     .add(TriggerChangeTeam(
            //                                     athleteId: state
            //                                         .eventRegistrations[
            //                                     index]
            //                                         .athlete!
            //                                         .underscoreId!,
            //                                     eventId: widget.eventId,
            //                                     teamId: state
            //                                         .selectedTeamId));
            //                               },
            //                               onLeftTap: () {
            //                                 Navigator.pop(context);
            //                               },
            //                               rightBtnLabel:
            //                               AppStrings.btn_submit,
            //                               leftBtnLabel: AppStrings.btn_cancel,
            //                               isCancelBtnRequired: true,
            //                               prompt: AppStrings
            //                                   .myPurchases_registration_teamReselection_bottomSheet_prompt,
            //                               textEditingController:
            //                               state.textEditingController,
            //                               onMenuStateChange: (value) {
            //                                 BlocProvider.of<
            //                                     PurchasedProductsBloc>(
            //                                     context)
            //                                     .add(TriggerDropdownExpand(
            //                                     isExpanded: value));
            //                               },
            //                               footerBtnLabel: AppStrings
            //                                   .myPurchases_bottomSheet_invoiceDownload_btn_text,
            //                               globalKey: state.globalKey,
            //                               highlightedTitle:
            //                               AppStrings.global_empty_string,
            //                               hint: state
            //                                   .eventRegistrations[index]
            //                                   .team!
            //                                   .name!,
            //                               isExpanded: state.isExpanded,
            //                               selectedValue: state.selectedTeam ??
            //                                   state.eventRegistrations[index]
            //                                       .team!.name!,
            //                               title: AppStrings
            //                                   .myPurchases_registration_teamReselection_bottomSheet_title,
            //                               richText: RichText(
            //                                 text: TextSpan(
            //                                   text:
            //                                   'You may change the team for ',
            //                                   style: AppTextStyles
            //                                       .bottomSheetSubtitle(
            //                                       isOutfit: true),
            //                                   children: [
            //                                     TextSpan(
            //                                         text:
            //                                         ' ${StringManipulation.combineFirstNameWithLastName(firstName: state.eventRegistrations[index].athlete!.firstName!, lastName: state.eventRegistrations[index].athlete!.lastName!)} ',
            //                                         style: AppTextStyles
            //                                             .bottomSheetSubtitle(
            //                                             isOutfit: true,
            //                                             color: AppColors
            //                                                 .colorPrimaryInverseText,
            //                                             isBold: true)),
            //                                     TextSpan(
            //                                         text: 'for the event, ',
            //                                         style: AppTextStyles
            //                                             .bottomSheetSubtitle(
            //                                           isOutfit: true,
            //                                         )),
            //                                     TextSpan(
            //                                         text:
            //                                         '${state.data?.title}',
            //                                         style: AppTextStyles
            //                                             .bottomSheetSubtitle(
            //                                             isOutfit: true,
            //                                             color: AppColors
            //                                                 .colorPrimaryInverseText,
            //                                             isBold: true)),
            //                                     TextSpan(
            //                                         text:
            //                                         '.\nIf you change the team, all registrations for this athlete for this event will be changed.\n',
            //                                         style: AppTextStyles
            //                                             .bottomSheetSubtitle(
            //                                           isOutfit: true,
            //                                         )),
            //                                     TextSpan(
            //                                         text:
            //                                         'Please select a team from the drop-down menu and confirm.\n',
            //                                         style: AppTextStyles
            //                                             .bottomSheetSubtitle(
            //                                           isOutfit: true,
            //                                         )),
            //                                   ],
            //                                 ),
            //                               ),
            //                               items: customDropDownMenuItems(
            //                                   items: state.teamNames),
            //                               onChanged: (value) {
            //                                 BlocProvider.of<
            //                                     PurchasedProductsBloc>(
            //                                     context)
            //                                     .add(TriggerInvoiceOrTeamSelection(
            //                                     teams: globalTeams,
            //                                     url: value ??
            //                                         AppStrings
            //                                             .global_empty_string,
            //                                     invoiceUrls: state
            //                                         .dropdownInvoicesUrls));
            //                               },
            //                               onTap: () {},
            //                             );
            //                           },
            //                         ));
            //                   },
            //                   openBottomSheetWithRegisteredWcs: (index) {
            //                     buildCustomShowModalBottomSheetParent(
            //                         ctx: context,
            //                         isNavigationRequired: false,
            //                         child: BlocBuilder<PurchasedProductsBloc,
            //                             PurchasedProductsWithInitialState>(
            //                           builder: (context, state) {
            //                             return bottomSheetForListOfDivisionsWithRegisteredWCs(
            //                                 isEditActive: state
            //                                     .eventRegistrations[index]
            //                                     .athlete!
            //                                     .canUserEditRegistration! &&
            //                                     (state.data
            //                                         ?.isRegistrationAvailable ??
            //                                         false),
            //                                 editWc: state
            //                                     .eventRegistrations[
            //                                 index]
            //                                     .athlete!
            //                                     .canUserEditRegistration! &&
            //                                     (state.data
            //                                         ?.isRegistrationAvailable ??
            //                                         false)
            //                                     ? (registerIndex) {
            //                                   Navigator.pop(context);
            //                                   buildCustomShowModalBottomSheetParent(
            //                                     ctx: context,
            //                                     isNavigationRequired:
            //                                     false,
            //                                     child: BlocBuilder<
            //                                         PurchasedProductsBloc,
            //                                         PurchasedProductsWithInitialState>(
            //                                       bloc: BlocProvider.of<
            //                                           PurchasedProductsBloc>(
            //                                           context)
            //                                         ..add(TriggerFetchWeightClasses(
            //                                             purchasedProductData:
            //                                             state.data!,
            //                                             indexOfRegistrationWithDivisionId:
            //                                             registerIndex,
            //                                             indexOfEventRegistrations:
            //                                             index)),
            //                                       builder:
            //                                           (context, state) {
            //                                         return buildBottomSheetWithBodyCheckboxList(
            //                                           isCheckListForWeightClass:
            //                                           true,
            //                                           isLoading: state
            //                                               .isLoadingWcs,
            //                                           isUpdateWCInactive:
            //                                           state.isUpdateWCInactive ||
            //                                               state
            //                                                   .isLoading,
            //                                           onTapForUpdate:
            //                                           state.isUpdateWCInactive
            //                                               ? () {}
            //                                               : () {
            //                                             buildBottomSheetWithBodyText(
            //                                               context:
            //                                               context,
            //                                               title:
            //                                               AppStrings.myPurchases_registration_changeWc_bottomsheet_title,
            //                                               subtitle:
            //                                               AppStrings.global_empty_string,
            //                                               richText: RichText(
            //                                                   text: TextSpan(
            //                                                     text: 'You are about to change the weight class(es) for ',
            //                                                     style: AppTextStyles.bottomSheetSubtitle(isOutfit: true),
            //                                                     children: [
            //                                                       TextSpan(text: StringManipulation.combineFirstNameWithLastName(firstName: state.eventRegistrations[index].athlete!.firstName!, lastName: state.eventRegistrations[index].athlete!.lastName!), style: AppTextStyles.bottomSheetSubtitle(isOutfit: true, color: AppColors.colorPrimaryInverseText, isBold: true)),
            //                                                       TextSpan(text: ' for the event, ', style: AppTextStyles.bottomSheetSubtitle(isOutfit: true)),
            //                                                       TextSpan(text: state.data!.title!, style: AppTextStyles.bottomSheetSubtitle(isOutfit: true, color: AppColors.colorPrimaryInverseText, isBold: true)),
            //                                                       TextSpan(text: ' for ', style: AppTextStyles.bottomSheetSubtitle(isOutfit: true,)),
            //                                                       TextSpan(text: '${state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].division!.title!} ${state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].division!.divisionType!} ${state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].division!.style!}', style: AppTextStyles.bottomSheetSubtitle(isOutfit: true, color: AppColors.colorPrimaryInverseText, isBold: true)),
            //                                                       TextSpan(text: '.\nYou are sure you want to do this?', style: AppTextStyles.bottomSheetSubtitle(isOutfit: true, )),
            //                                                     ],
            //                                                   )),
            //                                               isSingeButtonPresent:
            //                                               false,
            //                                               onLeftButtonPressed:
            //                                                   () {
            //                                                 Navigator.pop(context);
            //                                               },
            //                                               onRightButtonPressed:
            //                                                   () {
            //                                                 Navigator.pop(context);
            //                                                 Navigator.pop(context);
            //                                                 BlocProvider.of<PurchasedProductsBloc>(context).add(
            //                                                   TriggerChangeWC(
            //                                                     changeWCRequest: ChangeWCRequestModel(
            //                                                       weightClasses: [],
            //                                                       eventId: widget.eventId,
            //                                                       athleteId: state.eventRegistrations[index].athlete!.underscoreId!,
            //                                                       divisionId: state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].division!.id!,
            //                                                     ),
            //                                                     weightClasses: state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].weightClasses!,
            //                                                     selectedWeights: state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].selectedWeightClasses!,
            //                                                   ),
            //                                                 );
            //                                               },
            //                                               rightButtonText:
            //                                               AppStrings.btn_changeWC,
            //                                               leftButtonText:
            //                                               AppStrings.btn_keepIt,
            //                                               highLightedAthleteName:
            //                                               AppStrings.global_empty_string,
            //                                             );
            //                                           },
            //                                           onTapToSelectTile:
            //                                               (value) {
            //                                             BlocProvider.of<PurchasedProductsBloc>(context).add(TriggerWCReselect(
            //                                                 purchasedProductData:
            //                                                 state
            //                                                     .data!,
            //                                                 indexOfRegistrationWithDivisionId:
            //                                                 registerIndex,
            //                                                 indexOfEventRegistrations:
            //                                                 index,
            //                                                 indexOfWCFromAvailableWC:
            //                                                 value));
            //                                           },
            //                                           context: context,
            //                                           isFromPurchaseHistory:
            //                                           true,
            //                                           listOfAllRegisteredOptions: state
            //                                               .eventRegistrations[
            //                                           index]
            //                                               .registrationWithDivisionIdList![
            //                                           registerIndex]
            //                                               .scannedWeights!,
            //                                           listOfAllOptions: state
            //                                               .eventRegistrations[
            //                                           index]
            //                                               .registrationWithDivisionIdList![
            //                                           registerIndex]
            //                                               .availableWeightClasses!,
            //                                           listOfAllSelectedOption: state
            //                                               .eventRegistrations[
            //                                           index]
            //                                               .registrationWithDivisionIdList![
            //                                           registerIndex]
            //                                               .selectedWeightClasses!,
            //                                           listOfStyleTitles: [],
            //                                           athleteAge: state
            //                                               .eventRegistrations[
            //                                           index]
            //                                               .athlete!
            //                                               .age
            //                                               .toString(),
            //                                           athleteWeight: state
            //                                               .eventRegistrations[
            //                                           index]
            //                                               .athlete!
            //                                               .weight
            //                                               .toString(),
            //                                           athleteImageUrl: state
            //                                               .eventRegistrations[
            //                                           index]
            //                                               .athlete!
            //                                               .profileImage!,
            //                                           athleteNameAsTheTitle: StringManipulation.combineFirstNameWithLastName(
            //                                               firstName: state
            //                                                   .eventRegistrations[
            //                                               index]
            //                                                   .athlete!
            //                                                   .firstName!,
            //                                               lastName: state
            //                                                   .eventRegistrations[
            //                                               index]
            //                                                   .athlete!
            //                                                   .lastName!),
            //                                           checkBoxForWeightClassSelection:
            //                                               (value) {},
            //                                           selectedStyleIndex:
            //                                           0,
            //                                           selectStyle:
            //                                               (styleIndex) {},
            //                                         );
            //                                       },
            //                                     ),
            //                                   );
            //                                 }
            //                                     : (registerIndex) {
            //                                   bottomSheetForNoEditRegistration(
            //                                       isRegistrationAvailable: state
            //                                           .data
            //                                           ?.isRegistrationAvailable ??
            //                                           false,
            //                                       location:
            //                                       state.data?.address ??
            //                                           '',
            //                                       eventName:
            //                                       state.data?.title ??
            //                                           '',
            //                                       registeredTeamName: AppStrings
            //                                           .global_empty_string,
            //                                       context: context,
            //                                       athleteAge:
            //                                       state.eventRegistrations[index].athlete!.age
            //                                           .toString(),
            //                                       athleteWeight: state
            //                                           .eventRegistrations[
            //                                       index]
            //                                           .athlete!
            //                                           .weight
            //                                           .toString(),
            //                                       athleteImageUrl: state
            //                                           .eventRegistrations[index]
            //                                           .athlete!
            //                                           .profileImage!,
            //                                       athleteNameAsTheTitle: StringManipulation.combineFirstNameWithLastName(firstName: state.eventRegistrations[index].athlete!.firstName!, lastName: state.eventRegistrations[index].athlete!.lastName!));
            //                                 },
            //                                 context: context,
            //                                 title: state.data?.title ??
            //                                     AppStrings
            //                                         .global_empty_string,
            //                                 subtitle: AppStrings
            //                                     .athleteDetails_upcomingEvents_bottomSheet_subtitle,
            //                                 registrationWithSameDivisionId: state
            //                                     .data!
            //                                     .eventRegistrations![index]
            //                                     .registrationWithDivisionIdList!,
            //                                 isEditWCOptionAvailable: true);
            //                           },
            //                         ));
            //                   })
            //             ],
            //           if (state.selectedIndex == 0 &&
            //               state.eventRegistrations.isEmpty)
            //             SizedBox(
            //               height: Dimensions.getScreenHeight() * 0.25,
            //               child: Column(
            //                 children: [
            //                   const Spacer(),
            //                   Center(
            //                     child: Text(
            //                         AppStrings
            //                             .purchasedProducts_noRegistrations_text,
            //                         style: AppTextStyles.smallTitle()),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           if (state.selectedIndex == 1 &&
            //               state.productPurchases.isNotEmpty)
            //             Flexible(
            //                 child: ListView.separated(
            //                     padding:
            //                         EdgeInsets.symmetric(horizontal: 2.w),
            //                     itemBuilder: (context, index) {
            //                       return buildCardContainer(children: [
            //                         SizedBox(
            //                           width: 3.w,
            //                         ),
            //                         buildProductImage(
            //                             isMyProductDetail: true,
            //                             qrCodeStatus: state
            //                                     .productPurchases[index]
            //                                     .qrCodeStatus ??
            //                                 AppStrings.global_empty_string,
            //                             coverImage: state
            //                                 .productPurchases[index]
            //                                 .product!
            //                                 .image!),
            //                         buildProductInfo(
            //                           totalAmount: -1,
            //                           //price: state.productPurchases[index].price!,
            //                           productCardType:
            //                               ProductCardType.eventProds,
            //                           purchasedDate: state
            //                               .productPurchases[index].createdAt
            //                               .toString(),
            //                           totalCount:
            //                               AppStrings.global_empty_string,
            //                           context: context,
            //                           productTitle: state
            //                               .productPurchases[index]
            //                               .product!
            //                               .title!,
            //                         ),
            //                         buildPriceInformation(
            //                             productCardType:
            //                                 ProductCardType.eventProds,
            //                             registrations: [],
            //                             status: state
            //                                 .productPurchases[index]
            //                                 .qrCodeStatus!,
            //                             image: GlobalHandlers
            //                                 .convertQRCodeToImage(
            //                                     qrCode: state
            //                                         .productPurchases[index]
            //                                         .qrCode!),
            //                             price: state.productPurchases[index]
            //                                 .price!),
            //                         SizedBox(
            //                           width: 3.w,
            //                         ),
            //                       ]);
            //                       //   Container(
            //                       //   decoration: BoxDecoration(
            //                       //       color: AppColors.colorSecondary,
            //                       //       borderRadius: BorderRadius.circular(
            //                       //           Dimensions.generalSmallRadius)),
            //                       //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
            //                       //   child: Row(
            //                       //     children: [
            //                       //       buildProductImage(
            //                       //           isMyProductDetail: true,
            //                       //           qrCodeStatus:
            //                       //           state.productPurchases[index].qrCodeStatus ??
            //                       //               AppStrings.global_empty_string,
            //                       //           coverImage: state
            //                       //               .productPurchases[index].product!.image!),
            //                       //       SizedBox(width: 3.w,),
            //                       //       buildProductInfo(
            //                       //         totalAmount: -1,
            //                       //         //price: state.productPurchases[index].price!,
            //                       //         productCardType: ProductCardType.eventProds,
            //                       //         purchasedDate: state
            //                       //             .productPurchases[index].createdAt
            //                       //             .toString(),
            //                       //         totalCount: AppStrings.global_empty_string,
            //                       //         context: context,
            //                       //         productTitle:
            //                       //         state.productPurchases[index].product!.title!,
            //                       //       ),
            //                       //       const Spacer(),
            //                       //       buildPriceInformation(
            //                       //           productCardType: ProductCardType.eventProds,
            //                       //           registrations: [],
            //                       //           status:
            //                       //           state.productPurchases[index].qrCodeStatus!,
            //                       //           image: GlobalHandlers.convertQRCodeToImage(
            //                       //               qrCode:
            //                       //               state.productPurchases[index].qrCode!),
            //                       //           price: state.productPurchases[index].price!)
            //                       //     ],
            //                       //   ),
            //                       // );
            //                     },
            //                     separatorBuilder: (context, index) {
            //                       return SizedBox(
            //                         height: 10.h,
            //                       );
            //                     },
            //                     itemCount: state.productPurchases.length)),
            //           if (state.selectedIndex == 1 &&
            //               state.productPurchases.isEmpty)
            //             SizedBox(
            //               height: Dimensions.getScreenHeight() * 0.25,
            //               child: Column(
            //                 children: [
            //                   const Spacer(),
            //                   Center(
            //                     child: Text(
            //                         AppStrings
            //                             .purchasedProducts_noProducts_text,
            //                         style: AppTextStyles.smallTitle()),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //         ],
            //       ),
            //     ),
            //   ),
          );
        },
      ),
    );
  }

  Widget buildContent(PurchasedProductsWithInitialState state) {
    return AnimatedContainer(
      height: Dimensions.getScreenHeight(),
      duration: const Duration(milliseconds: 100),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: EdgeInsets.only(
              top: 145.h,
              left: 10.w,
              right: 10.w,
            ),
            height: Dimensions.getScreenHeight(),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    color: AppColors.colorBlackOpaque,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  margin: EdgeInsets.only(

                    left: 10.w,
                    right: 10.h,
                  ),
                  padding: EdgeInsets.only(
                      left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              state.data?.title ??
                                  AppStrings.global_empty_string,
                              style: AppTextStyles.smallTitle(),
                              maxLines: isShorten ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (!isShorten) ...[
                        if (!state.isLoading)
                          buildSvgWithInfo(
                              text: state.data?.startDatetime ??
                                  AppStrings.global_empty_string,
                              isDate: true),
                        if (!state.isLoading)
                          buildSvgWithInfo(
                              text: state.data?.address ??
                                  AppStrings.global_empty_string,
                              isDate: false),
                        Container(
                          margin: EdgeInsets.only(top: 5.h),
                          child: Text(
                            '${state.data?.totalCount} Purchases | ${StringManipulation.addADollarSign(price: state.data!.totalAmount!)}',
                            style: AppTextStyles.normalPrimary(isBold: true),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(
                  height: 10.h,
                  width: double.infinity,
                ),
                buildCustomTabBar(
                    isSmallButtonTitle: false,
                    isScrollRequired: false,
                    tabElements: [
                      TabElements(
                        count: state.eventRegistrations.length,
                          title: AppStrings
                              .myPurchases_tab_registration_title,
                          onTap: () {
                            BlocProvider.of<PurchasedProductsBloc>(
                                context)
                                .add(TriggerSwitchTab(
                                rootInvoiceUrl: state.data!
                                    .registrationInvoiceUrl!,
                                index: 0));
                          },
                          isSelected: state.selectedIndex == 0),
                      TabElements(
                        count: state.productPurchases.length,
                          title: AppStrings
                              .myPurchases_tab_products_title,
                          onTap: () {
                            BlocProvider.of<PurchasedProductsBloc>(
                                context)
                                .add(TriggerSwitchTab(
                                rootInvoiceUrl: state
                                    .data!.productInvoiceUrl!,
                                index: 1));
                          },
                          isSelected: state.selectedIndex == 1),
                    ]),
                if (state.selectedIndex == 0 &&
                    state.eventRegistrations.isNotEmpty)
                  ...[
                    buildListOfSeasonPasses(
                        isLoading: state.isLoadingWcs,
                        productCardType: ProductCardType.eventRegs,
                        purchasedProductData: state.data,
                        eventRegistrations: state.eventRegistrations,
                        openBottomSheetWithDropDown: (index) {
                          buildCustomShowModalBottomSheetParent(
                              ctx: context,
                              isNavigationRequired: false,
                              child: BlocBuilder<PurchasedProductsBloc,
                                  PurchasedProductsWithInitialState>(
                                bloc: BlocProvider.of<
                                    PurchasedProductsBloc>(context)
                                  ..add(
                                      TriggerOpenBottomSheetForDownloadingPdf()),
                                builder: (context, state) {
                                  return buildBottomSheetWithDropDown(
                                    isInvoice: false,
                                    context: context,
                                    onRightTap: () {
                                      BlocProvider.of<
                                          PurchasedProductsBloc>(
                                          context)
                                          .add(TriggerChangeTeam(
                                          athleteId: state
                                              .eventRegistrations[
                                          index]
                                              .athlete!
                                              .underscoreId!,
                                          eventId: widget.eventId,
                                          teamId: state
                                              .selectedTeamId));
                                    },
                                    onLeftTap: () {
                                      Navigator.pop(context);
                                    },
                                    rightBtnLabel:
                                    AppStrings.btn_submit,
                                    leftBtnLabel: AppStrings.btn_cancel,
                                    isCancelBtnRequired: true,
                                    prompt: AppStrings
                                        .myPurchases_registration_teamReselection_bottomSheet_prompt,
                                    textEditingController:
                                    state.textEditingController,
                                    onMenuStateChange: (value) {
                                      BlocProvider.of<
                                          PurchasedProductsBloc>(
                                          context)
                                          .add(TriggerDropdownExpand(
                                          isExpanded: value));
                                    },
                                    footerBtnLabel: AppStrings
                                        .myPurchases_bottomSheet_invoiceDownload_btn_text,
                                    globalKey: state.globalKey,
                                    highlightedTitle:
                                    AppStrings.global_empty_string,
                                    hint: state
                                        .eventRegistrations[index]
                                        .team!
                                        .name!,
                                    isExpanded: state.isExpanded,
                                    selectedValue: state.selectedTeam ??
                                        state.eventRegistrations[index]
                                            .team!.name!,
                                    title: AppStrings
                                        .myPurchases_registration_teamReselection_bottomSheet_title,
                                    richText: RichText(
                                      text: TextSpan(
                                        text:
                                        'You may change the team for ',
                                        style: AppTextStyles
                                            .bottomSheetSubtitle(
                                            isOutfit: true),
                                        children: [
                                          TextSpan(
                                              text:
                                              ' ${StringManipulation.combineFirstNameWithLastName(firstName: state.eventRegistrations[index].athlete!.firstName!, lastName: state.eventRegistrations[index].athlete!.lastName!)} ',
                                              style: AppTextStyles
                                                  .bottomSheetSubtitle(
                                                  isOutfit: true,
                                                  color: AppColors
                                                      .colorPrimaryInverseText,
                                                  isBold: true)),
                                          TextSpan(
                                              text: 'for the event, ',
                                              style: AppTextStyles
                                                  .bottomSheetSubtitle(
                                                isOutfit: true,
                                              )),
                                          TextSpan(
                                              text:
                                              '${state.data?.title}',
                                              style: AppTextStyles
                                                  .bottomSheetSubtitle(
                                                  isOutfit: true,
                                                  color: AppColors
                                                      .colorPrimaryInverseText,
                                                  isBold: true)),
                                          TextSpan(
                                              text:
                                              '.\nIf you change the team, all registrations for this athlete for this event will be changed.\n',
                                              style: AppTextStyles
                                                  .bottomSheetSubtitle(
                                                isOutfit: true,
                                              )),
                                          TextSpan(
                                              text:
                                              'Please select a team from the drop-down menu and confirm.\n',
                                              style: AppTextStyles
                                                  .bottomSheetSubtitle(
                                                isOutfit: true,
                                              )),
                                        ],
                                      ),
                                    ),
                                    items: customDropDownMenuItems(
                                        items: state.teamNames),
                                    onChanged: (value) {
                                      BlocProvider.of<
                                          PurchasedProductsBloc>(
                                          context)
                                          .add(TriggerInvoiceOrTeamSelection(
                                          teams: globalTeams,
                                          url: value ??
                                              AppStrings
                                                  .global_empty_string,
                                          invoiceUrls: state
                                              .dropdownInvoicesUrls));
                                    },
                                    onTap: () {},
                                  );
                                },
                              ));
                        },
                        openBottomSheetWithRegisteredWcs: (index) {
                          buildCustomShowModalBottomSheetParent(
                              ctx: context,
                              isNavigationRequired: false,
                              child: BlocBuilder<PurchasedProductsBloc,
                                  PurchasedProductsWithInitialState>(
                                builder: (context, state) {
                                  return bottomSheetForListOfDivisionsWithRegisteredWCs(
                                      isEditActive: state
                                          .eventRegistrations[index]
                                          .athlete!
                                          .canUserEditRegistration! &&
                                          (state.data
                                              ?.isRegistrationAvailable ??
                                              false),
                                      editWc: state
                                          .eventRegistrations[
                                      index]
                                          .athlete!
                                          .canUserEditRegistration! &&
                                          (state.data
                                              ?.isRegistrationAvailable ??
                                              false)
                                          ? (registerIndex) {
                                        Navigator.pop(context);
                                        buildCustomShowModalBottomSheetParent(
                                          ctx: context,
                                          isNavigationRequired:
                                          false,
                                          child: BlocBuilder<
                                              PurchasedProductsBloc,
                                              PurchasedProductsWithInitialState>(
                                            bloc: BlocProvider.of<
                                                PurchasedProductsBloc>(
                                                context)
                                              ..add(TriggerFetchWeightClasses(
                                                  purchasedProductData:
                                                  state.data!,
                                                  indexOfRegistrationWithDivisionId:
                                                  registerIndex,
                                                  indexOfEventRegistrations:
                                                  index)),
                                            builder:
                                                (context, state) {
                                              return buildBottomSheetWithBodyCheckboxList(
                                                disclaimer: '',
                                                isCheckListForWeightClass:
                                                true,
                                                isLoading: state
                                                    .isLoadingWcs,
                                                isUpdateWCInactive:
                                                state.isUpdateWCInactive ||
                                                    state
                                                        .isLoading,
                                                onTapForUpdate:
                                                state.isUpdateWCInactive
                                                    ? () {}
                                                    : () {
                                                  buildBottomSheetWithBodyText(
                                                    context:
                                                    context,
                                                    title:
                                                    AppStrings.myPurchases_registration_changeWc_bottomsheet_title,
                                                    subtitle:
                                                    AppStrings.global_empty_string,
                                                    richText: RichText(
                                                        text: TextSpan(
                                                          text: 'You are about to change the weight class(es) for ',
                                                          style: AppTextStyles.bottomSheetSubtitle(isOutfit: true),
                                                          children: [
                                                            TextSpan(text: StringManipulation.combineFirstNameWithLastName(firstName: state.eventRegistrations[index].athlete!.firstName!, lastName: state.eventRegistrations[index].athlete!.lastName!), style: AppTextStyles.bottomSheetSubtitle(isOutfit: true, color: AppColors.colorPrimaryInverseText, isBold: true)),
                                                            TextSpan(text: ' for the event, ', style: AppTextStyles.bottomSheetSubtitle(isOutfit: true)),
                                                            TextSpan(text: state.data!.title!, style: AppTextStyles.bottomSheetSubtitle(isOutfit: true, color: AppColors.colorPrimaryInverseText, isBold: true)),
                                                            TextSpan(text: ' for ', style: AppTextStyles.bottomSheetSubtitle(isOutfit: true,)),
                                                            TextSpan(text: '${state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].division!.title!} ${state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].division!.divisionType!} ${state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].division!.style!}', style: AppTextStyles.bottomSheetSubtitle(isOutfit: true, color: AppColors.colorPrimaryInverseText, isBold: true)),
                                                            TextSpan(text: '.\nYou are sure you want to do this?', style: AppTextStyles.bottomSheetSubtitle(isOutfit: true, )),
                                                          ],
                                                        )),
                                                    isSingeButtonPresent:
                                                    false,
                                                    onLeftButtonPressed:
                                                        () {
                                                      Navigator.pop(context);
                                                    },
                                                    onRightButtonPressed:
                                                        () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      BlocProvider.of<PurchasedProductsBloc>(context).add(
                                                        TriggerChangeWC(
                                                          scannedWeights: state
                                                              .eventRegistrations[
                                                          index]
                                                              .registrationWithDivisionIdList![
                                                          registerIndex]
                                                              .scannedWeights!,
                                                          changeWCRequest: ChangeWCRequestModel(
                                                            weightClasses: [],
                                                            eventId: widget.eventId,
                                                            athleteId: state.eventRegistrations[index].athlete!.underscoreId!,
                                                            divisionId: state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].division!.id!,
                                                          ),
                                                          weightClasses: state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].weightClasses!,
                                                          selectedWeights: state.eventRegistrations[index].registrationWithDivisionIdList![registerIndex].selectedWeightClasses!,
                                                        ),
                                                      );
                                                    },
                                                    rightButtonText:
                                                    AppStrings.btn_changeWC,
                                                    leftButtonText:
                                                    AppStrings.btn_keepIt,
                                                    highLightedAthleteName:
                                                    AppStrings.global_empty_string,
                                                  );
                                                },
                                                onTapToSelectTile:
                                                    (value) {
                                                  BlocProvider.of<PurchasedProductsBloc>(context).add(TriggerWCReselect(
                                                      purchasedProductData:
                                                      state
                                                          .data!,
                                                      indexOfRegistrationWithDivisionId:
                                                      registerIndex,
                                                      indexOfEventRegistrations:
                                                      index,
                                                      indexOfWCFromAvailableWC:
                                                      value,
                                                  ));
                                                },
                                                context: context,
                                                isFromPurchaseHistory:
                                                true,
                                                weightClass: state.eventRegistrations[index].registrationWithDivisionIdList?[registerIndex].weightClasses,
                                                isRegistrationLimitViewVisible: false,
                                                listOfAllRegisteredOptions: state
                                                    .eventRegistrations[
                                                index]
                                                    .registrationWithDivisionIdList![
                                                registerIndex]
                                                    .scannedWeights!,
                                                listOfAllOptions: state
                                                    .eventRegistrations[
                                                index]
                                                    .registrationWithDivisionIdList![
                                                registerIndex]
                                                    .availableWeightClasses!,
                                                listOfAllSelectedOption: state
                                                    .eventRegistrations[
                                                index]
                                                    .registrationWithDivisionIdList![
                                                registerIndex]
                                                    .selectedWeightClasses!,
                                                listOfStyleTitles: [],
                                                athleteAge: state
                                                    .eventRegistrations[
                                                index]
                                                    .athlete!
                                                    .age
                                                    .toString(),
                                                athleteWeight: state
                                                    .eventRegistrations[
                                                index]
                                                    .athlete!
                                                    .weight
                                                    .toString(),
                                                athleteImageUrl: state
                                                    .eventRegistrations[
                                                index]
                                                    .athlete!
                                                    .profileImage!,
                                                athleteNameAsTheTitle: StringManipulation.combineFirstNameWithLastName(
                                                    firstName: state
                                                        .eventRegistrations[
                                                    index]
                                                        .athlete!
                                                        .firstName!,
                                                    lastName: state
                                                        .eventRegistrations[
                                                    index]
                                                        .athlete!
                                                        .lastName!),
                                                checkBoxForWeightClassSelection:
                                                    (value) {},
                                                selectedStyleIndex:
                                                0,
                                                selectStyle:
                                                    (styleIndex) {},
                                              );
                                            },
                                          ),
                                        );
                                      }
                                          : (registerIndex) {
                                        bottomSheetForNoEditRegistration(
                                            isRegistrationAvailable: state
                                                .data
                                                ?.isRegistrationAvailable ??
                                                false,
                                            location:
                                            state.data?.address ??
                                                '',
                                            eventName:
                                            state.data?.title ??
                                                '',
                                            registeredTeamName: AppStrings
                                                .global_empty_string,
                                            context: context,
                                            athleteAge:
                                            state.eventRegistrations[index].athlete!.age
                                                .toString(),
                                            athleteWeight: state
                                                .eventRegistrations[
                                            index]
                                                .athlete!
                                                .weight
                                                .toString(),
                                            athleteImageUrl: state
                                                .eventRegistrations[index]
                                                .athlete!
                                                .profileImage!,
                                            athleteNameAsTheTitle: StringManipulation.combineFirstNameWithLastName(firstName: state.eventRegistrations[index].athlete!.firstName!, lastName: state.eventRegistrations[index].athlete!.lastName!));
                                      },
                                      context: context,
                                      title: state.data?.title ??
                                          AppStrings
                                              .global_empty_string,
                                      subtitle: AppStrings
                                          .athleteDetails_upcomingEvents_bottomSheet_subtitle,
                                      registrationWithSameDivisionId: state
                                          .data!
                                          .eventRegistrations![index]
                                          .registrationWithDivisionIdList!,
                                      isEditWCOptionAvailable: true);
                                },
                              ));
                        })
                  ],
                if (state.selectedIndex == 0 &&
                    state.eventRegistrations.isEmpty  && !state.isLoading)
                  SizedBox(
                    height: Dimensions.getScreenHeight() * 0.25,
                    child: Column(
                      children: [
                        const Spacer(),
                        Center(
                          child: Text(
                              AppStrings
                                  .purchasedProducts_noRegistrations_text,
                              style: AppTextStyles.smallTitle()),
                        ),
                      ],
                    ),
                  ),
                if (state.selectedIndex == 1 &&
                    state.productPurchases.isNotEmpty)
                  Flexible(
                      child: ListView.separated(
                          itemCount: state.productPurchases.length,
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 82.h,
                              child: buildCardContainer(

                                  children: [

                                Container(
                                  child: buildProductImage(
                                      isMyProductDetail: true,
                                      qrCodeStatus: state
                                          .productPurchases[index]
                                          .qrCodeStatus ??
                                          AppStrings.global_empty_string,
                                      coverImage: state
                                          .productPurchases[index]
                                          .product!
                                          .image!),
                                ),
                                buildProductInfo(
                                  totalAmount: -1,
                                  //price: state.productPurchases[index].price!,
                                  productCardType:
                                  ProductCardType.eventProds,
                                  purchasedDate: state
                                      .productPurchases[index].createdAt
                                      .toString(),
                                  totalCount:
                                  AppStrings.global_empty_string,
                                  context: context,
                                  productTitle: state
                                      .productPurchases[index]
                                      .product!
                                      .title!,
                                ),
                                buildPriceInformation(
                                    productCardType:
                                    ProductCardType.eventProds,
                                    registrations: [],
                                    status: state
                                        .productPurchases[index]
                                        .qrCodeStatus!,
                                    image: GlobalHandlers
                                        .convertQRCodeToImage(
                                        qrCode: state
                                            .productPurchases[index]
                                            .qrCode!),
                                    price: state.productPurchases[index]
                                        .price!),
                                SizedBox(
                                  width: 3.w,
                                ),
                              ]),
                            );

                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 10.h,
                              width: double.infinity,
                            );
                          },
                         )),
                if (state.selectedIndex == 1 &&
                    state.productPurchases.isEmpty && !state.isLoading)
                  SizedBox(
                    height: Dimensions.getScreenHeight() * 0.25,
                    child: Column(
                      children: [
                        const Spacer(),
                        Center(
                          child: Text(
                              AppStrings.purchasedProducts_noProducts_text,
                              style: AppTextStyles.smallTitle()),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
