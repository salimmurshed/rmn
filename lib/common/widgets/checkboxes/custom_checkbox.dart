import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Widget buildCustomCheckbox(
    {void Function(bool?)? onChanged,
    bool isDisabled = false,
      bool isSmall = false,
    required bool isChecked}) {
  return Theme(
    data: ThemeData(
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(
          color: AppColors.colorPrimaryAccent,
          width: 2,
        ),
        fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.colorDisabledPrimaryAccent;
          }
          return Colors.transparent;
        }),
        overlayColor: WidgetStateProperty.all(AppColors.colorDisabledPrimaryAccent), // This is key!
      ),
    ),
    child: SizedBox(
      height: isSmall? 12.h: Dimensions.authenticationCheckBoxHeight,
      width: isSmall? 15.w: 30.w,
      child: Center(
        child: Checkbox(
          value: isChecked,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          checkColor: AppColors.colorPrimaryInverse,
          onChanged: isDisabled ? null : onChanged,
          activeColor: isDisabled ? AppColors.colorDisabledPrimaryAccent : AppColors.colorPrimaryAccent,
        ),
      ),
    ),
  );
}
