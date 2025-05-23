import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/cards/custom_build_available_athlete_item.dart';
import '../../../imports/common.dart';
import '../bloc/buy_season_passes_bloc.dart';

Widget buildAvailableAthletes(SeasonPassesWithInitialState state, ) {
  return Container(
    constraints: BoxConstraints(
      maxHeight: Dimensions.getScreenHeight() * 0.5,
    ),

    child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buildAvailableAthleteItem(
            isAthleteInSelected: state.athletesAvailableForSelection[index].isSelected!,
            isAthleteInList: state.athletesAvailableForSelection[index]
                .isInList!,
            firstName: state.athletesAvailableForSelection[index].firstName!,
            lastName: state.athletesAvailableForSelection[index].lastName!,
            weightClass: state
                .athletesAvailableForSelection[index].weightClass
                .toString(),
            age: state.athletesAvailableForSelection[index].age.toString(),
            imageUrl:
            state.athletesAvailableForSelection[index].profileImage!,
            selectAthlete:
            state.athletesAvailableForSelection[index].isInList!
                ? () {}
                : () {
              BlocProvider.of<BuySeasonPassesBloc>(context).add(TriggerAthleteSelection(
                  athleteAvailableForSelection:
                  state.athletesAvailableForSelection,
                  athleteIndex: index));
            },
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 30.h,
          );
        },
        itemCount: state.athletesAvailableForSelection.length),
  );
}