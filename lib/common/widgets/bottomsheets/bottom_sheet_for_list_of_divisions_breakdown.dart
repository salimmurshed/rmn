import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

bottomSheetForListOfDivisionsWithRegisteredWCs({
  required BuildContext context,
  required String title,
  required String subtitle,
  required List<RegistrationWithSameDivisionId> registrationWithSameDivisionId,
  required bool isEditWCOptionAvailable,
  required Function(int index) editWc,
  required bool isEditActive,
}) {
  return customBottomSheetBasicBody(
      title: title,
      highLightedAthleteName: AppStrings.global_empty_string,
      isSingeButtonPresent: false,
      onLeftButtonPressed: () {},
      leftButtonText: AppStrings.global_empty_string,
      onRightButtonPressed: () {},
      rightButtonText: AppStrings.global_empty_string,
      context: context,
      widget: SizedBox(
        height: Dimensions.getBottomSheetHeight(),
        child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.colorSecondary,
                ),
                margin: EdgeInsets.symmetric(vertical: 5.h),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            registrationWithSameDivisionId[index]
                                .division!
                                .divisionType!,
                            style: AppTextStyles.largeTitle()),
                        if(registrationWithSameDivisionId[index].isCancelled!)
                        Text(' (Cancelled)', style: AppTextStyles.largeTitle(color: AppColors.colorPrimaryAccent)),
                        const Spacer(),
                        if (isEditWCOptionAvailable)
                          GestureDetector(
                            onTap: () {
                              editWc(index);
                            },
                            child: Container(
                              height: 20.h,
                              width: 20.w,
                              margin: EdgeInsets.only(top: 8.h),
                              padding: EdgeInsets.all(2.r),
                              decoration: BoxDecoration(
                                  color: isEditActive
                                      ? AppColors.colorSecondaryAccent
                                      : AppColors.colorBlueOpaque,
                                  borderRadius: BorderRadius.circular(2.r)),
                              child: SvgPicture.asset(AppAssets.icEdit),
                            ),
                          )
                      ],
                    ),
                    Text(registrationWithSameDivisionId[index].division!.title!,
                        style: AppTextStyles.smallTitle()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppAssets.icWrestling,
                          height: 12.h,
                          width: 14.w,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                            registrationWithSameDivisionId[index]
                                .division!
                                .style!,
                            style: AppTextStyles.componentLabels()),
                        SizedBox(width: 20.w),
                        SvgPicture.asset(
                          AppAssets.icWeight,
                          height: 12.h,
                          width: 14.w,
                        ),
                        SizedBox(width: 5.w),
                        SizedBox(
                          width: Dimensions.getScreenWidth() * 0.5,
                          child: Text(
                              registrationWithSameDivisionId[index]
                                  .registeredWeightClasses!
                                  .join(' '),
                              overflow: TextOverflow.ellipsis,
                              // Apply ellipsis to overflowing text
                              maxLines: 1,
                              style: AppTextStyles.componentLabels(
                                  color: AppColors.colorPrimaryAccent)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            itemCount: registrationWithSameDivisionId.length),
      ),
      footerNote: subtitle,
      singleButtonText: AppStrings.global_empty_string,
      isActive: true,
      isButtonPresent: false,
      isSingleButtonColorFilled: true);

  // return Wrap(
  //   children: [
  //     Container(
  //       decoration:
  //           AppWidgetStyles.buildBoxDecorationForBottomSheet(isLightBg: false),
  //       child: Padding(
  //         padding: AppWidgetStyles.buildPaddingForBottomSheet(),
  //         child: Column(
  //           children: [
  //             AppWidgetStyles.buildTitleForBottomSheet(
  //                 title: title,
  //                 highlightedString: AppStrings.global_empty_string),
  //             customDivider(isBottomSheetTitle: true),
  //             AppWidgetStyles.buildBodyTextForBottomSheet(bodyText: subtitle),
  //             AppWidgetStyles.buildGapBetweenBodyAndFooterForBottomSheet(),
  //             SizedBox(
  //               height: Dimensions.getBottomSheetHeight(),
  //               child: ListView.builder(
  //                   itemBuilder: (context, index) {
  //                     return Container(
  //                       width: 200.w,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10.r),
  //                         color: AppColors.colorTertiary,
  //                       ),
  //                       margin: EdgeInsets.symmetric(vertical: 5.h),
  //                       padding: EdgeInsets.symmetric(
  //                           horizontal: 10.w, vertical: 10.h),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Row(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                   registrationWithSameDivisionId[index]
  //                                       .division!
  //                                       .divisionType!,
  //                                   style: AppTextStyles.largeTitle()),
  //                               const Spacer(),
  //                               if (isEditWCOptionAvailable)
  //                                 GestureDetector(
  //                                   onTap: () {
  //                                     editWc(index);
  //                                   },
  //                                   child: Container(
  //                                     height: 15.h,
  //                                     width: 15.w,
  //                                     margin: EdgeInsets.only(top: 8.h),
  //                                     padding: EdgeInsets.all(2.r),
  //                                     decoration: BoxDecoration(
  //                                         color: AppColors.colorSecondaryAccent,
  //                                         borderRadius:
  //                                             BorderRadius.circular(2.r)),
  //                                     child: SvgPicture.asset(AppAssets.icEdit),
  //                                   ),
  //                                 )
  //                             ],
  //                           ),
  //                           Text(
  //                               registrationWithSameDivisionId[index]
  //                                   .division!
  //                                   .title!,
  //                               style: AppTextStyles.smallTitle()),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               SvgPicture.asset(
  //                                 AppAssets.icWrestling,
  //                                 height: 12.h,
  //                                 width: 14.w,
  //                               ),
  //                               SizedBox(width: 5.w),
  //                               Text(
  //                                   registrationWithSameDivisionId[index]
  //                                       .division!
  //                                       .style!,
  //                                   style: AppTextStyles.componentLabels()),
  //                               SizedBox(width: 20.w),
  //                               SvgPicture.asset(
  //                                 AppAssets.icWeight,
  //                                 height: 12.h,
  //                                 width: 14.w,
  //                               ),
  //                               SizedBox(width: 5.w),
  //                               SizedBox(
  //                                 width: Dimensions.getScreenWidth() *
  //                                     0.5,
  //                                 child: Text(
  //                                     registrationWithSameDivisionId[index]
  //                                         .registeredWeightClasses!
  //                                         .join(' '),
  //                                     overflow: TextOverflow.ellipsis,
  //                                     // Apply ellipsis to overflowing text
  //                                     maxLines: 1,
  //                                     style: AppTextStyles.componentLabels(
  //                                         color: AppColors.colorPrimaryAccent)),
  //                               ),
  //                             ],
  //                           )
  //                         ],
  //                       ),
  //                     );
  //                   },
  //                   itemCount: registrationWithSameDivisionId.length),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   ],
  // );
}
