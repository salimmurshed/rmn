import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/bottomsheets/build_bottomSheet_body_for_otherTeam.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../bloc/purchase_bloc.dart';
import 'build_list_of_selected_athletes_for_registration.dart';

List<Widget> buildRegistrationTabView(
    {required PurchaseWithInitialState state,
    required BuildContext context,
    required List<Team> teams,
    required bool isEdit}) {
  return state.readyForRegistrationAthletes.isEmpty
      ? [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: Dimensions.getScreenHeight() * 0.2),
                Center(
                  child: Text(
                    'In order to register athletes, please navigate to the Edit Registration and make your selections.',
                    style: AppTextStyles.smallTitleForEmptyList(),
                  ),
                ),
              ],
            ),
          )
        ]
      : [
          if (state.paymentModuleTabs ==
              PaymentModuleTabNames.registrations) ...[
            buildTheListOfSelectedAthletesForRegistration(
                isOpened: state.isDropDownOpened,
                onMenuStateChange: (isOpen) {
                  // BlocProvider.of<PurchaseBloc>(context).add(
                  //     TriggerOpenDropDown(
                  //         isAthlete: true,
                  //         // index: 0,
                  //         // products: state.products,
                  //         isOpened: isOpen));
                },
                openModalBottomSheetForOtherTeam: (athlete) {
                  buildCustomShowModalBottomSheetParent(
                      ctx: context,
                      isNavigationRequired: false,
                      child:
                          BlocBuilder<PurchaseBloc, PurchaseWithInitialState>(
                        bloc: BlocProvider.of<PurchaseBloc>(context),
                        builder: (context, state) {
                          return buildBottomSheetBodyForFindingOtherTeam(
                            otherTeamController: state.otherTeamController,
                            matchedTeams: state.matchedTeams,
                            context: context,
                            typedChange: (text) {
                              BlocProvider.of<PurchaseBloc>(context)
                                  .add(TriggerFindOtherTeams(
                                typedText:
                                    text ?? AppStrings.global_empty_string,
                                teams: teams,
                              ));
                            },
                            onTapMatchedTeam: (teamName, athlete, teams) {
                              BlocProvider.of<PurchaseBloc>(context).add(
                                  TriggerTapOnMatchedTeamName(
                                      teamName: teamName,
                                      teams: teams,
                                      athlete: athlete));
                            },
                            athlete: athlete,
                            teams: teams,
                          );
                        },
                      ));
                },
                onTapToExpand: (index) {
                  BlocProvider.of<PurchaseBloc>(context)
                      .add(TriggerUnHideDivisionList(index: index));
                },
                onTapMatchedTeam: (teamName, athlete, teams) {
                  BlocProvider.of<PurchaseBloc>(context).add(
                      TriggerTapOnMatchedTeamName(
                          teamName: teamName, teams: teams, athlete: athlete));
                },
                matchedTeams: state.matchedTeams,
                teams: teams,
                typedChange: (text) {
                  BlocProvider.of<PurchaseBloc>(context)
                      .add(TriggerFindOtherTeams(
                    typedText: text ?? AppStrings.global_empty_string,
                    teams: teams,
                  ));
                },
                onChanged: (value, athleteIndex) {
                  BlocProvider.of<PurchaseBloc>(context).add(
                      TriggerDropDownSelection(
                          selectedValue: value,
                          athlete:
                              state.readyForRegistrationAthletes[athleteIndex],
                          teams: teams));
                },
                searchController: state.searchController,
                otherTeamController: state.otherTeamController,
                dropDownKey: (athleteIndex) {
                  // print(
                  //     'dropDownKey: ${state.readyForRegistrationAthletes[athleteIndex].dropDownKey}\n ${state.readyForRegistrationAthletes[athleteIndex].dropDownKey!.currentState}\n ${athleteIndex} ${state.readyForRegistrationAthletes[athleteIndex].firstName} ${state.readyForRegistrationAthletes[athleteIndex].lastName}');
                  return state
                      .readyForRegistrationAthletes[athleteIndex].dropDownKey!;
                },
                selectedValue: (athleteIndex) {
                  return state.readyForRegistrationAthletes[athleteIndex]
                      .selectedTeam?.name;
                },
                isExpanded: (athleteIndex) {
                  return state
                      .readyForRegistrationAthletes[athleteIndex].isExpanded!;
                },
                readyForRegistrationAthletes:
                    state.readyForRegistrationAthletes)
          ]
        ];
}
