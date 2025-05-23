import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';
import 'package:rmnevents/presentation/create_edit_profile/bloc/create_edit_profile_bloc.dart';
import '../../../imports/common.dart';

buildBottomSheetForNoTeamFound({
  required BuildContext context,
  required TextEditingController otherTeamController,
  required FocusNode otherTeamFocusNode,
  required void Function(String?)? onChanged,
  required void Function() onRightTap
}) {
  List<String> matchedTeams = [];
  otherTeamController.clear();
  buildCustomShowModalBottomSheetParent(
    ctx: context,
    isNavigationRequired: false,
    child: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Wrap(
          children: [
            Container(
              width: double.infinity,
              //padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: AppWidgetStyles.buildBoxDecorationForBottomSheet(),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(


                      children: [
                        SizedBox(
                          height: Dimensions.bottomSheetVerticalGap,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppWidgetStyles.buildTitleForBottomSheet(
                              isCentered: true,
                              isHighlightedTextBold: false,
                              isAccentedHighlight: false,
                              title: AppStrings.global_athleteRegistration_findOtherTeam_bottomSheet_title,
                              highlightedString: AppStrings.global_empty_string,
                            ),
                          ],
                        ),
                        customDivider(isBottomSheetTitle: true),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppWidgetStyles.buildBodyTextForBottomSheet(
                                bodyText: AppStrings.global_athleteRegistration_findOtherTeam_bottomSheet_subtitle,
                              ),
                              AppWidgetStyles.buildBodyTextForBottomSheet(
                                bodyText: AppStrings.global_athleteRegistration_findOtherTeam_bottomSheet_body,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30.h, bottom: 10.h),
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: AppColors.colorPrimaryAccent,
                          ),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: AppStrings.global_athleteRegistration_findOtherTeam_bottomSheet_warning_predecessor_text,
                                style: AppTextStyles.subtitle(),
                                children: [
                                  TextSpan(
                                    text: AppStrings.global_athleteRegistration_findOtherTeam_bottomSheet_warning_body_text,
                                    style: AppTextStyles.subtitle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        CustomTextFormFields(
                          maxLength: 7,
                          textInputType: TextInputType.name,
                          textEditingController: otherTeamController,
                          focusNode: otherTeamFocusNode,
                          label: AppStrings.textfield_addTeamName_label,
                          hint: AppStrings.textfield_addTeamName_hint,
                          isAsteriskPresent: true,
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                matchedTeams.clear();
                              } else {
                                matchedTeams = globalTeams
                                    .where((team) => team.name!.toLowerCase().contains(value.toLowerCase()))
                                    .map((team) => team.name!)
                                    .toList();
                              }
                            });
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        IntrinsicWidth(
                          child: Container(
                          
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              runSpacing: 4.w,
                              spacing: 2.w,
                              children: [
                                if(matchedTeams.isNotEmpty)
                                Text(
                                  AppStrings.global_athleteRegistration_findOtherTeam_bottomSheet_footer,
                                  style: AppTextStyles.regularPrimary(),
                                ),
                                if (matchedTeams.length > 3) ...[
                                  for (var i = 0; i < 3; i++) ...[
                                    GestureDetector(
                                      onTap: () {
                                        onChanged!(matchedTeams[i]);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: SizedBox(
                                        child: Text(
                                          '${matchedTeams[i]} ',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            decorationStyle: TextDecorationStyle.solid,
                                            decorationColor: AppColors.colorPrimaryNeutral,
                                            decorationThickness: 2,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.colorPrimaryNeutral,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                ] else ...[
                                  for (var i = 0; i < matchedTeams.length; i++) ...[
                                    GestureDetector(
                                      onTap: () {
                                        onChanged!(matchedTeams[i]);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        // otherTeamController.text = matchedTeams[i];
                                      },
                                      child: SizedBox(
                                        child: Text(
                                          '${matchedTeams[i]} ',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            decorationStyle: TextDecorationStyle.solid,
                                            decorationColor: AppColors.colorPrimaryNeutral,
                                            decorationThickness: 2,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.colorPrimaryNeutral,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                ]
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.screenVerticalGap),
                      ],
                    ),
                  ),
                  buildTwinButtons(
                    isActive: true,
                    leftBtnLabel: AppStrings.btn_back,
                    rightBtnLabel: AppStrings.btn_submit,
                    onLeftTap: () {
                      Navigator.pop(context);
                    },
                    onRightTap: (){
                      BlocProvider.of<CreateEditProfileBloc>(context).add(
                       TriggerTeamNameRequest(teamName: otherTeamController.text)
                      );
                    },
                  ),
                  SizedBox(
                    height: Dimensions.screenVerticalGap,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}