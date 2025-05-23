import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/common/resources/app_assets.dart';



ClipRRect buildClipRRectForImage({required String profileImage, File? imageFile}) {
  debugPrint('profileImage: $profileImage\n', wrapWidth: 1024);
  return ClipRRect(
    borderRadius: BorderRadius.circular(5.r),
    child: Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(2.r)),
        child: imageFile == null ?(
        profileImage.isNotEmpty?
            CachedNetworkImage(
          height: 42.h,
          width: 50.w,
          fit: BoxFit.cover,
          imageUrl: profileImage,
          errorWidget: (context, url, error) => SvgPicture.asset(
            AppAssets.icProfileAvatar,
            height: 42.h,
            width: 50.w,
            fit: BoxFit.cover,
          ),
        ): SvgPicture.asset(
          AppAssets.icProfileAvatar,
          height: 42.h,
          width: 50.w,
          fit: BoxFit.cover,
        )
      ): Image.file(imageFile, height: 42.h, width: 50.w, fit: BoxFit.cover),
      ),
    ),
  );
}