
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

Padding buildBottomSheetBodyForFindingOtherTeam({
  required BuildContext context,
  required TextEditingController otherTeamController,
  required void Function(String, Athlete, List<Team>) onTapMatchedTeam,
  required void Function(String?)? typedChange,
  required Athlete athlete,
  required List<Team> teams,
  required List<String> matchedTeams,

}) {
  return Padding(
    padding:
    EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    child: Wrap(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimensions.bottomSheetRadius)),
                color: AppColors.colorPrimary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppWidgetStyles.buildTitleForBottomSheet(
                    title: AppStrings
                        .global_athleteRegistration_findOtherTeam_bottomSheet_title,
                    highlightedString: AppStrings.global_empty_string),
                customDivider(isBottomSheetTitle: true),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      AppStrings
                          .global_athleteRegistration_findOtherTeam_bottomSheet_subtitle,
                      textAlign: TextAlign.left,
                      style: AppTextStyles.subtitle()),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      AppStrings
                          .global_athleteRegistration_findOtherTeam_bottomSheet_body,
                      textAlign: TextAlign.left,
                      style: AppTextStyles.subtitle()),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimaryAccent,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: AppStrings
                          .global_athleteRegistration_findOtherTeam_bottomSheet_warning_predecessor_text,
                      style: AppTextStyles.subtitle(isBold: true),
                      children: [
                        TextSpan(
                          text: AppStrings
                              .global_athleteRegistration_findOtherTeam_bottomSheet_warning_body_text,
                          style: AppTextStyles.subtitle(
                            color: AppColors.colorPrimaryInverseText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    buildCustomLabel(
                      label:
                      AppStrings.profile_createEditAthlete_dropDown_label,
                      isAsteriskPresent: true,
                    ),
                  ],
                ),
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.colorTertiary,
                  ),
                  padding: EdgeInsets.all(5.r),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: otherTeamController,
                    onChanged: typedChange,
                    cursorColor: AppWidgetStyles.textFormCursorColor(),
                    style: AppTextStyles.textFormFieldELabelStyle(),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        top: 8.h,
                      ),
                      hintText: AppStrings
                          .eventDetails_athleteRegistration_team_textField_hint,
                      enabled: true,
                      hintStyle: AppTextStyles.textFormFieldEHintStyle(),
                      // focusedBorder: AppWidgetStyles.textFormFieldFocusedBorder(),
                      // enabledBorder: AppWidgetStyles.textFormFieldEnabledBorder(),
                    ),
                  ),
                ),
                if (matchedTeams.isNotEmpty)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        Text(
                          AppStrings
                              .global_athleteRegistration_findOtherTeam_bottomSheet_footer,
                          style: AppTextStyles.normalPrimary(),
                        ),
                        for (String team in matchedTeams)
                          GestureDetector(
                            onTap: () {
                              onTapMatchedTeam(team, athlete, teams);
                            },
                            child: Text('$team ',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                  decorationStyle: TextDecorationStyle.solid,
                                  fontFamily: AppFontFamilies.outfit,
                                  fontWeight:
                                  AppFontWeight.normalWeightedOutFitLight,
                                  fontSize: AppFontSizes.normal,
                                  color: AppColors.colorDisabled,
                                )),
                          ),
                      ],
                    ),
                  ),

              ],
            ),

          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 20.h),
            child: buildTwinButtons(
                onLeftTap: () {
                  Navigator.pop(context);
                },
                onRightTap: () {},
                leftBtnLabel: 'Back',
                rightBtnLabel: 'Submit',
                isActive: otherTeamController.text.isNotEmpty))
      ],
    ),
  );
}