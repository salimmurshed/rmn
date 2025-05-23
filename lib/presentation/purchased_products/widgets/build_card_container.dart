import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Container buildCardContainer({required List<Widget> children, bool isBig=true}) {
  return Container(
    width: double.infinity,
    height: isBig?100.h:90.h
    ,
    decoration: BoxDecoration(
        color: AppColors.colorSecondary,
        borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius)),
    padding: EdgeInsets.symmetric(
      horizontal: 5.w,
      vertical: 3.h,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    ),
  );
}
