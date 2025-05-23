import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../imports/common.dart';
import '../../../../root_app.dart';

Container buildCustomDatePlaceHolder({
  required String startDate,
  required String endDate,
  required String timezone,
  bool isLarge = true,
}) {
  if(DateFunctions.getDateInSingleNumber(
      date: startDate, timezone: timezone) == DateFunctions.getDateInSingleNumber(
      date: endDate, timezone: timezone)
  &&
      DateFunctions.getMonthInSingleNumber(
          date: startDate, timezone: timezone) == DateFunctions.getMonthInSingleNumber(
          date: endDate, timezone: timezone)
  ) {
    return Container(
      height: isLarge ? 55.h : (isTablet? 50.h:40.h),
      width: 60.w,
      decoration: BoxDecoration(
        color: AppColors.colorBlackOpaque,
        borderRadius: isLarge
            ? BorderRadius.only(
            topRight: Radius.circular(2.r),
            bottomRight: Radius.circular(2.r))
            : BorderRadius.only(
            topRight: Radius.circular(2.r),
            bottomRight: Radius.circular(2.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildCustomDate(
              isLarge: isLarge,
              date: DateFunctions.getDateInSingleNumber(
                  date: startDate, timezone: timezone),
              month: DateFunctions.getMonthInSingleNumber(
                  date: startDate, timezone: timezone)),

        ],
      ),
    );

  }
  else{
    return Container(
      height: isLarge ? 65.h : (isTablet? 60.h:40.h),
      width: isLarge ? 100.w : 70.w,
      decoration: BoxDecoration(
        color: AppColors.colorBlackOpaque,
        borderRadius: isLarge
            ? BorderRadius.only(
            topRight: Radius.circular(Dimensions.generalRadius),
            bottomRight: Radius.circular(Dimensions.generalRadius))
            : BorderRadius.only(
            topRight: Radius.circular(2.r),
            bottomRight: Radius.circular(2.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildCustomDate(
              isLarge: isLarge,
              date: DateFunctions.getDateInSingleNumber(
                  date: startDate, timezone: timezone),
              month: DateFunctions.getMonthInSingleNumber(
                  date: startDate, timezone: timezone)),
          Text(
            '-',
            style: isLarge
                ? AppTextStyles.smallTitle()
                : AppTextStyles.componentLabels(),
          ),
          buildCustomDate(
              isLarge: isLarge,
              date: DateFunctions.getDateInSingleNumber(
                  date: endDate, timezone: timezone),
              month: DateFunctions.getMonthInSingleNumber(
                  date: endDate, timezone: timezone)),
        ],
      ),
    );
  }
}

Padding buildCustomDate(
    {required bool isLarge, required String date, required String month}) {
  return Padding(
    padding: isLarge
        ? EdgeInsets.all(Dimensions.generalPaddingAllAroundSmall)
        : EdgeInsets.all(isTablet? 0:1.r),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          month,
          style: isLarge? AppTextStyles.subtitle(isOutFit: false):
          AppTextStyles.componentLabels(),
        ),
        Text(
          date,
          style: isLarge? AppTextStyles.largeTitle():
          AppTextStyles.subtitle( isOutFit: false),
        ),
      ],
    ),
  );
}
