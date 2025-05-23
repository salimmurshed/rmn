import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

Widget buildAthleteInformation(
    {required BuildContext context,
    required String fullName,
    required List<String> teamNames,
    required List<Registrations> registrations,
    required String teamName,
    required bool isEditActive,
    required void Function() openBottomSheetWithDropDown,
    required void Function() openBottomSheetWithRegisteredWcs}) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subtitle(isOutFit: true, isBold: true),
                ),
              )
            ],
          ),
          SizedBox(
            width: Dimensions.getScreenWidth() * 0.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    teamName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.regularNeutralOrAccented(
                      color: AppColors.colorPrimaryNeutralText,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: openBottomSheetWithDropDown,
                  child: Container(
                    height: 15.h,
                    width: 18.w,
                    margin: EdgeInsets.only(left: 10.w),
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.r),
                        color: isEditActive? AppColors.colorSecondaryAccent: AppColors.colorBlueOpaque),
                    child: SvgPicture.asset(AppAssets.icEdit),
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          buildTotalRegistrationInfo(
              isFromEventList: false,
              rank: 0,
              isUpcoming: true,
              value: registrations.length.toString(),
              onTapToOpenBottomSheet: openBottomSheetWithRegisteredWcs),
          SizedBox(
            height: 8.h,
          ),
        ],
      ),
    ),
  );
}
