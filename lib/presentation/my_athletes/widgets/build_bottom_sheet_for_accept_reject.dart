import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

void buildBottomSheetForAcceptOrReject({
  required BuildContext context,
  required Athlete athlete,
  required void Function() reject,
  required void Function() accept,
}) {
  buildCustomShowModalBottomSheetParent(
      ctx: context,
      isNavigationRequired: false,
      child: customBottomSheetBasicBody(
          title: AppStrings
              .myAthletes_bottomSheet_acceptRejectBody_title(
            access: AppStrings
                .myAthletes_bottomSheet_acceptRejectBody_accessType_title(
                access: athlete.accessType!),
          ),
          highLightedAthleteName: AppStrings.global_empty_string,
          isSingeButtonPresent: false,
          onLeftButtonPressed: reject,isButtonPresent: true,
          leftButtonText: AppStrings.btn_reject,
          onRightButtonPressed: accept,
          rightButtonText: AppStrings.btn_accept,
          context: context,
          footerNote: AppStrings.global_empty_string,
          richText:  AppWidgetStyles.buildBodyTextWithHighlightedText(
              precedingText: athlete.accessType == 0
                  ? AppStrings
                  .myAthletes_bottomSheet_acceptRejectBody_viewAccess_preceding_text
                  : athlete.accessType == 1
                  ? AppStrings
                  .myAthletes_bottomSheet_acceptRejectBody_ownershipAccess_preceding_text
                  : AppStrings
                  .myAthletes_bottomSheet_acceptRejectBody_coachAccess_preceding_text,
              highlightedText:
              StringManipulation.combineFirstNameWithLastName(
                firstName: athlete.firstName!,
                lastName: athlete.lastName!,
              ),
              followingText: athlete.accessType == 0
                  ? AppStrings
                  .myAthletes_bottomSheet_acceptRejectBody_viewAccess_following_text
                  : athlete.accessType == 1
                  ? AppStrings
                  .myAthletes_bottomSheet_acceptRejectBody_ownershipAccess_following_text
                  : AppStrings
                  .myAthletes_bottomSheet_acceptRejectBody_coachAccess_following_text
          ),
          widget: Column(children: [
            if(athlete.accessType == 0) Text(AppStrings.bottomSheet_viewRight_title, style: AppTextStyles.regularNeutralOrAccented(isOutfit: true)),
            if(athlete.accessType == 2) Text(AppStrings.bottomSheet_coachRight_title, style: AppTextStyles.regularNeutralOrAccented(isOutfit: true)),
            if(athlete.accessType == 1) Text(AppStrings.bottomSheet_ownershipRight_title, style: AppTextStyles.regularNeutralOrAccented(isOutfit: true)),
            Container(
              margin: EdgeInsets.only(top: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppAssets.icPerson, width: 15.w, height: 15.h,),
                  SizedBox(width: 5.w,),
                  Text(athlete.requestData!.senderName!, style: AppTextStyles.subtitle(isOutFit: false)),
                ],
              ),
            )
          ],),
          singleButtonText: AppStrings.global_empty_string,
          isActive: true,
          isSingleButtonColorFilled: true)

      );
}
