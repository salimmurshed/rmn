import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../imports/common.dart';

Widget buildLeadingForDivisionTile({
  required bool isExpanded,
  required int number,
  bool isSmall = false,
  required bool isParent,
}) {

  //  print('is $isParent $isSmall $number');
  // print('isExpanded: ${getWidth(isParent: isParent, isSmall: isSmall, isZero: number == 0)}');
  return SizedBox(
    width: getWidth(isParent: isParent, isSmall: isSmall, isZero: number == 0),
    child: Row(
      mainAxisAlignment: number == 0
          ? MainAxisAlignment.start
          : MainAxisAlignment.spaceBetween,
      children: [
        // if (isParent)
        //   Container(
        //     height: 27.h,
        //     width: 5.w,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10.r),
        //         color: AppColors.colorPrimaryAccent),
        //   ),
        if (number != 0)
          Container(
            margin: EdgeInsets.only(left: 8.w, right: 5),
            height: isSmall?20.h: 25.h,
            width:isSmall? 25.w: 30.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: isExpanded
                    ? AppColors.colorPrimaryAccent
                    : AppColors.colorPrimary),
            child: Center(
              child: Text(number.toString().padLeft(2, '0'),
                  style: isSmall? AppTextStyles.regularNeutralOrAccented(
                  ): AppTextStyles.smallTitle(
                    isOutFit: false,
                  )),
            ),
          ),
      ],
    ),
  );
}

double getWidth({required isSmall, required isParent, required isZero}) {
  if (isSmall) {
    if (isZero && isParent) {
      return 10.w;
    } else if (isZero && !isParent) {
      return 10.w;
    } else {
      return 40.w;
    }
  } else {
    if (isZero && isParent) {
      return 14.w;
    } else if (isZero && !isParent) {
      return 10.w;
    } else {
      return 50.w;
    }
  }
}
