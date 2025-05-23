import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/root_app.dart';

import '../../../imports/common.dart';

Widget buildForgotPasswordTextBtn() {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
          navigatorKey.currentContext!, AppRouteNames.routeResetPassword);
    },
    child: Container(
      margin: EdgeInsets.only(bottom: Dimensions.generalGap, top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            AppStrings.authentication_signIn_forgotPasswordBtn,
            style: AppTextStyles.regularNeutralOrAccented(),
          )
        ],
      ),
    ),
  );
}
