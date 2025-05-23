import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Future<dynamic> showDialogMetricDialog(
    {required BuildContext context, String? title, TypeOfMetric typeOfMetric = TypeOfMetric.none, String? text}) {
  return showDialog(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Material(
              type: MaterialType.transparency,
              child: Align(
                  alignment: Alignment.center,
                  child: Wrap(children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
                      decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius:
                        BorderRadius.circular(Dimensions.generalRadius),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(

                           title??  ( typeOfMetric == TypeOfMetric.noOfEvents
                                  ? AppStrings
                                  .profile_athlete_metrics_upcoming_title
                                  : typeOfMetric == TypeOfMetric.rank
                                  ? AppStrings
                                  .profile_athlete_metrics_rank_title
                                  : typeOfMetric == TypeOfMetric.award
                                  ? AppStrings
                                  .profile_athlete_metrics_awards_title
                                  : typeOfMetric == TypeOfMetric.weight
                                  ? AppStrings
                                  .profile_athlete_metrics_weight_title
                                  : AppStrings
                                  .profile_athlete_metrics_age_title),
                              style: AppTextStyles.smallTitle()),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 30.w),
                            child: Divider(
                              thickness: 2.w,
                              color: AppColors.colorPrimaryInverse,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Center(
                            child: Text(
                            text??  (typeOfMetric == TypeOfMetric.noOfEvents
                                  ? AppStrings
                                  .profile_athlete_metrics_upcoming_subtitle
                                  : typeOfMetric == TypeOfMetric.rank
                                  ? AppStrings
                                  .profile_athlete_metrics_rank_subtitle
                                  : typeOfMetric == TypeOfMetric.award
                                  ? AppStrings
                                  .profile_athlete_metrics_awards_subtitle
                                  : typeOfMetric == TypeOfMetric.weight
                                  ? AppStrings
                                  .profile_athlete_metrics_weight_subtitle
                                  : AppStrings
                                  .profile_athlete_metrics_age_subtitle),
                              style: AppTextStyles.regularPrimary(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]))),
        );
      });
}