import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/data.dart';
import 'build_selected_athlete_widget.dart';

Widget buildListOfDivisionsAgeGroupWise(
    {required List<RegistrationDivision> athleteRegistrationDivision}) {
  return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 20.h),
      itemBuilder: (context, selectedDivisionIndex) {
        return buildDivisionContainer(
            athleteRegistrationDivision, selectedDivisionIndex);
      },
      separatorBuilder: (context, selectedDivisionIndex) {
        return Container(
          height: 20,
        );
      },
      itemCount: athleteRegistrationDivision.length);
}