import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

GestureDetector buildLiveOrNextCard({
  required void Function()? onTap,
  required String startDate,
  required String endDate,
  required String imageUrl,
  required BuildContext context,
  required EventStatus eventCardType,
  required String nameOfTheEvent,
  required String location,
  required String timezone,
  required bool isFromHome,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 170.h,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: Dimensions.generalGap),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.generalRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.generalRadius),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 170.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            buildCustomDatePlaceHolder(
                timezone: timezone,
                startDate: startDate,
                endDate: endDate,
                ),
            buildLiveOrNextCardFooter(
              isFromHome: isFromHome,
                nameOfTheEvent: nameOfTheEvent,
                location: location,
                context: context,
                eventCardType: eventCardType)
          ],
        ),
      ),
    ),
  );
}


Align buildLiveOrNextCardFooter(
    {required String nameOfTheEvent,
      required String location,
      required BuildContext context,
      required bool isFromHome,
      required EventStatus eventCardType}) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: double.infinity,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.generalGapSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(Dimensions.generalRadius)),
        color: EventStatus.live == eventCardType
            ? AppColors.colorRedOpaque
            : AppColors.colorBlackOpaque,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCustomEventNameLocationHolder(
            isFromHome: isFromHome,
            nameOfTheEvent: nameOfTheEvent,
            location: location, context: context,
          ),
          Padding(
            padding: EdgeInsets.all(2.r),
            child: SvgPicture.asset(
              AppAssets.icLive,
              height: 20.h,
              width: 20.w,
            ),
          ),
          Text(
            eventCardType == EventStatus.live
                ? AppStrings.clientHome_eventType_live_text
                : AppStrings.clientHome_eventType_next_text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.smallTitle(),
          ),
        ],
      ),
    ),
  );
}