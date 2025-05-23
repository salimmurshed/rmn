import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Widget customRegularExpansionTile(
    {required List<Widget> children,
    required void Function(bool) onExpansionChanged,
    required bool isExpansionTileOpened,
    required String title,
    Widget? leading,
    bool isSmall = false,
    bool isParent = false,
    bool isNumZero = false,
    double? height,
    bool isBackDropDarker = true,
    bool isAppSettingsView = false}) {
  return ListTileTheme(
    contentPadding: EdgeInsets.zero,
    horizontalTitleGap: 0,
    minVerticalPadding: 0,
    minLeadingWidth: 0.w,
    tileColor: AppColors.colorSecondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.r),
    ),
    child: ExpansionTile(
      minTileHeight:height?? (isSmall ? 35.h : 40.h),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.r),
      ),
      initiallyExpanded: isExpansionTileOpened,
      leading: leading,
      tilePadding: EdgeInsets.only(right: 10.w),
      childrenPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      iconColor: AppColors.colorPrimaryAccent,
      collapsedIconColor: AppColors.colorPrimaryInverse,
      collapsedTextColor: AppColors.colorPrimaryInverse,
      textColor: AppColors.colorPrimaryAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.r),
      ),
      backgroundColor:
          isBackDropDarker ? AppColors.colorPrimary : AppColors.colorTertiary,
      // Background color for expanded children
      collapsedBackgroundColor: AppColors.colorSecondary,

      // Background when collapsed
      onExpansionChanged: (val) {
        onExpansionChanged(val);
      },
      title: Container(
          padding: EdgeInsets.symmetric(vertical: isSmall ? 0 : 8.h),
          margin: isNumZero ? EdgeInsets.only(right: 10.w) : EdgeInsets.zero,
          child: Text(title,
              style: isAppSettingsView
                  ? (isExpansionTileOpened
                      ? AppTextStyles.subtitle(
                          isOutFit: false, color: AppColors.colorPrimaryAccent)
                      : AppTextStyles.smallTitle(isOutFit: true))
                  : TextStyle(
                      color: isExpansionTileOpened
                          ? AppColors.colorPrimaryAccent
                          : AppColors.colorPrimaryInverseText,
                      fontFamily: AppFontFamilies.squada,
                      fontSize: isSmall ? 14 : 16.sp,
                      fontWeight: FontWeight.w300))),
      children: children,
    ),
  );
}
