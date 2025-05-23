import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../base/bloc/base_bloc.dart';
import 'event_details_bloc.dart';

class EventDetailsHandlers {
  static void emitInitialState(
      {required Emitter<EventDetailsWithInitialState> emit,
        required EventDetailsWithInitialState state}) {
    emit(state.copyWith(
        isRefreshedRequired: false,
        isFailure: false,
        isLoading: true,
        message: AppStrings.global_empty_string));
  }

  static void emitRefreshState(
      {required Emitter<EventDetailsWithInitialState> emit,
        required EventDetailsWithInitialState state}) {
    emit(state.copyWith(
        isRefreshedRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));
  }

  static String getCoverImage(
      {required String assetsUrl, required String imageUrl}) {
    return '$assetsUrl$imageUrl';
  }

  static String getLocationDateTime({required String address,
    required String time,

    required String startDateTime}) {
    String formattedDate =
    DateFunctions.getMMMMddyyyyFormat(date: startDateTime);
    String formattedTime = DateFunctions.getTimeStamp(
        startTime: time, endTime: AppStrings.global_empty_string);
    String completeAddress =
    '$address || $formattedDate at $formattedTime';
    debugPrint('Complete Address: $completeAddress');
    return completeAddress;
  }

  static List<DivisionTypes> getDivisionData(
      {required List<DivisionTypes> divisions,
        required List<Athlete> eventWiseAthletes,
        bool isForEmployees = false,
       bool isFirstTime = false,
        required String assetUrl}) {
    for (DivisionTypes division in divisions) {
      division.numberOfSelectedRegisteredAthlete = 0;
      division.isExpanded = false;
      division.divisionType =
          StringManipulation.capitalizeFirstLetterOfEachWord(
              value: division.divisionType!);
      for (AgeGroups ageGroup in division.ageGroups!) {
        List<String> weights = [];
        ageGroup.selectedAthletes = isFirstTime ? []: (ageGroup.selectedAthletes ?? []);
        ageGroup.selectedAthletesForCount = isFirstTime ? []: (ageGroup.selectedAthletesForCount ?? []);
        ageGroup.registeredAthletesForCount = isFirstTime ? []: (ageGroup.registeredAthletesForCount ?? []);
        ageGroup.availableAthletes = isFirstTime ? []: (ageGroup.availableAthletes ?? ageGroup.athletes ?? []);
        ageGroup.registeredAthletes =isFirstTime ? []: (ageGroup.registeredAthletes ?? []);
        ageGroup.expansionPanelAthlete = isFirstTime ? []: (ageGroup.expansionPanelAthlete?? []);
        ageGroup.ageGroupWithExpansionPanelWeights = isFirstTime ? []: (ageGroup.ageGroupWithExpansionPanelWeights ?? []);
        ageGroup.weightAvailable = isFirstTime ? []: (ageGroup.weightAvailable ?? []);
        ageGroup.registeredWeights = isFirstTime ? []: (ageGroup.registeredWeights?? []);
        ageGroup.ageGroupWithWeightsJoined = isFirstTime ? AppStrings.global_empty_string: (ageGroup.ageGroupWithWeightsJoined ??  AppStrings.global_empty_string);

        ageGroup.isExpanded = false;

        for (Athlete athlete in eventWiseAthletes) {
          for (Athlete athleteInAgeGroup in ageGroup.athletes ?? []) {
            if (athlete.id == athleteInAgeGroup.id) {
              athleteInAgeGroup = athlete;
            }
          }
        }
        if(!isForEmployees) {
        for (Styles style in ageGroup.styles!) {
          // for(WeightClass weightClass in style.division!.weightClasses!){

            for (RegisteredAthletes registeredAthletes
                in style.registeredAthletes ?? []) {
              if (style.division!.weightClasses!.any((element) =>
                  element.id == registeredAthletes.weightClassId)) {
                ageGroup.registeredWeights!.add(style.division!.weightClasses!
                    .firstWhere((element) =>
                        element.id == registeredAthletes.weightClassId)
                    .weight
                    .toString());
                //}
              }
            }

        }}

        if(!isForEmployees) {
          for (Styles style in ageGroup.styles!) {
            List<String> athleteIds = [];
            for (RegisteredAthletes registeredAthletes
                in style.registeredAthletes!) {
              if (!athleteIds.contains(registeredAthletes.athleteId)) {
                athleteIds.add(registeredAthletes.athleteId!);
                ageGroup.registeredAthletesForCount!.add(Athlete(
                  id: registeredAthletes.athletes!.id,
                  firstName: registeredAthletes.athletes!.firstName,
                  lastName: registeredAthletes.athletes!.lastName,
                ));
              }
            }
          }
        }

        ageGroup.title = StringManipulation.capitalizeFirstLetterOfEachWord(
            value: ageGroup.title!);
        for (Styles style in ageGroup.styles!) {
          for (WeightClass weightClass in style.division!.weightClasses!) {
            if (!weights.contains(weightClass.weight.toString())) {
              weights.add(weightClass.weight.toString());
            }
          }
        }
        weights = GlobalHandlers.sortWeights(weightClasses: weights);
        ageGroup.ageGroupWithWeightsJoined = weights.join(', ');
        for (Athlete athlete in ageGroup.athletes ?? []) {
          athlete.profileImage = '$assetUrl${athlete.profileImage}';
        }
      }
    }

    return divisions;
  }

