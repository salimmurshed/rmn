import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../imports/common.dart';
GestureDetector buildAvailableAthleteItem({
  required void Function() selectAthlete,
  required String weightClass,
  required String age,
  required String imageUrl,
  required String firstName,
  required String lastName,
  required bool isAthleteInList,
  required bool isAthleteInSelected,
}) {
  return GestureDetector(
    onTap: selectAthlete,
    child: Container(
      width: Dimensions.getScreenWidth(),
      height: 100.h,
      decoration: BoxDecoration(
          color: AppColors.colorSecondary,
          borderRadius: BorderRadius.circular(Dimensions.generalRadius)),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.generalGapSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCustomAthleteProfileHolder(
              weight: weightClass, age: age, imageUrl: imageUrl),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            width: Dimensions.getScreenWidth() * 0.5,
            child: Text(
              StringManipulation.combineFirstNameWithLastName(
                  firstName:firstName,
                  lastName:lastName),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextStyles.largeTitle(),
            ),
          ),
          isAthleteInList
              ? Opacity(
              opacity: 0.3,
              child: SvgPicture.asset(AppAssets.icBuyAthleteSeasonCheck))
              : SvgPicture.asset(
              isAthleteInSelected
                  ? AppAssets.icBuyAthleteSeasonCheck
                  : AppAssets.icBuyAthleteSeasonUncheck)
        ],
      ),
    ),
  );
}