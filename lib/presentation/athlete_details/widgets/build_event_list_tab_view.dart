import 'package:flutter/material.dart';

import '../../../imports/common.dart';
import '../bloc/athlete_details_bloc.dart';
import 'build_event_list.dart';

Widget buildBuildEventListTabView(
    AthleteDetailsWithInitialState state, BuildContext context) {
  return buildEventList(
      isUpcoming: state.tabNo == 0,
      events: state.events,
      onTapToEventDetails: (index) {
        Navigator.pushNamed(context, AppRouteNames.routeEventDetails,
            arguments: state.events[index].id);
      },
      onTapToOpenBottomSheet: (index) {
        buildCustomShowModalBottomSheetParent(
            ctx: context,
            isNavigationRequired: false,
            child: bottomSheetForListOfDivisionsWithRegisteredWCs(
              isEditActive: true,
                editWc: (i) {},
                context: context,
                title: state.events[index].title ??
                    AppStrings.global_empty_string,
                subtitle: AppStrings.bottomSheet_eventRegistrationBreakdown_subtitle,
                // state.tabNo == 0
                //     ? AppStrings
                //     .athleteDetails_upcomingEvents_bottomSheet_subtitle
                //     : AppStrings
                //     .athleteDetails_pastEvents_bottomSheet_subtitle,
                registrationWithSameDivisionId:
                state.events[index].registrationWithDivisionIdList!,
                isEditWCOptionAvailable: false));
      });
}