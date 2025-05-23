import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../../../root_app.dart';
import '../../base/bloc/base_bloc.dart';
import '../bloc/athlete_details_bloc.dart';
import 'build_athlete_info_section.dart';
//
Row buildAthleteProfileSection(
    AthleteDetailsWithInitialState state, BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        height: isTablet? 150.h: 110.h,
        width: 120.w,
        child: Column(
          children: [
            buildCustomImagePlaceHolder(
                onTapImage: () {

                },
                //teams: globalTeams,
                seasons: globalSeasons,
                //athleteId: state.athleteId,
                sizeType: SizeType.medium,
                userStatus:
                state.athlete?.userStatus ?? AppStrings.global_empty_string,
                imageUrl:
                state.athlete?.profileImage ?? AppStrings.global_empty_string,
                membership: state.athlete?.membership),
          ],
        ),
      ),
      SizedBox(
        width: 10.w,
      ),
      buildAthleteInfoSection(
        viewerCount: state.athlete?.viewers == null
            ? 0
            : state.athlete!.viewers!,
        coachCount: state.athlete?.coaches == null
            ? 0
            : state.athlete!.coaches!,
        athleteId: state.athleteId,
        removeCoach: (index) {

        },
        removeViewer: (index) {

        },
        coaches: state.coaches,
        viewers: state.viewers,
        ctx: context,
        noOfViewers: state.athlete?.viewers == null
            ? '0'
            : state.athlete!.viewers!.toString(),
        noOfCoaches: state.athlete?.coaches == null
            ? '0'
            : state.athlete!.coaches!.toString(),
        teamName: state.athlete?.team == null
            ? AppStrings.global_no_team
            : state.athlete!.team!.name!,
        name: state.athlete == null
            ? AppStrings.global_empty_string
            : StringManipulation.combineFirstNameWithLastName(
            firstName: state.athlete!.firstName!,
            lastName: state.athlete!.lastName!),
        email: state.athlete?.email ?? AppStrings.global_empty_string,
        phoneNumber: state.athlete?.phoneNumber == null
            ? AppStrings.global_empty_string
            : state.athlete!.phoneNumber.toString(),
      ),
    ],
  );
}