import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/imports/services.dart';

import '../../../di/di.dart';
import '../../../imports/common.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  @override
  void initState() {
    setSession();
    super.initState();
  }

  setSession() async {
    await instance<UserCachedData>().setFirstTimeUser(value: false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.colorPrimary,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.imgOnboardingBg,
              fit: BoxFit.fill,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.only(bottom: 5.h),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 10.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.onboarding_welcome_text,
                              style: AppTextStyles.subtitle()),
                          Text(AppStrings.onboarding_welcome_predecessor_text,
                              style: AppTextStyles.extraLargeTitle()),
                          customDivider(isBottomSheetTitle: false),
                          SizedBox(
                            width: Dimensions.getScreenWidth(),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      AppStrings
                                          .onboarding_welcome_successor_text,
                                      maxLines: 2,
                                      style: AppTextStyles.subtitle()),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                          bottom: Platform.isIOS ? 20.h : 0.0),
                      width: Dimensions.getScreenWidth(),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildCustomLargeFooterBtn(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRouteNames.routeAppSettings,
                                      arguments: true);
                                },
                                btnLabel: AppStrings.btn_continue,
                                hasKeyBoardOpened: false,
                                isColorFilledButton: true),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
