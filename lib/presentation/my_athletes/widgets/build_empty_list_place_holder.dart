import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Widget buildEmptyListPlaceHolder(
    {required bool showFooterButton,
    required BuildContext context,
    required int selectedTab,
    required String textForEmptyList}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: Dimensions.getScreenHeight() * 0.2,
      ),
      Container(
        margin: EdgeInsets.only(bottom: 5.h),
        child: SvgPicture.asset(
          AppAssets.icEmptyAthleteList,
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 5.h),
        width: Dimensions.getScreenWidth() * 0.6,
        child: Text(
          textForEmptyList,
          textAlign: TextAlign.center,
          style: AppTextStyles.smallTitleForEmptyList(),
        ),
      ),
      if (!showFooterButton)
        SizedBox(
          height: 30.h,
          width: double.infinity,
        ),
      if (showFooterButton)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.w),
          child: buildCustomLargeFooterBtn(
              hasKeyBoardOpened: false,
              onTap: () {
                Navigator.pushNamed(
                    context, AppRouteNames.routeCreateOrEditAthleteProfile);
              },
              isSmallPaddingNeeded: true,
              btnLabel: AppStrings.clientHome_addAthleteNow_button_text,
              isColorFilledButton: true),
        ),
    ],
  );
}
