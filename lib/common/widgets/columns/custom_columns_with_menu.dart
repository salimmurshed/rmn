import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Column customColumnsWithMenu({
  required BuildContext context,
  required List<String> menuBarTitles,
  required void Function(int i) onTapOnMenuBar,
  bool showArrow = true,
  String? svgs,
}) {
  return Column(
    children: [
      for (int i = 0; i < menuBarTitles.length; i++)
        GestureDetector(
          onTap: () {
            onTapOnMenuBar(i);
          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: AppColors.colorSecondary),
              margin: EdgeInsets.symmetric(vertical: 5.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Row(
                  children: [
                  if(svgs != null)
              SvgPicture.asset(svgs, height: 20.h,
              width: 20.w, fit: BoxFit.cover),

      Text(menuBarTitles[i], style: AppTextStyles.smallTitle()),
      const Spacer(),
      if (showArrow)
        Icon(
          Icons.arrow_forward_ios,
          color: AppColors.colorPrimaryNeutral,
        )
    ],
  )),
  )
  ]
  ,
  );
}
