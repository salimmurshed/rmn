import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Widget customEventFilterButton(
    {required void Function() filterOnFunction,
      required bool isFilterOn}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap: filterOnFunction,
    child: Container(
      // height: 39.h,
      width: 42.w,
      padding: EdgeInsets.all(9.r),
      decoration: BoxDecoration(
        color: isFilterOn
            ? AppColors.colorPrimaryAccent
            : AppColors.colorSecondary,
        border: Border.all(color: AppColors.colorTertiary),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: !isFilterOn? SvgPicture.asset(
        AppAssets.icFilter,
      ): Icon(
        Icons.all_inclusive,
        color: AppColors.colorPrimaryNeutralText,
      ),
    ),
  );
}