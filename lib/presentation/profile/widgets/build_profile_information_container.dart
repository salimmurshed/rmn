import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmnevents/root_app.dart';

import '../../../imports/common.dart';

Container buildProfileInformationContainer({
  required bool isLoadingForUserInfo,
  required String fullName,
  required String email,
  required String phone,
  required String metricCountForAthlete,
  required String metricCountForAwards,
  required String metricCountForEvents,
}) {
  return Container(
    height: Dimensions.getScreenHeight() * 0.3,
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.colorTertiary),
    child: Padding(
      padding: EdgeInsets.only(bottom: 10.h, left: 5.w, right: 5.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!isLoadingForUserInfo) ...[
              Container(
                  margin: EdgeInsets.only(top: Dimensions.generalGap),
                  child: Text(fullName, style: AppTextStyles.largeTitle())),
              buildUserInfoRow(info: email, icon: AppAssets.icEmail),
              buildUserInfoRow(info: phone, icon: AppAssets.icCall),
              SizedBox(
                height: Dimensions.generalGapSmall,
              ),
            ] else ...[
              Center(
                  child: SizedBox(
                      height: 50.h,
                      child: CustomLoader(child: const SizedBox())))
            ],
            if (!isLoadingForUserInfo) ...[
              buildMetrics(
                metricCountForAthlete: metricCountForAthlete,
                metricCountForAwards: metricCountForAwards,
                metricCountForEvents: metricCountForEvents,
              )
            ]
          ],
        ),
      ),
    ),
  );
}

Container buildMetrics({
  required String metricCountForAthlete,
  required String metricCountForAwards,
  required String metricCountForEvents,
}) {
  return Container(
    margin: EdgeInsets.only(top: isTablet? 20.h: 0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildMetricContainer(
          onTap: () {
            navigatorKey.currentState!
                .pushNamed(AppRouteNames.routeMyAthleteProfiles);
          },
          metricCount: metricCountForAthlete,
          metricLabel: AppStrings.accountSettings_profileMetrics_athlete_label,
        ),
        SizedBox(
          width: 15.w,
        ),
        buildMetricContainer(
          onTap: () {
            navigatorKey.currentState!
                .pushNamed(AppRouteNames.routeMyAthleteProfiles);
          },
          metricCount: metricCountForAwards,
          metricLabel: AppStrings.accountSettings_profileMetrics_awards_label,
        ),
        SizedBox(
          width: 15.w,
        ),
        buildMetricContainer(
          onTap: () {
            navigatorKey.currentState!
                .pushNamed(AppRouteNames.routeMyAthleteProfiles);
          },
          metricCount: metricCountForEvents,
          metricLabel:
              AppStrings.accountSettings_profileMetrics_upcomings_label,
        ),
      ],
    ),
  );
}

Widget buildMetricContainer(
    {required String metricCount,
    required String metricLabel,
    required void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
        width: 80.w,
        decoration: BoxDecoration(
            color: AppColors.colorSecondaryAccent,
            borderRadius: BorderRadius.circular(5.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(metricCount, style: AppTextStyles.extraLargeTitle()),
              Text(metricLabel, style: AppTextStyles.subtitle(isOutFit: false)),
            ],
          ),
        )),
  );
}

Widget buildUserInfoRow({required String icon, required String info}) {
  return Container(
    margin: EdgeInsets.only(left: 3.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h),
          child: SvgPicture.asset(icon, height: 10.h, width: 10.w),
        ),
        SizedBox(width: 2.w),
        Flexible(
            child: Text(info,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.normalNeutral())),
      ],
    ),
  );
}
