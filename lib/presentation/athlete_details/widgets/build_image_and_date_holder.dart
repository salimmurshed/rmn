import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

GestureDetector buildImageAndDateHolder(
    {required void Function()? onTapToEventDetails,
      required String imageUrl,
      required String startDate,
   required String timezone,
      required String endDate}) {
  return GestureDetector(
    onTap: onTapToEventDetails,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.generalRadius),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: 88.h,
            width: 120.w,
            fit: BoxFit.cover,
          ),
          buildCustomDatePlaceHolder(
            timezone: timezone,
            isLarge: false,
            startDate: startDate,
            endDate: endDate,

          ),
        ],
      ),
    ),
  );
}