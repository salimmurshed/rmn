import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../imports/common.dart';
import '../../../../imports/data.dart';
import '../../../../root_app.dart';

Widget memberShip(
    {required SizeType sizeType, required Memberships? membership}) {
  return GestureDetector(
    onTap: () async {
      Navigator.pushNamed(
        navigatorKey.currentState!.context,
        AppRouteNames.routeBuySeasonPasses,
      );
    },
    child: Container(
      padding: EdgeInsets.all(Dimensions.generalPaddingAllAroundSmall),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(Dimensions.generalSmallRadius)),
          color: membership == null
              ? AppColors.colorRedOpaque
              : AppColors.colorBlueOpaque),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          svgPlaceHolder(
            sizeType: sizeType,
            typeOfMetric: TypeOfMetric.none,
            isMetric: false,
            imageUrl: AppAssets.icMembership,
          ),
          SizedBox(
              width: sizeType == SizeType.large
                  ? Dimensions.generalGapSmallAtComponentLabel
                  : 2.w),
          pictureLabels(
              sizeType: sizeType,
              child: Text(
                membership == null
                    ? AppStrings.global_no_season_pass
                    : membership.product!.title!,
                style: sizeType == SizeType.large
                    ? AppTextStyles.smallTitle()
                    : sizeType == SizeType.medium
                        ? AppTextStyles.componentLabels(isNormal: false)
                        : AppTextStyles.componentLabels(isNormal: false),
              ))
        ],
      ),
    ),
  );
}
