import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
Positioned buildPositionedForCheckbox({required bool isSelectedORegistered}) {
  return Positioned(
    top: 0,
    right: 2.w,
    child: SizedBox(
      height: 15.h,
      width: 15.w,
      child: isSelectedORegistered
          ? SvgPicture.asset(fit: BoxFit.cover, AppAssets.icChecked)
          : SvgPicture.asset(fit: BoxFit.cover, AppAssets.icUnChecked),
    ),
  );
}