  static List<ScheduleGroupedList> updateScheduleParameters({
    required String timeZone,
    required List<Schedules> schedules,
  }) {
    List<Schedules> updatedSchedules = List.from(schedules);
    Map<String, ScheduleGroupedList> groupedSchedules = {};

    for (Schedules schedule in updatedSchedules) {
      schedule.isExpanded = false;
      String timeStamp = DateFunctions.getTimeStamp(
          startTime: schedule.startTime!, endTime: schedule.endTime!);
      schedule.title = '${schedule.title} from $timeStamp';
      schedule.description =
          StringManipulation.capitalizeTheInitial(
              value: schedule.description!);
      String monthDate = DateFunctions.getMonthDateYearFormatWithTimeZone(
          timezone: timeZone, date: schedule.date!);
      String day = DateFunctions.getDayOfWeekInTimeZone(
          date: schedule.date!, timezone: timeZone);

      String key = '$day-$monthDate';
      debugPrint('Key: $key');
      if (!groupedSchedules.containsKey(key)) {
        groupedSchedules[key] = ScheduleGroupedList(
          day: day,
          monthDate: monthDate,
          schedules: [],
        );
      }
      groupedSchedules[key]!.schedules.add(schedule);
    }

    return groupedSchedules.values.toList();
  }

  static List<Award> updateAwardsParameter(
      {required String assetUrl, required List<Award> awards}) {
    List<Award> updatedAwards = awards;
    for (Award award in updatedAwards) {
      award.image = '$assetUrl${award.image}';
      award.title = StringManipulation.capitalizeTheInitial(
          value: award.title ?? AppStrings.global_empty_string);
      award.description = StringManipulation.capitalizeTheInitial(
          value: award.description ?? AppStrings.global_empty_string);
    }
    return updatedAwards;
  }

  static List<Products> updateProductParameter(
      {required String assetUrl, required List<Products> products}) {
    List<Products> updatedProducts = [];
    for (Products product in products) {
      bool isLater = DateTime.parse(product.endDate!).isAfter(DateTime.now());
      bool isSame =
          DateTime
              .now()
              .day == DateTime
              .parse(product.endDate!)
              .day &&
              DateTime
                  .now()
                  .month == DateTime
                  .parse(product.endDate!)
                  .month &&
              DateTime
                  .now()
                  .year == DateTime
                  .parse(product.endDate!)
                  .year;
      if (isSame || isLater) {
        product.productDetails!.image =
        '$assetUrl${product.productDetails!.image}';
        product.productDetails!.title =
            StringManipulation.capitalizeTheInitial(
                value: product.productDetails?.title ??
                    AppStrings.global_empty_string);

          product.giveAwayCounts == product.availableGiveaways;
          print('---${product.productDetails!.title}---${product.availableGiveaways}----${product.productDetails!.isGiveaway}----${product.giveAwayCounts}');
          if(product.giveAwayCounts == 0){
            product.isMaxGiveawayAdded = true;
          }

        product.productDetails!.description =
            StringManipulation.capitalizeTheInitial(
                value: product.productDetails?.description ??
                    AppStrings.global_empty_string);
        updatedProducts.add(product);
      }
    }
    return updatedProducts;
  }

