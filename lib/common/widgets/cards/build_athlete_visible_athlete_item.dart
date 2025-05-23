import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
import '../../../root_app.dart';

Container buildVisibleAthleteItem({
  required String weightClass,
  required String age,
  required String imageUrl,
  required String firstName,
  required String lastName,
  required int index,
  required bool noMembership,
  bool isLocal = false,
  required String selectedSeasonPassTitle,
  required void Function()? removeAthlete,
  required void Function() openBottomSheet,
}) {
  return Container(
    height: 100.h,
    padding: EdgeInsets.all(10.r),
    decoration: BoxDecoration(
        color: AppColors.colorSecondary,
        borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCustomAthleteProfileHolder(
          isLocal: isLocal,
            weight: weightClass, age: age, imageUrl: imageUrl),
        Container(
          padding: EdgeInsets.only(left: 10.w),
          width: Dimensions.getScreenWidth() * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      StringManipulation.combineFirstNameWithLastName(
                          firstName: firstName, lastName: lastName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.largeTitle(),
                    ),
                  ),
                ],
              ),
              IntrinsicWidth(
                child: GestureDetector(
                  onTap: openBottomSheet,
                  child: Container(
                    margin: EdgeInsets.only(top: isTablet ? 5.h: 20.h),
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                            width: 2.w,
                            color: !noMembership
                                ? Colors.transparent
                                : AppColors.colorPrimaryNeutral),
                        color: !noMembership
                            ? AppColors.colorPrimaryAccent
                            : Colors.transparent),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(AppAssets.icSelectSeasonPass),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 5.w, left: 5.w, bottom: 1.h),
                          child: Text(
                            !noMembership
                                ? AppStrings
                                    .buySeasonPasses_athleteWithoutSeasonPass_bottomSheetButton_title
                                : selectedSeasonPassTitle,
                            style: AppTextStyles.buttonTitle(
                                color: !noMembership
                                    ? AppColors.colorPrimaryInverseText
                                    : AppColors.colorPrimaryAccent),
                          ),
                        ),
                        SvgPicture.asset(AppAssets.icLeftArrow),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const Spacer(),
        if (removeAthlete != null)
          GestureDetector(
              onTap: removeAthlete, child: SvgPicture.asset(
            height: isTablet ?18.sp: null,
              width: isTablet ? 20.w: null,
              AppAssets.icBin))
      ],
    ),
  );
}

Container buildAthleteCardGeneral({
  required String weightClass,
  required String age,
  required String imageUrl,
  required String firstName,
  required String lastName,
  required int index,
  bool isActive = true,
  bool isLocal = false,
  required String? selectedDivision,
  required void Function()? removeAthlete,
  required void Function() edit,
  required void Function() openBottomSheet,
}) {
  print('buildAthleteCardGeneral $weightClass $age $imageUrl $firstName $lastName $index $selectedDivision');
  return Container(
    height: 100.h,
    padding: EdgeInsets.all(8.r),
    decoration: BoxDecoration(
        color: AppColors.colorSecondary,
        borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCustomAthleteProfileHolder(
          isLocal: isLocal,
            weight: weightClass, age: age, imageUrl: imageUrl),
        Container(
          padding: EdgeInsets.only(left: 10.w),
          width: Dimensions.getScreenWidth() * 0.51,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      StringManipulation.combineFirstNameWithLastName(
                          firstName: firstName, lastName: lastName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.largeTitle(),
                    ),
                  ),
                ],
              ),
              // IntrinsicWidth(
              //   child: GestureDetector(
              //     onTap: openBottomSheet,
              //     child: Container(
              //       margin: EdgeInsets.only(top: 20.h),
              //       padding: EdgeInsets.symmetric(horizontal: 5.w),
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(5.r),
              //           border: Border.all(
              //               width: 2.w,
              //               color: selectedDivision != null
              //                   ? Colors.transparent
              //                   : AppColors.colorPrimaryNeutral),
              //           color: selectedDivision == null
              //               ? AppColors.colorPrimaryAccent
              //               : Colors.transparent),
              //       child: Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           SvgPicture.asset(
              //            height: 16.sp,
              //               AppAssets.icWeight),
              //           Padding(
              //             padding: EdgeInsets.only(
              //                 right: 5.w, left: 5.w, bottom: 1.h),
              //             child: Text(
              //               selectedDivision ??
              //                   AppStrings.registerAndSell_selectDivision_title,
              //               style: AppTextStyles.buttonTitle(
              //                   color: selectedDivision == null
              //                       ? AppColors.colorPrimaryInverseText
              //                       : AppColors.colorPrimaryAccent),
              //             ),
              //           ),
              //           SvgPicture.asset(AppAssets.icLeftArrow),
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
        const Spacer(),
        if(isLocal)
        SizedBox(
          height: 25.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: edit,
                  child: Container(
                      height: 24.h,
                      width: 25.w,
                      padding: EdgeInsets.all(5.r),
                      decoration: BoxDecoration(
                          color:isActive?  AppColors.colorSecondaryAccent: AppColors.colorBlueOpaque,
                          borderRadius: BorderRadius.circular(5.r)),
                      child: SvgPicture.asset(
                          fit: BoxFit.cover,
                          AppAssets.icEdit))),
              SizedBox(width: 8.w),
              GestureDetector(
                  onTap: removeAthlete,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.r),
                    child:
                    Opacity(
                        opacity: isActive ? 1 : 0.5,
                        child: SvgPicture.asset(fit: BoxFit.cover,
                            height: 25.h,
                            width: 23.w,
                            AppAssets.icBin)),
                  ))
            ],
          ),
        )
      ],
    ),
  );
}
