import 'package:flutter/cupertino.dart';

import '../../../imports/data.dart';
import 'build_wrap_of_athletes.dart';
import 'build_wrap_of_weights.dart';

Wrap buildWrapOfAthletesAndWeights(
    {required List<String> weightAvailable,
      required List<String> ageGroupWithExpansionPanelWeights,
      required List<Athlete> expansionPanelAthletes,
      required void Function(int) openAthlete,
      required AgeGroups ageGroup,
      required void Function(AgeGroups ageGroup) addAthlete}) {
  return Wrap(
    direction: expansionPanelAthletes.isEmpty? Axis.vertical: Axis.horizontal,
    children: [
      buildWrapOfAthletes(
          openAthlete: openAthlete,
          ageGroup: ageGroup,
          expansionPanelAthletes: expansionPanelAthletes,
          addAthlete: addAthlete),
      buildWrapOfWeights(
          weightAvailable: weightAvailable,
          ageGroupWithExpansionPanelWeights: ageGroupWithExpansionPanelWeights)
    ],
  );
}