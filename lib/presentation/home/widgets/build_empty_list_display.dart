import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/data/models/arguments/athlete_argument.dart';
import 'package:rmnevents/root_app.dart';

import '../../../imports/common.dart';

Widget buildEmptyListDisplay({
  required bool isEvents,
}) {
  return IntrinsicHeight(
    child: Container(
      margin: EdgeInsets.only(bottom: Dimensions.generalGapSmall),
     // height: 240.h,
      width: double.infinity,
      child: Column(
        children: [
          SvgPicture.asset(
            isEvents ? AppAssets.icEmptyEvents : AppAssets.icEmptyAthletes,
            height: 110.h,
          ),
          Container(
            margin: EdgeInsets.only(
                bottom: Dimensions.generalGap, top: Dimensions.generalGapSmall),
            child: Text(
              isEvents
                  ? AppStrings.clientHome_nextEvents_empty_text
                  : AppStrings.clientHome_athletes_empty_text,
              textAlign: TextAlign.center,
              style: AppTextStyles.smallTitle(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: buildCustomLargeFooterBtn(
                hasKeyBoardOpened: false,
                onTap: () {
                  if (isEvents) {
                    Navigator.pushNamed(
                      navigatorKey.currentState!.context,
                      AppRouteNames.routeAllEvents,
                    );
                  } else {
                    Navigator.pushNamed(
                        navigatorKey.currentState!.context,
                        arguments: AthleteArgument(createProfileType: CreateProfileTypes.addAthleteFromMyList),
                        AppRouteNames.routeCreateOrEditAthleteProfile);
                  }
                },
                isSmallPaddingNeeded: false,
                btnLabel: isEvents
                    ? AppStrings.clientHome_eventRegisterNow_button_text
                    : AppStrings.clientHome_addAthleteNow_button_text,
                isColorFilledButton: true),
          ),
        ],
      ),
    ),
  );
}
