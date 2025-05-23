import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

GestureDetector buildEventInfo({
  required void Function()? onTapToEventDetails,
  required String eventName,
  required String location,
}) {
  return GestureDetector(
    onTap: onTapToEventDetails,
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
               eventName ,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.subtitle(isOutFit: true, isBold: true),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
                margin: EdgeInsets.only(right: 5.w),
                height: 12.h,
                width: 12.w,
                child: SvgPicture.asset(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        AppColors.colorPrimaryAccent, BlendMode.srcIn),
                    AppAssets.icLocation)),
            Expanded(
              child: Text(
                location,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.normalNeutral(isSquada: true),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}