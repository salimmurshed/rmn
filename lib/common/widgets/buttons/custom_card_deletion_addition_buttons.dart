import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Widget buildCardDeletionAdditionButtons(
    {
      required bool showTitle,
      // void Function()? delete,
      void Function()? add}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10.h),
    child: Row(
      children: [
        if(showTitle)
        Text('Select Payment Method', style: AppTextStyles.largeTitle(isSquada: true)),
        const Spacer(),
        // GestureDetector(
        //     onTap: delete,
        //     child: SizedBox(
        //         height: 28.h,
        //         width: 30.w,
        //         child: SvgPicture.asset(
        //           AppAssets.icBin,
        //           fit: BoxFit.cover,
        //         ))),
        InkWell(
          splashColor: Colors.transparent,
          onTap: add,
          child: Container(
              margin: EdgeInsets.only(left: 10.w),
              decoration: BoxDecoration(
                  color: AppColors.colorSecondaryAccent,
                  borderRadius: BorderRadius.circular(5.r)),
              padding: EdgeInsets.all(5.r),
              child: SvgPicture.asset(AppAssets.icAdd)),
        )
      ],
    ),
  );
}