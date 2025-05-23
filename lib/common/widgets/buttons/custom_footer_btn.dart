import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Widget buildCustomLargeFooterBtn({
  required void Function() onTap,
  required String btnLabel,
  required bool hasKeyBoardOpened,
  required bool isColorFilledButton,
  bool isFromCancel = false,
  bool isTabButton = false,
  bool isActive = true,
  bool isSmallPaddingNeeded = false,
  Color? color,
}) {
  // Trigger onTap immediately if isFromCancel is true
  if (isFromCancel) {
    Future.delayed(Duration.zero, onTap);
  }

  return InkWell(
    splashColor: Colors.transparent,
    onTap: hasKeyBoardOpened
        ? () {
      FocusManager.instance.primaryFocus?.unfocus();
      onTap();
    }
        : onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.buttonBorderRadius),
        border: Border.all(
          color: color ?? (isColorFilledButton
              ? AppColors.colorSecondaryAccent
              : AppColors.colorPrimaryAccent),
        ),
        color: color ?? (isColorFilledButton
            ? (isActive
            ? AppColors.colorSecondaryAccent
            : AppColors.colorBlueOpaque)
            : Colors.transparent),
      ),
      margin: isSmallPaddingNeeded ? EdgeInsets.symmetric(horizontal: 15.w) : null,
      padding: EdgeInsets.all(8.r),
      child: Center(
        child: Text(
          btnLabel,
          style: AppTextStyles.buttonTitle(
            color: isColorFilledButton ? null : AppColors.colorPrimaryAccent,
          ),
        ),
      ),
    ),
  );
}
