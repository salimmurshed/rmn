import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../imports/common.dart';

Widget assessType({required SizeType sizeType, required String userStatus}) {

  return accessContainer(
    sizeType: sizeType,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        svgPlaceHolder(
          sizeType: sizeType,
          typeOfMetric: TypeOfMetric.none,
          isMetric: false,
          imageUrl: userStatus == TypeOfAccess.owner.name
              ? AppAssets.icOwner
              : userStatus == TypeOfAccess.view.name
                  ? AppAssets.icViewer
                  : AppAssets.icCoach,
        ),
        pictureLabels(
            sizeType: sizeType,
            child: Text(
              userStatus == TypeOfAccess.owner.name
                  ? 'Owner'
                  : userStatus == TypeOfAccess.view.name
                      ? 'Viewer'
                      : userStatus == TypeOfAccess.coach.name
                          ? 'Coach'
                          : '',
              style: sizeType == SizeType.large
                  ? AppTextStyles.smallTitle():
              sizeType == SizeType.medium
                  ? AppTextStyles.componentLabels(isNormal: false)
                  : AppTextStyles.componentLabels(isNormal: false),
            ))
      ],
    ),
  );
}

Widget accessContainer({required SizeType sizeType, required Widget child}) =>
    Container(
      padding: EdgeInsets.symmetric(
          horizontal: sizeType == SizeType.large
              ? 8.w
              : sizeType == SizeType.medium
                  ? 6.w
                  : 4.w,
          vertical: sizeType == SizeType.large
              ? 4.h
              : sizeType == SizeType.medium
                  ? 2.h
                  : 1.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(Dimensions.generalSmallRadius)),
          color: AppColors.colorGreenOpaque),
      child: child,
    );
