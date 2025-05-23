
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/home/staff_home_bloc/staff_home_bloc.dart';

import '../../../imports/common.dart';
import '../../pos_settings/widgets/pos_info_dialog.dart';

class PosDevice extends StatelessWidget {
  PosDevice(
      {super.key,
      required this.deviceName,
      this.isFromSettings = false,
      required this.isConnected});

  final String deviceName;
  final bool isConnected;
  bool isFromSettings;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
              context, AppRouteNames.routePosSettings)
              .then((val) {
            if (context.mounted) {
              BlocProvider.of<StaffHomeBloc>(context)
                  .add(TriggerGetBackReader());
            }
          });
        },
        child: Container(
          width: Dimensions.getScreenWidth(),
          margin: EdgeInsets.symmetric(horizontal: isFromSettings ? 0 : 15.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.colorSecondary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    AppStrings.staff_home_posContainer_title,
                    style: AppTextStyles.smallTitle(isOutFit: false),
                  ),
                  const Spacer(),
                  if (!isFromSettings)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                                context, AppRouteNames.routePosSettings)
                            .then((val) {
                          if (context.mounted) {
                            BlocProvider.of<StaffHomeBloc>(context)
                                .add(TriggerGetBackReader());
                          }
                        });
                      },
                      child: Text(
                        isConnected
                            ? AppStrings.staff_home_posContainer_changeCTA
                            : AppStrings.staff_home_posContainer_connectCTA,
                        style: TextStyle(
                          decorationStyle: TextDecorationStyle.solid,
                          decorationThickness: 2,
                          decorationColor: AppColors.colorPrimaryInverseText,
                          decoration: TextDecoration.underline,
                          fontFamily: AppFontFamilies.squada,
                          fontWeight: AppFontWeight.titleSmallWeightedOutFit,
                          fontSize: AppFontSizes.regular,
                          color: AppColors.colorPrimaryInverseText,
                        ),
                      ),
                    ),
                  if (isFromSettings) ...[
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        buildDialogForStaffPosInfo(
                            context: context,
                            posInfoType: PosInfoType.connected
                       );
                      },
                      child: Icon(
                        Icons.info_outline,
                        color: AppColors.colorPrimaryNeutral,
                      ),
                    )
                  ],
                ],
              ),
              SizedBox(height: 10.h),
              IntrinsicWidth(
                child: Row(
                  children: [
                    buildConnectedContainer(isConnected: isConnected),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: Text(
                        deviceName,
                        maxLines: 2,
                        style: AppTextStyles.largeTitle(
                            color: AppColors.colorComponent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget buildConnectedContainer({required bool isConnected, String? string}) {
  return Container(
    height: 30.h,
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    decoration: BoxDecoration(
      color: isConnected
          ? AppColors.colorSuccess.withOpacity(0.1)
          : AppColors.colorError.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Row(
      children: [
        Container(
          height: 10.h,
          width: 10.w,
          decoration: BoxDecoration(
            color: isConnected
                ? AppColors.colorSuccess
                : AppColors.colorPrimaryAccent,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          string ?? (isConnected
              ? AppStrings.staff_home_posContainer_connected_status
              : AppStrings.staff_home_posContainer_noDevice_status),
          style: AppTextStyles.subtitle(
              color: isConnected
                  ? AppColors.colorSuccess
                  : AppColors.colorPrimaryAccent),
        ),
      ],
    ),
  );
}