import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Container buildAuthenticationSocialOptionText(
    {required Authentication authentication}) {
  return Container(
    margin: EdgeInsets.only(bottom: Dimensions.generalGap, top: 10.h),
    child: Center(
      child: SvgPicture.asset(
        authentication == Authentication.signUp
            ? AppAssets.icSocialSignUpText
            : AppAssets.icSocialSignInText,
        height: Dimensions.textFormFieldIconHeight,
        fit: BoxFit.cover,
      ),
    ),
  );
}
