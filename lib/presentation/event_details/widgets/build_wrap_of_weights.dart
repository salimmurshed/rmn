import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';

Widget buildWrapOfWeights(
    {required List<String> weightAvailable,
    required List<String> ageGroupWithExpansionPanelWeights}) {
  return SizedBox(
    width: Dimensions.getScreenWidth() * 0.8,

    child: Wrap(
    direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      children: [
        for (String weight in weightAvailable)
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.h),
            child: Text(
              weight == weightAvailable.last ? weight : '$weight, ',
              textAlign: TextAlign.left,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.regularNeutralOrAccented(
                  color: ageGroupWithExpansionPanelWeights.contains(weight)
                      ? AppColors.colorPrimaryAccent
                      : AppColors.colorPrimaryNeutralText),
            ),
          ),
      ],
    ),
  );
}
