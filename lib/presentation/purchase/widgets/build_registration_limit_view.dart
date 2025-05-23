import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/common/dimensions/dimensions.dart';
import 'package:rmnevents/common/resources/app_colors.dart';
import 'package:rmnevents/common/resources/app_strings.dart';
import 'package:rmnevents/common/resources/app_text_styles.dart';


Widget buildRegistrationLimitView({required num? totalRegistration, required num? registrationLimit, bool? isProgressBarVisible}) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: checkIsSoldOut(totalRegistration ?? 0, registrationLimit ?? 0) ? AppColors.colorRedOpaque.withOpacity(0.12) : AppColors.colorGreenOpaque.withOpacity(0.12),
      // Dark background color
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(color: AppColors.colorTertiary, width: 2)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: Dimensions.getScreenWidth() - 137.w,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      checkIsSoldOut(totalRegistration ?? 0, registrationLimit ?? 0) ? AppStrings.event_registration_limitation_sold_out_title :AppStrings.event_registration_limitation_avilable_title,
                      style: AppTextStyles.dialogTitle(),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: 2.0.h),
                  Text(
                    checkIsSoldOut(totalRegistration ?? 0, registrationLimit ?? 0) ? AppStrings.event_registration_limitation_sold_out_sub_title :AppStrings.event_registration_limitation_avilable_subtitle,
                    style: AppTextStyles.subtitle(isOutFit: true),
                  ),
                  SizedBox(height: 2.0.h),
                ],
              ),
            ),
            SizedBox(
              width: 15.0.w,
            ),
            SizedBox(
              height: 60.h,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 2.0.h),
                  height: 25.h,
                  decoration: BoxDecoration(
                    color:checkIsSoldOut(totalRegistration ?? 0, registrationLimit ?? 0) ? AppColors.colorPrimaryAccent : AppColors.colorGreenAccent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      checkIsSoldOut(totalRegistration ?? 0, registrationLimit ?? 0) ? AppStrings.event_registration_limitation_sold_out :AppStrings.event_registration_limitation_available,
                      style: AppTextStyles.smallTitle(
                          color: AppColors.colorPrimaryInverseText,
                          fontSize: 14.sp,
                          isBold: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isProgressBarVisible ?? true)
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 8.0.h,
                      decoration: BoxDecoration(
                        color: AppColors.colorDisabled,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: calculatePercentage(totalRegistration ?? 0, registrationLimit ?? 0), // 100 out of 200 (50%)
                      child: Container(
                        height: 8.0.h,
                        decoration: BoxDecoration(
                          color: checkIsSoldOut(totalRegistration ?? 0, registrationLimit ?? 0) ? AppColors.colorPrimaryAccent : AppColors.colorGreenAccent,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Row(
                children: [
                  Text(
                    '$totalRegistration/',
                    style: AppTextStyles.smallTitle(
                        color: AppColors.colorPrimaryInverseText,
                        fontSize: 14.sp,
                        isBold: false),
                  ),
                  Text(
                    '$registrationLimit',
                    style: AppTextStyles.smallTitle(
                        color: AppColors.colorPrimaryInverseText,
                        fontSize: 16.sp,
                        isBold: true),
                  ),
                ],
              ),
            ],
          ),
      ],
    ),
  );
}
double calculatePercentage(num a, num b) {
  if (b == 0) {
    return 0.0;
  }
  return (a / b).clamp(0.0, 1.0); // Ensures the value is between 0 and 1
}

bool checkIsSoldOut(num a, num b){
  return a >= b ? true : false;
}