  static List<Hotels> updateHotelsParameter(
      {required String assetUrl, required List<Hotels> hotels}) {
    List<Hotels> updateHotels = hotels;
    for (Hotels hotel in updateHotels) {
      hotel.image = '$assetUrl${hotel.image}';
      hotel.title = StringManipulation.capitalizeTheInitial(
          value: hotel.title ?? AppStrings.global_empty_string);
      hotel.description = StringManipulation.capitalizeTheInitial(
          value: hotel.description ?? AppStrings.global_empty_string);
    }
    return updateHotels;
  }

  static int calculateAgeDifferenceInYears(String birthDateString,
      String cutoffDateString)
  {
    debugPrint('Birth Date: $birthDateString');
    debugPrint('Cutoff Date: $cutoffDateString');
    DateTime birthDate = DateTime.now();
    if(birthDateString.contains('/')){
      List<String> parts = birthDateString.split('/');
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);

      birthDate = DateTime(year, month, day);
    }else{
      birthDate = DateTime.parse(birthDateString);

    }
    debugPrint('bday--- $birthDate $cutoffDateString');
    // DateTime cutoffDate = DateTime.parse(cutoffDateString);
    // int maxAge = int.parse(cutoffDateString);
    // DateTime cutoffDate = DateTime.now();
    DateTime dateTime = DateTime.parse(cutoffDateString.split(' ').last);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formanttedDate = formatter.format(dateTime);
    DateTime cutoffDate = DateTime.parse(formanttedDate);
    int ageDifferenceInYears = cutoffDate.year - birthDate.year;

    //Adjust if the birth date hasn't occurred yet this year
    // if (cutoffDate.month < birthDate.month ||
    //     (cutoffDate.month == birthDate.month &&
    //         cutoffDate.day < birthDate.day)) {
    //   ageDifferenceInYears--;
    // }
    print('Age Difference in Years: $ageDifferenceInYears');

