
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Positioned buildPositionedForAgeWeight({
  required String age,
  required String weight,
}) {
  return Positioned(
    bottom: 0,
    right: 0,
    left: 0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ageWeightPlaceHolder(age, true),
        SizedBox(width: 2.w),
        ageWeightPlaceHolder(weight, false),

      ],
    ),
  );
}

Widget ageWeightPlaceHolder(String age, bool isAge) {
  return IntrinsicWidth(
    child: Container(
          height: 18.h,
          width: 35.w,
          //padding: EdgeInsets.symmetric(horizontal: 1.w),
          decoration: BoxDecoration(
              color: isAge?AppColors.colorPrimaryAccent: AppColors.colorSecondaryAccent,
              borderRadius: BorderRadius.circular(2.r)),
          child: Center(
            child: Text(
              age,
              maxLines: 1,
              style: TextStyle(
                  color: AppColors.colorPrimaryNeutralText,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700),

              // style: AppTextStyles.superSmallPrimary(
              //
              //     color: AppColors.colorPrimaryNeutralText),
            ),
          ),
        ),
  );
}
