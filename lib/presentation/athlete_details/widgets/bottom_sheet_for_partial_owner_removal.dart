import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/imports/common.dart';

import '../../../data/models/response_models/user_response_model.dart';

Widget buildCustomModalBottomSheetForPartialOwner(
    {required String ownerName,
    required List<DataBaseUser> partialOwner,
    required bool isViewer,
      required bool isLoadingPartialOwner,
    required void Function(int index) removePartialOwner,
    required BuildContext ctx}) {
  return customBottomSheetBasicBody(
      title: isViewer
          ? AppStrings.bottomSheet_athleteViewerList_title
          : AppStrings.bottomSheet_athleteCoachList_title,
      isButtonPresent: false,
      isAccentedHighlight: true,
      highLightedAthleteName: ownerName,
      isSingeButtonPresent: false,
      onLeftButtonPressed: () {},
      widget: isLoadingPartialOwner?
      CustomLoader(
        isForSingleWidget: true,
          child: Container()):(partialOwner.isEmpty
          ? Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        child: Center(
          child: Text(
              isViewer
                  ? AppStrings.bottomSheet_athleteViewerEmptyList_bodyText
                  : AppStrings.bottomSheet_athleteCoachesEmptyList_bodyText,
              style: AppTextStyles.smallTitleForEmptyList()),
        ),
      )
          : Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        constraints: BoxConstraints(
            maxHeight: Dimensions.getScreenHeight() * 0.45),
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return Container(
                  decoration: BoxDecoration(
                      color: AppColors.colorSecondary,
                      borderRadius: BorderRadius.circular(5.r)),
                  padding: EdgeInsets.symmetric(
                      horizontal: 5.w, vertical: 5.h),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3.r),
                        child: Container(
                          color: AppColors.colorPrimary,
                          child: CachedNetworkImage(
                            imageUrl: partialOwner[i].profile!,
                            height: 20.h,
                            width: 20.w,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                SvgPicture.asset(AppAssets.icProfile,
                                    height: 20.h,
                                    width: 20.w,
                                    fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 5.w),
                            child: Text(
                                StringManipulation
                                    .combineFirstNameWithLastName(
                                    firstName: partialOwner[i].firstName!,
                                    lastName: partialOwner[i].lastName!),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.componentLabels()),
                          )),
                      GestureDetector(
                        onTap: () {
                          removePartialOwner(i);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.colorDisabledPrimaryAccent,
                              borderRadius: BorderRadius.circular(5.r)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 2.h),
                          child: Row(
                            children: [
                              SvgPicture.asset(AppAssets.icTrash,
                                  fit: BoxFit.contain,
                                  colorFilter: ColorFilter.mode(
                                      AppColors.colorPrimaryInverse,
                                      BlendMode.srcIn),
                                  height: 12.h,
                                  width: 12.w),
                              // Text(AppStrings.btn_remove,
                              //     style: AppTextStyles.componentLabels()),
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
            },
            separatorBuilder: (context, i) {
              return SizedBox(
                height: 10.h,
              );
            },
            itemCount: partialOwner.length),
      )),
      leftButtonText: AppStrings.global_empty_string,
      onRightButtonPressed: () {},
      rightButtonText: AppStrings.global_empty_string,
      context: ctx,
      singleButtonText: AppStrings.global_empty_string,
      isActive: false,
      footerNote: isViewer
          ? AppStrings.bottomSheet_athleteViewerList_subtitle
          : AppStrings.bottomSheet_athleteCoachesList_subtitle,
      isSingleButtonColorFilled: true);
}
