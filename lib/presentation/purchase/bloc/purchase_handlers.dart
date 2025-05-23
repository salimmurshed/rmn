import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../base/bloc/base_bloc.dart';
import 'purchase_bloc.dart';

class PurchaseHandlers {
  static void emitInitialState(
      {required Emitter<PurchaseWithInitialState> emit,
      required PurchaseWithInitialState state}) {
    emit(state.copyWith(
        isRefreshedRequired: false,
        isFailure: false,
        isLoading: true,
        message: AppStrings.global_empty_string));
  }

  static void emitRefreshState(
      {required Emitter<PurchaseWithInitialState> emit,
      required PurchaseWithInitialState state}) {
    emit(state.copyWith(
        isRefreshedRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));
  }

  static List<Athlete> updateAthletes(
      {required String assetsUrl, required List<Athlete> athletes}) {
    for (Athlete athlete in athletes) {
      athlete.profileImage = '${athlete.profileImage}';
      athlete.dropDownKey = GlobalKey<State<StatefulWidget>>();
      athlete.isExpanded = false;
    }
    return athletes;
  }

  static List<Products> updateProduct(
      {required String assetsUrl, required List<Products> products}) {
    // for (Products product in products) {
    //   product.selectedVariant =
    //       product.variants!.isNotEmpty ? product.variants![0] : null;
    //   product.quantity = 0;
    //   product.totalPrice = 0;
    //   product.productDetails?.image =
    //       '$assetsUrl${product.productDetails?.image}';
    //   product.dropDownKeyForProduct = GlobalKey<State<StatefulWidget>>();
    //   bool isGiveAway = product.productDetails?.isGiveaway ?? false;
    //   if(isGiveAway){
    //     product.giveAwayCounts = product.availableGiveaways ?? 0;
    //   }
    // }
    for (Products product in products) {
      List<String> ids = [];
      List<String> idsForGiveaways = [];
      bool isGiveaway = product.productDetails?.isGiveaway ?? false;
      int giveAwayAvailable = product.availableGiveaways ?? 0;
      product.giveAwayCounts = giveAwayAvailable;
        product.selectedVariant =
            product.variants!.isNotEmpty ? product.variants![0] : null;
        product.quantity = 0;
        product.totalPrice = 0;
        product.productDetails?.image =
            '$assetsUrl${product.productDetails?.image}';
        product.dropDownKeyForProduct = GlobalKey<State<StatefulWidget>>();
      if (isGiveaway) {


        switch (product.productDetails?.giveAwayType)
        {
          case 'athlete':
            // for (Registrations registration in registrations) {
            //   ids.add(registration.athleteId!);
            // }
            // ids = ids.toSet().toList();
            // idsForGiveaways = readyForRegistrationAthletes
            //     .where((athlete) => (!ids.contains(athlete.underscoreId)))
            //     .map((athlete) => athlete.underscoreId!)
            //     .toList();
            // idsForGiveaways = idsForGiveaways.toSet().toList();
            // if (idsForGiveaways.isNotEmpty) {
            //   product.giveAwayCounts =
            //       idsForGiveaways.length + giveAwayAvailable;
            // } else {
            //   product.giveAwayCounts = giveAwayAvailable;
            // }
            if (product.giveAwayCounts == 0) {
              product.isMaxGiveawayAdded = true;
            } else {
              product.isMaxGiveawayAdded = null;
            }
            if ((product.quantity ??0 )> product.giveAwayCounts!) {
              product.quantity = product.giveAwayCounts;
            }
            debugPrint(
                'Giveawaytype: athlete:-${product.giveAwayCounts}');
          case 'account':
            product.giveAwayCounts = giveAwayAvailable;
            if (product.giveAwayCounts == 0) {
              product.isMaxGiveawayAdded = true;
            } else {
              product.isMaxGiveawayAdded = null;
            }
            debugPrint(
                'Giveawaytype: account:-${product.giveAwayCounts}');
            if ((product.quantity ??0 )> product.giveAwayCounts!) {
              product.quantity = product.giveAwayCounts;
            }
          case 'athlete-bracket':
          // // 1. Create a unique identifier including athleteId, divId, and weightClassId
          //   Set<String> registeredCombinations = {};
          //   for (Registrations registration in registrations) {
          //     // Assuming weightClassId is accessible in Registrations, otherwise modify accordingly.
          //     registeredCombinations.add(
          //         "${registration.athleteId!}-${registration.divisionId!}-${registration.weightClassId}");
          //   }
          //
          //   // 2. Filter athletes based on the unique combination
          //   List<Athlete> athletesForGiveAway = [];
          //   for (Athlete athlete in readyForRegistrationAthletes) {
          //     // Assuming weightClassId is in athlete.wcList
          //     for (RegistrationDivision registrationDivision
          //     in athlete.athleteRegistrationDivision!) {
          //       for (String weightClass
          //       in registrationDivision.finalisedWeightIds!) {
          //         String combination =
          //             "${athlete.underscoreId}-${registrationDivision.divisionId}-$weightClass";
          //         if (!registeredCombinations.contains(combination)) {
          //           //we need to add the athlete only once per combination
          //           bool alreadyAdded = false;
          //           for (Athlete addedAthlete in athletesForGiveAway) {
          //             for (RegistrationDivision addedRegistrationDivision
          //             in addedAthlete.athleteRegistrationDivision!) {
          //               // Check against all wc
          //               for (String weightClassAdded
          //               in addedRegistrationDivision
          //                   .finalisedWeightIds!) {
          //                 String combinationAdded =
          //                     "${addedAthlete.underscoreId}-${addedRegistrationDivision.divisionId}-$weightClassAdded";
          //                 if (combination == combinationAdded) {
          //                   alreadyAdded = true;
          //                   break;
          //                 }
          //               }
          //               if (alreadyAdded) {
          //                 break; // No need to keep checking if we already find it
          //               }
          //             }
          //             if (alreadyAdded) {
          //               break;
          //             }
          //           }
          //           if (!alreadyAdded) {
          //             athletesForGiveAway.add(athlete);
          //           }
          //         }
          //       }
          //     }
          //   }
          //   // 3. Count giveaways based on unique combinations
          //   Map<String, int> combinationCounts = {};
          //
          //   for (Athlete athlete in athletesForGiveAway) {
          //     for (RegistrationDivision registrationDivision
          //     in athlete.athleteRegistrationDivision!) {
          //       for (String weightClass
          //       in registrationDivision.finalisedWeightIds!) {
          //         String combination =
          //             "${athlete.underscoreId}-${registrationDivision.divisionId}-$weightClass";
          //         combinationCounts.update(
          //             combination, (value) => value + 1,
          //             ifAbsent: () => 1);
          //       }
          //     }
          //   }
          //   idsForGiveaways = []; // Clear the previous list
          //   for (String combination in combinationCounts.keys) {
          //     int count = combinationCounts[combination]!;
          //     for (int i = 0; i < count; i++) {
          //       idsForGiveaways.add(combination);
          //     }
          //   }
          //
          //   print(
          //       'length of giveawaysIds = ${idsForGiveaways.length} - $giveAwayAvailable');
          //   if (idsForGiveaways.isNotEmpty) {
          //     product.giveAwayCounts =
          //         idsForGiveaways.length + giveAwayAvailable;
          //   } else {
          //     product.giveAwayCounts = giveAwayAvailable;
          //   }
            if (product.giveAwayCounts == 0) {
              product.isMaxGiveawayAdded = true;
            } else {
              product.isMaxGiveawayAdded = null;
            }
            if ((product.quantity ??0 )> product.giveAwayCounts!) {
              product.quantity = product.giveAwayCounts;
            }

        }

      }
    }
    return products;
  }

