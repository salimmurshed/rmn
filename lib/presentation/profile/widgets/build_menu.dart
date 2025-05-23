import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../data/models/arguments/athlete_argument.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';
import '../bloc/profile_bloc.dart';

GestureDetector buildMenu(BuildContext context,
    {required dynamic argument,
    required String routeName,
    required String menuTitle,
    required String iconUrl}) {
  return GestureDetector(
    onTap: () async {
      if(argument == null) {
        Navigator.pushNamed(context, routeName, arguments: argument);
      }else{
        Navigator.pushNamed(
            context,
            AppRouteNames.routeCreateOrEditAthleteProfile,
            arguments: AthleteArgument(
              createProfileType:argument
            )).then((value) {
          BlocProvider.of<ProfileBloc>(navigatorKey.currentContext!)
              .add(TriggerGetProfileData());});
      }
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(Dimensions.textFormFieldBorderRadius),
        color: AppColors.colorTertiary,
      ),
      height: 35.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      margin: EdgeInsets.only(bottom: Dimensions.generalGapSmall, left: 5.w, right: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconUrl,
                height: 15.h,
                width: 15.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  menuTitle,
                  style: AppTextStyles.subtitle(
                    isOutFit: false,
                      color: AppColors.colorPrimaryNeutral),
                ),
                const Spacer(),
                // Adds a flexible space to push the arrow to the right
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
