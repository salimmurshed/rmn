import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/data.dart';
import 'build_selected_athlete_widget.dart';

Widget buildTheListOfSelectedAthletesForRegistration({

  required bool isOpened,
  required List<Athlete> readyForRegistrationAthletes,
  required List<String> matchedTeams,
  required List<Team> teams,
  required TextEditingController searchController,
  required TextEditingController otherTeamController,
  required GlobalKey<State<StatefulWidget>> Function(int) dropDownKey,
  required String? Function(int) selectedValue,
  required bool Function(int) isExpanded,
  required void Function(String, Athlete, List<Team>) onTapMatchedTeam,
  required void Function(String?)? typedChange,
  required void Function(String?, int) onChanged,
  required void Function(int) onTapToExpand,
  required void Function(bool) onMenuStateChange,
  required void Function(Athlete) openModalBottomSheetForOtherTeam,
}) {

  return Expanded(
    //height: Dimensions.getScreenHeight()*0.52,
    child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 0),
        itemBuilder: (context, athleteIndex) {

          return
            GestureDetector(
              onTap: () {

              },
              child: buildSelectedAthleteWidget(
                isOpened: isOpened,
                onMenuStateChange: onMenuStateChange,
                openModalBottomSheetForOtherTeam:
                    openModalBottomSheetForOtherTeam,
                context: context,
                onTapToExpand: () {
                  onTapToExpand(athleteIndex);
                },
                matchedTeams: matchedTeams,
                onTapMatchedTeam: onTapMatchedTeam,
                onChanged: (value) {
                  onChanged(value, athleteIndex);
                },
                typedChange: typedChange,
                searchController: searchController,
                otherTeamController: otherTeamController,
                dropDownKey: dropDownKey(athleteIndex),
                selectedValue: selectedValue(athleteIndex),
                teams: teams,
                isExpanded: isExpanded(athleteIndex),
                athlete: readyForRegistrationAthletes[athleteIndex]),
            );
        },
        separatorBuilder: (context, i) {
          return SizedBox(height: 20.h);
        },
        itemCount: readyForRegistrationAthletes.length),
  );
}
