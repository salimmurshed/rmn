import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/app_settings/bloc/app_settings_bloc.dart';

import '../../../imports/common.dart';

class AppSettingsView extends StatefulWidget {
  AppSettingsView({super.key, this.isFromOnboarding});

  bool? isFromOnboarding;

  @override
  State<AppSettingsView> createState() => _AppSettingsViewState();
}

class _AppSettingsViewState extends State<AppSettingsView>
    with WidgetsBindingObserver {
  AppSettingOptions appSettingOptions = AppSettingOptions.notification;

  @override
  void initState() {
    BlocProvider.of<AppSettingsBloc>(context).add(TriggerFetchAppInformation());
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if ( state != AppLifecycleState.detached) {
      BlocProvider.of<AppSettingsBloc>(context)
          .add(TriggerCheckPhoneSettings());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppSettingsBloc, AppSettingsWithInitialStates>(
      listener: (context, state) {
        appSettingOptions = state.appSettingOptions;
      },
      child: BlocBuilder<AppSettingsBloc, AppSettingsWithInitialStates>(

        builder: (context, state) {
          return customScaffold(
              customAppBar: CustomAppBar(
                title: widget.isFromOnboarding == null
                    ? AppStrings.appSettings_title
                    : AppStrings.appSettings_permissionAccess_title,
                isLeadingPresent: widget.isFromOnboarding == null,
              ),
              hasForm: false,
              persistentFooterButtons: [
                if (widget.isFromOnboarding != null)
                  buildCustomLargeFooterBtn(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            AppRouteNames.routeSignInSignUp, (route) => false,
                            arguments: Authentication.signIn);
                      },
                      btnLabel: AppStrings.btn_continue,
                      hasKeyBoardOpened: false,
                      isColorFilledButton: true)
              ],
              formOrColumnInsideSingleChildScrollView: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildCardWithSwitch(
                      isActivated: state.isCrashCollectionActivated,
                      appSettingOption: AppSettingOptions.crashCollection),
                  if (widget.isFromOnboarding == null)
                    buildCardWithSwitch(
                        isActivated: state.isLocationDetectionActivated,
                        appSettingOption: AppSettingOptions.location),
                  buildCardWithSwitch(
                      isActivated: state.isNotificationActivated,
                      appSettingOption: AppSettingOptions.notification),
                  if (widget.isFromOnboarding == null)
                    customRegularExpansionTile(
                        isParent: false,
                        isNumZero: true,
                        isExpansionTileOpened: state.isExpansionTileOpened,
                        isBackDropDarker: false,
                        leading: SizedBox(
                          width: 15.w,
                        ),
                        onExpansionChanged: (value) {
                          BlocProvider.of<AppSettingsBloc>(context).add(
                              TriggerToggleExpansionTile(isExpanded: value));
                        },
                        title: AppStrings
                            .appSettings_appInformation_expansionTile_title,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppStrings
                                        .appSettings_appInformation_expansionTile_applicationName_title,
                                    style: AppTextStyles.smallTitle(),
                                  ),
                                ),
                                Text(
                                  state.appName,
                                  style: AppTextStyles.smallTitle(),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppStrings
                                        .appSettings_appInformation_expansionTile_applicationVersion_title,
                                    style: AppTextStyles.smallTitle(),
                                  ),
                                ),
                                Text(
                                  state.appBuildVersion,
                                  style: AppTextStyles.smallTitle(),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppStrings
                                        .appSettings_appInformation_expansionTile_applicationBuildNumber_title,
                                    style: AppTextStyles.smallTitle(),
                                  ),
                                ),
                                Text(
                                  state.appBuildNumber,
                                  style: AppTextStyles.smallTitle(),
                                )
                              ],
                            ),
                          )
                        ]),
                ],
              ),
              anyWidgetWithoutSingleChildScrollView: null);
        },
      ),
    );
  }

  Widget buildCardWithSwitch(
      {required AppSettingOptions appSettingOption,
      required bool isActivated}) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<AppSettingsBloc>(context).add(
            TriggerAppSettingsOptions(appSettingOptions: appSettingOption));
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 10.h),
        color: AppColors.colorSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appSettingOption == AppSettingOptions.notification
                    ? AppStrings.appSettings_notification_switch_title
                    : appSettingOption == AppSettingOptions.location
                        ? AppStrings.appSettings_enableLocation_switch_title
                        : AppStrings.appSettings_crashCollection_switch_title,
                style: AppTextStyles.smallTitle(isOutFit: true),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    appSettingOption == AppSettingOptions.notification
                        ? AppStrings.appSettings_notification_switch_subtitle
                        : appSettingOption == AppSettingOptions.location
                            ? AppStrings
                                .appSettings_enableLocation_switch_subtitle
                            : AppStrings
                                .appSettings_crashCollection_switch_subtitle,
                    textAlign: TextAlign.left,
                    style: AppTextStyles.regularPrimary(
                        color: AppColors.colorPrimaryNeutralText),
                  )),
                  Container(
                    margin: EdgeInsets.only(left: 15.w),
                    child: CupertinoSwitch(
                      trackColor: isActivated
                          ? AppColors.colorPrimaryAccent
                          : AppColors.colorPrimaryNeutral,
                      activeColor: AppColors.colorPrimaryAccent,
                      thumbColor: isActivated
                          ? AppColors.colorPrimaryInverse
                          : AppColors.colorPrimary,
                      onChanged: (value) {
                        BlocProvider.of<AppSettingsBloc>(context).add(
                            TriggerAppSettingsOptions(
                                appSettingOptions: appSettingOption));
                      },
                      value: isActivated,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
