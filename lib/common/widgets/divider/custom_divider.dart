import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Container customDivider({bool isBottomSheetTitle = false}) {
  return Container(
    width: isBottomSheetTitle ? 100.w: null,
    margin: EdgeInsets.symmetric(vertical: Dimensions.dividerTitleGap,),
    child: SvgPicture.asset(AppAssets.icTitleDivider, fit: BoxFit.fill
    ),
  );
}