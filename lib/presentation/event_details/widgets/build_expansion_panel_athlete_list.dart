import 'package:flutter/material.dart';

import '../../../imports/data.dart';
import 'build_wrap_of_athletes_and_weights.dart';


Align buildExpansionPanelAthleteList(
    {required List<String> weightAvailable,
    required List<String> ageGroupWithExpansionPanelWeights,
    required List<Athlete> expansionPanelAthletes,
    required void Function(int) openAthlete,
    required AgeGroups ageGroup,

    required void Function(AgeGroups ageGroup) addAthlete}) {
  return Align(
    alignment: Alignment.topLeft,
    child: buildWrapOfAthletesAndWeights(
      ageGroup: ageGroup,
      addAthlete: (ageGroup){
        addAthlete(ageGroup);
      },
      expansionPanelAthletes: expansionPanelAthletes,
      openAthlete: openAthlete,
      weightAvailable: weightAvailable,
      ageGroupWithExpansionPanelWeights: ageGroupWithExpansionPanelWeights,
    ),
  );
}













