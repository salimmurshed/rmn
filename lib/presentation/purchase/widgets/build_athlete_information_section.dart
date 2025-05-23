import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/widgets/dialog/base_show_dialog.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../base/bloc/base_bloc.dart';
import '../../purchased_products/bloc/purchased_products_bloc.dart';
import 'build_athlete_membership_info_price.dart';

Container buildAthleteInformationSection({
  required List<String> matchedTeams,
  required List<Team> teams,
  required Athlete athlete,
  required bool isExpanded,
  required bool isOpened,
  required TextEditingController searchController,
  required TextEditingController otherTeamController,
  required GlobalKey<State<StatefulWidget>> dropDownKey,
  required String? selectedValue,
  required BuildContext context,
  required void Function(String, Athlete, List<Team>) onTapMatchedTeam,
  required void Function(String?)? typedChange,
  required void Function(bool) onMenuStateChange,
  required void Function(Athlete) openModalBottomSheetForOtherTeam,
  required void Function(
    String?,
  )? onChanged,
  required void Function()? onTapToExpand,
}) {
  return Container(
    height: 90.h,
    width: Dimensions.getScreenWidth() - 105.w,
    padding: EdgeInsets.only(left: 10.w),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                StringManipulation.combineFirstNameWithLastName(
                    firstName: athlete.firstName!, lastName: athlete.lastName!),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.subtitle(isOutFit: true, isBold: true),
              ),
            ),
            buildAthleteMembershipInfo(athlete.membership)
          ],
        ),
        Container(
          height: 20.h,
          margin: EdgeInsets.only(top: 5.h),
          child: Row(

            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IntrinsicWidth(
                child: Text(
                  athlete.team != null ? athlete.team!.name! : selectedValue ?? AppStrings.global_no_team,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.regularNeutralOrAccented(
                    color: AppColors.colorPrimaryNeutralText,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  if (athlete.team != null) {
                    buildBaseShowDialog(
                        title: Text(
                          AppStrings.dialog_athleteWithNoTeamChange_title,
                          style: AppTextStyles.dialogTitle(),
                        ),
                        isDivider: true,
                        body: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppStrings
                                    .dialog_athleteWithNoTeamChange_preceding_subtitle,
                                style: AppTextStyles.dialogSubtitle(),
                              ),
                              TextSpan(
                                text: athlete.team!.name!,
                                style: AppTextStyles.dialogSubtitle(
                                    isBold: true,
                                    color: AppColors.colorPrimaryInverseText),
                              ),
                              TextSpan(
                                text: AppStrings
                                    .dialog_athleteWithNoTeamChange_following_subtitle,
                                style: AppTextStyles.dialogSubtitle(),
                              ),
                            ],
                          ),
                        ));
                  } else {
                    buildCustomShowModalBottomSheetParent(
                        ctx: context,
                        isNavigationRequired: false,
                        child: BlocBuilder<PurchasedProductsBloc,
                            PurchasedProductsWithInitialState>(
                          bloc: BlocProvider.of<PurchasedProductsBloc>(
                              context)
                            ..add(
                                TriggerOpenBottomSheetForDownloadingPdf()),
                          builder: (context, state) {
                            return buildBottomSheetWithDropDown(
                              isInvoice: false,
                              context: context,
                              onRightTap: () {
                                if(onChanged != null) {
                                  onChanged(state.selectedTeam);
                                }
                                Navigator.pop(context);
                              },
                              onLeftTap: () {
                                Navigator.pop(context);
                              },
                              rightBtnLabel: AppStrings.btn_changeTeam,
                              leftBtnLabel: AppStrings.btn_cancel,
                              isCancelBtnRequired: true,
                              prompt: AppStrings
                                  .myPurchases_registration_teamReselection_bottomSheet_prompt,
                              textEditingController: state
                                  .textEditingController,
                              onMenuStateChange: (value) {
                                BlocProvider.of<PurchasedProductsBloc>(
                                    context)
                                    .add(TriggerDropdownExpand(
                                    isExpanded: value));
                              },
                              footerBtnLabel: AppStrings
                                  .myPurchases_bottomSheet_invoiceDownload_btn_text,
                              globalKey: state.globalKey,
                              highlightedTitle: AppStrings
                                  .global_empty_string,
                              hint: selectedValue ?? AppStrings
                                  .global_no_team,
                              isExpanded: state.isExpanded,
                              selectedValue: state.selectedTeam ,
                              title: AppStrings
                                  .myPurchases_registration_teamReselection_bottomSheet_title,
                              richText: RichText(
                                text: TextSpan(
                                  text: 'You may change the team for ',
                                  style: AppTextStyles.bottomSheetSubtitle(isOutfit: true),
                                  children: [
                                    TextSpan(
                                        text: ' ${StringManipulation
                                            .combineFirstNameWithLastName(
                                            firstName: athlete.firstName!,
                                            lastName: athlete.lastName!)} ',
                                        style: AppTextStyles.bottomSheetSubtitle(isOutfit: true,color: AppColors.colorPrimaryInverseText, isBold: true)),
                                    TextSpan(
                                        text: 'for the event, ',
                                        style: AppTextStyles.bottomSheetSubtitle(isOutfit: true,)),
                                    TextSpan(
                                        text: '${globalEventResponseData?.event?.title}',
                                        style: AppTextStyles.bottomSheetSubtitle(isOutfit: true, color: AppColors.colorPrimaryInverseText, isBold: true)),
                                    TextSpan(
                                        text: '.\nIf you change the team, all registrations for this athlete for this event will be changed.\n',
                                        style: AppTextStyles.bottomSheetSubtitle(isOutfit: true,)), TextSpan(
                                        text: 'Please select a team from the drop-down menu and confirm.\n',
                                        style: AppTextStyles.bottomSheetSubtitle(isOutfit: true,)),

                                  ],
                                ),
                              ),
                              items:
                              customDropDownMenuItems(
                                  items: state.teamNames),
                              onChanged: (value) {
                                BlocProvider.of<PurchasedProductsBloc>(
                                    context).add(
                                    TriggerInvoiceOrTeamSelection(
                                        teams: globalTeams,
                                        url:
                                        value ?? AppStrings
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
                  height: 15.h,
                  width: 18.w,
                  margin: EdgeInsets.only(left: 10.w, ),
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.r),
                      color: athlete.team != null
                          ? AppColors.colorBlueOpaque
                          : AppColors.colorSecondaryAccent),
                  child: SvgPicture.asset(AppAssets.icEdit),
                ),
              ),
              // if(athlete.team == null)
              //   dropDownForTeamSelection(
              //     otherTeamFocusNode: FocusNode(),
              //     isSmallSpace: true,
              //     onRightTap: () {},
              //     context: context,
              //     onChanged: onChanged,
              //     dropDownKey: dropDownKey,
              //     selectedValue: selectedValue,
              //     searchController: searchController,
              //     otherTeamController: otherTeamController,
              //   )
            ],
          ),
        ),
        const Spacer(),
        buildTotalRegistrationInfo(
            isFromEventList: false,
            rank: 0,
            isExpanded: isExpanded,
            isFromRegs: true,
            money: StringManipulation.addADollarSign(
                price: athlete.totalRegistrationDivisionCost!),
            isUpcoming: true,
            value: athlete.noOfRegistrations.toString(),
            onTapToOpenBottomSheet: onTapToExpand),
      ],
    ),
    // Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     buildARowOfAthleteNameAndTeamName(
    //       membership: athlete.membership,
    //         isOpened: isOpened,
    //         onMenuStateChange: onMenuStateChange,
    //         openModalBottomSheetForOtherTeam: openModalBottomSheetForOtherTeam,
    //         onTapMatchedTeam: onTapMatchedTeam,
    //         typedChange: typedChange,
    //         onChanged: onChanged,
    //         athlete: athlete,
    //         teams: teams,
    //         searchController: searchController,
    //         otherTeamController: otherTeamController,
    //         dropDownKey: dropDownKey,
    //         selectedValue: selectedValue,
    //         context: context),
    //
    //     if(athlete.team != null)
    //       GestureDetector(
    //         onTap: () {
    //           buildBaseShowDialog(title: Text(
    //             AppStrings.dialog_athleteWithNoTeamChange_title,
    //             style: AppTextStyles.dialogTitle(),
    //           ), isDivider: true,
    //               body: RichText(
    //                 text: TextSpan(
    //                   children: [
    //                     TextSpan(
    //                       text: AppStrings.dialog_athleteWithNoTeamChange_preceding_subtitle,
    //                       style: AppTextStyles.dialogSubtitle(),
    //                     ),  TextSpan(
    //                       text: athlete.team!.name!,
    //                       style: AppTextStyles.dialogSubtitle(isBold: true, color: AppColors.colorPrimaryInverseText),
    //                     ),
    //                     TextSpan(
    //                       text: AppStrings.dialog_athleteWithNoTeamChange_following_subtitle,
    //                       style: AppTextStyles.dialogSubtitle(),
    //                     ),
    //                   ],
    //                 ),
    //               )
    //           );
    //         },
    //         child: Container(
    //           height: 26.h,
    //           width: Dimensions.getScreenWidth() * 0.3,
    //           padding: EdgeInsets.symmetric(
    //             horizontal: 15.w,
    //           ),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(5.r),
    //             border: Border.all(
    //               color: AppColors.colorPrimaryNeutral,
    //             ),
    //             color: AppWidgetStyles.textFormFieldFillColor(),
    //           ),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               SvgPicture.asset(AppAssets.icDisableDropDown, height: 20),
    //               SizedBox(width: 8.w),
    //               Expanded(
    //                 child: Text(
    //                   athlete.team!.name!,
    //                   maxLines: 1,
    //                   overflow: TextOverflow.ellipsis,
    //                   style: AppTextStyles.textFormFieldELabelStyle(),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     if(athlete.team == null)
    //       Container(
    //         height: 26.h,
    //         child: dropDownForTeamSelection(
    //           otherTeamFocusNode: FocusNode(),
    //           isSmallSpace: true,
    //           onRightTap: () {},
    //           context: context,
    //           onChanged: onChanged,
    //           dropDownKey: dropDownKey,
    //           selectedValue: selectedValue,
    //           searchController: searchController,
    //           otherTeamController: otherTeamController,
    //         ),
    //       ),
    //     SizedBox(height: 10.h,),
    //     Row(
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: [
    //         Expanded(
    //             flex: 2,
    //             child: GestureDetector(
    //               onTap: onTapToExpand,
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(5.r),
    //                     color:AppColors.colorPrimary),
    //
    //                 padding: EdgeInsets.symmetric(
    //                   horizontal: 7.w,
    //                   vertical: 2.h,
    //                 ),
    //                 child: Row(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   children: [
    //                     RichText(
    //                       text: TextSpan(
    //                         children: [
    //                           TextSpan(
    //                             text:
    //                             AppStrings.athleteDetails_totalRegistration_title,
    //                             style: AppTextStyles.componentLabels(),
    //                           ),
    //                           TextSpan(
    //                             text: athlete.noOfRegistrations.toString(),
    //                             style: AppTextStyles.componentLabels(
    //                                 color: AppColors.colorPrimaryAccent),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     const Spacer(),
    //                     SvgPicture.asset(
    //                       AppAssets.icExpand,
    //                       height: 20.h,
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             )),
    //         SizedBox(width: 10.w),
    //         Text(
    //           StringManipulation.addADollarSign(
    //               price: athlete.totalRegistrationDivisionCost!),
    //           style: AppTextStyles.smallTitle(
    //             isOutFit: false,
    //             isBold: true,
    //             color: isExpanded
    //                 ? AppColors.colorPrimaryAccent
    //                 : AppColors.colorPrimaryInverseText,
    //           ),
    //         ),
    //       ],
    //     )
    //
    //   ],
    // ),
  );
}
