// ignore: unused_import
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../imports/common.dart';

bottomSheetForNoEditRegistration({
  required BuildContext context,
  required String athleteImageUrl,
  required String athleteAge,
  required String athleteWeight,
  required String registeredTeamName,
  required String athleteNameAsTheTitle,
  required String eventName,
  required String location,
  required bool isRegistrationAvailable,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.colorTertiary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.bottomSheetRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Section
          Text(
            registeredTeamName.isEmpty
                ? "Change Weightclass In Registration"
                : "Change Team In Registration",
            style: AppTextStyles.bottomSheetTitle(),
            textAlign: TextAlign.center,
          ),
          customDivider(isBottomSheetTitle: true),
          const SizedBox(height: 16),

          customAthleteImageForBottomSheet(
            imageUrl: athleteImageUrl,
            athleteAge: athleteAge,
            athleteWeight: athleteWeight,
            textStyle: AppTextStyles.extraLargeTitle(isLight: true),
            athleteNameAsTheTitle: athleteNameAsTheTitle,
          ),
          const SizedBox(height: 16),

          // Event Information Section
          Row(
            children: [
              Expanded(
                child: Container(
                  margin:  EdgeInsets.only(left: 5.w),
                  child: Text(
                    eventName,
                    style: AppTextStyles.subtitle(isOutFit: false),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppAssets.icLocation,
                colorFilter: ColorFilter.mode(
                  AppColors.colorPrimaryAccent,
                  BlendMode.srcIn,
                ),
                height: 16,
                width: 16,
              ),
               SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  location,
                  style: AppTextStyles.normalNeutral(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
           SizedBox(height: 30.h
           ),

          // Error/Information Message Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.colorPrimaryAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "IMPORTANT: ",
                style: AppTextStyles.normalPrimary(isBold: true, isOutfit: true),
               children: [
                 TextSpan(
                   text: isRegistrationAvailable
                    ? "This registration can’t be edited as you don’t have access to the athlete anymore."
                    : "The registration for the event is closed and can no longer be updated.\nIn urgent cases, please contact our support team via chat.",
                   style: AppTextStyles.normalPrimary(isOutfit: true),
                 ),
               ]
              ),
            ),
            // Text(
            //   isRegistrationAvailable
            //       ? "IMPORTANT: This registration can’t be edited as you don’t have access to the athlete anymore."
            //       : "The registration for the event is closed and can no longer be updated. In urgent cases, please contact our support team via chat.",
            //   style: AppTextStyles.regularNeutralOrAccented(),
            //   textAlign: TextAlign.center,
            // ),
          ),
          const SizedBox(height: 16),

          // Registered Team Section
          if (registeredTeamName.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.colorSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                registeredTeamName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          SizedBox(height: 30.h
          ),

          // OK Button
          buildCustomLargeFooterBtn(onTap: (){
            Navigator.of(context).pop();
          }, btnLabel: AppStrings.btn_ok, hasKeyBoardOpened: false, isColorFilledButton: true)
        ],
      ),
    ),
  );
}
