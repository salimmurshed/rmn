import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../imports/common.dart';

ClipRRect buildCustomAthleteProfileHolder(
    {bool isScanned = false,
    required String weight,
    required String age,
    bool? isFromRegs,
      bool isLocal = false,
    required String imageUrl}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius),
    child: SizedBox(
      height: isFromRegs != null ? 90.h : 80.h,
      child: Stack(
        children: [
          Container(
              color: AppColors.colorPrimary,
              width: 75.w,
              height: 75.h,
              child: isLocal? (imageUrl.isNotEmpty? Image.file(File(imageUrl),  fit: BoxFit.cover, ):
              SvgPicture.asset(
                  fit: BoxFit.cover, AppAssets.icProfileAvatar) ):
              imageUrl.isEmpty
                  ? SvgPicture.asset(
                      fit: BoxFit.cover, AppAssets.icProfileAvatar)
                  : CachedNetworkImage(
                      errorWidget: (context, url, error) => SvgPicture.asset(
                        AppAssets.icProfileAvatar,
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                    )),
          if (isScanned)
            Positioned(
                child: Container(
              color: AppColors.colorBlueOpaque,
              width: 75.w,
              height: 75.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.icTick,
                    width: 30.w,
                  ),
                  Text(
                    AppStrings.global_used,
                    style:
                        AppTextStyles.subtitle(isOutFit: false, isBold: true),
                  ),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ),
            )),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorPrimaryAccent,
                        borderRadius: BorderRadius.circular(
                            Dimensions.generalSmallRadius),
                      ),
                      height: 25.h,
                      width: 30.w,
                      child: Center(
                        child: Text(
                          age == 'null' ? AppStrings.global_empty_string : age,
                          style: AppTextStyles.componentLabels(),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  SizedBox(width: 4.w),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.colorSecondaryAccent,
                      borderRadius:
                          BorderRadius.circular(Dimensions.generalSmallRadius),
                    ),
                    height: 25.h,
                    width: 30.w,
                    child: Center(
                      child: Text(
                        weight == 'null'
                            ? AppStrings.global_empty_string
                            : weight,
                        style: AppTextStyles.componentLabels(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    ),
  );
}
