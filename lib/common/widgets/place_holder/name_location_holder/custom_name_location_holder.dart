import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../imports/common.dart';

SizedBox buildCustomEventNameLocationHolder(
    {required String nameOfTheEvent,
    required BuildContext context,
    required bool isFromHome,
    required String location}) {
  return SizedBox(
    width:  Dimensions.getScreenWidth() * 0.6,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Dimensions.getScreenWidth(),
          child: Text(
            nameOfTheEvent,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.smallTitle(),
          ),
        ),
        if(!isFromHome)
        SizedBox(
          width: Dimensions.getScreenWidth(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppAssets.icLocation,
                height: 14.h,
                width: 14.w,

              ),
              Expanded(
                child: Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subtitle(),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
