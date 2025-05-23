import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'empty_tab_list_text.dart';

Widget buildRankList({required List<Ranks> ranks}) {
  return ranks.isEmpty
      ? emptyTabListText(text: AppStrings.athleteDetails_ranksList_text)
      : Expanded(
    child: ListView.builder(
      itemCount: ranks.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.generalGapSmall),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(Dimensions.generalRadius),
            color: AppColors.colorTertiary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ranks[index].divisionType ??
                        AppStrings.global_empty_string,
                    style: AppTextStyles.smallTitle(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        ranks[index].division != null
                            ? ranks[index].division!.title!
                            : AppStrings.global_empty_string,
                        style: AppTextStyles.componentLabels(),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 5.w),
                          child: SvgPicture.asset(AppAssets.icWeight)),
                      Text(
                        ranks[index].weightClass != null
                            ? ranks[index]
                            .weightClass!
                            .weight
                            .toString()
                            : AppStrings.global_empty_string,
                        style: AppTextStyles.componentLabels(
                            color: AppColors.colorPrimaryAccent),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 5.w),
                      child: SvgPicture.asset(AppAssets.icRank)),
                  Text(
                    ranks[index].rank.toString(),
                    style: AppTextStyles.largeTitle(),
                  ),
                ],
              )
            ],
          ),
        );
      },
    ),
  );
}