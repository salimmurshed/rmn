import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../imports/common.dart';

Container buildAuthenticationLandingImage() {
  return Container(
    margin: EdgeInsets.only(
        bottom: Dimensions.titleSubtitleGap,
        top: Dimensions.screenVerticalGap),
    child: Stack(
      children: [
        Image.asset(AppAssets.imgAuthenticationSignUpSignInLanding),
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.all(35.r),
            child: SvgPicture.asset(
              AppAssets.icAppName,
            ),
          ),
        )
      ],
    ),
  );
}