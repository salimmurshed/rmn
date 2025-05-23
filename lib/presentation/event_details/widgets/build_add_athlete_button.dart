import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';


GestureDetector buildAddAthleteButton({required AgeGroups ageGroup,required void Function(AgeGroups ageGroup) addAthlete}) {
  return GestureDetector(
    onTap: (){
      addAthlete(ageGroup);
    },
    child: Container(
      height: 35.h,
      width: 40.w,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.colorPrimaryAccent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: SvgPicture.asset(AppAssets.icAdd, fit: BoxFit.cover),
    ),
  );
}
