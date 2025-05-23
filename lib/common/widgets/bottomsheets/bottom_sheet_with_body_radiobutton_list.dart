import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

buildBottomSheetWithBodyRadioButtonList({
  required BuildContext context,
  required String title,
  required String subtitle,
  required int groupValue,
  required void Function() onTapForRequest,
  required RequestTypeCombination requestTypeCombination,
  required void Function() onTapViewAccess,
  required void Function() onTapCoachAccess,
  required void Function() onTapOwnerAccess,
  required String athleteName,
}) {
  buildCustomShowModalBottomSheetParent(
    ctx: context,
    isNavigationRequired: false,
    child: StatefulBuilder(builder: (context, state) {
      return customBottomSheetBasicBody(title: title,
          highLightedAthleteName: athleteName,
          isAccentedHighlight: true,
          isSingeButtonPresent: true,
          isButtonPresent: true,
          widget: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                ...buildRadioButtonList(
                    onTapCoachAccess: () {
                      onTapCoachAccess();
                      state(() {
                        groupValue = 3;
                      });
                    },
                    onTapOwnerAccess: () {
                      onTapOwnerAccess();
                      state(() {
                        groupValue = 2;
                      });
                    },
                    onTapViewAccess: () {
                      onTapViewAccess();
                      state(() {
                        groupValue = 1;
                      });
                    },
                    groupValue: groupValue,
                    requestTypeCombination: requestTypeCombination),
              ],
            ),
          ),
          onLeftButtonPressed: (){},
          leftButtonText: AppStrings.global_empty_string,
          onRightButtonPressed: (){},
          rightButtonText: AppStrings.global_empty_string,
          context: context,
          singleButtonFunction: onTapForRequest,
          footerNote: subtitle,
          singleButtonText: AppStrings.btn_request,
          isActive: true,
          isSingleButtonColorFilled: true);

    }),
  );
}

List<Widget> buildRadioButtonList({required int groupValue,
  required void Function() onTapViewAccess,
  required void Function() onTapCoachAccess,
  required void Function() onTapOwnerAccess,
  required RequestTypeCombination requestTypeCombination}) {
  switch (requestTypeCombination) {
    case RequestTypeCombination.all:
      return [
        radioButtonWithTitleAndDescription(
          onTap: onTapViewAccess,
          value: 1,
          groupValue: groupValue,
          title: AppStrings.radio_viewAccess,
          description:
          AppStrings.myAthletes_request_viewAccess_description_text,
        ),
        radioButtonWithTitleAndDescription(
          onTap: onTapCoachAccess,
          value: 3,
          groupValue: groupValue,
          title: AppStrings.radio_coachAccess,
          description:
          AppStrings.myAthletes_request_coachAccess_description_text,
        ),
        radioButtonWithTitleAndDescription(
          onTap: onTapOwnerAccess,
          value: 2,
          groupValue: groupValue,
          title: AppStrings.radio_ownerAccess,
          description:
          AppStrings.myAthletes_request_ownerAccess_description_text,
        ),

      ];
    case RequestTypeCombination.coachOwner:
      return [
        radioButtonWithTitleAndDescription(
          onTap: onTapCoachAccess,
          value: 3,
          groupValue: groupValue,
          title: AppStrings.radio_coachAccess,
          description:
          AppStrings.myAthletes_request_coachAccess_description_text,
        ),
        radioButtonWithTitleAndDescription(
          onTap: onTapOwnerAccess,
          value: 2,
          groupValue: groupValue,
          title: AppStrings.radio_ownerAccess,
          description:
          AppStrings.myAthletes_request_ownerAccess_description_text,
        ),
      ];

    case RequestTypeCombination.ownerOnly:
      return [
        radioButtonWithTitleAndDescription(
          onTap: onTapOwnerAccess,
          value: 2,
          groupValue: groupValue,
          title: AppStrings.radio_ownerAccess,
          description:
          AppStrings.myAthletes_request_ownerAccess_description_text,
        ),
      ];
  }
}

Widget radioButtonWithTitleAndDescription({required String title,
  required String description,
  required int value,
  required int groupValue,
  required void Function() onTap}) {
  return IntrinsicHeight(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.bottomSheetBodyStyleTabPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.colorPrimary,
          borderRadius: BorderRadius.circular(
            Dimensions.textFormFieldBorderRadius,
          ),
          border: Border.all(color: AppColors.colorTertiary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio(
                  value: value,
                  groupValue: groupValue,
                  fillColor: AppWidgetStyles.radioButtonFillColor(),
                  focusColor: AppColors.colorPrimaryAccent,
                  onChanged: (value) {
                    onTap();
                  },
                ),
                Text(title, style: AppTextStyles.smallTitle()),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                description,
                style: AppTextStyles.textFormFieldEHintStyle(),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
