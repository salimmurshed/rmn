import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/common/resources/app_enums.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';

import '../../../imports/data.dart';
import 'build_division_tab_list.dart';
import 'build_information_tab.dart';

List<Widget> buildDivisionTab(
    {required List<DivisionTypes> divisionsTypes,
    required void Function(int, bool) onExpansionChangedParent,
    required void Function(int, int, bool) onExpansionChangedChild,
    required Widget customTabBar,
    required EventDetailsWithInitialState state,
    required int divisionTabIndex,
      bool isShorten = false,
    required String weighInDescription}) {
  return [
    Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      child: customTabBar,
    ),
    if (divisionTabIndex == 0)
      HTMLTabView(
        isShorten: isShorten,
        state: state,
          eventDetailTab: EventDetailTab.divisions,
          text: weighInDescription,
          isBottomPaddingNeeded: true),
    if (divisionTabIndex == 1) ...[
      DivisionTabList(
        isShorten: isShorten,
        isSmall: true,
        onExpansionChangedParent: onExpansionChangedParent,
        onExpansionChangedChild: onExpansionChangedChild,
        divisionsTypes: divisionsTypes,
      )
    ],
  ];
}
