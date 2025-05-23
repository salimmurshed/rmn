import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/presentation/chat/bloc/chat_bloc.dart';
import 'package:rmnevents/presentation/register_and_sell/bloc/register_and_sell_bloc.dart';
import 'package:rmnevents/root_app.dart';
import '../../../data/models/response_models/registration_list_model.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../base/bloc/base_bloc.dart';
import '../../purchase/bloc/purchase_bloc.dart';
import '../../questionnaire/bloc/questionnaire_bloc.dart';
import 'event_details_handlers.dart';

part 'event_details_event.dart';

part 'event_details_state.dart';

part 'event_details_bloc.freezed.dart';

class EventDetailsBloc
    extends Bloc<EventDetailsEvent, EventDetailsWithInitialState> {
  EventDetailsBloc() : super(EventDetailsWithInitialState.initial()) {
    on<TriggerFetchEventWiseAthletes>(_onTriggerFetchEventWiseAthletes);
    on<TriggerFetchEventDetails>(_onTriggerFetchEventDetails);
    on<TriggerGetDivisionForEmployee>(_onTriggerGetDivisionForEmployee);
    on<TriggerFetchEmployeeAthletes>(_onTriggerFetchEmployeeAthletes);
    on<TriggerPickDivision>(_onTriggerPickDivision);
    on<TriggerGetRegistrationList>(_onTriggerGetRegistrationList);
    on<TriggerSwitchTab>(_onTriggerSwitchTab);
    on<TriggerExpandTileDivisionTab>(_onTriggerExpandTileInsideDivisionTab);
    on<TriggerExpandTileScheduleTile>(_onTriggerExpandTileScheduleTile);
    on<TriggerUpDivisionListAthletes>(_onTriggerUpDivisionListAthletes);
    on<TriggerAssembleForDivision>(_onTriggerAssembleForDivision);
    on<TriggerSwitchBetweenAthleteSelectionsTab>(_onTriggerSwitchBetweenTab);
    on<TriggerSelectStyleIndex>(_onTriggerSelectStyleIndex);
    on<TriggerWCSelectionTemporarily>(_onTriggerWCSelectionTemporarily);
    on<TriggerUpdateExpansionPaneList>(_onTriggerUpdateExpansionPaneList);
    on<TriggerUpdateYourAthleteList>(_onTriggerUpdateYourAthleteList);
    on<TriggerOpenAgeGroup>(_onTriggerOpenAgeGroup);
    on<TriggerMoveBetweenTabs>(_onTriggerMoveBetweenTabs);
    on<TriggerRemoveFromSelectAthlete>(_onTriggerRemoveFromSelectAthlete);
    on<TriggerAddToExpansionPanel>(_onTriggerAddToExpansionPanel);
    on<TriggerResetStyleIndex>(_onTriggerResetStyleIndex);
    on<TriggerSetIndex>(_onTriggerSetIndex);
    on<TriggerToCollectRegistrationList>(_onTriggerToCollectRegistrationList);
    on<TriggerSearchReg>(_onTriggerSearchReg);
    on<TriggerOnChangeSearchEvent>(_onTriggerOnChangeSearchEvent);
    on<TriggerEraseSearchValue>(_onTriggerEraseSearchValue);
    on<TriggerShortenEventDetails>(_onTriggerShortenEventDetails);
    on<IncrementEvent>(_onTriggerIncrement);
    on<DecrementEvent>(_onTriggerDecrement);
    on<TriggerRemoveUnConfirmAthlates>(_onTriggerRemoveCacheAthlate);
    on<TriggerChangeTeam>(_onTriggerChangeTeam);
    on<TriggerCheckForUpdateCartStatus>(_onTriggerCheckForUpdateCartStatus);
  }

  FutureOr<void> _onTriggerRemoveCacheAthlate(
      TriggerRemoveUnConfirmAthlates event,
      Emitter<EventDetailsWithInitialState> emit) async {
    // Collect athletes to remove
    List<Athlete> athletesToRemove = [];

    for (var athlete in state.selectedAgeGroup!.selectedAthletes!) {
      if (!athlete.isTakenInThisRegistration) {
        // Count how many chosen WCs to decrement the limit

        // Clear temporarilySelectedWeights for each athleteStyle
        athlete.athleteStyles?.forEach((style) {
          if (state.eventResponseData?.event?.temporeryLimit != null) {
            state.eventResponseData!.event!.temporeryLimit =
                state.eventResponseData!.event!.temporeryLimit! -
                    style.temporarilySelectedWeights!.length;
          }
          for (var i in style.temporarilySelectedWeights!) {
            for (int index = 0; index < (style.division?.weightClasses?.length ?? 0); index++) {
              var weightClass = style.division!.weightClasses![index];
              if (i == weightClass.weight.toString()) {
                if (weightClass.totalRegistration != null && weightClass.totalRegistration! > 0) {
                  style.division!.weightClasses![index].totalRegistration =
                      weightClass.totalRegistration! - 1;
                  debugPrint('Decremented totalRegistration at index $index for weight: ${weightClass.weight}');
                }
              }
            }
          }

          style.temporarilySelectedWeights?.clear();
        });
        athletesToRemove.add(athlete);
      }
    }

    // Update the temporeryLimit

    // Remove athletes that are not taken in this registration
    state.selectedAgeGroup!.selectedAthletes!
        .removeWhere((athlete) => !athlete.isTakenInThisRegistration);

    // Add removed athletes to availableAthletes
    state.selectedAgeGroup!.availableAthletes!.addAll(athletesToRemove);

    // Emit the updated state
    emit(state.copyWith(
      eventResponseData: state.eventResponseData,
      selectedAgeGroup: state.selectedAgeGroup,
    ));

    // Debug prints
    // Pop the navigator
    add(TriggerCheckForUpdateCartStatus());

  }

  FutureOr<void> _onTriggerIncrement(
      IncrementEvent event, Emitter<EventDetailsWithInitialState> emit) async {
    emit(state.copyWith(selectionCounter: state.selectionCounter + 1));
  }

  FutureOr<void> _onTriggerDecrement(
      DecrementEvent event, Emitter<EventDetailsWithInitialState> emit) async {
    emit(state.copyWith(selectionCounter: state.selectionCounter - 1));
  }

  FutureOr<void> _onTriggerFetchEventWiseAthletes(
      TriggerFetchEventWiseAthletes event,
      Emitter<EventDetailsWithInitialState> emit) async {
    EventDetailsHandlers.emitInitialState(emit: emit, state: state);
    try {
      final response = await AthleteRepository.getAthletesOrSearchAthletes(
          athleteApiType: AthleteApiType.eventWiseAthletes,
          eventId: event.eventId);
      response.fold((failure) {
        emit(state.copyWith(
          isFailure: true,
          isLoading: false,
          message: failure.message,
        ));
      }, (success) {
        List<Athlete> athletes = success.responseData!.data ?? [];
        for (Athlete athlete in athletes) {
          athlete.isAthleteTaken = false;
          athlete.athleteStyles = [];
          athlete.chosenWCs = [];
          athlete.profileImage = athlete.profileImage != null
              ? success.responseData!.assetsUrl! + athlete.profileImage!
              : AppStrings.global_empty_string;
          athlete.profile = athlete.profile != null
              ? success.responseData!.assetsUrl! + athlete.profile!
              : AppStrings.global_empty_string;
        }
        List<Registrations> registrations =
        state.eventResponseData!.event!.registrations!;
        for (Athlete athlete in athletes) {
          for (Registrations registration in registrations) {
            if (registration.athleteId == athlete.id) {
              String teamName = globalTeams
                  .firstWhere((element) => element.id == registration.teamId)
                  .name!;
              athlete.team = Team(name: teamName, id: registration.teamId);
            }
          }
        }
        emit(state.copyWith(
          isFailure: false,
          isLoading: true,
          eventWiseAthletes: athletes,
        ));
        if(event.fetchQuestionnaire){
          BlocProvider.of<QuestionnaireBloc>(navigatorKey.currentContext!)
              .add(TriggerQuestionnaireFetch(eventId: event.eventId));
        }
        add(TriggerUpDivisionListAthletes(
            isEnteringPurchaseView: event.isEnteringPurchaseView,
            divisionTypes: state.divisionsTypes,
            childIndex: event.childIndex,
            divIndex: event.divIndex));
      });
    } catch (e) {
      emit(state.copyWith(
        isFailure: true,
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerUpDivisionListAthletes(
      TriggerUpDivisionListAthletes event,
      Emitter<EventDetailsWithInitialState> emit) {
    List<DivisionTypes> updatedDivisionTypes = event.divisionTypes;

    for (int i = 0; i < updatedDivisionTypes.length; i++) {
      DivisionTypes updatedDiv = updatedDivisionTypes[i];

      List<AgeGroups> updatedAgeGroup = updatedDiv.ageGroups!;
      for (int j = 0; j < updatedAgeGroup.length; j++) {
        AgeGroups ageGroup = updatedAgeGroup[j];

        ageGroup.distributedAthletes = List.from(state.eventWiseAthletes);

        if (updatedDivisionTypes[i].divisionType!.toLowerCase().contains('girls')) {
          ageGroup.distributedAthletes!
              .removeWhere((element) => element.gender != 'female');
        }

        List<Athlete> ageGroupWiseAthlete = List.from([]);
        print('=-================');
        print(globalEventResponseData!.event!.hasGradeBrackets);
        for (int k = 0; k < ageGroup.distributedAthletes!.length; k++) {
          Athlete athlete = ageGroup.distributedAthletes![k];


          if (globalEventResponseData!.event!.hasGradeBrackets!) {
            if (athlete.grade != null) {

              debugPrint(
                  'globalGrades: ${GlobalHandlers.validateGradeWithGradesRange(
                grade: athlete.grade,
                gradeValues: globalGrades.map((e) => e.value!).toList(),
                maxGrade: ageGroup.maxGrade!,
                minGrade: ageGroup.minGrade!,
              )}');
              if (GlobalHandlers.validateGradeWithGradesRange(
                grade: athlete.grade,
                gradeValues: globalGrades.map((e) => e.value!).toList(),
                maxGrade: ageGroup.maxGrade!,
                minGrade: ageGroup.minGrade!,
              )) {
                Athlete newAthlete = Athlete(
                  id: athlete.id ?? athlete.underscoreId,
                  birthDate: athlete.birthDate,
                  profileImage: athlete.profileImage,
                  profile: athlete.profile,
                  age: athlete.age,
                  firstName: athlete.firstName,
                  lastName: athlete.lastName,
                  email: athlete.email,
                  weightClass: athlete.weightClass,
                  weight: athlete.weight,
                  athleteStyles: List.from(athlete.athleteStyles ?? []),
                  createdAt: athlete.createdAt,
                  updatedAt: athlete.updatedAt,
                  state: athlete.state,
                  teamId: athlete.teamId,
                  isUserParent: athlete.isUserParent,
                  dropDownKey: athlete.dropDownKey,
                  gender: athlete.gender,
                  city: athlete.city,
                  phoneNumber: athlete.phoneNumber,
                  requestData: athlete.requestData,
                  rankReceived: athlete.rankReceived,
                  team: athlete.team,
                  userStatus: athlete.userStatus,
                  membership: athlete.membership,
                  awards: athlete.awards,
                  athleteRegistrationDivision:
                      athlete.athleteRegistrationDivision,
                  totalRegistrationDivisionCost:
                      athlete.totalRegistrationDivisionCost,
                  accessType: athlete.accessType,
                  athleteIdentity: athlete.athleteIdentity,
                  availableSeasonPasses: athlete.availableSeasonPasses,
                  coaches: athlete.coaches,
                  isNotReadyToRegisterWithSelectedWeights:
                      athlete.isNotReadyToRegisterWithSelectedWeights,
                  isSelected: athlete.isSelected,
                  mailingAddress: athlete.mailingAddress,
                  noOfRegistrations: athlete.noOfRegistrations,
                  noUpcomningEvents: athlete.noUpcomningEvents,
                  ownerId: athlete.ownerId,
                  phoneCode: athlete.phoneCode,
                  pincode: athlete.pincode,
                  rank: athlete.rank,
                  rankDivision: athlete.rankDivision,
                  registrations: athlete.registrations,
                  selectedSeasonPassTitle: athlete.selectedSeasonPassTitle,
                  selectedTeam: athlete.selectedTeam,
                  senderName: athlete.senderName,
                  temporaryMembership: athlete.temporaryMembership,
                  underscoreId: athlete.underscoreId,
                  userId: athlete.userId,
                  viewers: athlete.viewers,
                  isAthleteTaken: athlete.isAthleteTaken,
                  chosenWCs: List.from(athlete.chosenWCs ?? []),
                );

                ageGroupWiseAthlete.add(newAthlete);
              }
            }
          }
          else {
            if (athlete.birthDate != null && ageGroup.maxAge != null) {
              print('+++${ageGroup.maxAge}');
              int athleteAge =
                  EventDetailsHandlers.calculateAgeDifferenceInYears(
                      athlete.birthDate!, state.eventResponseData!.event!.cutoffDate!);
              print('athleteAge: $athleteAge  ${int.parse(ageGroup.maxAge.toString())}');
              if (athleteAge <= int.parse(ageGroup.maxAge.toString())) {
                Athlete newAthlete = Athlete(
                  id: athlete.id ?? athlete.underscoreId,
                  birthDate: athlete.birthDate,
                  profileImage: athlete.profileImage,
                  profile: athlete.profile,
                  age: athlete.age,
                  firstName: athlete.firstName,
                  lastName: athlete.lastName,
                  email: athlete.email,
                  weightClass: athlete.weightClass,
                  weight: athlete.weight,
                  athleteStyles: List.from(athlete.athleteStyles ?? []),
                  createdAt: athlete.createdAt,
                  updatedAt: athlete.updatedAt,
                  state: athlete.state,
                  teamId: athlete.teamId,
                  isUserParent: athlete.isUserParent,
                  dropDownKey: athlete.dropDownKey,
                  gender: athlete.gender,
                  city: athlete.city,
                  phoneNumber: athlete.phoneNumber,
                  requestData: athlete.requestData,
                  rankReceived: athlete.rankReceived,
                  team: athlete.team,
                  userStatus: athlete.userStatus,
                  membership: athlete.membership,
                  awards: athlete.awards,
                  athleteRegistrationDivision:
                      athlete.athleteRegistrationDivision,
                  totalRegistrationDivisionCost:
                      athlete.totalRegistrationDivisionCost,
                  accessType: athlete.accessType,
                  athleteIdentity: athlete.athleteIdentity,
                  availableSeasonPasses: athlete.availableSeasonPasses,
                  coaches: athlete.coaches,
                  isNotReadyToRegisterWithSelectedWeights:
                      athlete.isNotReadyToRegisterWithSelectedWeights,
                  isSelected: athlete.isSelected,
                  mailingAddress: athlete.mailingAddress,
                  noOfRegistrations: athlete.noOfRegistrations,
                  noUpcomningEvents: athlete.noUpcomningEvents,
                  ownerId: athlete.ownerId,
                  phoneCode: athlete.phoneCode,
                  pincode: athlete.pincode,
                  rank: athlete.rank,
                  rankDivision: athlete.rankDivision,
                  registrations: athlete.registrations,
                  selectedSeasonPassTitle: athlete.selectedSeasonPassTitle,
                  selectedTeam: athlete.selectedTeam,
                  senderName: athlete.senderName,
                  temporaryMembership: athlete.temporaryMembership,
                  underscoreId: athlete.underscoreId,
                  userId: athlete.userId,
                  viewers: athlete.viewers,
                  isAthleteTaken: athlete.isAthleteTaken,
                  chosenWCs: List.from(athlete.chosenWCs ?? []),
                );

                ageGroupWiseAthlete.add(newAthlete);
              }
            }
          }
        }


        ageGroup.weightAvailable =
            ageGroup.ageGroupWithWeightsJoined!.split(', ');
        ageGroup.ageGroupWithExpansionPanelWeights = [];

        ageGroup.availableAthletes = List.from(ageGroupWiseAthlete);

        for (Athlete availableAthlete in ageGroup.availableAthletes!) {
          for (Athlete panelAthlete in ageGroup.expansionPanelAthlete!) {
            if ((panelAthlete.id ?? panelAthlete.underscoreId) == (availableAthlete.id ?? availableAthlete.underscoreId)) {
              panelAthlete.isAthleteTaken = availableAthlete.isAthleteTaken;
              panelAthlete.profileImage = availableAthlete.profileImage;
              panelAthlete.profile = availableAthlete.profile;
              panelAthlete.age = availableAthlete.age;
              panelAthlete.team = availableAthlete.team;

              panelAthlete.weightClass = availableAthlete.weightClass;
              panelAthlete.weight = availableAthlete.weight;
              panelAthlete.chosenWCs = availableAthlete.chosenWCs;
              panelAthlete.athleteStyles = availableAthlete.athleteStyles;
            }
          }
        }
      }
    }



    for (int i = 0; i < updatedDivisionTypes.length; i++) {
      DivisionTypes updatedDiv = updatedDivisionTypes[i];
      List<AgeGroups> updatedAgeGroup = updatedDiv.ageGroups!;
      for (int j = 0; j < updatedAgeGroup.length; j++) {
        AgeGroups ageGroup = updatedAgeGroup[j];
        for (Athlete athlete in ageGroup.availableAthletes!) {
          athlete.athleteStyles =  List.from(ageGroup.styles!
                  .map((style) => Styles(
                        id: style.id,
                        style: style.style,
                        divisionType: style.divisionType,
                        disclaimer: style.disclaimer,
                        finalizedSelectedWeightClasses: List.from(
                            style.finalizedSelectedWeightClasses ?? []),
                        finalizedSelectedWeights:
                            List.from(style.finalizedSelectedWeights ?? []),
                        registeredAthletes:
                            List.from(style.registeredAthletes ?? []),
                        registeredWeightClasses:
                            List.from(style.registeredWeightClasses ?? []),
                        registeredWeights:
                            List.from(style.registeredWeights ?? []),
                        temporarilySelectedWeights:
                            List.from(style.temporarilySelectedWeights ?? []),
                        temporarySelectedWeightClasses: List.from(
                            style.temporarySelectedWeightClasses ?? []),
                        division: Division(
                          id: style.division?.id,
                          style: style.division?.style,
                          title: style.division?.title,
                          createdAt: style.division?.createdAt,
                          updatedAt: style.division?.updatedAt,
                          athletes: List.from(style.division?.athletes ?? []),
                          maxAge: style.division?.maxAge,
                          minAge: style.division?.minAge,
                          maxDate: style.division?.maxDate,
                          guestRegistrationPrice:
                              style.division?.guestRegistrationPrice,
                          weightClasses:
                              List.from(style.division?.weightClasses ?? []),
                          availableWeightsPerStyle: List.from(
                              style.division?.availableWeightsPerStyle ?? []),
                          divisionType: style.division?.divisionType,
                        ),
                      ))
                  .toList());
          debugPrint('check styles ${athlete.firstName} ${athlete.athleteStyles!.length} --> ${athlete.athleteStyles!.map((e) => e.toJson())}');
        }
      }
    }
    for (int i = 0; i < updatedDivisionTypes.length; i++) {
      DivisionTypes updatedDiv = updatedDivisionTypes[i];
      List<AgeGroups> updatedAgeGroup = updatedDiv.ageGroups!;
      for (int j = 0; j < updatedAgeGroup.length; j++) {}
    }

    if (event.divIndex == null || event.childIndex == null) {
      for (int i = 0; i < updatedDivisionTypes.length; i++) {
        for (AgeGroups ageGroup in updatedDivisionTypes[i].ageGroups!) {
          List<Athlete> availableAthletes = ageGroup.availableAthletes!;
          List<Athlete> expansionPanelAthlete = ageGroup.expansionPanelAthlete!;
          for (Athlete athlete in availableAthletes) {
            athlete.chosenWCs = athlete.chosenWCs ?? [];
          }

          for (Athlete athlete in availableAthletes) {
            for (Styles style in athlete.athleteStyles!) {
              style.division!.availableWeightsPerStyle = [];
              for (WeightClass weightClass in style.division!.weightClasses!) {
                style.division!.availableWeightsPerStyle!
                    .add(weightClass.weight.toString());
              }
            }

            for (Styles style in athlete.athleteStyles!) {
              // Initialize a local list to store weights for this specific athlete and style
              List<String> weights = [];
              for (WeightClass weightClass in style.division!.weightClasses!) {

                bool isMatch = style.registeredAthletes!.any((element)
                {
                  debugPrint('check athlete ${element.athleteId} ${element.athletes!.firstName} ${athlete.id} ${athlete.underscoreId} ${element.weightClassId} ${weightClass.id}');
                      return (element.weightClassId == weightClass.id &&
                          element.athleteId ==
                              (athlete.id ?? athlete.underscoreId));
                    });

                if (isMatch &&
                    !weights.contains(weightClass.weight.toString())) {
                  athlete.isAthleteTaken = true;
                  weights.add(weightClass.weight.toString());
                }
              }
              style.registeredWeights = weights;

              if (athlete.chosenWCs!.isEmpty) {
                for (String wc in style.registeredWeights!) {
                  if (!athlete.chosenWCs!.contains(wc)) {
                    athlete.chosenWCs!.add(wc);
                  }
                }
              }
            }

            for (String wc in athlete.chosenWCs!) {
              if (!ageGroup.ageGroupWithExpansionPanelWeights!.contains(wc)) {
                ageGroup.ageGroupWithExpansionPanelWeights!.add(wc);
              }
            }

            bool isMatched = expansionPanelAthlete
                .any((element) => (element.id ?? element.underscoreId) == (athlete.id ?? athlete.underscoreId));
            if (isMatched) {
              expansionPanelAthlete
                  .where((element) => (element.id ?? element.underscoreId) == (athlete.id ?? athlete.underscoreId))
                  .forEach((element) {
                element.athleteStyles = athlete.athleteStyles;
                element.isAthleteTaken = athlete.isAthleteTaken;
                element.profileImage = athlete.profileImage;
                element.profile = athlete.profile;
                element.age = athlete.age;
                element.team = athlete.team;
                element.weightClass = athlete.weightClass;
                element.weight = athlete.weight;
                element.membership = athlete.membership;
                element.chosenWCs = athlete.chosenWCs;
              });
            }
          }
        }
      }
    }
    // for (DivisionTypes division in updatedDivisionTypes) {
    //   List<String> athleteIds = [];
    //   for (AgeGroups ageGroup in division.ageGroups!) {
    //     for (Athlete athlete in ageGroup.availableAthletes!) {
    //       for (Styles style in athlete.athleteStyles!) {
    //         for (RegisteredAthletes registeredAthletes
    //             in style.registeredAthletes!) {
    //           if (registeredAthletes.athleteId == athlete.id) {
    //             if (!athleteIds.contains(athlete.id!)) {
    //               athleteIds.add(athlete.id!);
    //               division.numberOfSelectedRegisteredAthlete =
    //                   division.numberOfSelectedRegisteredAthlete! + 1;
    //             }
    //           }
    //         }
    //       }
    //     }
    //   }
    // }

    emit(state.copyWith(
        isLoading: false,
        isRefreshedRequired: false,
        divisionsTypes: updatedDivisionTypes));
    if (event.divIndex != null && event.childIndex != null) {
      add(TriggerOpenAgeGroup(
        sendToRoute: false,
        ageGroupIndex: event.childIndex!,
        divIndex: event.divIndex!,
      ));
    }
    BlocProvider.of<PurchaseBloc>(navigatorKey.currentContext!)
        .add(TriggerStopLoader());
    if (event.isEnteringPurchaseView != null) {
      if (event.isEnteringPurchaseView != CouponModules.employeeRegistration) {
        BlocProvider.of<PurchaseBloc>(navigatorKey.currentContext!).add(
            TriggerFetchEventWiseData(
                couponModules: event.isEnteringPurchaseView!));
      }
    }
  }

  FutureOr<void> _onTriggerOpenAgeGroup(
      TriggerOpenAgeGroup event, Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitInitialState(emit: emit, state: state);

    debugPrint('event.divIndex: ${event.divIndex}');
    List<DivisionTypes> divs = state.divisionsTypes;

    AgeGroups ageGroup = divs[event.divIndex].ageGroups![event.ageGroupIndex];
    // List<Styles> styles = List.from(ageGroup.styles!
    //     .map((style) => Styles(
    //           id: style.id,
    //           style: style.style,
    //           divisionType: style.divisionType,
    //           finalizedSelectedWeightClasses:
    //               List.from(style.finalizedSelectedWeightClasses ?? []),
    //           finalizedSelectedWeights:
    //               List.from(style.finalizedSelectedWeights ?? []),
    //           registeredAthletes: List.from(style.registeredAthletes ?? []),
    //           registeredWeightClasses:
    //               List.from(style.registeredWeightClasses ?? []),
    //           registeredWeights: List.from(style.registeredWeights ?? []),
    //           temporarilySelectedWeights:
    //               List.from(style.temporarilySelectedWeights ?? []),
    //           temporarySelectedWeightClasses:
    //               List.from(style.temporarySelectedWeightClasses ?? []),
    //           division: Division(
    //             id: style.division?.id,
    //             style: style.division?.style,
    //             title: style.division?.title,
    //             createdAt: style.division?.createdAt,
    //             updatedAt: style.division?.updatedAt,
    //             athletes: List.from(style.division?.athletes ?? []),
    //             maxAge: style.division?.maxAge,
    //             minAge: style.division?.minAge,
    //             maxDate: style.division?.maxDate,
    //             guestRegistrationPrice: style.division?.guestRegistrationPrice,
    //             weightClasses: List.from(style.division?.weightClasses ?? []),
    //             availableWeightsPerStyle:
    //                 List.from(style.division?.availableWeightsPerStyle ?? []),
    //             divisionType: style.division?.divisionType,
    //           ),
    //         ))
    //     .toList());

    List<Athlete> availableAthletes = ageGroup.availableAthletes ?? [];
    List<Athlete> expansionPanelAthlete = ageGroup.expansionPanelAthlete!;
    for (Athlete athlete in availableAthletes) {
      athlete.chosenWCs = [];
    }

    for (Athlete athlete in availableAthletes) {
      // athlete.athleteStyles = List.from(styles.map((style) {
      //   return Styles(
      //     id: style.id,
      //     style: style.style,
      //     divisionType: style.divisionType,
      //     finalizedSelectedWeightClasses:
      //         List.from(style.finalizedSelectedWeightClasses ?? []),
      //     finalizedSelectedWeights:
      //         List.from(style.finalizedSelectedWeights ?? []),
      //     registeredAthletes: List.from(style.registeredAthletes ?? []),
      //     registeredWeightClasses:
      //         List.from(style.registeredWeightClasses ?? []),
      //     registeredWeights: List.from(style.registeredWeights ?? []),
      //     temporarilySelectedWeights:
      //         List.from(style.temporarilySelectedWeights ?? []),
      //     temporarySelectedWeightClasses:
      //         List.from(style.temporarySelectedWeightClasses ?? []),
      //     division: Division(
      //       id: style.division?.id,
      //       style: style.division?.style,
      //       title: style.division?.title,
      //       createdAt: style.division?.createdAt,
      //       updatedAt: style.division?.updatedAt,
      //       athletes: List.from(style.division?.athletes ?? []),
      //       maxAge: style.division?.maxAge,
      //       minAge: style.division?.minAge,
      //       maxDate: style.division?.maxDate,
      //       guestRegistrationPrice: style.division?.guestRegistrationPrice,
      //       weightClasses: List.from(style.division?.weightClasses ?? []),
      //       availableWeightsPerStyle:
      //           List.from(style.division?.availableWeightsPerStyle ?? []),
      //       divisionType: style.division?.divisionType,
      //     ),
      //   );
      // }).toList());
      for (Styles style in athlete.athleteStyles!) {
        style.division!.availableWeightsPerStyle = [];
        for (WeightClass weightClass in style.division!.weightClasses!) {
          style.division!.availableWeightsPerStyle!
              .add(weightClass.weight.toString());
        }
      }

      for (Styles style in athlete.athleteStyles!) {
        // Initialize a local list to store weights for this specific athlete and style
        List<String> weights = [];
        for (WeightClass weightClass in style.division!.weightClasses!) {
          bool isMatch = style.registeredAthletes!.any((element) =>
              element.weightClassId == weightClass.id &&
              element.athleteId == athlete.id);

          if (isMatch && !weights.contains(weightClass.weight.toString())) {
            athlete.isAthleteTaken = true;
            weights.add(weightClass.weight.toString());
          }
        }
        style.registeredWeights = weights;
        print('----- ${style.registeredWeights}');

        if (athlete.chosenWCs!.isEmpty) {
          for (String wc in style.registeredWeights!) {
            if (!athlete.chosenWCs!.contains(wc)) {
              athlete.chosenWCs!.add(wc);
            }
          }
        }
      }

      for (String wc in athlete.chosenWCs!) {
        if (!ageGroup.ageGroupWithExpansionPanelWeights!.contains(wc)) {
          ageGroup.ageGroupWithExpansionPanelWeights!.add(wc);
        }
      }

      bool isMatched =
          expansionPanelAthlete.any((element) => element.id == athlete.id);
      if (isMatched) {
        expansionPanelAthlete
            .where((element) => element.id == athlete.id)
            .forEach((element) {
          element.athleteStyles = athlete.athleteStyles;
          element.isAthleteTaken = athlete.isAthleteTaken;
          element.profileImage = athlete.profileImage;
          element.profile = athlete.profile;
          element.age = athlete.age;
          element.team = athlete.team;
          element.weightClass = athlete.weightClass;
          element.weight = athlete.weight;
          element.membership = athlete.membership;
          element.chosenWCs = athlete.chosenWCs;
        });
      }
    }

    // ageGroup.availableAthletes = [];

    // ageGroup.availableAthletes = availableAthletes;
    // ageGroup.expansionPanelAthlete = expansionPanelAthlete;

    emit(state.copyWith(
        isRefreshedRequired: false,
        isLoading: false,
        divisionsTypes: divs,
        childIndex: event.ageGroupIndex,
        parentIndex: event.divIndex,
        styleIndex: 0,
        athleteSelectionTabs: ageGroup.selectedAthletes!.isNotEmpty
            ? AthleteSelectionTabs.selectedAthletes
            : AthleteSelectionTabs.yourAthletes,
        selectedAgeGroup: ageGroup));
    if (event.sendToRoute) {
      Navigator.pushNamed(navigatorKey.currentContext!,
          AppRouteNames.routeEventAthleteSelection);
    }
  }

  FutureOr<void> _onTriggerFetchEventDetails(TriggerFetchEventDetails event,
      Emitter<EventDetailsWithInitialState> emit) async {
    emit(EventDetailsWithInitialState.initial());
    try {
      final response =
          await EventsRepository.getEventDetailsData(eventId: event.eventId);
      response.fold(
        (failure) {
          emit(state.copyWith(
            isFailure: true,
            isLoading: false,
            message: failure.message,
          ));
        },
        (success) {
          String coverImage = EventDetailsHandlers.getCoverImage(
              assetsUrl: success.responseData?.assetsUrl ??
                  AppStrings.global_empty_string,
              imageUrl: success.responseData!.event!.coverImage!);
          success.responseData!.event!.temporeryLimit = 0;
          List<DivisionTypes> divisionTypes =
              EventDetailsHandlers.getDivisionData(
                  eventWiseAthletes: state.eventWiseAthletes,
                  assetUrl: success.responseData!.assetsUrl!,
                  divisions: success.responseData?.event?.divisionTypes ?? []);
          String scheduleOverView =
              success.responseData!.event!.scheduleOverview!;
          List<ScheduleGroupedList> schedules =
              EventDetailsHandlers.updateScheduleParameters(
                  timeZone: success.responseData!.event!.timezone!,
                  schedules: success.responseData!.event!.schedules ?? []);
          List<Award> updatedAwards =
              EventDetailsHandlers.updateAwardsParameter(
            awards: success.responseData!.event!.awards ?? [],
            assetUrl: success.responseData!.assetsUrl!,
          );
          List<Hotels> updatedHotel =
              EventDetailsHandlers.updateHotelsParameter(
            hotels: success.responseData!.event!.hotels ?? [],
            assetUrl: success.responseData!.assetsUrl!,
          );

          List<Products> products = EventDetailsHandlers.updateProductParameter(
            products: success.responseData!.event!.products ?? [],
            assetUrl: success.responseData!.assetsUrl!,
          );
          EventStatus eventStatus = GlobalHandlers.getStatusEvent(
              startDate: success.responseData!.event!.startDatetime!,
              endDate: success.responseData!.event!.endDatetime!);
          String eventStatusMessage = eventStatus == EventStatus.upcoming
              ? 'Upcoming in ${DateTime.parse(success.responseData!.event!.startDatetime!).difference(DateTime.now()).inDays} days'
              : eventStatus == EventStatus.live
                  ? EventStatus.live.name
                  : DateFunctions.getMMMMddyyyyFormat(
                      date: success.responseData!.event!.startDatetime!);
          String locationDateTime = EventDetailsHandlers.getLocationDateTime(
              time: success.responseData!.event!.startTime!,
              address: success.responseData?.event?.address ??
                  AppStrings.global_empty_string,
              startDateTime: success.responseData!.event!.startDatetime!);

          List<String> tiles = [
            AppStrings.eventDetailView_information_tabButtonTitle,
            AppStrings.eventDetailView_registrationList_tabButtonTitle,
            AppStrings.eventDetailView_divisions_tabButtonTitle,
            AppStrings.eventDetailView_schedule_tabButtonTitle,
            AppStrings.eventDetailView_hotels_tabButtonTitle,
            AppStrings.eventDetailView_awards_tabButtonTitle,
            AppStrings.eventDetailView_products_tabButtonTitle,
          ];
          if (success.responseData!.event!.additionalData!.isNotEmpty) {
            for (AdditionalData data
                in success.responseData!.event!.additionalData!) {
              tiles.add(data.title!);
            }
          }
          EventResponseData eventResponseData = success.responseData!;
          eventResponseData.event!.coverImage = coverImage;
          eventResponseData.event!.divisionTypes = divisionTypes;
          // eventResponseData.event!.schedules = schedules;
          eventResponseData.event!.awards = updatedAwards;
          eventResponseData.event!.hotels = updatedHotel;
          eventResponseData.event!.products = products;
          // eventId = eventResponseData.event!.underscoreId!;
          globalEventResponseData = eventResponseData;
          String startDate = DateFunctions.getddMMyyHmma(
              timezone: success.responseData!.event!.timezone!,
              date: success.responseData!.event!.startDatetime!);
          String endDate = DateFunctions.getddMMyyHmma(
              timezone: success.responseData!.event!.timezone!,
              date: success.responseData!.event!.endDatetime!);
          String eventDateTime =
              startDate == endDate ? startDate : '$startDate - $endDate';

          String regsLinks = AppStrings.global_empty_string;
          regsLinks = success.responseData!.event!.registrationLink ??
              AppStrings.global_empty_string;
          emit(state.copyWith(
            isFailure: false,
            regsLink: regsLinks,
            locationDateTime: locationDateTime,
            eventResponseData: eventResponseData,
            eventStatusMessage: eventStatusMessage,
            coverImage: coverImage,
            eventStatus: eventStatus,
            assetUrl: success.responseData!.assetsUrl!,
            schedules: schedules,
            tabButtonTitles: tiles,
            products: products,
            awards: updatedAwards,
            eventDateTime: eventDateTime,
            selectedAgeGroup: event.divIndex != null && event.childIndex != null
                ? divisionTypes[event.divIndex!].ageGroups![event.childIndex!]
                : null,
            eventLocation: success.responseData?.event?.venue != null
                ? '${success.responseData?.event?.venue?.name}, ${success.responseData?.event?.address}'
                : success.responseData?.event?.address ??
                    AppStrings.global_empty_string,
            hotels: success.responseData?.event?.hotels ?? [],
            scheduleOverView: scheduleOverView,
            eventDescription: success.responseData!.event!.shortDesc!,
            eventTitle: success.responseData!.event!.title!,
            weightInGuidelines: success.responseData?.weightInGuidelines,
            eventInformation: success.responseData?.event?.description ??
                AppStrings.global_empty_string,
            divisionsTypes: divisionTypes,
            isLoading: false,
            registrationTabList: success.responseData?.event?.registrationTab,
          ));
          if (event.canFetchQuestionnaire) {
            BlocProvider.of<QuestionnaireBloc>(navigatorKey.currentContext!)
                .add(TriggerQuestionnaireFetch(eventId: event.eventId));
          }
          if (event.isFromDetailView) {
            if (success.responseData!.event!.registrationTab != null) {
              if (success.responseData!.event!.registrationTab!.isAvailable!) {
                add(TriggerGetRegistrationList());
              }
            }
          } else {
            BlocProvider.of<ChatBloc>(navigatorKey.currentContext!).add(
                TriggerFetchChat(
                    eventId: eventResponseData.event!.id!,
                    eventImage: coverImage));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isFailure: true,
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerSwitchTab(
      TriggerSwitchTab event, Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    if (event.isDivTabIndex) {
      for (var element in state.divisionsTypes) {
        element.isExpanded = false;
        for (var ageGroup in element.ageGroups!) {
          ageGroup.isExpanded = false;
        }
      }
      emit(state.copyWith(
          isRefreshedRequired: false, divisionTabIndex: event.index));
    } else {
      emit(state.copyWith(isRefreshedRequired: false, tabIndex: event.index));
    }
  }

  FutureOr<void> _onTriggerExpandTileInsideDivisionTab(
      TriggerExpandTileDivisionTab event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    List<DivisionTypes> divisionsTypes = event.divisionsTypes;
    if (event.sublistIndex == -1) {
      divisionsTypes[event.index].isExpanded = event.isExpanded;
    } else {
      divisionsTypes[event.index].ageGroups![event.sublistIndex].isExpanded =
          event.isExpanded;
    }

    emit(state.copyWith(
        isLoading: false,
        isRefreshedRequired: false,
        divisionsTypes: divisionsTypes));
  }

  FutureOr<void> _onTriggerExpandTileScheduleTile(
      TriggerExpandTileScheduleTile event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    emit(state.copyWith(
        isRefreshedRequired: false,
        scheduleTileIndex: event.scheduleTileIndex));
  }

  FutureOr<void> _onTriggerUpdateExpansionPaneList(
      TriggerUpdateExpansionPaneList event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    Athlete currentAthlete = event.athlete;

    currentAthlete.chosenWCs = [];
    for (Styles styles in currentAthlete.athleteStyles!) {
      for (String wc in styles.finalizedSelectedWeights!) {
        if (!currentAthlete.chosenWCs!.contains(wc)) {
          currentAthlete.chosenWCs!.add(wc);
        }
      }
    }
    for (Styles styles in currentAthlete.athleteStyles!) {
      for (String wc in styles.registeredWeights!) {
        if (!currentAthlete.chosenWCs!.contains(wc)) {
          currentAthlete.chosenWCs!.add(wc);
        }
      }
    }

    List<Athlete> selectedAthletes =
        List.from(event.ageGroup.selectedAthletes!);
    List<Athlete> availableAthletes =
        List.from(event.ageGroup.availableAthletes!);
    List<Athlete> athletes = List.from(event.ageGroup.athletes!);
    List<Athlete> expansionPanelAthlete =
        List.from(event.ageGroup.expansionPanelAthlete!);
    bool isTempListEmpty = currentAthlete.athleteStyles!
        .every((element) => element.temporarilySelectedWeights!.isEmpty);
    bool isRegListEmpty = currentAthlete.athleteStyles!
        .every((element) => element.registeredWeights!.isEmpty);
    if (isTempListEmpty && isRegListEmpty) {
      currentAthlete.isAthleteTaken = false;
    } else {
      currentAthlete.isAthleteTaken = true;
    }

    if (isTempListEmpty) {
      selectedAthletes
          .removeWhere((element) => element.id == currentAthlete.id);
      availableAthletes.add(currentAthlete);
      bool isRegListEmpty = currentAthlete.athleteStyles!
          .every((element) => element.registeredWeights!.isEmpty);
      if (isRegListEmpty) {
        currentAthlete.isAthleteTaken = false;
      } else {
        currentAthlete.isAthleteTaken = true;
      }
    } else {
      availableAthletes
          .removeWhere((element) => element.id == currentAthlete.id);
      bool isAlreadySelected =
          selectedAthletes.any((element) => element.id == currentAthlete.id);
      if (isAlreadySelected) {
        selectedAthletes
            .where((element) => element.id == currentAthlete.id)
            .forEach((element) {
          element.chosenWCs = currentAthlete.chosenWCs;
          element.athleteStyles = currentAthlete.athleteStyles;
        });
      } else {
        selectedAthletes.add(currentAthlete);
      }
    }

    event.ageGroup.ageGroupWithExpansionPanelWeights = [];
    for (Athlete athlete in event.ageGroup.availableAthletes!) {
      for (Styles styles in athlete.athleteStyles!) {
        for (String wc in styles.finalizedSelectedWeights!) {
          if (!event.ageGroup.ageGroupWithExpansionPanelWeights!.contains(wc)) {
            event.ageGroup.ageGroupWithExpansionPanelWeights!.add(wc);
          }
        }
        for (String wc in styles.registeredWeights!) {
          if (!event.ageGroup.ageGroupWithExpansionPanelWeights!.contains(wc)) {
            event.ageGroup.ageGroupWithExpansionPanelWeights!.add(wc);
          }
        }
      }
    }
    for (Athlete athlete in event.ageGroup.expansionPanelAthlete!) {
      for (Styles styles in athlete.athleteStyles!) {
        for (String wc in styles.finalizedSelectedWeights!) {
          if (!event.ageGroup.ageGroupWithExpansionPanelWeights!.contains(wc)) {
            event.ageGroup.ageGroupWithExpansionPanelWeights!.add(wc);
          }
        }
        for (String wc in styles.registeredWeights!) {
          if (!event.ageGroup.ageGroupWithExpansionPanelWeights!.contains(wc)) {
            event.ageGroup.ageGroupWithExpansionPanelWeights!.add(wc);
          }
        }
      }
    }
    int noOfAthletesWithSelectedWeights = 0;

    event.divisionType.numberOfSelectedRegisteredAthlete =
        noOfAthletesWithSelectedWeights +
            event.divisionType.numberOfSelectedRegisteredAthlete!;

    event.ageGroup.selectedAthletes = List.from(selectedAthletes);
    event.ageGroup.availableAthletes = List.from(availableAthletes);
    event.ageGroup.expansionPanelAthlete = List.from(expansionPanelAthlete);

    event.ageGroup.selectedAthletesForCount = [];
    for (Athlete athlete in event.ageGroup.expansionPanelAthlete!) {
      if (athlete.athleteStyles!
          .any((element) => element.temporarilySelectedWeights!.isNotEmpty)) {
        event.ageGroup.selectedAthletesForCount!.add(athlete);
      }
    }
    event.ageGroup.athletes = List.from(athletes);
    emit(state.copyWith(
        isRefreshedRequired: false, selectedAgeGroup: event.ageGroup));
    add(TriggerToCollectRegistrationList(divisionTypes: state.divisionsTypes));
  }

  FutureOr<void> _onTriggerMoveBetweenTabs(TriggerMoveBetweenTabs event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    AthleteSelectionTabs tab = AthleteSelectionTabs.selectedAthletes;
    Athlete athlete = event.athlete;
    AgeGroups ageGroup = state.selectedAgeGroup!;
    bool isTemporaryListEmpty = athlete.athleteStyles!
        .every((element) => element.temporarilySelectedWeights!.isEmpty);
    bool isRegisteredListEmpty = athlete.athleteStyles!
        .every((element) => element.registeredWeights!.isEmpty);
    List<String> originalWC = [];
    List<String> tempWC = [];
    if (!isRegisteredListEmpty) {
      originalWC = athlete.athleteStyles!
          .map((e) => e.registeredWeights!)
          .expand((element) => element)
          .toList();
    }
    if (!isTemporaryListEmpty) {
      tempWC = athlete.athleteStyles!
          .map((e) => e.temporarilySelectedWeights!)
          .expand((element) => element)
          .toList();
    } else {
      tab = AthleteSelectionTabs.yourAthletes;
    }

    List<Athlete> selectedAthletes = List.from(ageGroup.selectedAthletes!);
    List<Athlete> availableAthletes = List.from(ageGroup.availableAthletes!);
    print('rrrr${availableAthletes.length}');
    athlete.chosenWCs = List.from(originalWC);
    for (String wc in tempWC) {
      if (!athlete.chosenWCs!.contains(wc)) {
        athlete.chosenWCs!.add(wc);
      }
    }
    if (!isTemporaryListEmpty) {
      if (selectedAthletes.isEmpty) {
        selectedAthletes = [athlete];
      } else {
        bool isExistingAthlete =
            selectedAthletes.any((element) => (element.id ?? element.underscoreId)== (athlete.id ?? athlete.underscoreId));
        if (isExistingAthlete) {
          selectedAthletes
              .where((element) =>(element.id ?? element.underscoreId)== (athlete.id ?? athlete.underscoreId))
              .forEach((element) {
            element.chosenWCs = athlete.chosenWCs;
            element.athleteStyles = athlete.athleteStyles!;
          });
        } else {
          selectedAthletes = [...selectedAthletes, athlete];
        }
      }
      availableAthletes.removeWhere((element)  {
        debugPrint('check ${element.id} ${athlete.id} ${element.underscoreId} ${athlete.underscoreId}');
        return ((element.id ?? element.underscoreId)== (athlete.id ?? athlete.underscoreId));});
    }
    else {
      selectedAthletes.removeWhere((element) => (element.id ?? element.underscoreId)== (athlete.id ?? athlete.underscoreId));
      athlete.isAthleteTaken = false;
      availableAthletes.add(athlete);
    }
    ageGroup.selectedAthletes = selectedAthletes;
    ageGroup.availableAthletes = availableAthletes;
    ageGroup.ageGroupWithExpansionPanelWeights =
        EventDetailsHandlers.chosenWC(ageGroup);
    emit(state.copyWith(
      isRefreshedRequired: false,
      selectedAgeGroup: ageGroup,
      athleteSelectionTabs: tab,

    ));
  }

  FutureOr<void> _onTriggerRemoveFromSelectAthlete(
      TriggerRemoveFromSelectAthlete event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    AthleteSelectionTabs tab = AthleteSelectionTabs.selectedAthletes;
    event.selectedAthletes[event.index].isAthleteTaken = false;
    List<Athlete> yourAthlete = [event.selectedAthletes[event.index]];
    for (Styles style in event.selectedAthletes[event.index].athleteStyles!) {
      for (String wc in style.temporarilySelectedWeights!) {
        state.eventResponseData!.event!.temporeryLimit =
            state.eventResponseData!.event!.temporeryLimit! - 1;
        if (event.selectedAthletes[event.index].chosenWCs!.contains(wc)) {
          event.selectedAthletes[event.index].chosenWCs!.remove(wc);
        }
      }
      style.temporarilySelectedWeights = [];
      event.selectedAthletes[event.index].chosenWCs =
          GlobalHandlers.sortWeights(
              weightClasses: event.selectedAthletes[event.index].chosenWCs!);
    }
    List<Athlete> selectedAthletes = List.from(event.selectedAthletes);

    selectedAthletes.removeAt(event.index);
    AgeGroups ageGroup = state.selectedAgeGroup!;
    ageGroup.selectedAthletes = selectedAthletes;
    ageGroup.availableAthletes = [
      ...ageGroup.availableAthletes!,
      ...yourAthlete
    ];
    ageGroup.ageGroupWithExpansionPanelWeights =
        EventDetailsHandlers.chosenWC(ageGroup);
    emit(state.copyWith(
      isRefreshedRequired: false,
      selectedAgeGroup: ageGroup,
      athleteSelectionTabs: tab,
    ));
  }

  FutureOr<void> _onTriggerSwitchBetweenTab(
      TriggerSwitchBetweenAthleteSelectionsTab event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    if (event.athleteSelectionTabs == AthleteSelectionTabs.selectedAthletes) {
      emit(state.copyWith(
          athleteSelectionTabs: AthleteSelectionTabs.selectedAthletes));
    } else {
      emit(state.copyWith(
          athleteSelectionTabs: AthleteSelectionTabs.yourAthletes));
    }
    emit(state.copyWith(isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerSelectStyleIndex(TriggerSelectStyleIndex event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    emit(state.copyWith(isRefreshedRequired: false, styleIndex: event.index));
  }

  FutureOr<void> _onTriggerWCSelectionTemporarily(
      TriggerWCSelectionTemporarily event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    List<String> availableWeightsPerStyle = List.from(event.athlete
        .athleteStyles![state.styleIndex].division!.availableWeightsPerStyle!);
    List<String> temporarilySelectedWeights = List.from(event
        .athlete.athleteStyles![state.styleIndex].temporarilySelectedWeights!);
    List<WeightClass> temporarilySelectedWeightsClasses = List.from(event
        .athlete
        .athleteStyles![state.styleIndex]
        .temporarySelectedWeightClasses!);

    String selectedWc = availableWeightsPerStyle[event.weightIndex];
    WeightClass weightClass = event.athlete.athleteStyles![state.styleIndex]
        .division!.weightClasses![event.weightIndex];

    debugPrint('selectedWc: ${weightClass.toJson()}');
    if (temporarilySelectedWeights.contains(selectedWc)) {
      temporarilySelectedWeights.remove(selectedWc);
      state.eventResponseData!.event!.temporeryLimit =
          state.eventResponseData!.event!.temporeryLimit! - 1;
      if (weightClass.totalRegistration != null) {
        weightClass.totalRegistration = (weightClass.totalRegistration! - 1);
      }
      weightClass.isCalculated = false;
      temporarilySelectedWeightsClasses.remove(weightClass);
    }
    else {
      num? maxLimit = state.eventResponseData?.event?.eventRegistrationLimit;
      if(navigatorKey.currentContext!.read<RegisterAndSellBloc>().state.isStaffRegistration){
        state.eventResponseData?.event!.temporeryLimit =
        (state.eventResponseData!.event!.temporeryLimit! + 1);
        weightClass.isCalculated = true;
        temporarilySelectedWeights.add(selectedWc);
        temporarilySelectedWeightsClasses.add(weightClass);
        if (weightClass.totalRegistration != null) {
          weightClass.isCalculated = true;
          weightClass.totalRegistration =
          (weightClass.totalRegistration! + 1);
        }
      }
      else{
        if (maxLimit != null) {
          num? alredyRegisterd =
              state.eventResponseData?.event?.totalRegistrations;
          num? bracketCapacity = maxLimit - alredyRegisterd!;
          if (state.eventResponseData!.event!.temporeryLimit! < bracketCapacity) {
            //  add(IncrementEvent());
            state.eventResponseData?.event!.temporeryLimit =
            (state.eventResponseData!.event!.temporeryLimit! + 1);
            temporarilySelectedWeights.add(selectedWc);
            if (weightClass.totalRegistration != null) {
              weightClass.totalRegistration =
              (weightClass.totalRegistration! + 1);
            }
            temporarilySelectedWeightsClasses.add(weightClass);
          } else {
            emit(state.copyWith(
                message:
                'The limit of registrations for this event has been reached. You cannot register for further brackets.',
                isLoading: false,
                isFailure: true));
            return Future.value();
          }
        }
        else{
          state.eventResponseData!.event!.temporeryLimit = (state.eventResponseData!.event!.temporeryLimit! + 1);
          if (weightClass.totalRegistration != null) {
            weightClass.totalRegistration = (weightClass.totalRegistration!);
          }
          temporarilySelectedWeights.add(selectedWc);
          temporarilySelectedWeightsClasses.add(weightClass);
        }
      }
    }
    event.athlete.athleteStyles![state.styleIndex].temporarilySelectedWeights =
        List.from(temporarilySelectedWeights);
    event.athlete.athleteStyles![state.styleIndex]
        .temporarySelectedWeightClasses =
        List.from(temporarilySelectedWeightsClasses);

    debugPrint('----> ${temporarilySelectedWeightsClasses}');
    debugPrint('----> ${temporarilySelectedWeights}');
    event.athlete.athleteStyles![state.styleIndex].finalizedSelectedWeights =
        List.from(temporarilySelectedWeights);
    event.athlete.athleteStyles![state.styleIndex]
        .finalizedSelectedWeightClasses =
        List.from(temporarilySelectedWeightsClasses);
    event.athlete.chosenWCs = event.athlete.athleteStyles!
        .map((e) => e.finalizedSelectedWeights!)
        .expand((element) => element)
        .toList();
    if(event.athlete.chosenWCs!.isNotEmpty){
      event.athlete.isAthleteTaken = true;
      event.athlete.chosenWCs!.toSet();
      event.athlete.chosenWCs = GlobalHandlers.sortWeights(
          weightClasses: event.athlete.chosenWCs!);}else{
      event.athlete.isAthleteTaken = false;
    }
    emit(state.copyWith(
      isRefreshedRequired: false,
      selectedAgeGroup: event.ageGroup,
    ));

    if (event.athleteSelectionTabs == AthleteSelectionTabs.expansionPanel) {
      add(TriggerUpdateExpansionPaneList(
          divisionType: event.divisionType,
          ageGroup: event.ageGroup,
          athlete: event.athlete));
    } else {
      add(TriggerMoveBetweenTabs(
        athlete: event.athlete,
      ));
    }
  }

  FutureOr<void> _onTriggerUpdateYourAthleteList(
      TriggerUpdateYourAthleteList event,
      Emitter<EventDetailsWithInitialState> emit) {}

  FutureOr<void> _onTriggerAddToExpansionPanel(TriggerAddToExpansionPanel event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    AgeGroups ageGroup = state.selectedAgeGroup!;
    List<Athlete> selectedAthletes = List.from(ageGroup.selectedAthletes!);
    List<Athlete> athletes =
        state.couponModule == CouponModules.employeeRegistration
            ? List.from(ageGroup.availableAthletes!)
            : List.from(ageGroup.athletes!);
    List<Athlete> expansionPanelAthletes =
        List.from(ageGroup.expansionPanelAthlete!);
    for (Athlete selectedAthlete in selectedAthletes) {
      // Check if the selected athlete exists in the athletes list
      selectedAthlete.isAthleteTaken = true;

      // Check if the selected athlete exists in the expansionPanelAthletes list
      int indexInExpansionPanel = expansionPanelAthletes
          .indexWhere((athlete) => (athlete.id ?? athlete.underscoreId) == (selectedAthlete.id ?? selectedAthlete.underscoreId));
      if (indexInExpansionPanel != -1) {
        // Replace the athlete in expansionPanelAthletes with the selected athlete
        expansionPanelAthletes[indexInExpansionPanel] = selectedAthlete;
      } else {
        // Add the selected athlete to expansionPanelAthletes if not already present
        selectedAthlete.isTakenInThisRegistration = true;
        expansionPanelAthletes.add(selectedAthlete);
      }
    }

    ageGroup.ageGroupWithExpansionPanelWeights =
        EventDetailsHandlers.chosenWC(ageGroup);
    ageGroup.expansionPanelAthlete = expansionPanelAthletes;
    ageGroup.athletes = athletes;
    ageGroup.selectedAthletes = selectedAthletes;
    // event.ageGroup.selectedAthletesForCount = [];
    // for(Athlete athlete in event.ageGroup.expansionPanelAthlete!){
    //   if(athlete.athleteStyles!.any((element) => element.temporarilySelectedWeights!.isNotEmpty)){
    //     event.ageGroup.selectedAthletesForCount!.add(athlete);
    //   }
    // }
    ageGroup.needUpdate = ageGroup.selectedAthletes!.isNotEmpty ? true : null;

    emit(state.copyWith(
      isRefreshedRequired: false,
      selectedAgeGroup: ageGroup,
    ));
    add(
        TriggerToCollectRegistrationList(
          divisionTypes: state
              .divisionsTypes,
        ));


  }

  FutureOr<void> _onTriggerResetStyleIndex(TriggerResetStyleIndex event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    //  bool isSelected = event.ageGroup.selectedAthletes!.any((element) =>
    //      element.id == event.athlete.id);
    // bool isAvailable = event.ageGroup.availableAthletes!.any((element) =>
    //      element.id == event.athlete.id);
    // if(isSelected) {
    //  Athlete selectedAthlete = event.ageGroup.selectedAthletes!
    //      .firstWhere((element) => element.id == event.athlete.id);
    //  event.athlete.athleteStyles = List.from(selectedAthlete.athleteStyles!
    //      .map((style) => Styles(
    //    id: style.id,
    //    style: style.style,
    //    divisionType: style.divisionType,
    //    finalizedSelectedWeightClasses:
    //    List.from(style.finalizedSelectedWeightClasses ?? []),
    //    finalizedSelectedWeights:
    //    List.from(style.finalizedSelectedWeights ?? []),
    //    registeredAthletes: List.from(style.registeredAthletes ?? []),
    //    registeredWeightClasses:
    //    List.from(style.registeredWeightClasses ?? []),
    //    registeredWeights: List.from(style.registeredWeights ?? []),
    //    temporarilySelectedWeights:
    //    List.from(style.temporarilySelectedWeights ?? []),
    //    temporarySelectedWeightClasses:
    //    List.from(style.temporarySelectedWeightClasses ?? []),
    //    division: Division(
    //      id: style.division?.id,
    //      style: style.division?.style,
    //      title: style.division?.title,
    //      createdAt: style.division?.createdAt,
    //      updatedAt: style.division?.updatedAt,
    //      athletes: List.from(style.division?.athletes ?? []),
    //      maxAge: style.division?.maxAge,
    //      minAge: style.division?.minAge,
    //      maxDate: style.division?.maxDate,
    //      guestRegistrationPrice: style.division?.guestRegistrationPrice,
    //      weightClasses: List.from(style.division?.weightClasses ?? []),
    //      availableWeightsPerStyle:
    //      List.from(style.division?.availableWeightsPerStyle ?? []),
    //      divisionType: style.division?.divisionType,
    //    ),
    //  ))
    //      .toList());
    // }
    // else if(isAvailable){
    //   Athlete available = event.ageGroup.availableAthletes!
    //       .firstWhere((element) => element.id == event.athlete.id);
    //   event.athlete.athleteStyles = List.from(available.athleteStyles!
    //       .map((style) => Styles(
    //     id: style.id,
    //     style: style.style,
    //     divisionType: style.divisionType,
    //     finalizedSelectedWeightClasses:
    //     List.from(style.finalizedSelectedWeightClasses ?? []),
    //     finalizedSelectedWeights:
    //     List.from(style.finalizedSelectedWeights ?? []),
    //     registeredAthletes: List.from(style.registeredAthletes ?? []),
    //     registeredWeightClasses:
    //     List.from(style.registeredWeightClasses ?? []),
    //     registeredWeights: List.from(style.registeredWeights ?? []),
    //     temporarilySelectedWeights:
    //     List.from(style.temporarilySelectedWeights ?? []),
    //     temporarySelectedWeightClasses:
    //     List.from(style.temporarySelectedWeightClasses ?? []),
    //     division: Division(
    //       id: style.division?.id,
    //       style: style.division?.style,
    //       title: style.division?.title,
    //       createdAt: style.division?.createdAt,
    //       updatedAt: style.division?.updatedAt,
    //       athletes: List.from(style.division?.athletes ?? []),
    //       maxAge: style.division?.maxAge,
    //       minAge: style.division?.minAge,
    //       maxDate: style.division?.maxDate,
    //       guestRegistrationPrice: style.division?.guestRegistrationPrice,
    //       weightClasses: List.from(style.division?.weightClasses ?? []),
    //       availableWeightsPerStyle:
    //       List.from(style.division?.availableWeightsPerStyle ?? []),
    //       divisionType: style.division?.divisionType,
    //     ),
    //   ))
    //       .toList());
    // }
    // else{
    //   event.athlete.athleteStyles = List.from(event.ageGroup.styles!
    //       .map((style) => Styles(
    //     id: style.id,
    //     style: style.style,
    //     divisionType: style.divisionType,
    //     finalizedSelectedWeightClasses:
    //     List.from(style.finalizedSelectedWeightClasses ?? []),
    //     finalizedSelectedWeights:
    //     List.from(style.finalizedSelectedWeights ?? []),
    //     registeredAthletes: List.from(style.registeredAthletes ?? []),
    //     registeredWeightClasses:
    //     List.from(style.registeredWeightClasses ?? []),
    //     registeredWeights: List.from(style.registeredWeights ?? []),
    //     temporarilySelectedWeights:
    //     List.from(style.temporarilySelectedWeights ?? []),
    //     temporarySelectedWeightClasses:
    //     List.from(style.temporarySelectedWeightClasses ?? []),
    //     division: Division(
    //       id: style.division?.id,
    //       style: style.division?.style,
    //       title: style.division?.title,
    //       createdAt: style.division?.createdAt,
    //       updatedAt: style.division?.updatedAt,
    //       athletes: List.from(style.division?.athletes ?? []),
    //       maxAge: style.division?.maxAge,
    //       minAge: style.division?.minAge,
    //       maxDate: style.division?.maxDate,
    //       guestRegistrationPrice: style.division?.guestRegistrationPrice,
    //       weightClasses: List.from(style.division?.weightClasses ?? []),
    //       availableWeightsPerStyle:
    //       List.from(style.division?.availableWeightsPerStyle ?? []),
    //       divisionType: style.division?.divisionType,
    //     ),
    //   ))
    //       .toList());
    // }
    emit(state.copyWith(
      isRefreshedRequired: false,
      styleIndex: 0,
      selectedAgeGroup: event.ageGroup,
    ));
  }

  FutureOr<void> _onTriggerToCollectRegistrationList(
      TriggerToCollectRegistrationList event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    List<Athlete> athleteReadyForRegistrations =
        EventDetailsHandlers.collectAthletes(
            divisionTypes: state.divisionsTypes);
    for(Athlete a in athleteReadyForRegistrations){
      if(a.selectedTeam?.name != null){
        String teamId = globalTeams.firstWhere((e) => e.name == a.selectedTeam?.name).id ?? AppStrings.global_empty_string;
        a.selectedTeam?.id = teamId;
        a.teamId = teamId;
      }
    }
    emit(state.copyWith(
      isRefreshedRequired: false,
      readyForRegistrationAthletes: athleteReadyForRegistrations,
      couponModule: CouponModules.registration,
    ));
    BlocProvider.of<PurchaseBloc>(navigatorKey.currentContext!).add(
        TriggerMovingForward(
            isContinueButtonActive: athleteReadyForRegistrations.isNotEmpty,
            athletesForSeasonPass: const [],
            couponModule: CouponModules.registration));
  }

  FutureOr<void> _onTriggerSetIndex(
      TriggerSetIndex event, Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    emit(state.copyWith(
      isRefreshedRequired: false,
      parentIndex: event.parentIndex,
      childIndex: event.childIndex,
    ));
  }

  FutureOr<void> _onTriggerGetRegistrationList(TriggerGetRegistrationList event,
      Emitter<EventDetailsWithInitialState> emit) async {
    //EventDetailsHandlers.emitInitialState(emit: emit, state: state);

    try {
      final response = await EventsRepository.getRegistrationList(
          eventId: state.eventResponseData!.event!.id!);
      response.fold(
          (failure) => emit(state.copyWith(isFailure: true, isLoading: false)),
          (success) => emit(state.copyWith(
              isLoading: false, data: success.responseData?.data ?? [])));
    } catch (e) {
      emit(state.copyWith(
        isFailure: true,
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerSearchReg(
      TriggerSearchReg event, Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    List<RegistrationListData> searchResults = [];
    if (event.searchValue.isNotEmpty) {
      searchResults = state.data
          .where((element) =>
              element.firstName!
                  .toLowerCase()
                  .contains(event.searchValue.toLowerCase()) ||
              element.lastName!
                  .toLowerCase()
                  .contains(event.searchValue.toLowerCase()))
          .toList();
    }
    emit(state.copyWith(
      isRefreshedRequired: false,
      showEraser: true,
      searchedData: searchResults,
    ));
  }

  FutureOr<void> _onTriggerOnChangeSearchEvent(TriggerOnChangeSearchEvent event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    List<RegistrationListData> searchResults = [];
    if (event.searchValue.isNotEmpty) {
      searchResults = state.data
          .where((element) =>
              element.firstName!
                  .toLowerCase()
                  .contains(event.searchValue.toLowerCase()) ||
              element.lastName!
                  .toLowerCase()
                  .contains(event.searchValue.toLowerCase()))
          .toList();
    }
    emit(state.copyWith(
      isRefreshedRequired: false,
      searchedData: searchResults,
      showEraser: event.searchValue.isNotEmpty,
    ));
  }

  FutureOr<void> _onTriggerEraseSearchValue(TriggerEraseSearchValue event,
      Emitter<EventDetailsWithInitialState> emit) {
    emit(state.copyWith(
      isRefreshedRequired: false,
      searchController: TextEditingController(),
      showEraser: false,
      searchedData: [],
    ));
  }

  FutureOr<void> _onTriggerShortenEventDetails(TriggerShortenEventDetails event,
      Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    emit(state.copyWith(
      isRefreshedRequired: false,
      isShorten: event.isShorten,
    ));
  }

  FutureOr<void> _onTriggerPickDivision(
      TriggerPickDivision event, Emitter<EventDetailsWithInitialState> emit) {
    EventDetailsHandlers.emitRefreshState(emit: emit, state: state);
    event.divisionType[event.divIndex].isExpanded = true;
    for (var i = 0; i < event.divisionType.length; i++) {
      if (event.divIndex != i) {
        event.divisionType[i].isExpanded = false;
      }
    }
    emit(state.copyWith(
      isRefreshedRequired: false,
      selectedDivisionIndex: event.divIndex,
      divisionsTypes: event.divisionType,
    ));
  }

  FutureOr<void> _onTriggerFetchEmployeeAthletes(
      TriggerFetchEmployeeAthletes event,
      Emitter<EventDetailsWithInitialState> emit) {
    emit(state.copyWith(
        isLoading: true,
        couponModule: CouponModules.employeeRegistration,
        message: AppStrings.global_empty_string,
        isFailure: false));
    EventData eventData = navigatorKey.currentContext!
        .read<RegisterAndSellBloc>()
        .state
        .eventData;
    List<Athlete> athletes =
        navigatorKey.currentContext!.read<RegisterAndSellBloc>().state.athletes;

    List<DivisionTypes> divisionTypes = eventData.divisionTypes!;

    List<DivisionTypes> updateDivs = [];

    updateDivs = EventDetailsHandlers.getDivisionData(
        isForEmployees: true,
        eventWiseAthletes: athletes,
        isFirstTime: true,
        assetUrl: AppStrings.global_empty_string,
        divisions: divisionTypes);
    for (var i = 0; i < athletes.length; i++) {
      athletes[i].isAthleteTaken = false;
      athletes[i].chosenWCs = [];
    }
    emit(state.copyWith(
      isRefreshedRequired: false,
      divisionsTypes: updateDivs,
      eventWiseAthletes: athletes,
      isLoading: false,
      message: AppStrings.global_empty_string,
    ));
    eventData.temporeryLimit = 0;
    globalEventResponseData = EventResponseData(event: eventData);
    emit(state.copyWith(
      eventResponseData: globalEventResponseData,
    ));

    add(TriggerUpDivisionListAthletes(
      isEnteringPurchaseView: CouponModules.employeeRegistration,
      divisionTypes: updateDivs,
    ));
  }

  FutureOr<void> _onTriggerAssembleForDivision(TriggerAssembleForDivision event,
      Emitter<EventDetailsWithInitialState> emit) {
    List<Athlete> eventWiseAthletes = List.from(state.eventWiseAthletes);
    eventWiseAthletes.addAll(event.athletes);
    emit(state.copyWith(
        isLoading: false,
        message: AppStrings.global_empty_string,
        isFailure: false));
    List<DivisionTypes> updateDivs = EventDetailsHandlers.getDivisionData(
        isForEmployees: true,
        eventWiseAthletes: eventWiseAthletes,
        assetUrl: AppStrings.global_empty_string,
        divisions: event.divisionTypes);
    globalEventResponseData?.event = navigatorKey.currentContext!
        .read<RegisterAndSellBloc>()
        .state
        .eventData;
    globalEventResponseData?.event!.divisionTypes = updateDivs;
    globalEventResponseData?.event!.temporeryLimit = 0;
    List<DivisionTypes> updatedDivisionTypes = updateDivs;

    for (var i = 0; i < updateDivs.length; i++) {
      for (var j = 0; j < updateDivs[i].ageGroups!.length; j++) {
          Athlete newAthlete = Athlete(
          id: event.athletes[0].id,
          firstName: event.athletes[0].firstName,
          lastName: event.athletes[0].lastName,
          isAthleteTaken: false,
          athleteStyles:   List.from(updateDivs[i].ageGroups![j].styles!
              .map((style) => Styles(
            id: style.id,
            style: style.style,
            disclaimer: style.disclaimer,
            divisionType: style.divisionType,
            finalizedSelectedWeightClasses: List.from(
                style.finalizedSelectedWeightClasses ?? []),
            finalizedSelectedWeights:
            List.from(style.finalizedSelectedWeights ?? []),
            registeredAthletes:
            List.from(style.registeredAthletes ?? []),
            registeredWeightClasses:
            List.from(style.registeredWeightClasses ?? []),
            registeredWeights:
            List.from(style.registeredWeights ?? []),
            temporarilySelectedWeights:
            List.from(style.temporarilySelectedWeights ?? []),
            temporarySelectedWeightClasses: List.from(
                style.temporarySelectedWeightClasses ?? []),
            division: Division(
              id: style.division?.id,
              style: style.division?.style,
              title: style.division?.title,
              createdAt: style.division?.createdAt,
              updatedAt: style.division?.updatedAt,
              athletes: List.from(style.division?.athletes ?? []),
              maxAge: style.division?.maxAge,
              minAge: style.division?.minAge,
              maxDate: style.division?.maxDate,
              guestRegistrationPrice:
              style.division?.guestRegistrationPrice,
              weightClasses:
              List.from(style.division?.weightClasses ?? []),
              availableWeightsPerStyle: List.from(
                  style.division?.availableWeightsPerStyle ?? []),
              divisionType: style.division?.divisionType,
            ),
          ))
              .toList()),
          weightClass: event.athletes[0].weightClass,
          age: event.athletes[0].age,
          uniqueId: event.athletes[0].id,
          underscoreId: event.athletes[0].id,
          grade: event.athletes[0].grade,
          state: event.athletes[0].state,
          city: event.athletes[0].city,
          mailingAddress: event.athletes[0].mailingAddress,
          gender: event.athletes[0].gender,
          pincode: event.athletes[0].pincode,
          phoneCode: event.athletes[0].phoneCode,
          phoneNumber: event.athletes[0].phoneNumber,
          teamId: event.athletes[0].teamId,
          team: event.athletes[0].team,
          birthDate: event.athletes[0].birthDate,
          fileImage: event.athletes[0].fileImage,
          weight: event.athletes[0].weight,
          selectedGrade: event.athletes[0].selectedGrade,
          selectedTeam: event.athletes[0].selectedTeam,
          isRedshirt: event.athletes[0].isRedshirt,
          chosenWCs: [],
        );
          debugPrint('New Athlete: ${newAthlete.firstName} ${newAthlete.lastName}');
          debugPrint('New Athlete: ${updatedDivisionTypes[i].ageGroups![j].title}');
          debugPrint('New Athlete: ${updatedDivisionTypes[i].ageGroups![j].availableAthletes!}');
          updatedDivisionTypes[i].ageGroups![j].availableAthletes!.add(newAthlete);
          if (updatedDivisionTypes[i].divisionType!.toLowerCase() == 'girls') {
            updateDivs[i].ageGroups![j].availableAthletes!
                .removeWhere((element) => element.gender != 'female');
          }
      }

    }
    emit(state.copyWith(
        isLoading: false,
        eventResponseData: globalEventResponseData,
        eventWiseAthletes: eventWiseAthletes,
        divisionsTypes: updatedDivisionTypes,
        message: AppStrings.global_empty_string,
        isFailure: false));

    // add(TriggerUpDivisionListAthletes(
    //   isEnteringPurchaseView: CouponModules.employeeRegistration,
    //   divisionTypes: updateDivs,
    //   divIndex: event.divIndex,
    //   childIndex: event.childIndex,
    // ));
  }

  FutureOr<void> _onTriggerGetDivisionForEmployee(TriggerGetDivisionForEmployee event, Emitter<EventDetailsWithInitialState> emit) {
   emit(state.copyWith(divisionsTypes: event.divisionTypes));
  }

  FutureOr<void> _onTriggerChangeTeam(TriggerChangeTeam event, Emitter<EventDetailsWithInitialState> emit) {
    emit(state.copyWith(
      isRefreshedRequired: true,
      message: AppStrings.global_empty_string,
      isLoading: false,
    ));
    emit(state.copyWith(
      isRefreshedRequired: false,
    ));
  }

  FutureOr<void> _onTriggerCheckForUpdateCartStatus(TriggerCheckForUpdateCartStatus event, Emitter<EventDetailsWithInitialState> emit) {
    emit(state.copyWith(
      isRefreshedRequired: true,
      message: AppStrings.global_empty_string,
      isLoading: false,
    ));
    if(state.selectedAgeGroup != null) {
      state.selectedAgeGroup!.needUpdate =
          state.selectedAgeGroup!.selectedAthletes!.isNotEmpty ? true : null;
    }
    emit(state.copyWith(
      isRefreshedRequired: false,
    ));
    Navigator.pop(navigatorKey.currentContext!);
  }
}
