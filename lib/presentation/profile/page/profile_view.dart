import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../imports/common.dart';
import '../../base/bloc/base_bloc.dart';
import '../../legals/bloc/legals_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/build_menu.dart';
import '../widgets/build_profile_information_container.dart';
import '../widgets/build_profile_picture.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late ProfileBloc _profileBloc;

  @override
  void initState() {
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _profileBloc.add(TriggerGetProfileData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileWithInitialState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(
            msg: state.message,
            isFailure: state.isFailure,
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileWithInitialState>(
        builder: (context, state) {
          return state.isLoadingForLogout
              ? CustomLoader(child: buildAccountLayout(state, context))
              : buildAccountLayout(state, context);
        },
      ),
    );
  }

  Scaffold buildAccountLayout(
      ProfileWithInitialState state, BuildContext context) {
    debugPrint('ProfileView: ${state.myAccountMenuModelList.first.routeName}');
    return Scaffold(
        backgroundColor: AppColors.colorPrimary,
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Dimensions.screenHorizontalGap),
          child: Column(
            children: [
              Flexible(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50.h, left: 5.w, right: 5.w),
                        height: Dimensions.getScreenHeight() * 0.22,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildProfilePicture(
                                    label: state.label,
                                    cachedNetworkImageUrl:
                                        state.cachedNetworkImageUrl,
                                    isLoadingForUserInfo:
                                        state.isLoadingForUserInfo),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5.w),
                                              child: Text(
                                                state.fullName,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyles.largeTitle(),
                                              ),
                                            ),
                                          ),
                                          // GestureDetector(
                                          //   onTap: () async {
                                          //     Navigator.pushNamed(
                                          //         context,
                                          //         AppRouteNames.routeCreateOrEditAthleteProfile,
                                          //         arguments: CreateProfileTypes
                                          //             .editProfileForOwner).then((value) {
                                          //
                                          //       _profileBloc
                                          //           .add(TriggerGetProfileData());});
                                          //   },
                                          //   child: Container(
                                          //
                                          //     padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                                          //     decoration: BoxDecoration(
                                          //       color: AppColors
                                          //           .colorSecondaryAccent,
                                          //       borderRadius:
                                          //       BorderRadius.circular(2.r),
                                          //     ),
                                          //     child: SvgPicture.asset(
                                          //       AppAssets.icEdit,
                                          //       height: 15.h,
                                          //       width: 15.w,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      buildUserInfoRow(
                                          info: state.phone,
                                          icon: AppAssets.icCall),
                                      buildUserInfoRow(
                                          info: state.email,
                                          icon: AppAssets.icEmail),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            if (state.isSwitchPresent)
                              BlocBuilder<BaseBloc, BaseWithInitialState>(
                                builder: (context, state) {
                                  return Positioned(
                                    bottom: 2,
                                    right: 30.w,
                                    left: 30.w,
                                    child: GestureDetector(
                                      onTap: () async {
                                        BlocProvider.of<BaseBloc>(context)
                                            .add(TriggerSwitchBetweenRoles());
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                currentRole ==
                                                        UserTypes.user.name
                                                    ? AppColors
                                                        .colorSecondaryAccent
                                                    : AppColors
                                                        .colorPrimaryAccent,
                                                currentRole ==
                                                        UserTypes.user.name
                                                    ? AppColors
                                                        .colorSecondaryAccent
                                                    : AppColors
                                                        .colorPrimaryAccent,
                                                Colors.black,
                                                Colors.black,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.generalSmallRadius),
                                            border: Border.all(
                                                color: currentRole ==
                                                        UserTypes.user.name
                                                    ? AppColors
                                                        .colorSecondaryAccent
                                                    : AppColors
                                                        .colorPrimaryAccent,
                                                width: 1),
                                          ),
                                          height: 40.h,
                                          margin: EdgeInsets.only(top: 27.h),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                currentRole ==
                                                        UserTypes.user.name
                                                    ? 'User View'
                                                    : 'Employee View',
                                                style: AppTextStyles.subtitle(isOutFit: true,
                                                    color: Colors.white),
                                              ),
                                              Transform.scale(
                                                scaleX: 0.8,
                                                scaleY: 0.7,
                                                child: CupertinoSwitch(
                                                    value: currentRole !=
                                                        UserTypes.user.name,
                                                    onChanged: (bool value) {
                                                      BlocProvider.of<BaseBloc>(
                                                              context)
                                                          .add(
                                                              TriggerSwitchBetweenRoles());
                                                    },
                                                    activeColor: AppColors
                                                        .colorPrimaryAccent,
                                                    trackColor: AppColors
                                                        .colorSecondaryAccent
                                                    // trackColor: ColorManager.secondaryBlue,
                                                    ),
                                              )
                                            ],
                                          )),
                                    ),
                                  );
                                },
                              ),

                          ],
                        ),
                      ),
                      if (state.isSwitchPresent)
                        SizedBox(
                          height: 15.h,
                        ),
                      buildMetrics(
                        metricCountForAthlete: state.noOfAthletes.toString(),
                        metricCountForAwards: state.noOfAwards.toString(),
                        metricCountForEvents:
                            state.noOfUpcomingEvents.toString(),
                      ),
                      if(state.noOfAthletes != '0')
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 10.h, bottom: 5.h, left: 5.w),
                          child: Text(
                            'Settings',
                            style: AppTextStyles.subtitle(
                              isOutFit: false,
                                color: AppColors.colorPrimaryNeutralText),
                          ),
                        ),
                      ),
                      if (state.noOfAthletes == '0') ...[
                        SizedBox(
                          height: 15.h,
                        ),
                        buildInformationTitle(
                            text: AppStrings
                                .accountSettings_zeroAthleteMenu_preceding_title),
                        buildMenu(context,
                            argument: CreateProfileTypes
                                .addAthleteFromMyList, // CreateProfileTypes.createProfileForOwner
                            iconUrl: state.myAccountMenuModelList.first.iconUrl,
                            menuTitle:
                                state.myAccountMenuModelList.first.menuTitle,
                            routeName:
                                state.myAccountMenuModelList.first.routeName),
                        buildInformationTitle(
                            text: AppStrings
                                .accountSettings_settings_preceding_title),
                      ],
                      for (var j = 1; j < state.myAccountMenuModelList.length; j++)
                        buildMenu(context,
                            argument: j != 1? null: CreateProfileTypes.editProfileForOwner,
                            iconUrl: state.myAccountMenuModelList[j].iconUrl,
                            menuTitle:
                                state.myAccountMenuModelList[j].menuTitle,
                            routeName:
                                state.myAccountMenuModelList[j].routeName),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 10.h,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    buildBottomSheetWithBodyText(
                        context: context,
                        title: AppStrings.bottomSheet_logout_title,
                        subtitle: AppStrings.accountSettings_logoutBtn_subtitle,
                        isSingeButtonPresent: false,
                        leftButtonText: AppStrings.btn_logOut,
                        rightButtonText: AppStrings.btn_stay,
                        onLeftButtonPressed: () {
                          _profileBloc.add(TriggerLogout());
                        },
                        onRightButtonPressed: () {
                          Navigator.of(context).pop();
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppAssets.icLogOut,
                        height: 15.h,
                        width: 15.w,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        AppStrings.accountSettings_logoutBtn_title,
                        style: AppTextStyles.smallTitle(

                            color: AppColors.colorPrimaryAccent),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimensions.generalGapSmall)
            ],
          ),
        ));
  }

  Container buildInformationTitle({required String text}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: Dimensions.generalGapSmall, left: 5.w),
      child: Text(
        text,
        style: AppTextStyles.smallTitle(color: AppColors.colorPrimaryNeutral),
      ),
    );
  }
}