    return ageDifferenceInYears;
  }

  static List<String> chosenWC(AgeGroups ageGroup) {
    List<String> chosenWcs = [];
    for (Athlete athlete in ageGroup.availableAthletes!) {
      for (Styles style in athlete.athleteStyles!) {
        for (String wc in style.registeredWeights!) {
          if (!chosenWcs.contains(wc)) {
            chosenWcs.add(wc);
          }
        }
      }
      for (Styles style in athlete.athleteStyles!) {
        for (String wc in style.temporarilySelectedWeights!) {
          if (!chosenWcs.contains(wc)) {
            chosenWcs.add(wc);
          }
        }
      }
    }
    for (Athlete athlete in ageGroup.expansionPanelAthlete!) {
      for (Styles style in athlete.athleteStyles!) {
        for (String wc in style.registeredWeights!) {
          if (!chosenWcs.contains(wc)) {
            chosenWcs.add(wc);
          }
        }
      }
      for (Styles style in athlete.athleteStyles!) {
        for (String wc in style.temporarilySelectedWeights!) {
          if (!chosenWcs.contains(wc)) {
            chosenWcs.add(wc);
          }
        }
      }
    }
    for (Athlete athlete in ageGroup.selectedAthletes!) {
      for (Styles style in athlete.athleteStyles!) {
        for (String wc in style.registeredWeights!) {
          if (!chosenWcs.contains(wc)) {
            chosenWcs.add(wc);
          }
        }
      }
      for (Styles style in athlete.athleteStyles!) {
        for (String wc in style.temporarilySelectedWeights!) {
          if (!chosenWcs.contains(wc)) {
            chosenWcs.add(wc);
          }
        }
      }
    }
    return chosenWcs;
  }

  static bool isActive({required List<DivisionTypes> divisionTypes}) {
    bool isActive = false;

    isActive = divisionTypes.any((division) {
      return division.ageGroups!.any((ageGroup) {
        return ageGroup.expansionPanelAthlete!.any((athlete) {
          if (athlete.athleteStyles == null) {
            return false;
          } else {
            if (athlete.athleteStyles!.isEmpty) {
              return false;
            } else {
              return athlete.athleteStyles!.any((style) {
                return style.temporarilySelectedWeights!.isNotEmpty;
              });
            }
          }
        });
      });
    });

    return isActive;
  }

  static List<Athlete> collectAthletes(
      {required List<DivisionTypes> divisionTypes}) {
    List<Athlete> readyForRegistrationAthletes = [];
    List<String> storedAthleteIds = [];
    for (DivisionTypes divisionTypes in divisionTypes) {
      for (AgeGroups ageGroup in divisionTypes.ageGroups!) {
        for (Athlete athlete in ageGroup.expansionPanelAthlete!) {
          for (Styles style in athlete.athleteStyles!) {
            style.finalizedSelectedWeights =
                List.from(style.temporarilySelectedWeights!);
            style.finalizedSelectedWeightClasses =
                List.from(style.temporarySelectedWeightClasses!);
          }
        }
      }
    }
    for (DivisionTypes divisionType in divisionTypes) {
      for (AgeGroups ageGroup in divisionType.ageGroups!) {
        print('${ageGroup.title} ${ageGroup.expansionPanelAthlete}');
        for (Athlete athlete in ageGroup.expansionPanelAthlete!) {
          if (athlete.isAthleteTaken! &&
              athlete.athleteStyles!.any(
                      (style) =>
                  style.temporarilySelectedWeights!.isNotEmpty)) {
            if (!storedAthleteIds.contains(athlete.underscoreId)) {
              print('Athlete ID:${ageGroup.title} ${athlete.team} ${athlete.teamId} ${athlete.selectedTeam?.name}');
              Athlete newAthlete = Athlete(
                id: athlete.id,
                isRedshirt: athlete.isRedshirt,
                selectedGrade: athlete.selectedGrade,
                grade: athlete.grade,
                canUserEditRegistration: athlete.canUserEditRegistration,
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
              storedAthleteIds.add(newAthlete.underscoreId!);

              newAthlete.athleteRegistrationDivision = [];
              for (Styles style in newAthlete.athleteStyles!) {
                if (style.finalizedSelectedWeights!.isNotEmpty) {
                  newAthlete.athleteRegistrationDivision!.add(
                      RegistrationDivision(
                          memberships: newAthlete.membership,
                          totalPriceForFinalisedWeights:
                              style.division!.guestRegistrationPrice! *
                                  style.finalizedSelectedWeights!.length,
                          ageGroupName: StringManipulation
                              .capitalizeFirstLetterOfEachWord(
                                  value: ageGroup.title ??
                                      AppStrings.global_empty_string),
                          divisionName: divisionType.divisionType,
                          teamId: newAthlete.teamId ?? '0',
                          styleName: StringManipulation
                              .capitalizeFirstLetterOfEachWord(
                                  value: style.style ??
                                      AppStrings.global_empty_string),
                          guestRegistrationPrice:
                              style.division!.guestRegistrationPrice!,
                          divisionId: style.division!.id,
                          styleId: style.id,
                          finalisedWeights: style.finalizedSelectedWeights,
                          finalisedWeightClasses:
                              style.finalizedSelectedWeightClasses,
                          finalisedWeightIds: style
                              .finalizedSelectedWeightClasses!
                              .map((e) => e.id.toString())
                              .toList()));
                }
              }

              readyForRegistrationAthletes.add(newAthlete);
            }
            else {
              print('iidd ${ageGroup.title} ${athlete.team} ${athlete.teamId} ${athlete.selectedTeam?.name}');
              for (Athlete readyAthlete in readyForRegistrationAthletes) {
                if (readyAthlete.underscoreId == athlete.underscoreId) {
                  for (Styles style in athlete.athleteStyles!) {
                    if (style.finalizedSelectedWeights!.isNotEmpty) {
                      // Find the matching style in readyAthlete.athleteStyles
                      Styles matchedStyle = readyAthlete.athleteStyles!
                          .firstWhere((readyStyle) => readyStyle.id == style.id,
                              orElse: () => Styles(id: ''));

                      if (matchedStyle.id!.isNotEmpty) {
                        // Combine finalizedSelectedWeights with unique strings
                        matchedStyle.finalizedSelectedWeights =
                            (matchedStyle.finalizedSelectedWeights! +
                                    style.finalizedSelectedWeights!)
                                .toSet()
                                .toList();
                        matchedStyle.finalizedSelectedWeightClasses =
                            (matchedStyle.finalizedSelectedWeightClasses! +
                                    style.finalizedSelectedWeightClasses!)
                                .toSet()
                                .toList();
                      } else {
                        // Add the style to readyAthlete.athleteStyles if no match is found
                        readyAthlete.athleteStyles!.add(style);
                      }

                      readyAthlete.athleteRegistrationDivision!.add(
                          RegistrationDivision(
                                 teamId: athlete.teamId ?? '0',
                              memberships: readyAthlete.membership,
                              totalPriceForFinalisedWeights:
                                  style.division!.guestRegistrationPrice! *
                                      style.finalizedSelectedWeights!.length,
                              guestRegistrationPrice:
                                  style.division!.guestRegistrationPrice!,
                              ageGroupName: StringManipulation
                                  .capitalizeFirstLetterOfEachWord(
                                      value: ageGroup.title ??
                                          AppStrings.global_empty_string),
                              divisionName: divisionType.divisionType,
                              styleName: StringManipulation
                                  .capitalizeFirstLetterOfEachWord(
                                      value: style.style ??
                                          AppStrings.global_empty_string),
                              divisionId: style.division!.id,
                              styleId: style.id,
                              finalisedWeights: style.finalizedSelectedWeights,
                              finalisedWeightClasses:
                                  style.finalizedSelectedWeightClasses,
                              finalisedWeightIds: style
                                  .finalizedSelectedWeightClasses!
                                  .map((e) => e.id.toString())
                                  .toList()));
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    for (Athlete athlete in readyForRegistrationAthletes) {
      int noOfRegistrations = 0;
      num totalRegistrationDivisionCost = 0;
      for (RegistrationDivision registrationDivision
          in athlete.athleteRegistrationDivision!) {
        if (registrationDivision.finalisedWeights!.isNotEmpty) {
          noOfRegistrations += registrationDivision.finalisedWeights!.length;
        }
        totalRegistrationDivisionCost +=
            registrationDivision.totalPriceForFinalisedWeights!;
      }
      athlete.noOfRegistrations = noOfRegistrations;
      athlete.totalRegistrationDivisionCost = totalRegistrationDivisionCost;
    }
    for (Athlete athlete in readyForRegistrationAthletes) {
      if (athlete.team != null) {
        athlete.selectedTeam = athlete.team;
      }
      else {
        String teamId = athlete.athleteRegistrationDivision?.last.teamId ?? '0';
          String name = AppStrings.global_empty_string;
          for (Team team in globalTeams) {
            if (team.id == teamId) {
              name = team.name!;
              break;
            }
          }

          athlete.selectedTeam = Team(id: athlete.teamId, name: name);

      }
      debugPrint('After ${athlete.team} ${athlete.teamId} ${athlete.selectedTeam?.name}');

    }

    // for (Athlete athlete in readyForRegistrationAthletes) {
    //   for (RegistrationDivision registrationDivision
    //       in athlete.athleteRegistrationDivision!) {
    //     print(
    //         'Style Name: ${registrationDivision.styleName} \n styleId: ${registrationDivision.styleId} \n divisionId: ${registrationDivision.divisionId} \n AgeGroupName: ${registrationDivision.ageGroupName} \n DivisionName: ${registrationDivision.divisionName} \n FinalisedWeights: ${registrationDivision.finalisedWeights} \n FinalisedWeightClasses: ${registrationDivision.finalisedWeightClasses} \n FinalisedWeightIds: ${registrationDivision.finalisedWeightIds} \n GuestRegistrationPrice: ${registrationDivision.guestRegistrationPrice} \n TotalPriceForFinalisedWeights: ${registrationDivision.totalPriceForFinalisedWeights} \n');
    //   }
    // }
    return readyForRegistrationAthletes;
  }
}