  static List<CardData> updateCardData({required List<CardData> cards}) {
    for (CardData card in cards) {
      card.expMonthYear =
          "${card.expMonth} / ${card.expYear.toString().substring(card.expYear.toString().length - 2)}";
    }
    return cards;
  }

  // static List<RegistrationForSummary> updateRegistrationForSummary(
  //     {required List<Athlete> selectedAthletes}) {
  //   List<String> registrationTypeId = [];
  //   int athleteCount = 0;
  //   //sorting out the registration for athletes without a pass
  //   List<RegistrationForSummary> registrationForSummary = [];
  //   for (Athlete athlete in selectedAthletes) {
  //     String id = AppStrings.global_empty_string;
  //     if (athlete.membership == null) {
  //       for (RegistrationDivision registrationDivision
  //           in athlete.athleteRegistrationDivision!) {
  //         id =
  //             '${registrationDivision.divisionName}/${registrationDivision.styleName}';
  //         int count = 0;
  //         if (!registrationTypeId.contains(id)) {
  //           registrationTypeId.add(id);
  //           for (String wc in registrationDivision.finalisedWeights!) {
  //             count = count + 1;
  //           }
  //
  //           String registrationType = id;
  //
  //           registrationForSummary.add(RegistrationForSummary(
  //             registrationType:
  //                 'Guest Registration (${StringManipulation.removeDivision(division: registrationType)})',
  //             priceOfStyle: StringManipulation.addADollarSign(
  //                 price: registrationDivision.guestRegistrationPrice!),
  //             quantity: '$count' 'x',
  //             totalPrice: StringManipulation.addADollarSign(
  //                 price: registrationDivision.guestRegistrationPrice! * count),
  //           ));
  //         } else {
  //           for (String wc in registrationDivision.finalisedWeights!) {
  //             count = count + 1;
  //           }
  //           for (RegistrationForSummary registration
  //               in registrationForSummary) {
  //             if (registration.registrationType ==
  //                 'Guest Registration (${StringManipulation.removeDivision(division: id)})') {
  //               registration.quantity =
  //                   '${int.parse(registration.quantity.split('x')[0]) + count}'
  //                   'x';
  //               registration.totalPrice = StringManipulation.addADollarSign(
  //                   price: registrationDivision.guestRegistrationPrice! *
  //                       (int.parse(registration.quantity.split('x')[0])));
  //             }
  //           }
  //         }
  //       }
  //     } else {
  //       athleteCount = athleteCount + 1;
  //     }
  //   }
  //   //sorting out the registration for athletes with a pass
  //   if (athleteCount > 0) {
  //     registrationForSummary.add(RegistrationForSummary(
  //       registrationType: 'Season Pass Registration',
  //       priceOfStyle: StringManipulation.addADollarSign(price: 0),
  //       quantity: '$athleteCount' 'x',
  //       totalPrice: StringManipulation.addADollarSign(price: 0),
  //     ));
  //   }
  //   //insert season pass at the front
  //   RegistrationForSummary? item;
  //   for (RegistrationForSummary registration in registrationForSummary) {
  //     if (registration.registrationType == 'Season Pass Registration') {
  //       item = registration;
  //       registrationForSummary.remove(registration);
  //       registrationForSummary.insert(0, item);
  //     }
  //   }
  //   return registrationForSummary;
  // }

