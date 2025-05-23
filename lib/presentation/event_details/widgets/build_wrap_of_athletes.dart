import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/data.dart';
import 'build_athlete_image_with_age_weights_checkbox.dart';

Wrap buildWrapOfAthletes(
    {required List<Athlete> expansionPanelAthletes,
      required void Function(int) openAthlete,
      required AgeGroups ageGroup,
      required void Function(AgeGroups ageGroup) addAthlete}) {

  return Wrap(
    spacing: 10.w,
    runSpacing: 10.w,
    children: [
      for (var i = 0; i < expansionPanelAthletes.length; i++) ...[
        buildAthleteImageWithWeightsAgeCheckBox(
            openAthlete: (){
              openAthlete(i);
            },
            expansionPanelAthlete: expansionPanelAthletes[i]),
      ],
    //  buildAddAthleteButton(addAthlete: addAthlete, ageGroup: ageGroup),
    ],
  );
}