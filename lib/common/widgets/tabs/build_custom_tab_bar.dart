import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badges;

import '../../../imports/common.dart';
import '../../../presentation/my_athletes/bloc/my_athletes_bloc.dart';

Widget buildCustomTabBar({
  required bool isScrollRequired,
  bool isRequestTab = false,
  bool isSmallButtonTitle = true,
  required List<TabElements> tabElements,
}) {
  return isScrollRequired
      ? Row(
          children: [
            Expanded(
              child: Container(
                height: 40.h,
                margin:
                    EdgeInsets.only(top: 2, bottom: Dimensions.generalGapSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: AppColors.colorSecondary,
                ),
                padding: EdgeInsets.all(1.r),
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return buildCustomTabBarButton(
                      isSmallButtonTitle: isSmallButtonTitle,
                      isRequestTab: false,
                      count: tabElements[i].count,
                      isScrollRequired: isScrollRequired,
                      tabButtonTitle: tabElements[i].title,
                      color: tabElements[i].isSelected
                          ? AppColors.colorPrimaryAccent
                          : AppColors.colorSecondary,
                      onTap: tabElements[i].onTap,
                    );
                  },
                  separatorBuilder: (context, i) {
                    return SizedBox(
                      width: 2.w,
                    );
                  },
                  itemCount: tabElements.length,
                ),
              ),
            ),
          ],
        )
      : Container(
          height: 40.h,
          width: double.infinity,
          margin: EdgeInsets.only(top: 2, bottom: Dimensions.generalGapSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: AppColors.colorSecondary,
          ),
          padding: EdgeInsets.all(5.r),
          child: Row(
            children: [
              for (var i = 0; i < tabElements.length; i++)
                buildCustomTabBarButton(
                  isActive: tabElements[i].isActive,
                  isRequestTab: i == 2,
                  isSmallButtonTitle: isSmallButtonTitle,
                  count: tabElements[i].count,
                  isScrollRequired: isScrollRequired,
                  tabButtonTitle: tabElements[i].title,
                  color: tabElements[i].isSelected
                      ? AppColors.colorPrimaryAccent
                      : AppColors.colorSecondary,
                  onTap: tabElements[i].onTap,
                ),
            ],
          ),
        );
}

Widget buildCustomTabBarButton(
    {required String tabButtonTitle,
    required Color color,
    required bool isScrollRequired,
    required void Function()? onTap,
    required bool isRequestTab,
    required bool isSmallButtonTitle,
    required int count,
    bool isActive = true}) {
  return isScrollRequired
      ? buildTabButton(onTap, color, tabButtonTitle, true, isSmallButtonTitle,
          isActive, count)
      : Expanded(
          child: isRequestTab
              ? BadgeWidget(
                  isRequestTab: isRequestTab,
                  child: buildTabButton(
                    onTap,
                    color,
                    tabButtonTitle,
                    false,
                    isSmallButtonTitle,
                    isActive,
                    count,
                  ),
                )
              : buildTabButton(onTap, color, tabButtonTitle, false,
                  isSmallButtonTitle, isActive, count));
}

GestureDetector buildTabButton(
  void Function()? onTap,
  Color color,
  String tabButtonTitle,
  bool isScrollRequired,
  bool isSmallButtonTitle,
  bool isActive,
  int count,
) {
  return GestureDetector(
    onTap:isActive? onTap: (){},
    child: Opacity(
      opacity: isActive ? 1 : 0.7,
      child: Container(
        padding: isScrollRequired ? EdgeInsets.symmetric(horizontal: 15.w) : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: color,
        ),
        alignment: Alignment.center,
        child: count == 0
            ? Text(
                tabButtonTitle,
                style: AppTextStyles.tabTitle(
                    isSmallButtonTitle: isSmallButtonTitle),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tabButtonTitle,
                    style: AppTextStyles.buttonTitle(),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Container(
                    width: 28.w,
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Center(
                      child: Text(
                        count.toString(),
                        style: AppTextStyles.componentLabels(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}

class TabElements {
  String title;
  void Function()? onTap;
  bool isSelected;
  bool isActive;
  int count;

  TabElements({
    required this.title,
    this.count = 0,
    this.isActive = true,
    required this.onTap,
    required this.isSelected,
  });
}

class BadgeWidget extends StatefulWidget {
  final Widget child;
  final bool isRequestTab;

  const BadgeWidget(
      {required this.child, required this.isRequestTab, super.key});

  @override
  _BadgeWidgetState createState() => _BadgeWidgetState();
}

class _BadgeWidgetState extends State<BadgeWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyAthletesBloc, MyAthletesWithInitialState>(
      buildWhen: (previous, current) {
        return previous.requests.length != current.requests.length;
      },
      builder: (context, state) {
        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: -15.h, end: -10.w),
          showBadge: state.requests.isNotEmpty && widget.isRequestTab,
          ignorePointer: false,
          badgeContent: Text(state.requests.length.toString(),
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
            padding: state.requests.length == 1
                ? EdgeInsets.all(8.r)
                : EdgeInsets.all(7.r),
            borderRadius: BorderRadius.circular(10.r),
            borderSide:
                BorderSide(color: AppColors.colorPrimaryInverse, width: 2),
            elevation: 2,
          ),
          child: widget.child,
        );
      },
    );
  }
}
