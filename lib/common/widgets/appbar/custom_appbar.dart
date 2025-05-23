// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../imports/common.dart';
import 'package:badges/badges.dart' as badges;

import '../../../presentation/notification/bloc/notification_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
    required this.title,
    required this.isLeadingPresent,
    this.appBarActionFunction,
    this.appBarActionSvgAddress,
    this.color = Colors.transparent,
    this.isNotification = false,
    this.customActionWidget,
    this.isNeededForCustomWidget = true,
    this.navigatorValue,
    this.goBack,
    this.isMoreButtonVisible = false,
    this.onAction,
    this.widgetTitle
  });

  final String title;
  final bool isLeadingPresent;
  final Widget? customActionWidget;
   bool isNeededForCustomWidget;
  final String? appBarActionSvgAddress;
  final Function()? appBarActionFunction;
  Color color;
  void Function()? goBack;
  void Function()? onAction;
  bool isNotification;
  bool isMoreButtonVisible;
  Widget? widgetTitle;
  dynamic navigatorValue;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(Dimensions.appBarHeight),
      child:
      AppBar(
        elevation: 1,
        backgroundColor: AppColors.colorPrimary,
        automaticallyImplyLeading: false,
        leadingWidth: Dimensions.appBarLeadingWidth,
        toolbarHeight: Dimensions.appBarToolHeight,
        leading: isLeadingPresent
            ? buildLeading(
          onTap: goBack,
                context: context,
                navigatorValue: navigatorValue,
              )
            : null,

        title: widgetTitle ?? buildTitle(),
        centerTitle: false,
        actions: [
          if(isMoreButtonVisible)...[
            buildActionButtonForMore(context: context,navigatorValue: navigatorValue,iconName: AppAssets.icMore,onTap: onAction),
          ]else...[
            if (appBarActionFunction != null) buildActionButton(),
          ]

        ],
      ),
    );
  }

  Widget buildActionButton() {
    return BlocBuilder<NotificationBloc, NotificationWithInitialState>(
      builder: (context, state) {
        return InkWell(
          splashColor: Colors.transparent,
          onTap: appBarActionFunction,
          child: state.unreads != '0' && isNotification
              ? badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -3.h, end: 8.w),
                  showBadge: true,
                  ignorePointer: false,
                  badgeContent: Text(state.unreads,
                      style: AppTextStyles.regularPrimary()),
                  badgeAnimation: const badges.BadgeAnimation.rotation(
                    animationDuration: Duration(seconds: 1),
                    loopAnimation: false,
                    curve: Curves.bounceInOut,
                    colorChangeAnimationCurve: Curves.easeInCubic,
                  ),
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: AppColors.colorPrimaryAccent,
                    padding: state.unreads.length == 1
                        ? EdgeInsets.all(8.r)
                        : EdgeInsets.all(7.r),
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                        color: AppColors.colorPrimaryInverse, width: 2),
                    elevation: 2,
                  ),
                  child: buildActionIcon())
              : buildActionIcon(),
        );
      },
    );
  }

  Container buildActionIcon({bool isLoading = false}) {
    return Container(
      height: Dimensions.appBarActionsHeight,
      width: isNeededForCustomWidget ? Dimensions.appBarActionsWidth : null,
      margin: EdgeInsets.only(
          right: isNotification ? 22.w : Dimensions.appBarToolHorizontalGap,
          left: Dimensions.appBarToolHorizontalGap,
          top: 10.h,
        bottom: 2.h
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.appBarToolRadius),
          color: color),
      child: customActionWidget ??
          Center(
            child: SizedBox(
                height: 16.h,
                width: isNeededForCustomWidget ? 16.w: null,
                child: appBarActionSvgAddress !=null? SvgPicture.asset(
                    appBarActionSvgAddress!,
                    fit: BoxFit.cover): const SizedBox(),)
          ),
    );
  }

  Container buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.appBarToolVerticalGap),
      child: Text(
        title,
        style: AppTextStyles.extraLargeTitle(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Dimensions.appBarHeight);
}

InkWell buildLeading({required BuildContext context, void Function()? onTap, dynamic navigatorValue, Color? color}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap:
        onTap ?? () {
      Navigator.pop(context, navigatorValue);
    },
    child: Container(
      width: 15.w,
      height: Dimensions.appBarActionsHeight,
      margin: EdgeInsets.only(
          left: Dimensions.appBarToolHorizontalGap,
          top: Dimensions.appBarToolVerticalGap),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.appBarToolRadius),
        color: color ?? AppColors.colorSecondary,
      ),
      child: Center(
        child:
            SvgPicture.asset(
                height: 18.h,
                AppAssets.icAppbarBackButton, fit: BoxFit.cover
            ),
      ),
    ),
  );
}

InkWell buildActionButtonForMore({required BuildContext context, void Function()? onTap, dynamic navigatorValue, required String iconName}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap:
    onTap ?? () {
      Navigator.pop(context, navigatorValue);
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        width: 45.w,
        height: Dimensions.appBarActionsHeight,
        margin: EdgeInsets.only(
            left: Dimensions.appBarToolHorizontalGap,
            top: Dimensions.appBarToolVerticalGap),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.appBarToolRadius),
          color: AppColors.colorSecondary,
        ),
        child: Center(
          child:
          SvgPicture.asset(
              height: 18.h,
              iconName, fit: BoxFit.cover
          ),
        ),
      ),
    ),
  );
}