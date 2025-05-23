import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Widget createAthleteDropdown(
    {required TextEditingController searchController,
    required BuildContext context,
    void Function(String?)? onChanged,
    required GlobalKey<State<StatefulWidget>> dropDownKey,
    required bool showLabel,
      String? gradeError,
    required DropDownTypeForCreateAthlete dropDownType,
    bool isSmallSpace = false,
    required String? selectedValue,
    required TextEditingController otherTeamController,
    required FocusNode otherTeamFocusNode,
      bool isAsteriskPresent = true,
    required void Function() onRightTap}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (showLabel)
        buildCustomLabel(
          label: dropDownType == DropDownTypeForCreateAthlete.gradeSelection
              ? AppStrings.profile_createEditAthlete_dropDownGrade_label
              : AppStrings.profile_createEditAthlete_dropDown_label,
          isAsteriskPresent: isAsteriskPresent,
        ),
      SizedBox(
        width: null,
        child: dropDownForTeamSelection(
          dropDownType: dropDownType,
          dropDownKey: dropDownKey,
          searchController: searchController,
          context: context,
          onChanged: onChanged,
          gradeError: gradeError,
          isSmallSpace: isSmallSpace,
          selectedValue: selectedValue,
          otherTeamController: otherTeamController,
          otherTeamFocusNode: otherTeamFocusNode,
          onRightTap: onRightTap,
        ),
      ),
      if(gradeError != null)
        Padding(
          padding: EdgeInsets.only(top: 3.h, left: 10.w),
          child: Text(gradeError, style: AppTextStyles.textFormFieldErrorStyle()),
        ),
    ],
  );
}


