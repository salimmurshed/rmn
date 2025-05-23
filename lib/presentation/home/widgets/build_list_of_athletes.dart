import 'package:flutter/cupertino.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';

import '../../../common/widgets/cards/custom_athlete_card.dart';
import '../../../imports/common.dart';
import '../client_home_bloc/client_home_bloc.dart';

List<Widget> buildListOfAthletes(ClientHomeWithInitialState state) {
  return [
    buildCustomCarousel(
        currentIndex: state.athleteCurrentIndex,
        itemCount: state.homeAthletes.length,
        pageController: state.athletePageController,
        itemBuilder: (context, index) {
          return customAthleteCard(
            requestData: null,
            seasons:globalSeasons,
            teams: globalTeams,viewProfile: (){
              Navigator.pushNamed(context, AppRouteNames.routeAthleteDetails,
                arguments: state.homeAthletes[index].id!,
              );
          },
            athleteId: state.homeAthletes[index].id!,
            athleteTab: AthleteTab.home,
              metricKeyValuePairs: [
                { TypeOfMetric.noOfEvents: (state.homeAthletes[index]
                    .noUpcomningEvents ?? 0).toString()},
                { TypeOfMetric.rank: (state.homeAthletes[index]
                    .rank ??
                    state.homeAthletes[index].rankReceived ?? 0).toString()},
                { TypeOfMetric.award:( state.homeAthletes[index]
                    .awards ?? 0).toString()},
                { TypeOfMetric.weight: (state.homeAthletes[index]
                    .weight ??state.homeAthletes[index]
                    .weightClass ?? '').toString()},
                { TypeOfMetric.age: (state.homeAthletes[index].age ??
                    '').toString()}
              ],
              isMarginRequired: state.homeAthletes.length >1 ? true: false,
              sizeType: SizeType.large,
              imageUrl: state.homeAthletes[index].profileImage!,
              userStatus: state.homeAthletes[index].userStatus ??
                  AppStrings.global_empty_string,
              context: context,
              firstName: state.homeAthletes[index].firstName!,
              lastName: state.homeAthletes[index].lastName!,
              membership: state.homeAthletes[index].membership);
        }),

    SizedBox(
      height: Dimensions.screenVerticalSpacing,
    )
  ];
}
