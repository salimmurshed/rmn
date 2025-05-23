import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'build_athlete_membership_info_price.dart';

Row buildARowOfAthleteNameAndTeamName({required Athlete athlete,
  required List<Team> teams,
  required bool isOpened,
  required Memberships? membership,
  required TextEditingController searchController,
  required TextEditingController otherTeamController,
  required GlobalKey<State<StatefulWidget>> dropDownKey,
  required String? selectedValue,
  required void Function(String, Athlete, List<Team>) onTapMatchedTeam,
  required void Function(String?)? onChanged,
  required void Function(String?)? typedChange,
  required void Function(bool) onMenuStateChange,
  required void Function(Athlete) openModalBottomSheetForOtherTeam,
  required BuildContext context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Text(
            StringManipulation.combineFirstNameWithLastName(
                firstName: athlete.firstName!, lastName: athlete.lastName!),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.smallTitle()),
      ),
      SizedBox(width: 10.w),
      buildAthleteMembershipInfo(membership),
    ],
  );
}
