import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../imports/common.dart';

SvgPicture svgPlaceHolder(
    {required bool isMetric,
    required TypeOfMetric typeOfMetric,
    required SizeType sizeType,
    required String imageUrl}) {
  return isMetric
      ? SvgPicture.asset(
          imageUrl,
          height: sizeType == SizeType.large? 20.h : sizeType == SizeType.medium? 12.h : 12.h,
          width: sizeType ==  SizeType.large ? 20.w : sizeType == SizeType.medium? 12.w : 12.w,
        )
      : SvgPicture.asset(
          imageUrl,
          height: sizeType == SizeType.large
              ? 16.h
              : sizeType == SizeType.medium
                  ? 12.h
                  : 12.h,
          width: sizeType == SizeType.large
              ? 16.w
              : sizeType == SizeType.medium
                  ? 12.w
                  : 12.w,
        );
}
