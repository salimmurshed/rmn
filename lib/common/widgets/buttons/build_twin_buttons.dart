import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../imports/common.dart';

Container buildTwinButtons({
  required void Function() onLeftTap,
  required void Function() onRightTap,
  required String leftBtnLabel,
  required String rightBtnLabel,
  required bool isActive,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10.w),
    child: Row(
      children: [
        Expanded(
          child: buildBtn(
              onTap: onLeftTap,
              btnLabel: leftBtnLabel,
              isColorFilledButton: false,
              isActive: isActive),
        ),
        SizedBox(
          width: 15.w,
        ),
        Expanded(
          child: buildBtn(
              onTap: onRightTap,
              btnLabel: rightBtnLabel,
              isColorFilledButton: true,
              isActive: isActive),
        )
      ],
    ),
  );
}

InkWell buildBtn({
  required void Function() onTap,
  required String btnLabel,
  bool hasHeight = false,
  required bool isColorFilledButton,
  required bool isActive,
  String? iconName, // Optional argument for specifying the image/icon name
}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap: onTap,
    child: Container(
      height: hasHeight ? 40.h : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.r),
        border: Border.all(
            color: isColorFilledButton
                ? AppColors.colorBlueOpaque
                : AppColors.colorPrimaryAccent),
        color: isColorFilledButton
            ? (isActive
            ? AppColors.colorSecondaryAccent
            : AppColors.colorBlueOpaque)
            : Colors.transparent,
      ),
      padding: EdgeInsets.all(5.r),
      child: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Text(
                btnLabel,
                style: AppTextStyles.buttonTitle(
                    color: isColorFilledButton ? null : AppColors.colorPrimaryAccent),
              ),
            if (iconName != null) ...[
              const SizedBox(width: 4),
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: SvgPicture.asset(AppAssets.icGoToLink),
              ),
            ]
          ],
        ),
      ),
    ),
  );
}