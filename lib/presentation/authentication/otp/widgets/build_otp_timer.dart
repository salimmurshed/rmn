import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../imports/common.dart';

Align buildOtpTimer(
    {required double animationPercentValue,
    required num animationValueProgressValue,
    required AnimationController animationController}) {
  return Align(
    alignment: Alignment.center,
    child: AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => CircularPercentIndicator(
        radius: 25.r,
        curve: Curves.linear,
        reverse: false,
        percent: animationPercentValue,
        backgroundColor: AppColors.colorPrimaryInverse,
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: AppColors.colorPrimaryAccent,
        center: Text(
          '$animationValueProgressValue',
          style: AppTextStyles.normalPrimary(),
        ),
      ),
    ),
  );
}
