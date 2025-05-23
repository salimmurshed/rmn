import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../data/models/response_models/season_passes_response_model.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'athlete_details_bloc.dart';

class AthleteDetailsHandlers {
  static void emitInitialState(
      {required Emitter<AthleteDetailsWithInitialState> emit,
      required AthleteDetailsWithInitialState state}) {
    emit(state.copyWith(
        isRefreshedRequired: true,
        isFailure: false,
        isLoadingAthleteInfo: false,
        isLoadingForTabs: false,
        message: AppStrings.global_empty_string));
  }

  static void emitWithLoaderForAthleteDetails(
      {required Emitter<AthleteDetailsWithInitialState> emit,
      required AthleteDetailsWithInitialState state}) {
    emit(state.copyWith(
        isRefreshedRequired: true,
        isFailure: false,
        isLoadingAthleteInfo: true,
        message: AppStrings.global_empty_string));
  }

  static void emitWithLoaderForTabSelection(
      {required Emitter<AthleteDetailsWithInitialState> emit,
      required AthleteDetailsWithInitialState state}) {
    emit(state.copyWith(
        isRefreshedRequired: true,
        isFailure: false,
        isLoadingForTabs: true,
        message: AppStrings.global_empty_string));
  }

  static Athlete updateAthleteParameters(
      {required String assetUrl, required Athlete athlete}) {
    athlete.profileImage = StringManipulation.combineStings(
        prefix: assetUrl, suffix: athlete.profileImage!);

    return athlete;
  }

  static List<EventsSeasonWiseForAthlete> updateEventsParameters(
      {required String assetUrl,
      required List<EventsSeasonWiseForAthlete> events}) {
    if (events.isNotEmpty) {
      for (EventsSeasonWiseForAthlete event in events) {
        event.mainImage = StringManipulation.combineStings(
            prefix: assetUrl, suffix: event.mainImage!);
      }
    }
    return events;
  }

  static List<RegistrationWithSameDivisionId>
      createListOfRegistrationWithDivisionId(
          {required List<Registrations> registrations}) {
    Map<String, RegistrationWithSameDivisionId> registrationWithDivisionMap =
        {};
    if (registrations.isNotEmpty) {
      for (Registrations registers in registrations) {
        String divId = registers.division!.id!;
        if (registrationWithDivisionMap.containsKey(divId)) {
          if (registrationWithDivisionMap[divId]!.registeredWeightClasses ==
              null) {
            registrationWithDivisionMap[divId]!.registeredWeightClasses = [
              registers.weightClass!.weight!.toString()
            ];
          } else {
            if (!registrationWithDivisionMap[divId]!
                .registeredWeightClasses!
                .contains(registers.weightClass!.weight!.toString())) {
              registrationWithDivisionMap[divId]!
                  .registeredWeightClasses!
                  .add(registers.weightClass!.weight!.toString());
            }
          }
        } else {
          registers.division!.divisionType =
              StringManipulation.capitalizeFirstLetterOfEachWord(
                  value: registers.division!.divisionType!);
          registers.division!.style =
              StringManipulation.capitalizeFirstLetterOfEachWord(
                  value: registers.division!.style!);
          registers.division!.title =
              StringManipulation.capitalizeFirstLetterOfEachWord(
                  value: registers.division!.title!);
          RegistrationWithSameDivisionId registrationWithDivisionId =
              RegistrationWithSameDivisionId(
                  division: registers.division,
                  registeredWeightClasses: [
                    registers.weightClass!.weight!.toString()
                  ],
                  isCancelled: registers.isCancelled ?? false,
                  selectedWeightClasses: [],
                  availableWeightClasses: []);
          registrationWithDivisionMap[divId] = registrationWithDivisionId;
        }
      }
    }
    return registrationWithDivisionMap.values.toList();
  }

  static List<Awards> updateAwardsParameters(
      {required String assetUrl, required List<Awards> awards}) {
    if (awards.isNotEmpty) {
      for (Awards award in awards) {
        if (award.award?.image != null) {
          award.award!.image = StringManipulation.combineStings(
              prefix: assetUrl, suffix: award.award!.image!);
        }
        if (award.division != null) {
          award.division!.title =
              StringManipulation.capitalizeFirstLetterOfEachWord(
                  value: award.division!.title!);
        }
      }
    }
    return awards;
  }

  static String modifyWC({required Awards award}) =>
      StringManipulation.combineStringWithSpaceBetween(
          firstPart: 'WC:', lastPart: award.weightClass!.weight!);

  // static String modifyMinEvents({required Awards award}) =>
  //     StringManipulation.combineStringWithSpaceBetween(
  //         firstPart: 'Win ${award.criteria!.minEvents}', lastPart: 'event(s)');
  //
  // static String modifyTotalMatches({required Awards award}) =>
  //     StringManipulation.combineStringWithSpaceBetween(
  //         firstPart: '${award.criteria!.totalMatches}',
  //         lastPart: 'times first');
  //
  // static double getPercentageForMinEvents({required Awards award}) {
  //   double progressValue = 0.0;
  //   if (award.criteria!.athleteWinEvents! < award.criteria!.minEvents!) {
  //     progressValue =
  //         (award.criteria!.athleteWinEvents! / award.criteria!.minEvents!);
  //   } else {
  //     progressValue = 1;
  //   }
  //   return progressValue;
  // }
  //
  // static String showWinByMin({required Awards award}) {
  //   return '${award.criteria!.athleteWinEvents!}/${award.criteria!.minEvents!}';
  // }
  //
  static Color showColor(
      {required int target, required int achieved, required String status}) {
    if (target == achieved && status != 'failed') {
      return AppColors.colorSuccess;
    }
    if (achieved < target && status == 'running') {
      return AppColors.colorSecondaryAccent;
    } else {
      return AppColors.colorPrimaryAccent;
    }
  }

  //
  // static Color showColorForAthleteMatchesByTotalMatches(
  //     {required Awards award}) {
  //   if (award.criteria!.athleteMatches! >= award.criteria!.totalMatches!) {
  //     return AppColors.colorPrimaryAccent;
  //   } else {
  //     return AppColors.colorSecondaryAccent;
  //   }
  // }
  //
  // static String showAthleteMatchesByTotalMatches({required Awards award}) {
  //   return '${award.criteria!.athleteMatches!}/${award.criteria!.totalMatches!}';
  // }
  //
  // static double getPercentageForTotalMatches({required Awards award}) {
  //   double progressValue = 0.0;
  //   if (award.criteria!.athleteMatches! < award.criteria!.totalMatches!) {
  //     progressValue =
  //         (award.criteria!.athleteMatches! / award.criteria!.totalMatches!);
  //   } else {
  //     progressValue = 1;
  //   }
  //   return progressValue;
  // }

  static List<String> seasonsName({required List<SeasonPass> seasons}) {
    List<String> teamsName = [];
    for (var season in seasons) {
      teamsName
          .add(StringManipulation.capitalizeTheInitial(value: season.title!));
    }
    return teamsName;
  }

  static List<Ranks> updateRankParameters({required List<Ranks> ranks}) {
    List<Ranks> rankModified = ranks;
    for (Ranks rank in rankModified) {
      String divisionType =
          StringManipulation.capitalizeTheInitial(value: rank.divisionType!);
      rank.divisionType = StringManipulation.combineStringWithSpaceBetween(
          firstPart: divisionType,
          lastPart: AppStrings.global_division_category_title);
      rank.style = StringManipulation.capitalizeTheInitial(value: rank.style!);
    }
    return rankModified;
  }
}
