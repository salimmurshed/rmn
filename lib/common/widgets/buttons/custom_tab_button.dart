import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';

Container buildCustomTabButton(
    {required void Function() onTap,
    required String btnLabel,
    required TabButtonType tabButtonType,
    required bool isWithCounter,
    String counter = '0'}) {
  return Container(
    // height: 45.h,
   // margin: EdgeInsets.only(bottom: Dimensions.buttonVerticalGap),
    child: InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.buttonBorderRadius),
            border: Border.all(
                color: tabButtonType == TabButtonType.selected
                    ? AppColors.colorPrimaryAccent
                    : AppColors.colorPrimary),
            color: tabButtonType == TabButtonType.selected
                ? AppColors.colorPrimaryAccent
                : AppColors.colorPrimary),
        padding: EdgeInsets.symmetric(horizontal: 10.w,),
        child: isWithCounter
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringManipulation.capitalizeFirstLetterOfEachWord(value: btnLabel),
                    style: AppTextStyles.smallTitle(
                      color: AppColors.colorPrimaryInverseText,
                    ),
                  ),
                  if (counter != '0')
                    Container(
                      height: 25.h,
                      width: 30.w,
                      margin: EdgeInsets.only(
                          left: Dimensions.bottomSheetBodyStyleTabPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        color: tabButtonType == TabButtonType.selected
                            ? AppColors.colorPrimary
                            : AppColors.colorPrimaryAccent,
                      ),

                      child: Center(
                        child: Text(
                          counter.toString(),
                          style: AppTextStyles.buttonTitle(
                            color: AppColors.colorPrimaryInverseText,
                          ),
                        ),
                      ),
                    )
                ],
              )
            : Center(
                child: Text(
                  btnLabel,
                  style: AppTextStyles.buttonTitle(
                    color: AppColors.colorPrimaryInverseText,
                  ),
                ),
              ),
      ),
    ),
  );
}
