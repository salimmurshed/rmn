import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Widget buildCustomEventCard({
  required String coverImage,
  required String eventName,
  required String location,
  required List<String> athleteProfiles,
  required BuildContext context,
  required String eventId,
  required String startDate,
  required String endDate,
  required bool isFromHome,
  required String timezone,
  required bool isLimitedRegistration,
}) {
  return GestureDetector(
    onTap:(){
      Navigator.pushNamed(context, AppRouteNames.routeEventDetails, arguments: eventId);
    },
    child: Container(
       height: 250.h,
      width: double.infinity,
      margin: EdgeInsets.only(
          bottom: Dimensions.generalGap, left: 3.w, right: 3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.generalRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.generalRadius),
        child: Stack(
          children: [
            buildCoverImage(context: context, coverImage: coverImage),
            buildCustomDatePlaceHolder(
                timezone: timezone,
                startDate: startDate,
                endDate: endDate,
            ),
            if (isLimitedRegistration)
              const Positioned( top: 5, right: 5,child: LimitedRegistrationBanner()),
            buildDetailSection(
                context: context,
                isFromHome: isFromHome,
                eventName: eventName,
                location: location,
                athleteProfiles: athleteProfiles),
          ],
        ),
      ),
    ),
  );
}

Align buildDetailSection(
    {required BuildContext context,
    required String eventName,
    required String location,
    required bool isFromHome,
    bool isFromAllEvents = false,
    required List<String> athleteProfiles}) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: IntrinsicHeight(
      child: Container(
        width: double.infinity,
        // height: Dimensions.getScreenHeight() * 0.15,
        decoration: BoxDecoration(
          color: AppColors.colorTertiary,
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(Dimensions.generalRadius)),
        ),
        child: Container(
          width: Dimensions.getScreenWidth() * 0.5,
          padding: EdgeInsets.all(Dimensions.generalRadius),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildEventName(context, eventName),
              if(!isFromHome)
              buildEventLocation(context, location),
              if (athleteProfiles.isNotEmpty)
              athleteProfilesProfileList(athleteProfiles: athleteProfiles),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget athleteProfilesProfileList({required List<String> athleteProfiles}) {
  return Container(
    width: Dimensions.getScreenWidth(),
    height: 30.h,
    margin: EdgeInsets.only(top: Dimensions.generalGapSmall),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded( // Wrap the ListView with Expanded
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: min(5, athleteProfiles.length) +
                (athleteProfiles.length > 5 ? 1 : 0), // Add 1 for placeholder
            separatorBuilder: (context, index) =>
                SizedBox(width: 5.w), // Add spacing between items
            itemBuilder: (context, index) {
              if (index < athleteProfiles.length && index < 5) {
                return buildAthleteProfileList(athleteProfiles, index);
              } else if (athleteProfiles.length > 5 && index == 5) {
                return buildPlusPlaceHolderForAthletes(
                    athleteProfiles: athleteProfiles);
              } else {
                return const SizedBox.shrink(); // Empty widget for extra items
              }
            },
          ),
        ),
        buildForwardArrow(),
      ],
    ),
  );
}

Container buildPlusPlaceHolderForAthletes({required List<String> athleteProfiles}) {
  return Container(
    margin: EdgeInsets.only(right: 5.w),
    height: 30.h,
    width: 35.w,
    decoration: BoxDecoration(
      color: AppColors.colorPrimaryAccent,
      borderRadius:
          BorderRadius.circular(Dimensions.generalPaddingAllAroundSmall),
    ),
    child: Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.generalPaddingAllAroundSmall),
        child: Text(
          '${athleteProfiles.length - 5}+',
          style: AppTextStyles.subtitle(isBold: true),
        ),
      ),
    ),
  );
}

Container buildForwardArrow() {
  return Container(
    height: 30.h,
    width: 30.w,
    padding: EdgeInsets.all(Dimensions.generalPaddingAllAroundSmall),
    decoration: BoxDecoration(
      color: AppColors.colorSecondaryAccent,
      borderRadius:
          BorderRadius.circular(Dimensions.generalPaddingAllAroundSmall),
    ),
    child: SvgPicture.asset(
      AppAssets.icForwardArrow,
      colorFilter: ColorFilter.mode(
          AppColors.colorPrimaryInverse, BlendMode.srcIn),
      height: 20.h,
      width: 20.w,
    ),
  );
}

Widget buildAthleteProfileList(List<String> athleteProfiles, int i) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius), // Adjust the radius as needed
    child: Container(
      height: 30.h,
      width: 35.w,
      color: AppColors.colorPrimary,
      child: CachedNetworkImage(
        imageUrl: athleteProfiles[i],
        fit: BoxFit.cover,
        height: 30.h,
      ),
    ),
  );
}

SizedBox buildEventLocation(BuildContext context, String location) {
  return SizedBox(
    width: Dimensions.getScreenWidth(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          AppAssets.icLocation,
          height: 14.h,
          width: 14.w,
          color: AppColors.colorPrimaryAccent,
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
  );
}

SizedBox buildEventName(BuildContext context, String eventName) {
  return SizedBox(
    width: Dimensions.getScreenWidth(),
    child: Text(
      eventName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.smallTitle(),
    ),
  );
}

SizedBox buildCoverImage(
    {required BuildContext context, required String coverImage}) {
  return SizedBox(
    height: Dimensions.getScreenHeight(),
    child: CachedNetworkImage(alignment: Alignment.topCenter,
      imageUrl: coverImage,
      width: double.infinity,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Icon(Icons.error, color: AppColors.colorPrimaryNeutral),
    ),
  );
}


class LimitedRegistrationBanner extends StatelessWidget {
  const LimitedRegistrationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0), // Matches the border radius
        child: Stack(
          children: [
            // Outer gradient border
            Container(
              padding: const EdgeInsets.all(1.0), // Thickness of the gradient border
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.colorPrimaryAccent,
                    AppColors.colorPrimaryInverse,
                    AppColors.colorPrimaryAccent,
                  ],
                  stops: const [0.0, 0.5, 1.0], // Position of each color in the gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(6.0), // Gradient border radius
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Inner content radius
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 6.0,
                    sigmaY: 6.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimaryAccent, // Background color
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Wraps content
                      children: [
                        Icon(
                          Icons.access_time, // Clock icon
                          color: AppColors.colorPrimaryInverse, // Icon color
                          size: 24.0, // Icon size
                        ),
                        const SizedBox(width: 8.0), // Spacing between icon and text
                        Text(
                          'Limited Registrations Available',
                          style: AppTextStyles.landingTitle(fontSize: AppFontSizes.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

