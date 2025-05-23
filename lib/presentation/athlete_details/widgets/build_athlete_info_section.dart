import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../data/models/response_models/user_response_model.dart';
import '../../../imports/common.dart';
import '../bloc/athlete_details_bloc.dart';
import 'bottom_sheet_for_partial_owner_removal.dart';
bool isFirstTimeOpenedV = true;
bool isFirstTimeOpenedC = true;
Widget buildAthleteInfoSection(
    {required String name,
    required String teamName,
    required String phoneNumber,
    required String noOfViewers,
    required String noOfCoaches,
    required String email,
    required String athleteId,
    required BuildContext ctx,
      required num viewerCount,
      required num coachCount,
    required void Function(int index) removeViewer,
    required void Function(int index) removeCoach,
    required List<DataBaseUser> viewers,
    required List<DataBaseUser> coaches}) {
  return StatefulBuilder(builder: (context, setState){

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAthleteNameSection(name: name),
          buildAthleteTeamSection(teamName: teamName),
          buildAthleteInfo(iconUrl: AppAssets.icCall, info: phoneNumber),
          buildAthleteInfo(iconUrl: AppAssets.icEmail, info: email),
          Wrap(
            runSpacing: 2.h,
            spacing: 10.w,
            children: [
              buildAccessButtons(
                metricValue: viewerCount.toString(),
                metricLabel: AppStrings.global_athleteAccessType_view_title,
                iconUrl: AppAssets.icViewer,
                color: AppColors.colorSecondaryAccent,
                onTap: () {

                  buildCustomShowModalBottomSheetParent(
                      ctx: ctx,
                      isNavigationRequired: false,
                      child: BlocBuilder<AthleteDetailsBloc,
                          AthleteDetailsWithInitialState>(
                        bloc: isFirstTimeOpenedV?
                        (BlocProvider.of<AthleteDetailsBloc>(ctx)
                          ..add(TriggerViewPartialOwnerList(
                              isViewer: true, athleteId: athleteId))):null,
                        builder: (context, state) {
                          return buildCustomModalBottomSheetForPartialOwner(
                            isLoadingPartialOwner: state.isLoadingPartialOwners,
                              isViewer: true,
                              ownerName: name,
                              partialOwner: state.viewers,
                              ctx: ctx,
                              removePartialOwner: (index) {
                                buildBottomSheetWithBodyText(
                                  richText: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppStrings
                                                .bottomSheet_athletePartialOwnerRemoval_predecessor_subtitle,
                                            style: AppTextStyles.bottomSheetSubtitle(
                                                isOutfit: true),
                                          ),
                                          TextSpan(
                                            text: StringManipulation
                                                .combineFirstNameWithLastName(
                                                firstName:
                                                state.viewers[index].firstName!,
                                                lastName:
                                                state.viewers[index].lastName!),
                                            style: AppTextStyles.bottomSheetSubtitle(
                                                isOutfit: true,
                                                color: AppColors.colorPrimaryAccent),
                                          ),
                                          TextSpan(
                                            text: AppStrings
                                                .bottomSheet_athletePartialOwnerRemoval_successor_subtitle(
                                                true),
                                            style: AppTextStyles.bottomSheetSubtitle(
                                              isOutfit: true,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' $name\'s ',
                                            style: AppTextStyles.bottomSheetSubtitle(
                                                isOutfit: true,
                                                color: AppColors.colorPrimaryAccent),
                                          ),
                                          TextSpan(
                                            text: 'profile.',
                                            style: AppTextStyles.bottomSheetSubtitle(
                                              isOutfit: true,
                                            ),
                                          ),
                                        ],
                                      )),
                                  highLightedAthleteName:
                                  AppStrings.global_empty_string,
                                  context: ctx,
                                  title: AppStrings
                                      .bottomSheet_athleteViewerRemoval_title,
                                  subtitle: AppStrings.global_empty_string,
                                  isSingeButtonPresent: false,
                                  onLeftButtonPressed: () {
                                    Navigator.pop(ctx);
                                  },
                                  onRightButtonPressed: () {
                                    BlocProvider.of<AthleteDetailsBloc>(context).add(
                                        TriggerRemovePartialOwner(
                                            athleteId: state.athleteId,
                                            isViewer: true,
                                            context: context,
                                            userId: state.viewers[index].underScoreId!));
                                  },
                                  leftButtonText: AppStrings.btn_back,
                                  rightButtonText: AppStrings.btn_remove,
                                );
                              });
                        },
                      ));
                  setState(() {
                    isFirstTimeOpenedV = false;
                  });
                },

              ),
              buildAccessButtons(
                metricValue: coachCount.toString(),
                metricLabel: AppStrings.global_athleteAccessType_coach_title,
                iconUrl: AppAssets.icCoach,
                color: AppColors.colorSecondaryAccent,
                onTap: () {
                  buildCustomShowModalBottomSheetParent(
                      ctx: ctx,
                      isNavigationRequired: false,
                      child: BlocBuilder<AthleteDetailsBloc,
                          AthleteDetailsWithInitialState>(
                        bloc:isFirstTimeOpenedC?
                        (BlocProvider.of<AthleteDetailsBloc>(ctx)
                          ..add(TriggerViewPartialOwnerList(
                              isViewer: false, athleteId: athleteId))):null,
                        builder: (context, state) {
                          return buildCustomModalBottomSheetForPartialOwner(
                              isViewer: false,
                              isLoadingPartialOwner: state.isLoadingPartialOwners,
                              ownerName: name,
                              partialOwner: state.coaches,
                              ctx: ctx,
                              removePartialOwner: (index) {
                                buildBottomSheetWithBodyText(
                                  context: ctx,
                                  title: AppStrings
                                      .bottomSheet_athleteCoachRemoval_title,
                                  highLightedAthleteName:
                                  AppStrings.global_empty_string,
                                  richText: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppStrings
                                                .bottomSheet_athletePartialOwnerRemoval_predecessor_subtitle,
                                            style: AppTextStyles
                                                .regularNeutralOrAccented(
                                                isOutfit: true),
                                          ),
                                          TextSpan(
                                            text: StringManipulation
                                                .combineFirstNameWithLastName(
                                                firstName:
                                                state.coaches[index].firstName!,
                                                lastName:
                                                state.coaches[index].lastName!),
                                            style: AppTextStyles
                                                .regularNeutralOrAccented(
                                                isOutfit: true,
                                                color:
                                                AppColors.colorPrimaryAccent),
                                          ),
                                          TextSpan(
                                            text: AppStrings
                                                .bottomSheet_athletePartialOwnerRemoval_successor_subtitle(
                                                false),
                                            style: AppTextStyles
                                                .regularNeutralOrAccented(
                                              isOutfit: true,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' $name\'s ',
                                            style: AppTextStyles
                                                .regularNeutralOrAccented(
                                                isOutfit: true,
                                                color:
                                                AppColors.colorPrimaryAccent),
                                          ),
                                          TextSpan(
                                            text: 'profile.',
                                            style: AppTextStyles
                                                .regularNeutralOrAccented(
                                                isOutfit: true,
                                                color: AppColors
                                                    .colorPrimaryInverseText),
                                          ),
                                        ],
                                      )),
                                  subtitle: AppStrings.global_empty_string,
                                  isSingeButtonPresent: false,
                                  onLeftButtonPressed: () {
                                    Navigator.pop(ctx);
                                  },
                                  onRightButtonPressed: () {
                                    BlocProvider.of<AthleteDetailsBloc>(context).add(
                                        TriggerRemovePartialOwner(
                                            athleteId: state.athleteId,
                                            isViewer: false,
                                            context: context,
                                            userId: state.coaches[index].underScoreId!));
                                  },
                                  leftButtonText: AppStrings.btn_no,
                                  rightButtonText: AppStrings.btn_yes,
                                );
                              });
                        },
                      ));
                  setState(() {
                    isFirstTimeOpenedC = false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  });
}

GestureDetector buildAccessButtons(
    {required void Function()? onTap,
    required String metricLabel,
    required String metricValue,
    required String iconUrl,
    required Color color}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(top: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(right: 5.w),
              height: 12.h,
              width: 13.w,
              child: SvgPicture.asset(fit: BoxFit.contain, iconUrl)),
          Text('$metricValue $metricLabel',
              style: AppTextStyles.componentLabels()),
        ],
      ),
    ),
  );
}

Row buildAthleteInfo({required String iconUrl, required String info}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.h),
        child: SvgPicture.asset(iconUrl),
      ),
      Expanded(
        child: Text(info,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.normalPrimary()),
      ),
    ],
  );
}

Row buildAthleteTeamSection({required String teamName}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Expanded(
        child: Text(teamName,
            maxLines: 1,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.smallTitle(
                color: AppColors.colorPrimaryNeutralText)),
      ),
    ],
  );
}

Row buildAthleteNameSection({required String name}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Text(name,
            maxLines: 1,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.extraLargeTitle()),
      ),
    ],
  );
}

Row buildUserInfoRow({required String icon, required String info}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.h),
        child: SvgPicture.asset(icon),
      ),
      Flexible(
          child: Text(info,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.subtitle())),
    ],
  );
}
