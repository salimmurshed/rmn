import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Container buildAthleteMetrics({required String iconUrl, required String info}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: Dimensions.generalGap,
      vertical: 5.h,
    ),
    decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
        border: Border.all(
          color: Colors.blue,
        ),
        color: AppColors.colorSecondaryAccent),
    child: Row(
      children: [
        SizedBox(
          height: 16.h,
          width: 16.w,
          child: SvgPicture.asset(
            fit: BoxFit.cover,
            iconUrl,
            colorFilter:
                ColorFilter.mode(AppColors.colorPrimaryInverse, BlendMode.srcIn),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Text(
          info,
          style: AppTextStyles.largeTitle(),
        ),
      ],
    ),
  );
}
