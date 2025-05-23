import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Widget buildProductImage({
  required bool isMyProductDetail,
  required String qrCodeStatus, required String coverImage}) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(3.r),
        child: SizedBox(
            width: 85.w,
            height:  82.h,
            child: coverImage.isEmpty
                ? SvgPicture.asset(fit: BoxFit.cover, AppAssets.icProfileAvatar)
                : CachedNetworkImage(fit: BoxFit.cover, imageUrl: coverImage)),
      ),
      if (qrCodeStatus.isNotEmpty && qrCodeStatus != AppStrings.myPurchases_qrCode_noScanDetails_text)
        Positioned.fill(
            child: Container(
              height:  82.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.r),
                  color: qrCodeStatus ==
                      AppStrings.myPurchases_qrCode_scanDetailsConfirmed_text
                      ? AppColors.colorSuccessOpaque
                      : AppColors.colorRedOpaque),
              width: 85.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    color: AppColors.colorPrimaryInverse,
                    size: 30.h,
                  ),
                  Text(
                    qrCodeStatus,
                    style: AppTextStyles.normalPrimary(color: AppColors.colorPrimaryInverse),
                  )
                ],
              ),
            )),
    ],
  );
}