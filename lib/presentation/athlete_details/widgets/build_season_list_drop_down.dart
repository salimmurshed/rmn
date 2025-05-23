import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../base/bloc/base_bloc.dart';
import '../bloc/athlete_details_bloc.dart';
import '../bloc/athlete_details_handlers.dart';
import 'build_centered_item_drop_down.dart';

Container buildSeasonListDropDown(
    BuildContext context, AthleteDetailsWithInitialState state) {
  return buildCenteredItemDropDown(
    onChanged: (value) {
      BlocProvider.of<AthleteDetailsBloc>(context).add(
          TriggerDropDownSelection(
              athleteId: state.athleteId,
              selectedValue: value!,
              selectedTab: state.tabNo,
              seasons: globalSeasons));
    },
    onMenuStateChange: (isExpanded) {},
    context: context,
    globalKey: state.dropDownKey,
    isExpanded: state.isExpanded,
    selectedValue: state.selectedValue,
    list: AthleteDetailsHandlers.seasonsName(seasons: globalSeasons),
  );
}