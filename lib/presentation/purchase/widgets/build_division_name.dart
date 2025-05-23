import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';

Text buildDivisionName({required String divisionName}) {
  return Text(
    divisionName,
    style: AppTextStyles.smallTitle(),
  );
}

Row buildRowForAgeGroupAndPrice({
  required String ageGroupName,
  required num guestRegistrationPrice,
  required num totalPriceForFinalisedWeights,
}) {
  return Row(
    children: [
      Text(
        ageGroupName,
        style: AppTextStyles.subtitle(isOutFit: false),
      ),
      const Spacer(),
      RichText(
        text: TextSpan(
          text:
              'Each ${StringManipulation.addADollarSign(price: guestRegistrationPrice)} = ',
          style: AppTextStyles.regularPrimary(isOutFit: false),
          children: [
            TextSpan(
                text: StringManipulation.addADollarSign(
                    price: totalPriceForFinalisedWeights),
                style: AppTextStyles.subtitle(isOutFit: false)),
          ],
        ),
      ),
    ],
  );
}

Widget buildStyleWithSelectedWeights({
  required String styleName,
  required List<String> finalisedWeights,
}) {
  return SizedBox(
    width: Dimensions.getScreenWidth(),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      // alignment: WrapAlignment.start,
      // direction: Axis.horizontal,
      children: [
        Container(
          margin: EdgeInsets.only(right: 5.w),
          height: 15.h,
          width: 14.w,
          child: SvgPicture.asset(AppAssets.icWrestling,
              colorFilter: ColorFilter.mode(
                  AppColors.colorPrimaryAccent, BlendMode.srcIn)),
        ),
        Text(
          styleName,
          style: AppTextStyles.subtitle(isOutFit: false),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.w, right: 5.w),
          height: 13.h,
          width: 14.w,
          child: SvgPicture.asset(AppAssets.icWeight,
              colorFilter: ColorFilter.mode(
                  AppColors.colorPrimaryAccent, BlendMode.srcIn)),
        ),
        Expanded(
          child: Text(
            finalisedWeights.join(', '),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subtitle(isOutFit: false),
          ),
        ),
      ],
    ),
  );
}
