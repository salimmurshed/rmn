import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;
import '../../../imports/common.dart';
import '../../../imports/data.dart';

Row buildAthleteMembershipInfoAndPrice(
    {required Memberships? membership,
      required void Function()? onTapToExpand,
      required num totalRegistrationDivisionCost,
      required bool isExpanded}) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildAthleteMembershipInfo(membership),
        const Spacer(),
        buildPriceExpansionButton(
            onTapToExpand: onTapToExpand,
            totalRegistrationDivisionCost: totalRegistrationDivisionCost,
            isExpanded: isExpanded)
      ]);
}


GestureDetector buildPriceExpansionButton(
    {required void Function()? onTapToExpand,
      required num totalRegistrationDivisionCost,
      required bool isExpanded}) {
  return GestureDetector(
    onTap: onTapToExpand,
    child: Row(
      children: [
        Text(
          StringManipulation.addADollarSign(
              price: totalRegistrationDivisionCost),
          style: AppTextStyles.subtitle(
            color: isExpanded
                ? AppColors.colorPrimaryAccent
                : AppColors.colorPrimaryInverseText,
          ),
        ),
        Transform.rotate(
            angle: isExpanded ? 180 * math.pi / 180 : 180 * math.pi / 90,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: isExpanded
                  ? AppColors.colorPrimaryAccent
                  : AppColors.colorPrimaryInverseText,
            ))
      ],
    ),
  );
}

IntrinsicWidth buildAthleteMembershipInfo(Memberships? membership) {
  return IntrinsicWidth(
    child: Container(
      decoration: BoxDecoration(
          color: membership == null
              ? AppColors.colorPrimaryAccent
              : AppColors.colorBlueOpaque,
          borderRadius: BorderRadius.circular(2.r)),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Row(children: [
        SvgPicture.asset(AppAssets.icMembership, height: 13.h, width: 13.w),
        SizedBox(width: 2.w),
        Text(
            membership == null
                ? AppStrings.global_no_season_pass
                : StringManipulation.capitalizeFirstLetterOfEachWord(
                value: membership.product?.title ??
                    AppStrings.global_empty_string),
            style: AppTextStyles.normalPrimary(isOutfit: false)),
      ]),
    ),
  );
}