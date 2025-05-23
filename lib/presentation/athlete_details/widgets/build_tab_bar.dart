import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../imports/common.dart';
import '../bloc/athlete_details_bloc.dart';

Widget buildTabBar(
    BuildContext context, AthleteDetailsWithInitialState state) {
  return buildCustomTabBar(isScrollRequired: true, tabElements: [
    TabElements(
        title: AppStrings.athleteDetails_upcomingEvents_tab_title,
        onTap: () {
          BlocProvider.of<AthleteDetailsBloc>(context).add(
            TriggerEventsFetch(
                selectedValue:
                state.selectedValue ?? AppStrings.global_empty_string,
                athleteId: state.athleteId,
                seasonId: state.seasonId,
                tabNo: 0),
          );
        },
        isSelected: state.tabNo == 0),
    TabElements(
        title: AppStrings.athleteDetails_pastEvents_tab_title,
        onTap: () {
          BlocProvider.of<AthleteDetailsBloc>(context).add(
            TriggerEventsFetch(
                selectedValue:
                state.selectedValue ?? AppStrings.global_empty_string,
                athleteId: state.athleteId,
                seasonId: state.seasonId,
                tabNo: 1),
          );
        },
        isSelected: state.tabNo == 1),
    TabElements(
        title: AppStrings.athleteDetails_awards_tab_title,
        onTap: () {
          BlocProvider.of<AthleteDetailsBloc>(context).add(
            TriggerTabSelection(
                selectedValue:
                state.selectedValue ?? AppStrings.global_empty_string,
                athleteId: state.athleteId,
                seasonId: state.seasonId,
                tabNo: 2),
          );
        },
        isSelected: state.tabNo == 2),
    TabElements(
        title: AppStrings.athleteDetails_ranks_tab_title,
        onTap: () {
          BlocProvider.of<AthleteDetailsBloc>(context).add(
            TriggerTabSelection(
                selectedValue:
                state.selectedValue ?? AppStrings.global_empty_string,
                athleteId: state.athleteId,
                seasonId: state.seasonId,
                tabNo: 3),
          );
        },
        isSelected: state.tabNo == 3),
  ]);
}