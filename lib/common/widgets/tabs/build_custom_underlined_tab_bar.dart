import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

buildCustomUnderlinedTabBar({
  required PaymentModuleTabNames paymentModuleTabs,
  required List<String> tabNames,
  required void Function(PaymentModuleTabNames) onTapToSelectTab,
}) {

  return Container(
    margin: EdgeInsets.only(left: 10.w, right: 10.w),
    height: 30.h,
    width: double.infinity,
    child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (context, i) {
          return Column(
            children: [
              Text(
                tabNames[i],
                style: AppTextStyles.subtitle(
                  isOutFit: false,
                  color: paymentModuleTabs.name.toUpperCase() ==
                          tabNames[i].toUpperCase()
                      ? AppColors.colorPrimaryInverse
                      : AppColors.colorPrimaryNeutralText,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                height: 2,
                width: tabNames.length == 4? Dimensions.getScreenWidth()* 0.22: Dimensions.getScreenWidth() * 0.3,
                color: paymentModuleTabs.name.toUpperCase() ==
                        tabNames[i].toUpperCase()
                    ? AppColors.colorPrimaryAccent
                    : AppColors.colorPrimaryNeutral,
              )
            ],
          );
        },
        separatorBuilder: (context, i) {
          return Container(
            width:tabNames.length == 4? 10.w: 13.w,
          );
        },
        itemCount: tabNames.length),
  );
}