  static List<Products> updateProductsForRegistration(
      {required List<Products> products}) {
    List<Products> selectedProducts = [];
    for (Products product in products) {
        String productName = StringManipulation.capitalizeFirstLetterOfEachWord(
            value: product.productDetails!.title!);
        product.productType = product.selectedVariant == null
            ? productName
            : '$productName (${product.selectedVariant})';

        product.totalPrice = product.price! * product.quantity!;
        selectedProducts.add(product);
    }
    return selectedProducts;
  }

  static List<Memberships> updateSeasonPassForSummary(
      {required List<Athlete> athletes})
  {
    List<Memberships> seasonPassForSummary = [];
    List<String> seasonPassIds = [];
    for (Athlete athlete in athletes) {
      if(athlete.membership != null) {
        athlete.membership?.quantity = 0;
        athlete.membership?.totalPrice = 0;

        if (seasonPassIds.contains((athlete.membership!.seasonId!))) {
          athlete.membership!.quantity = athlete.membership!.quantity! + 1;
          athlete.membership!.totalPrice = athlete.membership!.totalPrice! +
              (athlete.membership!.price! * athlete.membership!.quantity!);
          seasonPassForSummary
              .where((element) =>
                  element.seasonId == athlete.membership!.seasonId!)
              .first
              .quantity = athlete.membership!.quantity;
          seasonPassForSummary
              .where((element) =>
                  element.seasonId == athlete.membership!.seasonId!)
              .first
              .totalPrice = athlete.membership!.totalPrice;
        } else {
          seasonPassIds.add(athlete.membership!.seasonId!);
          athlete.membership!.quantity = 1;
          athlete.membership!.totalPrice = athlete.membership!.totalPrice! +
              (athlete.membership!.price! * athlete.membership!.quantity!);
          seasonPassForSummary.add(athlete.membership!);
        }
      }
    }
    return seasonPassForSummary;
  }

