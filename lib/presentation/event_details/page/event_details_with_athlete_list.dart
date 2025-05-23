import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/data/models/arguments/athlete_argument.dart';
import 'package:rmnevents/imports/common.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';
import 'package:rmnevents/presentation/purchase/bloc/purchase_bloc.dart';
import 'package:rmnevents/presentation/register_and_sell/bloc/register_and_sell_bloc.dart';

import '../../../common/widgets/bottomsheets/build_bottomSheet_body_for_otherTeam.dart';
import '../../../common/widgets/dialog/base_show_dialog.dart';
import '../../../imports/data.dart';
import '../../../root_app.dart';
import '../../base/bloc/base_bloc.dart';
import '../../purchased_products/bloc/purchased_products_bloc.dart';

class EventDetailsWithAthleteList extends StatefulWidget {
  const EventDetailsWithAthleteList({super.key});

  @override
  State<EventDetailsWithAthleteList> createState() =>
      _EventDetailsWithAthleteListState();
}

class _EventDetailsWithAthleteListState
    extends State<EventDetailsWithAthleteList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailsBloc, EventDetailsWithInitialState>(
      builder: (context, state) {
        return customScaffold(
            persistentFooterButtons: [
              if (state.selectedAgeGroup != null) ...[
                if (state.athleteSelectionTabs ==
                    AthleteSelectionTabs.selectedAthletes)
                  if (state.selectedAgeGroup!.selectedAthletes!.isNotEmpty)
                    buildCustomLargeFooterBtn(
                        onTap: () {
                          BlocProvider.of<EventDetailsBloc>(context).add(
                              TriggerAddToExpansionPanel(
                                  ageGroup: state.selectedAgeGroup!));
                          Navigator.pop(context);
                        },

                        btnLabel:state.selectedAgeGroup!.needUpdate == null?
                           'Add to Cart': 'Update Cart',
                        hasKeyBoardOpened: false,
                        isColorFilledButton: true),
              ]
            ],
            hasForm: false,
            customAppBar: CustomAppBar(
                goBack: () {
                  BlocProvider.of<EventDetailsBloc>(context)
                      .add(const TriggerRemoveUnConfirmAthlates());
                },
                isNeededForCustomWidget: false,
                customActionWidget:
                    context.read<PurchaseBloc>().state.couponModule ==
                            CouponModules.employeeRegistration
                        ? null
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.buttonBorderRadius),
                                color: AppColors.colorSecondaryAccent),
                            child: Center(
                                child: Text(
                              AppStrings.profile_createAthlete_btn_text,
                              style: AppTextStyles.buttonTitle(),
                            )),
                          ),
                appBarActionFunction: () {
                  Navigator.pushNamed(
                    context,
                    AppRouteNames.routeCreateOrEditAthleteProfile,
                    arguments: AthleteArgument(
                        createProfileType: context
                                    .read<PurchaseBloc>()
                                    .state
                                    .couponModule ==
                                CouponModules.employeeRegistration
                            ? CreateProfileTypes.createAthleteLocallyFromRegs
                            : CreateProfileTypes
                                .addAthleteFromRegistrationSelection),
                  );
                },
                title: state.selectedAgeGroup?.title ??
                    AppStrings.global_empty_string,
                isLeadingPresent: true),
            formOrColumnInsideSingleChildScrollView: null,
            anyWidgetWithoutSingleChildScrollView: state.isLoading
                ? CustomLoader(
                    child: Container(),
                  )
                : buildTabViewLayOut(context, state));
      },
    );
  }

  Column buildTabViewLayOut(
      BuildContext context, EventDetailsWithInitialState state) {
    return Column(
      children: [
        Text(AppStrings.eventRegistration_athleteSelection_intro_text,
            style: AppTextStyles.smallTitle()),
        SizedBox(
          height: Dimensions.generalGap,
        ),
        buildCustomTabBar(isScrollRequired: false, tabElements: [
          TabElements(
              title: 'Selected Athletes',
              count: state.selectedAgeGroup?.selectedAthletes?.length ?? 0,
              onTap: () {
                BlocProvider.of<EventDetailsBloc>(context).add(
                    const TriggerSwitchBetweenAthleteSelectionsTab(
                        athleteSelectionTabs:
                            AthleteSelectionTabs.selectedAthletes));
              },
              isSelected: state.athleteSelectionTabs ==
                  AthleteSelectionTabs.selectedAthletes),
          TabElements(
              title: 'Your Athletes',
              count: state.selectedAgeGroup?.availableAthletes?.length ?? 0,
              onTap: () {
                BlocProvider.of<EventDetailsBloc>(context).add(
                    const TriggerSwitchBetweenAthleteSelectionsTab(
                        athleteSelectionTabs:
                            AthleteSelectionTabs.yourAthletes));
              },
              isSelected: state.athleteSelectionTabs ==
                  AthleteSelectionTabs.yourAthletes),
        ]),
        if (!state.isLoading) ...[
          SizedBox(
            height: Dimensions.generalGap,
          ),
          if (state.eventWiseAthletes.isEmpty)
            ...messageForNoAthletes(context)
          else
            ...messageForUnSelectedAndNoMatchFound(state, context),
          if (state.selectedAgeGroup != null)
            buildListOfAthletes(
                assetUrl: state.assetUrl,
                ageGroup: state.selectedAgeGroup!,
                athleteSelectionTabs: state.athleteSelectionTabs,
                athletes: state.athleteSelectionTabs ==
                        AthleteSelectionTabs.selectedAthletes
                    ? state.selectedAgeGroup!.selectedAthletes!
                    : state.selectedAgeGroup!.availableAthletes!),
        ]
      ],
    );
  }

  List<Widget> messageForUnSelectedAndNoMatchFound(
      EventDetailsWithInitialState state, BuildContext context) {
    return [
      if (state.athleteSelectionTabs == AthleteSelectionTabs.selectedAthletes)
        if (state.selectedAgeGroup!.selectedAthletes!.isEmpty)
          buildMessageWithButton(context: context, isNoAthlete: false),
      if (state.athleteSelectionTabs == AthleteSelectionTabs.yourAthletes)
        if (state.selectedAgeGroup!.availableAthletes!.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Dimensions.getScreenHeight() * .25,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppStrings
                      .eventWiseAthleteRegistration_yourAthleteEmptyList_title,
                  style: AppTextStyles.smallTitleForEmptyList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  AppStrings
                      .eventWiseAthleteRegistration_yourAthleteEmptyList_subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle(isOutFit: false),
                ),
              ),
            ],
          ),
    ];
  }

  Column buildMessageWithButton(
      {required BuildContext context, required bool isNoAthlete}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: Dimensions.getScreenHeight() * .25,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            isNoAthlete
                ? AppStrings.eventWiseAthleteRegistration_athleteEmptyList_text
                : AppStrings
                    .eventWiseAthleteRegistration_selectedAthleteEmptyList_text,
            style: AppTextStyles.smallTitleForEmptyList(),
          ),
        ),
        SizedBox(height: Dimensions.generalGapSmall),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.w),
          child: buildCustomLargeFooterBtn(
              isSmallPaddingNeeded: true,
              onTap: () {
                if (isNoAthlete) {
                  Navigator.pushNamed(
                    context,
                    AppRouteNames.routeCreateOrEditAthleteProfile,
                    arguments: AthleteArgument(
                        createProfileType:
                            context.read<PurchaseBloc>().state.couponModule ==
                                    CouponModules.employeeRegistration
                                ? CreateProfileTypes.createAthleteLocally
                                : CreateProfileTypes
                                    .addAthleteFromRegistrationSelection),
                  );
                } else {
                  BlocProvider.of<EventDetailsBloc>(context).add(
                      const TriggerSwitchBetweenAthleteSelectionsTab(
                          athleteSelectionTabs:
                              AthleteSelectionTabs.yourAthletes));
                }
              },
              btnLabel: isNoAthlete
                  ? AppStrings.btn_addAthlete
                  : AppStrings.btn_selectAthlete,
              hasKeyBoardOpened: false,
              isColorFilledButton: true),
        ),
      ],
    );
  }

  List<Widget> messageForNoAthletes(BuildContext context) {
    return [
      buildMessageWithButton(context: context, isNoAthlete: true),
    ];
  }

  Widget buildListOfAthletes(
      {required AthleteSelectionTabs athleteSelectionTabs,
      required List<Athlete> athletes,
      required String assetUrl,
      required AgeGroups ageGroup}) {
    return Expanded(
        child: GridView.builder(
            itemBuilder: (context, index) {
              List<Map<TypeOfMetric, String>> metricKeyValuePairs = [
                {
                  TypeOfMetric.noOfEvents:
                      (athletes[index].noUpcomningEvents ?? 0).toString()
                },
                {
                  TypeOfMetric.rank: (athletes[index].rank ??
                          athletes[index].rankReceived ??
                          0)
                      .toString()
                },
                {TypeOfMetric.award: (athletes[index].awards ?? 0).toString()},
                {
                  TypeOfMetric.weight: (athletes[index].weightClass ??
                          athletes[index].weight ??
                          '')
                      .toString()
                },
                {TypeOfMetric.age: (athletes[index].age ?? '').toString()}
              ];
              String profileImage = athletes[index].profileImage ??
                  AppStrings.global_empty_string;
              if (profileImage.isNotEmpty && !profileImage.contains('http')) {
                profileImage = assetUrl + profileImage;
              }
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                decoration: BoxDecoration(
                    color: AppColors.colorTertiary,
                    borderRadius:
                        BorderRadius.circular(Dimensions.generalRadius)),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          buildCustomImagePlaceHolder(
                              onTapImage: () {},
                              sizeType: SizeType.medium,
                              imageUrl: profileImage,
                              userStatus: athletes[index].userStatus ??
                                  AppStrings.global_empty_string,
                              seasons: globalSeasons,
                              // athleteId: athleteId,
                              // teams: teams,
                              membership: athletes[index].membership),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List<Widget>.generate(
                                  metricKeyValuePairs.length,
                                  (i) => Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      metrics(
                                          context: context,
                                          sizeType: SizeType.medium,
                                          typeOfMetric: TypeOfMetric.values[i],
                                          athleteFirstName:
                                              athletes[index].firstName!,
                                          athleteLastName:
                                              athletes[index].lastName!,
                                          metricValue: metricKeyValuePairs[i]
                                              .values
                                              .first
                                              .toString()),
                                      if (i < 2) ...[
                                        SizedBox(height: 3.h),
                                        // dividerLine(sizeType: sizeType),
                                      ] else if (i == 2) ...[
                                        dividerLine(sizeType: SizeType.medium),
                                      ] else if (i == 3) ...[
                                        SizedBox(height: 3.h),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(AppAssets.icPerson,
                                height: 15.h, width: 15.w),
                            SizedBox(
                              width: 5.w,
                            ),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.only(right: 10.w, top: 0),
                              child: Text(
                                StringManipulation.combineFirstNameWithLastName(
                                    firstName: athletes[index].firstName!,
                                    lastName: athletes[index].lastName!),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.subtitle(isOutFit: false),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: Dimensions.getScreenWidth(),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Dimensions.getScreenWidth() * 0.3,
                                child: Text(
                                  athletes[index].selectedTeam?.name ??
                                      athletes[index].team?.name ??
                                      AppStrings.global_no_team,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.regularPrimary(
                                      color: AppColors.colorPrimaryNeutral,
                                      isOutFit: true),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (athletes[index].team != null) {
                                    buildBaseShowDialog(
                                        title: Text(
                                          AppStrings
                                              .dialog_athleteWithNoTeamChange_title,
                                          style: AppTextStyles.dialogTitle(),
                                        ),
                                        isDivider: true,
                                        body: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: AppStrings
                                                    .dialog_athleteWithNoTeamChange_preceding_subtitle,
                                                style: AppTextStyles
                                                    .dialogSubtitle(),
                                              ),
                                              TextSpan(
                                                text:
                                                    athletes[index].team!.name!,
                                                style: AppTextStyles.dialogSubtitle(
                                                    isBold: true,
                                                    color: AppColors
                                                        .colorPrimaryInverseText),
                                              ),
                                              TextSpan(
                                                text: AppStrings
                                                    .dialog_athleteWithNoTeamChange_following_subtitle,
                                                style: AppTextStyles
                                                    .dialogSubtitle(),
                                              ),
                                            ],
                                          ),
                                        ));
                                  } else {
                                    buildCustomShowModalBottomSheetParent(
                                        ctx: context,
                                        isNavigationRequired: false,
                                        child: BlocBuilder<
                                            PurchasedProductsBloc,
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
                                                BlocProvider.of<PurchaseBloc>(
                                                        context)
                                                    .add(
                                                        TriggerDropDownSelection(
                                                  selectedValue:
                                                      state.selectedTeam,
                                                  athlete: athletes[index],
                                                  teams: globalTeams,
                                                ));
                                                Navigator.pop(context);
                                              },
                                              onLeftTap: () {
                                                Navigator.pop(context);
                                              },
                                              rightBtnLabel:
                                                  AppStrings.btn_changeTeam,
                                              leftBtnLabel:
                                                  AppStrings.btn_cancel,
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
                                              highlightedTitle: AppStrings
                                                  .global_empty_string,
                                              hint: athletes[index]
                                                      .selectedTeam
                                                      ?.name ??
                                                  AppStrings.global_no_team,
                                              isExpanded: state.isExpanded,
                                              selectedValue: state.selectedTeam ?? athletes[index].selectedTeam?.name ?? AppStrings.global_no_team,
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
                                                            ' ${StringManipulation.combineFirstNameWithLastName(firstName: athletes[index].firstName!, lastName: athletes[index].lastName!)} ',
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
                                                            '${globalEventResponseData?.event?.title}',
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
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: athletes[index].team != null ? AppColors.colorBlueOpaque:
                                    AppColors.colorSecondaryAccent,
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
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<EventDetailsBloc>(context).add(
                                TriggerResetStyleIndex(
                                    ageGroup: ageGroup,
                                    athlete: athletes[index]));
                            buildCustomShowModalBottomSheetParent(
                                ctx: context,
                                isNavigationRequired: false,
                                child: BlocBuilder<EventDetailsBloc,
                                    EventDetailsWithInitialState>(
                                  builder: (context, state) {
                                    return buildBottomSheetWithBodyCheckboxList(
                                        disclaimer: state
                                                .selectedAgeGroup
                                                ?.styles?[state.styleIndex]
                                                .disclaimer ??
                                            AppStrings.global_empty_string,
                                        isCheckListForWeightClass: true,
                                        styles: athletes[index].athleteStyles!,
                                        context: context,
                                        athleteImageUrl: athletes[index].profileImage ??
                                            AppStrings.global_empty_string,
                                        athleteAge:
                                            athletes[index].age.toString(),
                                        athleteWeight: athletes[index]
                                            .weightClass
                                            .toString(),
                                        athleteNameAsTheTitle:
                                            StringManipulation.combineFirstNameWithLastName(
                                                firstName:
                                                    athletes[index].firstName!,
                                                lastName:
                                                    athletes[index].lastName!),
                                        listOfStyleTitles: athletes[index]
                                            .athleteStyles!
                                            .map((e) => e.style!)
                                            .toList(),
                                        listOfAllOptions:
                                            athletes[index].athleteStyles?[state.styleIndex].division?.availableWeightsPerStyle ??
                                                [],
                                        listOfAllSelectedOption: athletes[index]
                                            .athleteStyles![state.styleIndex]
                                            .temporarilySelectedWeights!,
                                        listOfAllRegisteredOptions:
                                            athletes[index].athleteStyles![state.styleIndex].registeredWeights ??
                                                [],
                                        selectedStyleIndex: state.styleIndex,
                                        weightClass: athletes[index]
                                            .athleteStyles![state.styleIndex]
                                            .division
                                            ?.weightClasses,
                                        selectStyle: (styleIndex) {
                                          BlocProvider.of<EventDetailsBloc>(
                                                  context)
                                              .add(TriggerSelectStyleIndex(
                                            index: styleIndex,
                                          ));
                                        },
                                        isUpdateWCInactive: false,
                                        isFromPurchaseHistory: false,
                                        onTapToSelectTile: (indexForWeight) {
                                          BlocProvider.of<EventDetailsBloc>(
                                                  context)
                                              .add(
                                                  TriggerWCSelectionTemporarily(
                                            divisionType: state.divisionsTypes[
                                                state.parentIndex],
                                            athleteSelectionTabs:
                                                athleteSelectionTabs,
                                            ageGroup: state.selectedAgeGroup!,
                                            weightIndex: indexForWeight,
                                            athlete: athletes[index],
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
                          child: athletes[index].chosenWCs!.isEmpty
                              ? buildSelectedWeights(
                                  athletes, index, athleteSelectionTabs)
                              : IntrinsicWidth(
                                  child: buildSelectedWeights(
                                      athletes, index, athleteSelectionTabs),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio:
                  athleteSelectionTabs == AthleteSelectionTabs.selectedAthletes
                      ? (isTablet ? 0.85 : 0.76)
                      : (isTablet ? 0.96 : 0.76),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: athletes.length));
  }

  Widget buildSelectedWeights(List<Athlete> athletes, int index,
      AthleteSelectionTabs athleteSelectionTabs) {
    return athletes[index].chosenWCs!.isEmpty?
      ClipRRect(
      borderRadius: BorderRadius.circular(5.r),
      child: Container(
         margin: EdgeInsets.only(top: Dimensions.generalGapSmall),
        height: 20.h,
        decoration: BoxDecoration(
          color:athletes[index].chosenWCs!.isEmpty? AppColors.colorSecondaryAccentAlternative:
          Colors.black,
          borderRadius: BorderRadius.circular(5.r), // Ensure rounding applies
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: selectedWeightWhenEmpty(athletes, index, athleteSelectionTabs),
          ),
        ),
      ),
    ):
    Container(
      margin: EdgeInsets.only(top: Dimensions.generalGapSmall),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.colorPrimary,
        borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius),
        border: Border.all(
          color: AppColors.colorPrimaryInverse
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(AppAssets.icUpdatedWc,
          ),
          SizedBox(width: 5.w,),
          Expanded(
            child: Text(
              athletes[index].chosenWCs!.isEmpty
                  ? 'Select Weight Classes'
                  : athleteSelectionTabs ==
                  AthleteSelectionTabs.selectedAthletes
                  ? athletes[index]
                  .athleteStyles!
                  .map((e) => e.temporarilySelectedWeights!.join(', '))
                  .join(', ')
                  .replaceAll(RegExp(r',\s*$'), '')
                  : athletes[index].chosenWCs!.length == 1
                  ? athletes[index].chosenWCs![0]
                  : athletes[index].chosenWCs!.join(', '),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextStyles.regularPrimary(
                  color: AppColors.colorPrimaryInverseText,
                  isOutFit: false),
            ),
          ),
          SvgPicture.asset(
            AppAssets.icForwardArrow,
            height: 15.h,
            width: 15.w,
          ),
        ],
      ),
    )
    ;
  }

  Container selectedWeightWhenEmpty(List<Athlete> athletes, int index, AthleteSelectionTabs athleteSelectionTabs) {
    return Container(

            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
            decoration: BoxDecoration(
                color: athletes[index].chosenWCs!.isEmpty
                    ? AppColors.colorSecondaryAccent
                    : Colors.black87,
                borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    athletes[index].chosenWCs!.isEmpty
                        ? 'Select Weight Classes'
                        : athleteSelectionTabs ==
                                AthleteSelectionTabs.selectedAthletes
                            ? athletes[index]
                                .athleteStyles!
                                .map((e) => e.temporarilySelectedWeights!.join(', '))
                                .join(', ')
                                .replaceAll(RegExp(r',\s*$'), '')
                            : athletes[index].chosenWCs!.length == 1
                                ? athletes[index].chosenWCs![0]
                                : athletes[index].chosenWCs!.join(' '),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.regularPrimary(
                        color: athletes[index].chosenWCs!.isEmpty
                            ? AppColors.colorPrimaryInverseText
                            : AppColors.colorPrimaryAccent,
                        isOutFit: false),
                  ),
                ),
                SvgPicture.asset(
                  AppAssets.icForwardArrow,
                  height: 15.h,
                  width: 15.w,
                ),
              ],
            ),
          );
  }

  bool checkISRegistrationApplied(List<WeightClass> weightClasses) {
    return weightClasses.any((e) => e.maxRegistration != null);
  }

  List<WeightClass>? getAthlate(List<Athlete> athlate, int parent, int style) {
    print('parent is $parent');
    print('style is $style');
    return athlate[parent].athleteStyles?[style].division?.weightClasses;
  }
}
