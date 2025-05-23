import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Widget buildTotalRegistrationInfo(
    {required bool isUpcoming,
    required num rank,
    bool isFromRegs = false,
    bool isExpanded = false,
    String money = AppStrings.global_empty_string,
    required void Function()? onTapToOpenBottomSheet,
    bool isFromEventList = true,
    required String value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: onTapToOpenBottomSheet,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color:
                  // isFromEventList
                  //     ? AppColors.colorSecondary
                  //     :
                  AppColors.colorPrimary),
              padding: EdgeInsets.symmetric(
                horizontal: isUpcoming ? 7.w : 4.w,
                vertical: 2.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              AppStrings.athleteDetails_totalRegistration_title,
                          style: AppTextStyles.componentLabels(),
                        ),
                        TextSpan(
                          text: value,
                          style: AppTextStyles.componentLabels(
                              color: AppColors.colorPrimaryAccent),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    AppAssets.icExpand,
                    height: 20.h,
                  )
                ],
              ),
            ),
          )),
      if (!isUpcoming) ...[
        if (rank != 0) ...[
          IntrinsicWidth(
            child: Container(
              margin: EdgeInsets.only(left: 5.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: AppColors.colorSecondary),
              height: 40.h,
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    height: 12.h,
                    width: 12.w,
                    AppAssets.icRank,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2.w, top: 1.5.h),
                    child: Text(
                      rank.toString(),
                      style: AppTextStyles.componentLabels(),
                    ),
                  )
                ],
              ),
            ),
          )
        ]
      ],
      if (isFromRegs) ...[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
           SizedBox(width: 12.w,),
              Text(
                money,
                style: AppTextStyles.subtitle(
                  isOutFit: false,
                  isBold: true,
                  color: isExpanded
                      ? AppColors.colorPrimaryAccent
                      : AppColors.colorPrimaryInverseText,
                ),
              ),
            ],
          ),
        ),
      ]
    ],
  );
}