  static PurchaseRequestModel handlePurchasePerCouponModule(
      {required TriggerPurchase event,
      required PurchaseWithInitialState state,
      required CouponModules couponModule}) {
    {
      late PurchaseRequestModel purchaseRequestModel;
      if (couponModule == CouponModules.seasonPasses) {
        List<AthleteWithAssignedSeasonPass> athletesForSeasonPass = [];
        for (var i = 0; i < event.athletesForSeasonPass.length; i++) {
          athletesForSeasonPass.add(AthleteWithAssignedSeasonPass(
              athleteId: event.athletesForSeasonPass[i].id!,
              seasonPassId:
                  event.athletesForSeasonPass[i].membership!.seasonId!));
        }

        purchaseRequestModel = PurchaseRequestModel(
            athleteWithAssignedSeasonPass: athletesForSeasonPass,
            cardToken: state.cardList[state.selectedCardIndex].id!,
            coupon: state.couponCode,
            saveCard: state.cardList[state.selectedCardIndex].isSaved!,
            isExisting: state.cardList[state.selectedCardIndex].isExisting!);
      } else if (couponModule == CouponModules.registration) {
      } else {
        print('**');
        print(state.cardList[state.selectedCardIndex].isSaved);
        List<ProductsForPurchase> productsForPurchase = [];
        for (Products product in state.selectedProducts) {
          productsForPurchase.add(ProductsForPurchase(
              productId: product.id!,
              quantity: product.quantity!,
              variant:
                  product.selectedVariant ?? AppStrings.global_empty_string));
        }
        purchaseRequestModel = PurchaseRequestModel(
            productsForPurchase: productsForPurchase,
            cardToken: state.cardList[state.selectedCardIndex].id!,
            coupon: state.couponCode,
            saveCard: state.cardList[state.selectedCardIndex].isSaved!,
            isExisting: state.cardList[state.selectedCardIndex].isExisting!);
      }
      return purchaseRequestModel;
    }
  }

