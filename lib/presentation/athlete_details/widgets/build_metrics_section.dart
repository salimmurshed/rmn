import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/root_app.dart';

import '../../../common/widgets/dialog/metric_dialog.dart';
import '../../../imports/common.dart';
import '../bloc/athlete_details_bloc.dart';
import 'build_athlete_metrics.dart';

Container buildMetricsSection(AthleteDetailsWithInitialState state) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: Dimensions.generalGapSmall),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            showDialogMetricDialog(
                context: navigatorKey.currentContext!,
                title: AppStrings.dialog_athleteDetail_event_title,
                text: AppStrings.dialog_athleteDetail_event_subtitle,
                typeOfMetric: TypeOfMetric.noOfEvents);
          },
          child: buildAthleteMetrics(
            iconUrl: AppAssets.icAthleteCalendar,
            info: state.athlete?.registrations == null
                ? '0'
                : state.athlete!.registrations.toString(),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        GestureDetector(
          onTap: () {
            showDialogMetricDialog(
                context: navigatorKey.currentContext!,
                title: AppStrings.dialog_athleteDetail_awards_title,
                text: AppStrings.dialog_athleteDetail_awards_subtitle,
                typeOfMetric: TypeOfMetric.award);
          },
          child: buildAthleteMetrics(
            iconUrl: AppAssets.icAwards,
            info: state.athlete?.awards == null
                ? '0'
                : state.athlete!.awards.toString(),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        GestureDetector(
          onTap: () {
            showDialogMetricDialog(
                context: navigatorKey.currentContext!,
                title: AppStrings.dialog_athleteDetail_rank_title,
                text: AppStrings.dialog_athleteDetail_rank_subtitle,
                typeOfMetric: TypeOfMetric.rank);
          },
          child: buildAthleteMetrics(
            iconUrl: AppAssets.icRank,
            info: state.athlete?.rank == null
                ? '0'
                : state.athlete!.rank.toString(),
          ),
        ),
      ],
    ),
  );
}
