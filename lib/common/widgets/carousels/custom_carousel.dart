import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../../../root_app.dart';

Widget buildCustomCarousel({
  required PageController pageController,
  required int itemCount,
  required int currentIndex,
  double? height,
  bool isSquare = true,
  required Widget? Function(BuildContext, int) itemBuilder,
}) {
  return IntrinsicHeight(
    child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(
              height: height ??(isTablet ? 280.h: 220.h),
              child: PageView.builder(
                  padEnds: itemCount == 1? true:false,

                  controller: pageController,
                  itemCount: itemCount,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: itemBuilder),
            ),
            if (itemCount > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(itemCount, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        vertical: Dimensions.generalGapSmall, horizontal: 5.w),
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(

                      color: currentIndex == index
                          ? AppColors.colorPrimaryAccent
                          : (isSquare?AppColors.colorTertiary: AppColors.colorPrimaryInverse),
                      shape:isSquare? BoxShape.rectangle: BoxShape.circle,
                    ),
                  );
                }),
              ),
          ],
        ),
      ],
    ),
  );
}