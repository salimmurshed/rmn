import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/root_app.dart';

import '../../../imports/common.dart';

buildBaseShowDialog(
    {required Widget title, required Widget body, required bool isDivider}) {
  showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Material(
              type: MaterialType.transparency,
              child: Align(
                  alignment: Alignment.center,
                  child: Wrap(children: [
                    Container(
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          title,
                          Divider(
                            color: AppColors.colorPrimaryNeutral,
                            thickness: 1,
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.all(5.r),
                            child: body,
                          ),
                        ],
                      ),
                    )
                  ]))),
        );
      });
}
