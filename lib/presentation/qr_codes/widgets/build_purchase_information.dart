import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Container buildPurchaseInformation({
  required String divisionType,
  required String divisionTitle,
  required String style,
  required String weight,
  required num price,
  required BuildContext context,
}) {
  return Container(
    width: Dimensions.getScreenWidth()* 0.58,
    margin: EdgeInsets.only(left: 10.w),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          margin: EdgeInsets.only(top: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(StringManipulation.capitalizeFirstLetterOfEachWord(value: divisionType), style: AppTextStyles.subtitle(isOutFit: false)),
              const Spacer(flex: 3),
              Text(StringManipulation.addADollarSign(price: price),
                  style: AppTextStyles.subtitle(isOutFit: false)),
            ],
          ),
        ),
        Text(divisionTitle, style: AppTextStyles.regularPrimary(isOutFit: false)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.icWrestling,
              height: 12.h,
              width: 14.w,
            ),
            SizedBox(width: 5.w),
            Text(style, style: AppTextStyles.componentLabels()),
            SizedBox(width: 10.w),
            SvgPicture.asset(
              AppAssets.icWeight,
              height: 12.h,
              width: 14.w,
            ),
            SizedBox(width: 5.w),
            Text(weight,
                overflow: TextOverflow.ellipsis,
// Apply ellipsis to overflowing text
                maxLines: 1,
                style: AppTextStyles.componentLabels(
                    color: AppColors.colorPrimaryAccent)),
          ],
        )
      ],
    ),
  );
}
