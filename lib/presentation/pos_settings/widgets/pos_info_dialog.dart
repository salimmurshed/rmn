import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Future<dynamic> buildDialogForStaffPosInfo(
    {required BuildContext context, required PosInfoType posInfoType, String? title, String? subtitle}) {
  return showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          blendMode: BlendMode.srcOver,
          filter: ImageFilter.blur(sigmaX: 10.w, sigmaY: 10.h),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Material(
                type: MaterialType.transparency,
                child: Align(
                    alignment: Alignment.center,
                    child: Wrap(children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.colorWhiteOpaque,
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                            BoxShadow(
                              color: AppColors.colorWhiteOpaque,
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, -3),
                            ),
                          ],
                          color: AppColors.colorSecondary,
                          borderRadius:
                              BorderRadius.circular(Dimensions.generalRadius),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                               title ??  (posInfoType == PosInfoType.connected
                                   ? AppStrings
                                   .staff_home_posContainer_connectedDevice_title
                                   : AppStrings
                                   .staff_home_posContainer_availableDevice_title),
                                style: AppTextStyles.largeTitle()),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Divider(
                                thickness: 1.w,
                                color: AppColors.colorPrimaryDivider,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Center(
                              child: Text(
                               subtitle ?? ( posInfoType == PosInfoType.connected
                                   ? AppStrings
                                   .staff_home_posContainer_connectedDevice_subtitle
                                   : AppStrings
                                   .staff_home_posContainer_availableDevice_subtitle),
                                style: AppTextStyles.subtitle(isOutFit: false),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]))),
          ),
        );
      });
}
