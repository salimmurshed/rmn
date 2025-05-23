import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Row customAthleteImageForBottomSheet(
    {required String imageUrl,
    required String athleteAge,
    required String athleteWeight,
      TextStyle? textStyle,
    required String athleteNameAsTheTitle}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(
        width: 80.w,
        height: 65.h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 6.w,
              child:  ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child:imageUrl.isEmpty
                          ? SvgPicture.asset(
                        AppAssets.icProfileAvatar,
                        height: 65.h,
                        width: 55.w,
                        fit: BoxFit.cover,
                      ): Container(
                        color: Colors.black,

                        child: imageUrl.contains('https')? CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 65.h,
                          width: 68.w,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => SvgPicture.asset(
                            AppAssets.icProfileAvatar,
                            height: 65.h,
                            width: 55.w,
                            fit: BoxFit.cover,
                          ),
                        ):
                        Image.file(
                           File(imageUrl),
                          height: 65.h,
                          width: 68.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ,
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: 25.h,
                width: 80.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    athleteAgeWeightContainer(isAge: true, metric: athleteAge),
                    SizedBox(
                      width: 5.w,
                    ),
                    athleteAgeWeightContainer(
                        isAge: false, metric: athleteWeight),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      SizedBox(width:10.w),
      Expanded(
          child: Text(athleteNameAsTheTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textStyle ?? AppTextStyles.largeTitle(),))
      // AppWidgetStyles.buildTitleForBottomSheet(
      //     title: athleteNameAsTheTitle,isCentered: false,
      //     highlightedString: AppStrings.global_empty_string),
    ],
  );
}

Expanded athleteAgeWeightContainer(
    {required bool isAge, required String metric}) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: isAge
            ? AppColors.colorPrimaryAccent
            : AppColors.colorSecondaryAccent,
      ),

      child: Center(
        child: Text(
          metric == 'null' ? AppStrings.global_empty_string : metric,
          style: AppTextStyles.subtitle(isOutFit: false),
        ),
      ),
    ),
  );
}
