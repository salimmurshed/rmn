import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

AppBar customAppBarForImageBehind(
    {required BuildContext context,
    void Function()? onTap,
    bool isLeadingPresent = true,
    List<Widget>? actions}) {
  return AppBar(
    leadingWidth: Dimensions.appBarLeadingWidth,
    toolbarHeight: Dimensions.appBarToolHeight,automaticallyImplyLeading: false,
    leading: isLeadingPresent? buildLeading(context: context, onTap: onTap): null,
    actions: actions,
    backgroundColor: Colors.transparent,
    elevation: 0, // Remove shadow
  );
}

Container buildAppBarIconButton({required String svgAddress}) {
  return Container(
    width: 40.w,
    height: 40.h,
    margin: EdgeInsets.only(
        right: 10.w, left: 10.w, top:5.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: AppColors.colorSecondaryAccent),
    child: Center(
        child: SizedBox(
      height: 16.h,
      width: 16.w,
      child: SvgPicture.asset(svgAddress, fit: BoxFit.cover),
    )),
  );
}
