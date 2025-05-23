import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../imports/common.dart';
import '../../dialog/metric_dialog.dart';

Widget metrics(
        {required BuildContext context,
        required TypeOfMetric typeOfMetric,
        required SizeType sizeType,
        required String athleteFirstName,
        required String athleteLastName,
        required String metricValue}) =>
    InkWell(
      onTap: () {
        showDialogMetricDialog(context: context, typeOfMetric: typeOfMetric);
      },
      child: Container(
        // height: sizeType == SizeType.large
        //     ? 30.h
        //     : sizeType == SizeType.medium
        //         ? 20.5.h
        //         : 15.h,
        padding: EdgeInsets.symmetric(
            vertical: sizeType == SizeType.large
                ? 2.55.h
                : sizeType == SizeType.medium
                    ? 1.59.h
                    : 5.h),
        width: sizeType == SizeType.large
            ? 80.w
            : sizeType == SizeType.medium
                ? 40.w
                : 30.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius),
            color: typeOfMetric == TypeOfMetric.age
                ? AppColors.colorPrimaryAccent
                : typeOfMetric == TypeOfMetric.weight
                    ? AppColors.colorSecondaryAccent
                    : AppColors.colorPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            svgPlaceHolder(
                sizeType: sizeType,
                isMetric: true,
                imageUrl: typeOfMetric == TypeOfMetric.age
                    ? AppAssets.icAge
                    : typeOfMetric == TypeOfMetric.weight
                        ? AppAssets.icWeight
                        : typeOfMetric == TypeOfMetric.rank
                            ? AppAssets.icRank
                            : typeOfMetric == TypeOfMetric.award
                                ? AppAssets.icAwards
                                : AppAssets.icCalendar,
                typeOfMetric: typeOfMetric),
            metricLabelHolder(text: metricValue, sizeType: sizeType)
          ],
        ),
      ),
    );



Text metricLabelHolder({required SizeType sizeType, required String text}) {
  return Text(
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    text,
    style: sizeType == SizeType.large
        ? AppTextStyles.smallTitle()
        : sizeType == SizeType.medium
            ? AppTextStyles.componentLabels()
            : AppTextStyles.componentLabels(),
  );
}

Widget dividerLine({required SizeType sizeType}) => Container(
      margin: EdgeInsets.symmetric(
          vertical: sizeType == SizeType.large
              ? 8.h
              : sizeType == SizeType.medium
                  ? 3.5.h
                  : 1.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius),
        color: AppColors.colorPrimaryNeutral,
      ),
      height: 1.h,
      width: sizeType == SizeType.large
          ? 80.w
          : sizeType == SizeType.medium
              ? 40.w
              : 30.w,
    );
