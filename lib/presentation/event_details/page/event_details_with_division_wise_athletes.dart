import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_handlers.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../base/bloc/base_bloc.dart';
import '../widgets/build_list_of_divisions.dart';

class EventDetailsWithDivisionWiseAthletes extends StatefulWidget {
  const EventDetailsWithDivisionWiseAthletes({super.key});

  @override
  State<EventDetailsWithDivisionWiseAthletes> createState() =>
      _EventDetailsWithDivisionWiseAthletesState();
}

class _EventDetailsWithDivisionWiseAthletesState
    extends State<EventDetailsWithDivisionWiseAthletes> {
  @override
  initState() {
    super.initState();
    BlocProvider.of<EventDetailsBloc>(context).add(
        TriggerFetchEventDetails(eventId: globalEventResponseData!.event!.id!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailsBloc, EventDetailsWithInitialState>(
      builder: (context, state) {
        return customScaffoldForImageBehind(
            appBar: customAppBarForImageBehind(
                context: context,
                onTap: () {
                  if (state.readyForRegistrationAthletes.isNotEmpty) {
                    buildBottomSheetWithBodyText(
                      context: context,
                      title: AppStrings.bottomSheet_leaveRegistration_title,
                      subtitle:AppStrings.bottomSheet_leaveRegistration_subtitle,
                      isSingeButtonPresent: false,
                      onLeftButtonPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      onRightButtonPressed: () {
                        Navigator.pop(context);
                      },
                      leftButtonText: AppStrings.btn_leave,
                      rightButtonText: AppStrings.btn_stay
                    );
                  } else {
                    Navigator.pop(context);
                  }
                }),
            body: state.isLoading
                ? CustomLoader(child: Container())
                : DynamicSliverAppBar(
              isLoading: state.isLoading,
                    fromDivisionList: true,
                    isInfoForEventDetail: false,
                    subtitle: AppStrings.global_empty_string,
                    location: state.eventLocation,
                    date: state.eventDateTime,
                    title: state.eventTitle,
                    coverImage: state.coverImage,
                    body: buildDivisionsLayout(context, state)));
      },
    );
  }

  Container buildDivisionsLayout(
      BuildContext context, EventDetailsWithInitialState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildListOfDivisions(
            parentIndex: 0,
            openAthlete: (Athlete athlete, int parentIndex, int childIndex,
                int athleteIndex) {
              BlocProvider.of<EventDetailsBloc>(context).add(
                  TriggerResetStyleIndex(
                      ageGroup: state
                          .divisionsTypes[parentIndex].ageGroups![childIndex],
                      athlete: state
                          .divisionsTypes[parentIndex]
                          .ageGroups![childIndex]
                          .expansionPanelAthlete![athleteIndex]));
              buildCustomShowModalBottomSheetParent(
                  ctx: context,
                  isNavigationRequired: false,
                  child: BlocBuilder<EventDetailsBloc,
                      EventDetailsWithInitialState>(
                    builder: (context, state) {
                      return buildBottomSheetWithBodyCheckboxList(
                          disclaimer: state.selectedAgeGroup?.styles?[state.styleIndex].disclaimer?? AppStrings.global_empty_string,
                          isCheckListForWeightClass: true,
                          styles: state
                              .divisionsTypes[parentIndex]
                              .ageGroups![childIndex]
                              .expansionPanelAthlete![athleteIndex]
                              .athleteStyles!,
                          context: context,
                          athleteImageUrl: athlete.profileImage!,
                          athleteAge: athlete.age.toString(),
                          athleteWeight: athlete.weightClass.toString(),
                          athleteNameAsTheTitle:
                              StringManipulation.combineFirstNameWithLastName(
                                  firstName: athlete.firstName!,
                                  lastName: athlete.lastName!),
                          listOfStyleTitles: state
                              .divisionsTypes[parentIndex]
                              .ageGroups![childIndex]
                              .expansionPanelAthlete![athleteIndex]
                              .athleteStyles!
                              .map((e) => e.style!)
                              .toList(),
                          listOfAllOptions: state
                                  .divisionsTypes[parentIndex]
                                  .ageGroups![childIndex]
                                  .expansionPanelAthlete![athleteIndex]
                                  .athleteStyles?[state.styleIndex]
                                  .division
                                  ?.availableWeightsPerStyle ??
                              [],
                          listOfAllSelectedOption: state
                              .divisionsTypes[parentIndex]
                              .ageGroups![childIndex]
                              .expansionPanelAthlete![athleteIndex]
                              .athleteStyles![state.styleIndex]
                              .temporarilySelectedWeights!,
                          listOfAllRegisteredOptions: state
                                  .divisionsTypes[parentIndex]
                                  .ageGroups![childIndex]
                                  .expansionPanelAthlete![athleteIndex]
                                  .athleteStyles![state.styleIndex]
                                  .registeredWeights ??
                              [],
                          selectedStyleIndex: state.styleIndex,
                          selectStyle: (styleIndex) {
                            BlocProvider.of<EventDetailsBloc>(context)
                                .add(TriggerSelectStyleIndex(
                              index: styleIndex,
                            ));
                          },
                          isUpdateWCInactive: false,
                          isFromPurchaseHistory: false,
                          onTapToSelectTile: (indexForWeight) {
                            BlocProvider.of<EventDetailsBloc>(context)
                                .add(TriggerWCSelectionTemporarily(
                              divisionType: state.divisionsTypes[parentIndex],
                              athleteSelectionTabs:
                                  AthleteSelectionTabs.expansionPanel,
                              ageGroup: state.divisionsTypes[parentIndex]
                                  .ageGroups![childIndex],
                              weightIndex: indexForWeight,
                              athlete: state
                                  .divisionsTypes[parentIndex]
                                  .ageGroups![childIndex]
                                  .expansionPanelAthlete![athleteIndex],
                            ));
                          },
                          checkBoxForWeightClassSelection: (value) {},
                          onTapForUpdate: () {
                            Navigator.pop(context);
                          },
                          isLoading: false);
                    },
                  ));
            },
            divisionsTypes: state.divisionsTypes,
            openParent: (bool isExpanded, int index) {},
            openChild: (bool isExpanded, int parentIndex, int childIndex) {
              BlocProvider.of<EventDetailsBloc>(context)
                  .add(TriggerOpenAgeGroup(
                divIndex: parentIndex,
                ageGroupIndex: childIndex,
              ));
            },
          ),
          buildCustomLargeFooterBtn(
              hasKeyBoardOpened: true,
              isActive: EventDetailsHandlers.isActive(
                  divisionTypes: state.divisionsTypes),
              onTap: EventDetailsHandlers.isActive(
                      divisionTypes: state.divisionsTypes)
                  ? () {
                      BlocProvider.of<EventDetailsBloc>(context)
                          .add(TriggerToCollectRegistrationList(
                        divisionTypes: state.divisionsTypes,
                      ));
                    }
                  : () {},
              btnLabel: AppStrings.eventDetailsView_registration_button_title,
              isColorFilledButton: true)
        ],
      ),
    );
  }
}