  static List<SummaryCardTypeForRegistration> getSummaryCardRegistrations(
      {required List<Athlete> athletes}) {
    List<SummaryCardTypeForRegistration> summaryCardTypeForRegistration = [];
    Map<String, SummaryCardTypeForRegistration> summaryCard = {};
    for (Athlete athlete in athletes) {
      num maxFreePass = athlete.membership?.remainingFreeRegistrations ?? 0;
        for(RegistrationDivision registrationDivision in athlete.athleteRegistrationDivision!) {
          String key = '${athlete.underscoreId}${registrationDivision
              .divisionName}${registrationDivision.styleName}';
          if(registrationDivision.memberships != null){

            if(!registrationDivision.memberships!.excludeEvents!.contains(globalEventResponseData!.event!.id)){
              if(!summaryCard.containsKey(key)){
                num? reducedPrice = calculateReducedPrice(maxFreePass,registrationDivision.finalisedWeights!.length, registrationDivision);
                summaryCard[key] = SummaryCardTypeForRegistration(
                  ageGroup: registrationDivision.ageGroupName!,
                  wcList: formatFinalizedWeights(registrationDivision.finalisedWeights),
                  tierName: registrationDivision.memberships!.product!.title!,
                  type: AppStrings.purchase_registrationAthlete_pass_type,
                  title: StringManipulation.combineFirstNameWithLastName(
                      firstName: athlete.firstName!, lastName: athlete.lastName!),
                  division: StringManipulation.capitalizeFirstLetterOfEachWord(
                      value: registrationDivision.divisionName!),
                  style: StringManipulation.capitalizeFirstLetterOfEachWord(
                      value: registrationDivision.styleName!),
                  price: registrationDivision.guestRegistrationPrice!,
                  quantity: registrationDivision.finalisedWeights!.length,
                  totalPrice: registrationDivision.totalPriceForFinalisedWeights!,
                  reducedPrice: reducedPrice,
                  nominator: registrationDivision.finalisedWeights!.length,
                  denominator: maxFreePass,
                  max: athlete.membership!.maxRegistrations!,
                );
                maxFreePass = maxFreePass - registrationDivision.finalisedWeights!.length;
                maxFreePass = maxFreePass < 0 ? 0 : maxFreePass;
              }else{
                  summaryCard[key]!.quantity += registrationDivision.finalisedWeights!.length;
                  summaryCard[key]!.totalPrice += registrationDivision.totalPriceForFinalisedWeights!;
                  summaryCard[key]!.nominator += registrationDivision.finalisedWeights!.length;
                  num? reducedPrice = calculateReducedPrice(summaryCard[key]!.denominator,  summaryCard[key]!.nominator,registrationDivision);
                  summaryCard[key]!.reducedPrice = reducedPrice;

              }
            }else{

              fillUpSummaryCardForNoSeasonPassOrExcludedEvents(summaryCard, key, athlete, registrationDivision);
            }
          }else{

            fillUpSummaryCardForNoSeasonPassOrExcludedEvents(summaryCard, key, athlete, registrationDivision);
          }
        }

    }
    summaryCardTypeForRegistration.addAll(summaryCard.values);
    return summaryCardTypeForRegistration;
  }

  static num? calculateReducedPrice(num maxFreePass, num nominator, RegistrationDivision registrationDivision) {
    num? reducedPrice = 0;
    if(maxFreePass >0){
      if(maxFreePass >nominator){
        reducedPrice = 0;}
      else{
        reducedPrice = registrationDivision.guestRegistrationPrice! * (nominator - maxFreePass);
      }
    }else{
      reducedPrice = registrationDivision.guestRegistrationPrice! * (nominator - maxFreePass);
    }
    return reducedPrice;
  }

  static void fillUpSummaryCardForNoSeasonPassOrExcludedEvents(Map<String, SummaryCardTypeForRegistration> summaryCard, String key, Athlete athlete, RegistrationDivision registrationDivision) {


     if(!summaryCard.containsKey(key)){

      summaryCard[key] = SummaryCardTypeForRegistration(
        ageGroup: registrationDivision.ageGroupName!,
        wcList: formatFinalizedWeights(registrationDivision.finalisedWeights),
        tierName:  AppStrings.global_empty_string,
        type: AppStrings.purchase_registrationAthlete_guest_type,
        title: StringManipulation.combineFirstNameWithLastName(
            firstName: athlete.firstName!, lastName: athlete.lastName!),
        division: StringManipulation.capitalizeFirstLetterOfEachWord(
            value: registrationDivision.divisionName!),
        style: StringManipulation.capitalizeFirstLetterOfEachWord(
            value: registrationDivision.styleName!),
        price: registrationDivision.guestRegistrationPrice!,
        quantity: registrationDivision.finalisedWeights!.length,
        totalPrice: registrationDivision.totalPriceForFinalisedWeights!,
        reducedPrice: null,
        nominator: 0,
        denominator: 0,
        max: 0,
      );
    }else{
      summaryCard[key]!.quantity += registrationDivision.finalisedWeights!.length;
      summaryCard[key]!.totalPrice += registrationDivision.totalPriceForFinalisedWeights!;
    }
  }
}
String formatFinalizedWeights(List<String>? finalizedWeights) {
  if (finalizedWeights == null || finalizedWeights.isEmpty) {
    return '';
  }
  if (finalizedWeights.length == 1) {
    return finalizedWeights.first;
  } else {
    return finalizedWeights.join(', ');
  }
}