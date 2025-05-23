import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
import '../../../root_app.dart';

Widget buildProfilePicture({required String cachedNetworkImageUrl, required String label,
  required bool isLoadingForUserInfo}) {
  return Container(
    margin: EdgeInsets.only(bottom: 10.h),
    width: 120.w,
    height: isTablet? 160.h:120.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Dimensions.generalRadius),
      color: AppColors.colorPrimary,
    ),
    child: isLoadingForUserInfo
        ? CustomLoader(
      child: const SizedBox(),
    )
        : Stack(

      children: [
        cachedNetworkImageUrl.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.generalRadius),
          child: CachedNetworkImage(
              width: 120.w,
              height: isTablet? 160.h:120.h,
              fit: BoxFit.cover, imageUrl: cachedNetworkImageUrl),
        )
            :
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.generalRadius),
          child: SvgPicture.asset(
            width: 120.w,
            height: isTablet? 160.h:120.h,
            AppAssets.icProfileAvatar,
            fit: BoxFit.cover,
          ),
        ),
        if(label.isNotEmpty)
        IntrinsicWidth(
          child: Container(
            alignment: Alignment.topLeft,
            height: 20.h,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius),
              color: AppColors.colorGreenAccent,
            ),
            child: Center(
              child: Text(
                StringManipulation.capitalizeTheInitial(value: label),
                style: AppTextStyles.normalAccented(AppColors.colorPrimaryInverseText),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
