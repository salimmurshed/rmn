import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/resources/app_strings.dart';
import '../../../imports/data.dart';
import '../../purchase/widgets/build_cliprRect_for_image.dart';
import '../../purchase/widgets/build_positioned_for_age_weight.dart';
import '../../purchase/widgets/build_positioned_for_checkbox.dart';
GestureDetector buildAthleteImageWithWeightsAgeCheckBox({
  required Athlete expansionPanelAthlete,
  required void Function() openAthlete,
}) {
  debugPrint('expansionPanelAthlete: ${expansionPanelAthlete.firstName} ${expansionPanelAthlete.lastName} ${expansionPanelAthlete.selectedTeam?.name} ${expansionPanelAthlete.selectedTeam?.id} ${expansionPanelAthlete.team?.name} ${expansionPanelAthlete.team?.id} ${expansionPanelAthlete.teamId}\n', wrapWidth: 3024);
  return GestureDetector(
    onTap: openAthlete,
    child: Container(
      padding: EdgeInsets.zero,
      height: 50.h,
      width: 72.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.r)),
      child: Stack(
        children: [
          buildClipRRectForImage(
            imageFile: expansionPanelAthlete.fileImage,
              profileImage: expansionPanelAthlete.profileImage ?? AppStrings.global_empty_string),
          buildPositionedForAgeWeight(
              weight: expansionPanelAthlete.weightClass.toString(),
              age: expansionPanelAthlete.age.toString()),
          buildPositionedForCheckbox(isSelectedORegistered: expansionPanelAthlete.isAthleteTaken ?? false)
        ],
      ),
    ),
  );
}