import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'build_athlete_information_section.dart';
import 'build_division_name.dart';
import 'build_list_of_divisions_age_group_wise.dart';

Container buildSelectedAthleteWidget({
  required List<String> matchedTeams,
  required List<Team> teams,
  required bool isExpanded,
  required bool isOpened,
  required Athlete athlete,
  required TextEditingController searchController,
  required TextEditingController otherTeamController,
  required GlobalKey<State<StatefulWidget>> dropDownKey,
  required String? selectedValue,
  required void Function(String, Athlete, List<Team>) onTapMatchedTeam,
  required void Function(String?)? typedChange,
  required void Function(String?)? onChanged,
  required void Function(bool) onMenuStateChange,
  required void Function()? onTapToExpand,
  required void Function(Athlete) openModalBottomSheetForOtherTeam,
  required BuildContext context,
}) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
          color: AppColors.colorTertiary,
          borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius)),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildCustomAthleteProfileHolder(
            isFromRegs: true,
              imageUrl: athlete.profileImage!,
              age: athlete.age.toString(),
              weight: athlete.weightClass.toString()),
          buildAthleteInformationSection(
            isOpened: isOpened,
              onMenuStateChange: onMenuStateChange,
              openModalBottomSheetForOtherTeam:
                  openModalBottomSheetForOtherTeam,
              onTapToExpand: onTapToExpand,
              matchedTeams: matchedTeams,
              onTapMatchedTeam: onTapMatchedTeam,
              typedChange: typedChange,
              onChanged: onChanged,
              context: context,
              searchController: searchController,
              otherTeamController: otherTeamController,
              dropDownKey: dropDownKey,
              selectedValue: selectedValue,
              teams: teams,
              athlete: athlete,
              isExpanded: isExpanded)
        ]),
        if(isExpanded)
        buildListOfDivisionsAgeGroupWise(
            athleteRegistrationDivision:
                athlete.athleteRegistrationDivision ?? [])
      ]));
}

Container buildDivisionContainer(
    List<RegistrationDivision> athleteRegistrationDivision,
    int selectedDivisionIndex) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.colorPrimary,
      borderRadius: BorderRadius.circular(5.r),
    ),
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDivisionName(
            divisionName: athleteRegistrationDivision[selectedDivisionIndex]
                    .divisionName ??
                AppStrings.global_empty_string),
        buildRowForAgeGroupAndPrice(
            ageGroupName: athleteRegistrationDivision[selectedDivisionIndex]
                    .ageGroupName ??
                AppStrings.global_empty_string,
            guestRegistrationPrice:
                athleteRegistrationDivision[selectedDivisionIndex]
                        .guestRegistrationPrice ??
                    1,
            totalPriceForFinalisedWeights:
                athleteRegistrationDivision[selectedDivisionIndex]
                        .totalPriceForFinalisedWeights ??
                    1),
        buildStyleWithSelectedWeights(
          finalisedWeights: athleteRegistrationDivision[selectedDivisionIndex]
                  .finalisedWeights ??
              [],
          styleName:
              athleteRegistrationDivision[selectedDivisionIndex].styleName ??
                  AppStrings.global_empty_string,
        )
      ],
    ),
  );
}
