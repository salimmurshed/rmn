import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/models/request_models/event_purchase_request_model.dart';
import 'package:rmnevents/data/repository/card_repository.dart';
import 'package:rmnevents/data/repository/coupon_details_repository.dart';
import 'package:rmnevents/data/repository/payment_repository.dart';
import 'package:rmnevents/data/repository/stripe_repository.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';
import 'package:rmnevents/presentation/purchase/bloc/purchase_handlers.dart';
import 'package:rmnevents/presentation/questionnaire/bloc/questionnaire_bloc.dart';

import '../../../data/models/response_models/season_passes_response_model.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../root_app.dart';
import '../../buy_season_passes/bloc/buy_season_passes_bloc.dart';
import '../../register_and_sell/bloc/register_and_sell_bloc.dart';
import '../page/client_registration_view.dart';
import '../widgets/updated_product_widget.dart';

part 'purchase_event.dart';

part 'purchase_state.dart';

part 'purchase_bloc.freezed.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseWithInitialState> {
  PurchaseBloc() : super(PurchaseWithInitialState.initial()) {
    on<TriggerFetchEventWiseData>(_onTriggerFetchEventWiseData);
    on<TriggerUnHideDivisionList>(_onTriggerUnHideDivisionList);
    on<TriggerDropDownSelection>(_onTriggerDropDownSelection);
    on<TriggerStopLoader>(_onTriggerStopLoader);
    on<TriggerOnChangeForCardExpiry>(_onTriggerOnChangeForCardExpiry);
    on<TriggerFindOtherTeams>(_onTriggerFindOtherTeams);
    on<TriggerTapOnMatchedTeamName>(_onTriggerTapOnMatchedTeamName);
    on<TriggerOpenDropDownP>(_onTriggerOpenDropDown);
    on<TriggerReFresh>(_onTriggerReFresh);
    on<TriggerSelectVariantP>(_onTriggerSelectVariant);
    on<TriggerChangeProductQuantityP>(_onTriggerChangeProductQuantity);
    on<TriggerCardListFetch>(_onTriggerCardListFetch);
    on<TriggerSelectCard>(_onTriggerSelectCard);
    on<TriggerUpdateCardCurrentIndex>(_onTriggerUpdateCardCurrentIndex);
    on<TriggerArrangeDataForSummary>(_onTriggerArrangeDataForSummary);
    on<TriggerMovingForward>(_onTriggerMovingForward);
    on<TriggerMovingBackward>(_onTriggerMovingBackward);
    on<TriggerPurchase>(_onTriggerPurchase);
    on<TriggerCouponApplication>(_onTriggerCouponApplication);
    on<TriggerCheckApplyButtonActivity>(_onTriggerCheckApplyButtonActivity);
    on<TriggerCheckContinueButtonActivity>(
        _onTriggerCheckContinueButtonActivity);
    on<TriggerCouponRemoval>(_onTriggerCouponRemoval);
    on<TriggerSelectMonthYear>(_onTriggerSelectMonthYear);
    on<TriggerAddCard>(_onTriggerAddCard);
    on<TriggerSaveCard>(_onTriggerSaveCard);
    on<TriggerOpenAddCardView>(_onTriggerOpenAddCardView);
    on<TriggerRemoveCard>(_onTriggerRemoveCard);
    on<TriggerEditItem>(_onTriggerEditItem);
    on<TriggerPurchaseEvent>(_onTriggerPurchaseEvent);
    on<TriggerRemoveSeasonPassAthlete>(_onTriggerRemoveSeasonPassAthlete);
    on<TriggerUpdateAthleteTier>(_onTriggerUpdateAthleteTier);
    on<TriggerSelectSeasonPassTier>(_onTriggerSelectSeasonPassTier);
    on<TriggerValidateCardDate>(_onTriggerValidateCardDate);
    on<TriggerSwitchTabs>(_onTriggerSwitchTabs);
    on<TriggerAddSelectedProductToCartP>(_onTriggerAddSelectedProductToCart);
    on<TriggerChangeProductCartQuantityP>(_onTriggerChangeProductCartQuantity);
    on<TriggerCheckIfApplyActive>(_onTriggerCheckIfApplyActive);
    on<TriggerRemoveItems>(_onTriggerRemoveItems);
    on<TriggerCheckForMandatory>(_onTriggerCheckForMandatory);
    on<TriggerOpenMBSFORGiveAway>(_onTriggerOpenMBSFORGiveAway);

  }

  FutureOr<void> _onTriggerFetchEventWiseData(
      TriggerFetchEventWiseData event, Emitter<PurchaseWithInitialState> emit) {
    int cardIndex = 0;
    emit(PurchaseWithInitialState.initial());
    state.cardPageController.addListener(() {
      cardIndex = state.cardPageController.page!.round();
      add(TriggerUpdateCardCurrentIndex(currentIndex: cardIndex));
    });

    List<Products> productsCollected =
        List.from(globalEventResponseData?.event?.products ?? []);
//initial
    if (productsCollected.isNotEmpty) {
      for (Products product in productsCollected) {
        if (product.productDetails?.isGiveaway == true) {
          product.giveAwayCounts = product.availableGiveaways;
          product.quantity == 0;
          product.isMaxGiveawayAdded = null;
        }
      }
    }
    List<Products> products = PurchaseHandlers.updateProduct(
      assetsUrl: state.assetUrl,
      products: productsCollected,
    );

    List<Athlete> seasonPassAthletes = List.from(navigatorKey.currentContext!
        .read<BuySeasonPassesBloc>()
        .state
        .athletesSelectedForPurchase);
    List<SeasonPass> seasons = navigatorKey.currentContext!
        .read<BuySeasonPassesBloc>()
        .state
        .seasonPasses;

    String assetUrl =
        globalEventResponseData?.assetsUrl ?? AppStrings.global_empty_string;
    CouponModules couponModule = event.couponModules;
    String eventTitle =
        navigatorKey.currentContext!.read<EventDetailsBloc>().state.eventTitle;

    String eventDateTime = AppStrings.global_empty_string;
    num? totalRegistration = navigatorKey.currentContext!
            .read<EventDetailsBloc>()
            .state
            .eventResponseData
            ?.event
            ?.totalRegistrations ??
        0;
    num? registrationLimit = navigatorKey.currentContext!
        .read<EventDetailsBloc>()
        .state
        .eventResponseData
        ?.event
        ?.eventRegistrationLimit;
    if (event.couponModules != CouponModules.seasonPasses) {
      eventDateTime = DateFunctions.getDateRange(
          startDate: globalEventResponseData?.event?.startDatetime ??
              AppStrings.global_empty_string,
          endDate: globalEventResponseData?.event?.endDatetime ??
              AppStrings.global_empty_string);
      // eventDateTime = DateFunctions.formatDateTimeRange(
      //     globalEventResponseData!.event!.startDatetime!,
      //     globalEventResponseData!.event!.endDatetime!);
    }

    // globalEventResponseData?.event?.startDatetime == null
    //     ? AppStrings.global_empty_string
    //     : GlobalHandlers.mmDDYYDateFormatHandler(
    //         dateTime:
    //             DateTime.parse(globalEventResponseData!.event!.startDatetime!));

    String eventLocation = navigatorKey.currentContext!
        .read<EventDetailsBloc>()
        .state
        .eventLocation;
    String coverImage =
        navigatorKey.currentContext!.read<EventDetailsBloc>().state.coverImage;
    emit(state.copyWith(
        isLoading: false,
        athleteWithSeasonPasses: seasonPassAthletes,
        seasonPasses: seasons,
        selectedCardIndex: -1,
        tabIndex: event.couponModules == CouponModules.tickets ? 1 : 0,
        assetUrl: assetUrl,
        registrationForSummary: [],
        readyForRegistrationAthletes: [],
        isRefreshedRequired: true,
        isContinueButtonActive: couponModule != CouponModules.tickets,
        eventTitle: eventTitle,
        eventDateTime: eventDateTime,
        eventLocation: eventLocation,
        coverImage: coverImage,
        products: products,
        couponModule: couponModule,
        registrationLimit: registrationLimit,
        totalRegistration: totalRegistration,
        paymentModuleTabs: couponModule == CouponModules.registration
            ? PaymentModuleTabNames.registrations
            : couponModule == CouponModules.tickets
                ? PaymentModuleTabNames.products
                : couponModule == CouponModules.seasonPasses
                    ? PaymentModuleTabNames.athletes
                    : PaymentModuleTabNames.none,
        tabNames: couponModule == CouponModules.registration
            ? ['Registrations', 'Products', 'Payment', 'Summary']
            : couponModule == CouponModules.tickets
                ? ['Products', 'Payment', 'Summary']
                : ['Athletes', 'Payment', 'Summary']));
    add(TriggerCardListFetch());
  }

  FutureOr<void> _onTriggerUnHideDivisionList(
      TriggerUnHideDivisionList event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);

    state.readyForRegistrationAthletes[event.index].isExpanded =
        !state.readyForRegistrationAthletes[event.index].isExpanded!;
    emit(state.copyWith(isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerDropDownSelection(
      TriggerDropDownSelection event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    for (Team team in event.teams) {
      if (team.name == event.selectedValue) {
        event.athlete.selectedTeam = Team(name: team.name, id: team.id);
        event.athlete.teamId = team.id;
      }
    }
    emit(state.copyWith(
        selectedValue: event.selectedValue, isRefreshedRequired: false));
    BlocProvider.of<EventDetailsBloc>(navigatorKey.currentContext!)
        .add(TriggerChangeTeam());
  }

  FutureOr<void> _onTriggerFindOtherTeams(
      TriggerFindOtherTeams event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    List<String> matchedTeams = List.from(state.matchedTeams);
    if (event.typedText.isNotEmpty) {
      for (Team team in event.teams) {
        if (team.name!.contains(event.typedText)) {
          if (!matchedTeams.contains(team.name!)) {
            matchedTeams.add(team.name!);
          }
        }
      }
    } else {
      matchedTeams.clear();
    }
    emit(
        state.copyWith(matchedTeams: matchedTeams, isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerTapOnMatchedTeamName(
      TriggerTapOnMatchedTeamName event,
      Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    for (Team team in event.teams) {
      if (team.name == event.teamName) {
        event.athlete.selectedTeam = Team(name: team.name, id: team.id);
      }
    }
    emit(state.copyWith(
        otherTeamController: TextEditingController(text: event.teamName),
        isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerOpenDropDown(
      TriggerOpenDropDownP event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    if (!event.isOpened) {
      state.searchController.clear();
      state.otherTeamController.clear();
    }
    if (event.isAthlete) {
      emit(state.copyWith(
          isDropDownOpened: event.isOpened, isRefreshedRequired: false));
    } else {
      emit(state.copyWith(
          isProductDropDownOpened: event.isOpened, isRefreshedRequired: false));
    }
  }

  FutureOr<void> _onTriggerChangeProductQuantity(
      TriggerChangeProductQuantityP event,
      Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    num quantity = event.quantity;
    if (event.isMinus) {
      if (quantity > 0) {
        quantity = quantity - 1;
      } else {
        quantity = 0;
      }
    } else {
      quantity = quantity + 1;
    }
    event.product[event.index].isMaxGiveawayAdded = null;
    event.product[event.index].quantity = quantity;
    event.product[event.index].totalPrice =
        event.product[event.index].quantity! *
            event.product[event.index].price!;

    bool isContinueButtonActive =
        event.product.any((element) => element.quantity! > 0);
    if (event.isFromMBS) {
      List<Products> allProducts = List.from(state.products);
      for (Products product in allProducts) {
        if (event.product[event.index].productDetails?.id ==
            product.productDetails?.id) {
          product.quantity = quantity;
          product.isMaxGiveawayAdded = null;
          product.totalPrice = event.product[event.index].totalPrice;
        }
      }

      emit(state.copyWith(
          products: allProducts,
          needsGiveaway: event.product,
          isRefreshedRequired: false));
    } else {
      emit(state.copyWith(products: event.product, isRefreshedRequired: false));
    }

    debugPrint('quantity --: ${state.products}');
    // BlocProvider.of<RegisterAndSellBloc>(navigatorKey.currentContext!).add(
    //     TriggerUpdateProductUI(index: event.index, products: state.products));
  }

  FutureOr<void> _onTriggerSelectVariant(
      TriggerSelectVariantP event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    event.product[event.index].selectedVariant = event.selectedValue;
    if (event.isFromMBS) {
      List<Products> allProducts = List.from(state.products);
      for (Products product in allProducts) {
        if (event.product[event.index].productDetails?.id ==
            product.productDetails?.id) {
          product.selectedVariant = event.selectedValue;
        }
      }
      bool isTargetReached = event.product
          .every((element) => element.quantity == element.giveAwayCounts!);
      emit(state.copyWith(
          products: allProducts,
          needsGiveaway: event.product,
          willRegister: isTargetReached,
          // isContinueButtonActive: state.couponModule == CouponModules.registration
          //     ? isContinueButtonActive = isContinueButtonActiveFunction(
          //         allProds: state.products,
          //         selectedProds: state.selectedProducts,
          //       )
          //     : isContinueButtonActive,
          isRefreshedRequired: false));
    } else {
      emit(state.copyWith(
          products: event.product,
          selectedValueProduct: event.selectedValue,
          isRefreshedRequired: false));
    }
    BlocProvider.of<RegisterAndSellBloc>(navigatorKey.currentContext!).add(
        TriggerUpdateProductUI(index: event.index, products: event.product));
  }

  FutureOr<void> _onTriggerCardListFetch(TriggerCardListFetch event,
      Emitter<PurchaseWithInitialState> emit) async {
    PurchaseHandlers.emitInitialState(emit: emit, state: state);
    try {
      final response = await CardRepository.getCardList();
      response.fold(
          (failure) => emit(state.copyWith(
              isLoading: false,
              isRefreshedRequired: false,
              message: failure.message)), (success) {
        List<CardData> cards = PurchaseHandlers.updateCardData(
            cards: success.responseData?.data ?? []);
        emit(state.copyWith(
          cardList: cards,
          isRefreshedRequired: false,
          isLoading: false,
          selectedCardIndex: cards.isNotEmpty ? 0 : -1,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(), isLoading: false, isRefreshedRequired: false));
    }
  }

  FutureOr<void> _onTriggerSelectCard(
      TriggerSelectCard event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
        isContinueButtonActive: true,
        selectedCardIndex: event.index,
        isRefreshedRequired: false,
        isLoading: false));
  }

  FutureOr<void> _onTriggerUpdateCardCurrentIndex(
      TriggerUpdateCardCurrentIndex event,
      Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    emit(state.copyWith(
        currentCardIndex: event.currentIndex, isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerArrangeDataForSummary(
      TriggerArrangeDataForSummary event,
      Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitInitialState(emit: emit, state: state);
    List<Memberships> selectedSeasonPasses = [];

    List<SummaryCardTypeForRegistration> registrationForSummary =
        state.registrationForSummary;


    List<Products> selectedProducts =
        PurchaseHandlers.updateProductsForRegistration(
            products: state.selectedProducts);
    if (state.couponModule == CouponModules.seasonPasses) {
      selectedSeasonPasses = PurchaseHandlers.updateSeasonPassForSummary(
          athletes: state.athleteWithSeasonPasses);
    }

    bool isProductsSelected = selectedProducts.isNotEmpty;

    num registrationSubTotal = registrationForSummary.fold(
        0,
        (previousValue, element) =>
            previousValue + double.parse(element.totalPrice.toString()));
    num reducedSubTotalForRegistration = 0;
    num nonReducedSubTotalForRegistration = 0;
    bool isPriceReducedForRegs = false;
    for (int i = 0; i < registrationForSummary.length; i++) {
      if (registrationForSummary[i].reducedPrice != null) {
        isPriceReducedForRegs = true;
        reducedSubTotalForRegistration =
            registrationForSummary[i].reducedPrice! +
                reducedSubTotalForRegistration;
      }
    }

    for (int i = 0; i < registrationForSummary.length; i++) {
      if (registrationForSummary[i].reducedPrice == null) {
        nonReducedSubTotalForRegistration =
            registrationForSummary[i].totalPrice +
                nonReducedSubTotalForRegistration;
      }
    }

    num productSubTotal = selectedProducts.fold(
        0, (previousValue, element) => previousValue + element.totalPrice!);

    num seasonPassSubTotal = selectedSeasonPasses.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.price! * element.quantity!));

    num totalWithOutCoupon = nonReducedSubTotalForRegistration +
        reducedSubTotalForRegistration +
        productSubTotal +
        seasonPassSubTotal;
    num transactionFee = 0;
    num totalWithTransactionFee = 0;

    transactionFee = totalWithOutCoupon * globalTransactionFee / 100;
    totalWithTransactionFee = totalWithOutCoupon + transactionFee;

    print('^^^^^^^^${selectedProducts}');
    emit(state.copyWith(
        isProductsSelected: isProductsSelected,
        selectedProducts: selectedProducts,
        seasonPassForSummary: selectedSeasonPasses,
        isPriceReducedForRegs: isPriceReducedForRegs,
        totalReducedPrice:
            nonReducedSubTotalForRegistration + reducedSubTotalForRegistration,
        paymentModuleTabs: PaymentModuleTabNames.summary,
        productSubTotal:
            StringManipulation.addADollarSign(price: productSubTotal),
        registrationSubTotal:
            StringManipulation.addADollarSign(price: registrationSubTotal),
        seasonPassSubTotal:
            StringManipulation.addADollarSign(price: seasonPassSubTotal),
        totalWithOutCoupon: totalWithOutCoupon,
        athleteSum: registrationSubTotal,
        productSum: productSubTotal,
        isLoading: false,
        isFailure: false,
        transactionFee:
            '${StringManipulation.addADollarSign(price: transactionFee)}',
        totalWithTransactionWithoutCouponFee: totalWithTransactionFee,
        isRefreshedRequired: false));
    if (state.couponCode.isNotEmpty) {
      add(TriggerCouponApplication(
          module: state.couponModule == CouponModules.registration
              ? 'registrations'
              : state.couponModule == CouponModules.employeeRegistration
                  ? 'registrations'
                  : state.couponModule == CouponModules.tickets
                      ? 'tickets'
                      : 'season-pass'));
    }
  }

  FutureOr<void> _onTriggerMovingForward(
      TriggerMovingForward event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);

    List<Athlete> readyForRegistrationAthletes = navigatorKey.currentContext!
        .read<EventDetailsBloc>()
        .state
        .readyForRegistrationAthletes;
    List<Athlete> athletes = PurchaseHandlers.updateAthletes(
      assetsUrl: state.assetUrl,
      athletes: readyForRegistrationAthletes,
    );
    List<SummaryCardTypeForRegistration> summaryCardRegsAthletes =
        PurchaseHandlers.getSummaryCardRegistrations(
      athletes: athletes,
    );
    for (int i = 0; i < summaryCardRegsAthletes.length; i++) {
      print('*******');
      print(summaryCardRegsAthletes[i].ageGroup);
      print(summaryCardRegsAthletes[i].wcList);
      print(summaryCardRegsAthletes[i].type);
    }
    emit(state.copyWith(
        isEditRegs: false,
        registrationForSummary: summaryCardRegsAthletes,
        readyForRegistrationAthletes: athletes,
        paymentModuleTabs: PaymentModuleTabNames.registrations,
        isContinueButtonActive: event.isContinueButtonActive,
        isRefreshedRequired: false));
    add(const TriggerArrangeDataForSummary());

    // TypesOfGiveaway type = TypesOfGiveaway.type1;
    // switch (state.paymentModuleTabs) {
    //   case PaymentModuleTabNames.registrations:
    //     if (event.couponModule == CouponModules.registration) {
    //       if (state.isEditRegs) {
    //         List<Athlete> readyForRegistrationAthletes = navigatorKey
    //             .currentContext!
    //             .read<EventDetailsBloc>()
    //             .state
    //             .readyForRegistrationAthletes;
    //         List<Athlete> athletes = PurchaseHandlers.updateAthletes(
    //           assetsUrl: state.assetUrl,
    //           athletes: readyForRegistrationAthletes,
    //         );
    //         List<SummaryCardTypeForRegistration> summaryCardRegsAthletes =
    //             PurchaseHandlers.getSummaryCardRegistrations(
    //           athletes: athletes,
    //         );
    //         emit(state.copyWith(
    //             isEditRegs: false,
    //             registrationForSummary: summaryCardRegsAthletes,
    //             readyForRegistrationAthletes: athletes,
    //             paymentModuleTabs: PaymentModuleTabNames.registrations,
    //             isContinueButtonActive: event.isContinueButtonActive,
    //             isRefreshedRequired: false));
    //       }
    //       else {
    //         List<Athlete> readyForRegistrationAthletes =
    //             List.from(state.readyForRegistrationAthletes);
    //         List<Registrations> registrations = navigatorKey.currentContext!
    //             .read<EventDetailsBloc>()
    //             .state
    //             .eventResponseData!
    //             .event!
    //             .registrations!;
    //
    //         for (Products product in state.products) {
    //           List<String> ids = [];
    //           List<String> idsForGiveaways = [];
    //           bool isGiveaway = product.productDetails?.isGiveaway ?? false;
    //
    //           if (isGiveaway) {
    //             int giveAwayAvailable = product.availableGiveaways ?? 0;
    //             switch (product.productDetails?.giveAwayType) {
    //               case 'athlete':
    //                 for (Registrations registration in registrations) {
    //                   ids.add(registration.athleteId!);
    //                 }
    //                 ids = ids.toSet().toList();
    //                 idsForGiveaways = readyForRegistrationAthletes
    //                     .where(
    //                         (athlete) => (!ids.contains(athlete.underscoreId)))
    //                     .map((athlete) => athlete.underscoreId!)
    //                     .toList();
    //                 idsForGiveaways = idsForGiveaways.toSet().toList();
    //                 if (idsForGiveaways.isNotEmpty) {
    //                   if (giveAwayAvailable == 0) {
    //                     giveAwayAvailable = 1;
    //                   }
    //                   product.giveAwayCounts =
    //                       idsForGiveaways.length + giveAwayAvailable;
    //                 } else {
    //                   product.giveAwayCounts = giveAwayAvailable;
    //                 }
    //                 debugPrint('Giveawaytype: athlete:-${product.giveAwayCounts}');
    //               case 'account':
    //                 product.giveAwayCounts = giveAwayAvailable;
    //                 debugPrint('Giveawaytype: account:-${product.giveAwayCounts}');
    //               case 'athlete-bracket':
    //                 for (Registrations registration in registrations) {
    //                   ids.add(
    //                       registration.athleteId! + registration.divisionId!);
    //                 }
    //                 ids = ids.toSet().toList();
    //                 List<Athlete> athletesForGiveAway = [];
    //                 for (Athlete athlete in readyForRegistrationAthletes) {
    //                   for (RegistrationDivision rD
    //                       in athlete.athleteRegistrationDivision!) {
    //                     if (!(ids.contains(
    //                         athlete.underscoreId! + rD.divisionId!))) {
    //                       athletesForGiveAway.add(athlete);
    //                     }
    //                   }
    //                 }
    //
    //                 Map<String, int> athleteIdCounts = {};
    //
    //                 for (Athlete athlete in athletesForGiveAway) {
    //                   athleteIdCounts.update(athlete.underscoreId!, (value) => value + 1, ifAbsent: () => 1);
    //                 }
    //                 idsForGiveaways = []; // Clear the previous list
    //                 for (String athleteId in athleteIdCounts.keys) {
    //                   int count = athleteIdCounts[athleteId]!;
    //                   for (int i = 0; i < count; i++) {
    //                     idsForGiveaways.add(athleteId);
    //                   }
    //                 }
    //                 if (idsForGiveaways.isNotEmpty) {
    //                   if (giveAwayAvailable == 0) {
    //                     giveAwayAvailable = 1;
    //                   }
    //                   product.giveAwayCounts =
    //                       idsForGiveaways.length + giveAwayAvailable;
    //                 }
    //                 else {
    //                   product.giveAwayCounts = giveAwayAvailable;
    //                 }
    //                 debugPrint('Giveawaytype: bracket:-${product.giveAwayCounts}');
    //             }
    //           }
    //         }
    //         emit(state.copyWith(
    //             isEditRegs: false,
    //             typeOfGivaway: type,
    //             paymentModuleTabs: PaymentModuleTabNames.products,
    //             isContinueButtonActive: true,
    //             isRefreshedRequired: false));
    //       }
    //     } else {
    //       bool isContinueButtonActive =
    //           state.products.any((element) => element.quantity! > 0);
    //       emit(state.copyWith(
    //           paymentModuleTabs: PaymentModuleTabNames.products,
    //           isContinueButtonActive: isContinueButtonActive,
    //           isRefreshedRequired: false));
    //     }
    //
    //     add(const TriggerArrangeDataForSummary());
    //     // add(TriggerCheckContinueButtonActivity(
    //     //     isContinueButtonActive: event.isContinueButtonActive));
    //     break;
    //   case PaymentModuleTabNames.products:
    //     emit(state.copyWith(
    //         paymentModuleTabs: PaymentModuleTabNames.payment,
    //         isContinueButtonActive: state.selectedCardIndex != -1,
    //         isRefreshedRequired: false));
    //
    //     break;
    //   case PaymentModuleTabNames.payment:
    //     add(const TriggerArrangeDataForSummary());
    //     break;
    //   case PaymentModuleTabNames.summary:
    //     emit(state.copyWith(
    //         paymentModuleTabs: PaymentModuleTabNames.none,
    //         isRefreshedRequired: false));
    //     break;
    //   case PaymentModuleTabNames.athletes:
    //     emit(state.copyWith(
    //         paymentModuleTabs: PaymentModuleTabNames.payment,
    //         isContinueButtonActive: state.selectedCardIndex != -1,
    //         isRefreshedRequired: false));
    //     break;
    //   case PaymentModuleTabNames.none:
    //     emit(state.copyWith(
    //         paymentModuleTabs: PaymentModuleTabNames.none,
    //         isRefreshedRequired: false));
    //     break;
    // }
  }

  FutureOr<void> _onTriggerMovingBackward(
      TriggerMovingBackward event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    switch (state.paymentModuleTabs) {
      case PaymentModuleTabNames.registrations:
        if (state.isEditRegs) {
          emit(state.copyWith(
              isContinueButtonActive: true,
              paymentModuleTabs: PaymentModuleTabNames.none,
              isRefreshedRequired: false));
          Navigator.pop(navigatorKey.currentContext!);
        } else {
          emit(state.copyWith(
              isContinueButtonActive: true,
              isEditRegs: true,
              paymentModuleTabs: PaymentModuleTabNames.registrations,
              isRefreshedRequired: false));
          if (navigatorKey.currentContext!
              .read<QuestionnaireBloc>()
              .state
              .questions
              .isNotEmpty) {
            BlocProvider.of<QuestionnaireBloc>(navigatorKey.currentContext!)
                .add(TriggerResetQuestionnaire());
          }
        }
        break;
      case PaymentModuleTabNames.products:
        if (event.couponModule == CouponModules.registration) {
          emit(state.copyWith(
              isContinueButtonActive: true,
              paymentModuleTabs: PaymentModuleTabNames.registrations,
              isRefreshedRequired: false));
          if (navigatorKey.currentContext!
              .read<QuestionnaireBloc>()
              .state
              .questions
              .isNotEmpty) {
            BlocProvider.of<QuestionnaireBloc>(navigatorKey.currentContext!)
                .add(TriggerResetQuestionnaire());
          }
        } else {
          emit(state.copyWith(
              isContinueButtonActive: false,
              paymentModuleTabs: PaymentModuleTabNames.none,
              isRefreshedRequired: false));
          Navigator.pop(
            navigatorKey.currentContext!,
          );
        }
        break;
      case PaymentModuleTabNames.payment:
        if (event.couponModule == CouponModules.seasonPasses) {
          emit(state.copyWith(
              // isContinueButtonActive: true,
              paymentModuleTabs: PaymentModuleTabNames.athletes,
              isRefreshedRequired: false));
        } else {
          if (event.couponModule == CouponModules.registration) {
            emit(state.copyWith(
                isContinueButtonActive: true,
                paymentModuleTabs: PaymentModuleTabNames.products,
                isRefreshedRequired: false));
          } else {
            bool isContinueButtonActive =
                state.products.any((element) => element.quantity! > 0);
            emit(state.copyWith(
                isContinueButtonActive: isContinueButtonActive,
                paymentModuleTabs: PaymentModuleTabNames.products,
                isRefreshedRequired: false));
          }
        }
        break;
      case PaymentModuleTabNames.summary:
        emit(state.copyWith(
            isContinueButtonActive: true,
            paymentModuleTabs: PaymentModuleTabNames.payment,
            isRefreshedRequired: false));
        break;
      case PaymentModuleTabNames.athletes:
        emit(state.copyWith(
            isContinueButtonActive: state.athleteWithSeasonPasses.isNotEmpty,
            paymentModuleTabs: PaymentModuleTabNames.none,
            isRefreshedRequired: false));
        Navigator.pop(
            navigatorKey.currentContext!, event.athletesForSeasonPass);
        break;
      case PaymentModuleTabNames.none:
        emit(state.copyWith(
            paymentModuleTabs: PaymentModuleTabNames.none,
            isRefreshedRequired: false));
        break;
    }
  }

  FutureOr<void> _onTriggerCouponApplication(TriggerCouponApplication event,
      Emitter<PurchaseWithInitialState> emit) async {
    emit(state.copyWith(
        isCouponLoading: true,
        couponMessage: AppStrings.global_empty_string,
        isRefreshedRequired: false));
    try {
      final response = await CouponDetailsRepository.getCouponDetails(
          couponCode: event.code ?? state.couponEditingController.text,
          module: event.module);
      response.fold(
          (failure) => {
                emit(state.copyWith(
                    isLoading: false,
                    isCouponLoading: false,
                    isRefreshedRequired: false,
                    couponMessage: failure.message)),
              }, (success) {
        CouponDetailResponseModel couponDetailResponseModel = success;
        num couponAmount = 0;
        num apiCouponAmount = success.responseData!.coupon!.amount!;
        bool isFix = false;
        num forRegNSell = 0;
        if (couponDetailResponseModel.responseData!.coupon!.type ==
            'percentage') {
          isFix = false;
          couponAmount = state.totalWithOutCoupon *
              couponDetailResponseModel.responseData!.coupon!.amount! /
              100;
          forRegNSell = couponDetailResponseModel.responseData!.coupon!.amount!;
        } else {
          isFix = true;
          couponAmount =
              couponDetailResponseModel.responseData!.coupon!.amount!;
          forRegNSell = couponAmount;
        }

        num totalWithTransactionWithoutCouponFee = state.totalWithOutCoupon +
            state.totalWithOutCoupon * globalTransactionFee / 100;
        num totalWithCoupon = state.totalWithOutCoupon - couponAmount;
        totalWithCoupon = totalWithCoupon < 0 ? 0 : totalWithCoupon;
        num transactionFee = totalWithCoupon * globalTransactionFee / 100;
        num totalWithTransactionFee = totalWithCoupon + transactionFee;
        emit(state.copyWith(
            couponMessage: AppStrings.global_empty_string,
            couponAmount:
                '- ${StringManipulation.addADollarSign(price: couponAmount > state.totalWithOutCoupon ? state.totalWithOutCoupon : couponAmount)}',
            couponAmountInNum: couponAmount,
            apiCouponAmount: apiCouponAmount,
            couponCode: couponDetailResponseModel.responseData!.coupon!.code!,
            transactionFee:
                '${StringManipulation.addADollarSign(price: transactionFee)}',
            totalWithCoupon: totalWithCoupon,
            totalWithTransactionWithoutCouponFee:
                totalWithTransactionWithoutCouponFee,
            totalWithOutCoupon: state.totalWithOutCoupon,
            isCouponLoading: false,
            isFix: isFix,
            totalWithTransactionWithCouponFee: totalWithTransactionFee,
            isRefreshedRequired: false));
        debugPrint('couponAmount: $couponAmount $isFix');
      });
    } catch (e) {
      emit(state.copyWith(
          isCouponLoading: false,
          couponMessage: e.toString(),
          isLoading: false,
          isRefreshedRequired: false));
    }
  }

  FutureOr<void> _onTriggerCheckApplyButtonActivity(
      TriggerCheckApplyButtonActivity event,
      Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    emit(state.copyWith(
        isApplyButtonActive: state.couponEditingController.text.isNotEmpty,
        isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerCouponRemoval(
      TriggerCouponRemoval event, Emitter<PurchaseWithInitialState> emit) {
    num transactionFee = state.totalWithOutCoupon * globalTransactionFee / 100;
    num totalWithTransactionFee = state.totalWithOutCoupon + transactionFee;
    emit(state.copyWith(
        couponAmount: AppStrings.global_empty_zero,
        couponCode: AppStrings.global_empty_string,
        transactionFee:
            StringManipulation.addADollarSign(price: transactionFee),
        message: AppStrings.global_empty_string,
        isApplyButtonActive: false,
        isFailure: false,
        couponEditingController: TextEditingController(),
        couponNode: FocusNode(),
        totalWithCoupon: 0,
        totalWithTransactionWithoutCouponFee: totalWithTransactionFee,
        isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerCheckContinueButtonActivity(
      TriggerCheckContinueButtonActivity event,
      Emitter<PurchaseWithInitialState> emit) {
    if (state.paymentModuleTabs == PaymentModuleTabNames.products) {
      bool isContinueButtonActive = false;
      if (state.couponModule == CouponModules.registration) {
        isContinueButtonActive = isContinueButtonActiveFunction(
          allProds: state.products,
          selectedProds: state.selectedProducts,
        );
        //false for other giveaway logic
      } else {
        isContinueButtonActive =
            state.products.any((element) => element.quantity! > 0);
      }
      emit(state.copyWith(
          isContinueButtonActive: isContinueButtonActive,
          isRefreshedRequired: false));
    }
    if (state.paymentModuleTabs == PaymentModuleTabNames.payment) {
      emit(state.copyWith(
          isContinueButtonActive: state.selectedCardIndex != -1,
          isRefreshedRequired: false));
    }
    if (state.paymentModuleTabs == PaymentModuleTabNames.athletes) {
      bool isContinueButtonActive = event.athletesForSeasonPass
          .any((element) => element.membership != null);
      emit(state.copyWith(
          isContinueButtonActive: isContinueButtonActive,
          isRefreshedRequired: false));
    }
    print('isContinueButtonActive: ${state.isContinueButtonActive}');
  }

  FutureOr<void> _onTriggerPurchase(
      TriggerPurchase event, Emitter<PurchaseWithInitialState> emit) async {
    PurchaseHandlers.emitInitialState(emit: emit, state: state);
    PurchaseRequestModel purchaseRequestModel =
        PurchaseHandlers.handlePurchasePerCouponModule(
            event: event, state: state, couponModule: event.couponModule);

    try {
      final response = await PaymentRepository.makePayment(
          purchaseRequestModel: purchaseRequestModel);
      response.fold(
          (failure) => emit(state.copyWith(
              isLoading: false,
              isRefreshedRequired: false,
              message: failure.message)), (success) {
        emit(state.copyWith(
            isLoading: false,
            isRefreshedRequired: false,
            message: success.responseData!.message!));
      });
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(), isLoading: false, isRefreshedRequired: false));
    }
  }

  FutureOr<void> _onTriggerSelectMonthYear(
      TriggerSelectMonthYear event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    String date = GlobalHandlers.formatDateStringForExpiryDate(
        event.monthYear.toString());
    emit(state.copyWith(
        expiryDateEditingController: TextEditingController(text: date),
        isRefreshedRequired: false));
    add(TriggerValidateCardDate(
        expiryDate: state.expiryDateEditingController.text));
  }

  FutureOr<void> _onTriggerAddCard(
      TriggerAddCard event, Emitter<PurchaseWithInitialState> emit) async {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    String? errorTextForDate = state.expiryDateEditingController.text.isEmpty
        ? AppStrings.textfield_addCardNumber_expiryDate_emptyField_error
        : null;
    if (errorTextForDate == null) {
      PurchaseHandlers.emitInitialState(emit: emit, state: state);
      try {
        final response = await StripeRepository.createStripeToken(
            createStripeTokenRequest: CreateStripeTokenRequestModel(
                cardNumber: event.cardNumber,
                cardHolderName: event.name,
                expiryMonth: event.expiryDate.split('/')[0],
                expiryYear: event.expiryDate.split('/')[1],
                cvc: event.cvc));
        response.fold(
            (failure) => emit(state.copyWith(
                isLoading: false,
                isFailure: true,
                isRefreshedRequired: false,
                message: failure.message)), (success) {
          List<CardData> cardList = [];
          success.card!.isSaved = state.isCardSaved;
          success.card!.isExisting = false;
          success.card?.tokenizationMethod = success.id;

          print('success.card!.tokenizationMethod: ${success.card!.isSaved}');
          print('success.card!.tokenizationMethod: ${state.isCardSaved}');
          cardList.add(success.card!);

          cardList = PurchaseHandlers.updateCardData(cards: cardList);

          emit(state.copyWith(
              isLoading: false,
              isRefreshedRequired: false,
              isContinueButtonActive: true,
              cardNumberEditingController: TextEditingController(),
              cvcEditingController: TextEditingController(),
              expiryDateEditingController: TextEditingController(),
              nameEditingController: TextEditingController(),
              cardNumberFocusNode: FocusNode(),
              cvcFocusNode: FocusNode(),
              expiryDateFocusNode: FocusNode(),
              isCardSaved: false,
              selectedCardIndex: 0,
              nameFocusNode: FocusNode(),
              cardList: [...state.cardList, ...cardList],
              message: AppStrings.payment_addCard_successToast,
              isFailure: false,
              formKey: GlobalKey<FormState>()));
          Navigator.pop(navigatorKey.currentContext!);
        });
      } catch (e) {
        emit(state.copyWith(
            message: e.toString(),
            isFailure: true,
            isLoading: false,
            isRefreshedRequired: false));
      }
    } else {
      emit(state.copyWith(
          message: errorTextForDate,
          isLoading: false,
          isRefreshedRequired: false));
    }
  }

  FutureOr<void> _onTriggerSaveCard(
      TriggerSaveCard event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    bool isSaved = !state.isCardSaved;
    print('isSaved: $isSaved');
    emit(state.copyWith(isCardSaved: isSaved, isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerOpenAddCardView(
      TriggerOpenAddCardView event, Emitter<PurchaseWithInitialState> emit) {
    emit(state.copyWith(
      isRefreshedRequired: false,
      cardNumberEditingController: TextEditingController(),
      cvcEditingController: TextEditingController(),
      expiryDateEditingController: TextEditingController(),
      nameEditingController: TextEditingController(),
      cardNumberFocusNode: FocusNode(),
      cvcFocusNode: FocusNode(),
      expiryDateFocusNode: FocusNode(),
      nameFocusNode: FocusNode(),
      dateErrorForCard: null,
      formKey: GlobalKey<FormState>(),
      message: AppStrings.global_empty_string,
      isFailure: false,
      isLoading: false,
      isCardSaved: false,
    ));
  }

  FutureOr<void> _onTriggerRemoveCard(
      TriggerRemoveCard event, Emitter<PurchaseWithInitialState> emit) async {
    PurchaseHandlers.emitInitialState(emit: emit, state: state);

    if (state.cardList[event.index].isExisting!) {
      try {
        final response = await PaymentRepository.removeCard(
            cardId: state.cardList[event.index].id!);
        response.fold(
            (failure) => emit(state.copyWith(
                isLoading: false,
                isFailure: true,
                isRefreshedRequired: false,
                message: failure.message)), (success) {
          List<CardData> cardList = List.from(state.cardList);
          cardList.removeAt(event.index);
          emit(state.copyWith(
              isLoading: false,
              isRefreshedRequired: false,
              cardList: cardList,
              selectedCardIndex: -1,
              isContinueButtonActive: false,
              cardToken: AppStrings.global_empty_string,
              currentCardIndex: 0,
              message: success.responseData!.message!,
              isFailure: false));
        });
      } catch (e) {
        emit(state.copyWith(
            message: e.toString(),
            isFailure: true,
            isLoading: false,
            isRefreshedRequired: false));
      }
    } else {
      List<CardData> cardList = List.from(state.cardList);
      cardList.removeAt(event.index);
      emit(state.copyWith(
          message: AppStrings.payment_addCard_deleteCard_successToast,
          isFailure: false,
          cardList: cardList,
          selectedCardIndex: -1,
          isContinueButtonActive: false,
          cardToken: AppStrings.global_empty_string,
          currentCardIndex: 0,
          isLoading: false,
          isRefreshedRequired: false));
    }
  }

  FutureOr<void> _onTriggerEditItem(
      TriggerEditItem event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);

    switch (event.section) {
      case SummarySection.regs:
        emit(state.copyWith(
            paymentModuleTabs: PaymentModuleTabNames.registrations,
            isRefreshedRequired: false));
        if (navigatorKey.currentContext!
            .read<QuestionnaireBloc>()
            .state
            .questions
            .isNotEmpty) {
          BlocProvider.of<QuestionnaireBloc>(navigatorKey.currentContext!)
              .add(TriggerResetQuestionnaire());
        }
        break;
      case SummarySection.products:
        emit(state.copyWith(
            paymentModuleTabs: PaymentModuleTabNames.products,
            isRefreshedRequired: false));
        break;
      case SummarySection.athletes:
        emit(state.copyWith(
            paymentModuleTabs: PaymentModuleTabNames.athletes,
            isRefreshedRequired: false));

        break;
      case SummarySection.payment:
        emit(state.copyWith(
            paymentModuleTabs: PaymentModuleTabNames.payment,
            isRefreshedRequired: false));
        break;

      case SummarySection.none:
        emit(state.copyWith(
            paymentModuleTabs: PaymentModuleTabNames.none,
            isRefreshedRequired: false));
        break;
    }
  }

  FutureOr<void> _onTriggerPurchaseEvent(TriggerPurchaseEvent event,
      Emitter<PurchaseWithInitialState> emit) async {
    PurchaseHandlers.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(isActivePurchaseButton: false, isEditActive: false));
    late RegisterEventRequestModel eventRegisterRequestModel;
    List<PostRegistrations> postRegistrations = [];
    List<PostProducts> postProducts = [];
    List<PostSeasonPasses> postSeasonPasses = [];
    for (Products products in state.selectedProducts) {
      postProducts.add(PostProducts(
        productId: products.id,
        qty: products.quantity,
        variant: products.selectedVariant ?? AppStrings.global_empty_string,
      ));
    }
    if (event.couponModule == CouponModules.registration) {
      for (Athlete athlete in state.readyForRegistrationAthletes) {
        print(
            'team?? ${athlete.team?.toJson()} -- ${athlete.selectedTeam?.toJson()}');
        postRegistrations.add(
          PostRegistrations(
            athleteId: athlete.id,
            teamId: athlete.selectedTeam?.id ?? '0',
            divisions: athlete.athleteRegistrationDivision!
                .map((e) => PostDivisions(
                      divisionId: e.divisionId,
                      eventDivisionId: e.styleId,
                      weightClasses: e.finalisedWeightIds,
                    ))
                .toList(),
          ),
        );
      }
    }
    if (event.couponModule == CouponModules.seasonPasses) {
      for (Athlete athlete in state.athleteWithSeasonPasses) {
        postSeasonPasses.add(PostSeasonPasses(
          athleteId: athlete.id,
          membershipId: athlete.membership!.id,
        ));
      }
    }
    eventRegisterRequestModel = RegisterEventRequestModel(
      coupon: state.couponCode,
      eventId: globalEventResponseData?.event?.underscoreId ??
          AppStrings.global_empty_string,
      products: postProducts,
      registrations: postRegistrations,
      athletesWithSeasonPasses: postSeasonPasses,
      cardToken: state.cardList[state.selectedCardIndex].isExisting!
          ? state.cardList[state.selectedCardIndex].id
          : state.cardList[state.selectedCardIndex].tokenizationMethod!,
      existing: state.cardList[state.selectedCardIndex].isExisting,
      saveCard: state.cardList[state.selectedCardIndex].isSaved,
      questionnaire: navigatorKey.currentContext!
          .read<QuestionnaireBloc>()
          .state
          .storedAnswers,
    );
    try {
      final response = await EventsRepository.eventPurchase(
          couponModule: event.couponModule,
          eventRegisterRequestModel: eventRegisterRequestModel);
      response.fold(
          (failure) => emit(state.copyWith(
              isLoading: false,
              isFailure: true,
              isRefreshedRequired: false,
              message: failure.message,
              isEditActive: true)), (success) {
        emit(state.copyWith(
            isLoading: false,
            isRefreshedRequired: false,
            message: success.responseData!.message!));
        buildBottomSheetWithBodyImage(
          context: navigatorKey.currentContext!,
          title: event.couponModule == CouponModules.seasonPasses
              ? "Season Pass Purchase Was Successful"
              : "Your purchase was successful",
          footerNote: event.couponModule == CouponModules.seasonPasses
              ? "Congratulations! Your purchase was successful. You can now enjoy the benefits of the season pass. Enjoy it!"
              : "Congratulations! Your ticket has been successfully booked. Let's start our journey.",
          buttonText: "My Profile",
          isSingleButtonPresent:
              event.couponModule == CouponModules.seasonPasses,
          imageUrl: event.couponModule == CouponModules.tickets
              ? AppAssets.icBuyProduct
              : AppAssets.icRegPass,
          leftText: "Let's Explore More",
          rightText: "My Purchases",
          onButtonPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
          },
          navigatorFunction: () {
            if (event.couponModule == CouponModules.seasonPasses) {
              Navigator.pop(navigatorKey.currentContext!);
              Navigator.pop(navigatorKey.currentContext!);
            } else {
              Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
                  AppRouteNames.routeBase, (route) => false,
                  arguments: null);
              Navigator.pushNamed(
                  navigatorKey.currentContext!, AppRouteNames.routeMyPurchases,
                  arguments: MyPurchases.products);
            }
          },
          onLeftButtonPressed: () {
            Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
                AppRouteNames.routeBase, (route) => false,
                arguments: null);
            Navigator.pushNamed(
              navigatorKey.currentContext!,
              AppRouteNames.routeAllEvents,
            );
          },
          onRightButtonPressed: () {
            Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
                AppRouteNames.routeBase, (route) => false,
                arguments: null);
            Navigator.pushNamed(
                navigatorKey.currentContext!, AppRouteNames.routeMyPurchases,
                arguments: MyPurchases.products);
          },
        );
      });
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(),
          isLoading: false,
          isRefreshedRequired: false,
          isEditActive: true));
    }
  }

  FutureOr<void> _onTriggerRemoveSeasonPassAthlete(
      TriggerRemoveSeasonPassAthlete event,
      Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    List<Athlete> athletes = List.from(state.athleteWithSeasonPasses);
    if (!event.isFromPurchaseView) {
      athletes[event.athleteIndex].isSelected = false;
      athletes[event.athleteIndex].isInList = false;
    }
    athletes[event.athleteIndex].selectedSeasonPassTitle =
        AppStrings.global_empty_string;
    athletes[event.athleteIndex].membership = null;
    athletes[event.athleteIndex].temporaryMembership = null;
    athletes[event.athleteIndex].temporarySeasonPassTitle =
        AppStrings.global_empty_string;
    athletes.removeAt(event.athleteIndex);
    bool canWeProceedToPurchase = state.athleteWithSeasonPasses
        .any((element) => element.membership != null);
    emit(state.copyWith(
        isContinueButtonActive: canWeProceedToPurchase,
        athleteWithSeasonPasses: athletes,
        isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerUpdateAthleteTier(
      TriggerUpdateAthleteTier event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    List<Athlete> athletes = List.from(state.athleteWithSeasonPasses);
    athletes[event.athleteIndex].selectedSeasonPassTitle =
        athletes[event.athleteIndex].temporarySeasonPassTitle!;
    if (athletes[event.athleteIndex].selectedSeasonPassTitle!.isNotEmpty) {
      athletes[event.athleteIndex].membership =
          athletes[event.athleteIndex].temporaryMembership;
    } else {
      athletes[event.athleteIndex].membership = null;
      athletes[event.athleteIndex].temporaryMembership = null;
    }

    bool canWeProceedToPurchase =
        athletes.any((element) => element.membership != null);
    emit(state.copyWith(
      isContinueButtonActive: canWeProceedToPurchase,
      athleteWithSeasonPasses: athletes,
      isRefreshedRequired: false,
    ));
  }

  FutureOr<void> _onTriggerSelectSeasonPassTier(
      TriggerSelectSeasonPassTier event,
      Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    List<Athlete> athletes = List.from(state.athleteWithSeasonPasses);
    int index = event.athleteIndex;
    if (athletes[index].temporarySeasonPassTitle! == event.seasonPassTitle) {
      athletes[index].temporarySeasonPassTitle = AppStrings.global_empty_string;
    } else {
      athletes[index].temporarySeasonPassTitle = event.seasonPassTitle;
    }
    if (athletes[index].availableSeasonPasses!.isNotEmpty) {
      String seasonId = AppStrings.global_empty_string;
      for (var i = 0; i < state.seasonPasses.length; i++) {
        if (state.seasonPasses[i].title == event.seasonPassTitle) {
          seasonId = state.seasonPasses[i].id!;
          athletes[index].temporaryMembership = Memberships(
              id: seasonId,
              seasonTitle: state.seasonPasses[i].title,
              price: state.seasonPasses[i].price,
              seasonId: seasonId);
          break;
        }
      }
    } else {
      athletes[index].temporaryMembership = null;
    }
    emit(state.copyWith(
        currentSeasonPassTitle: event.seasonPassTitle,
        athleteWithSeasonPasses: athletes,
        isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerValidateCardDate(
      TriggerValidateCardDate event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    String? errorTextForDate = event.expiryDate.isEmpty
        ? AppStrings.textfield_addCardNumber_expiryDate_emptyField_error
        : null;
    if (state.expiryDateEditingController.text.length == 5 &&
        state.expiryDateEditingController.text[2] == '/') {
      int currentMonth = DateTime.now().month;
      int currentYear = DateTime.now().year;
      int cardExpirationMonth =
          int.tryParse(state.expiryDateEditingController.text.substring(0, 2))!;
      int cardExpirationYearLastTwoDigits =
          int.tryParse(state.expiryDateEditingController.text.substring(3))!;
      int cardExpirationYear =
          (currentYear ~/ 100 * 100) + cardExpirationYearLastTwoDigits;

      DateTime expirationDate =
          DateTime(cardExpirationYear, cardExpirationMonth);
      if (expirationDate.isBefore(DateTime(currentYear, currentMonth))) {
        errorTextForDate = 'Expiry date cannot be in the past';
      }
    }

    emit(state.copyWith(
        dateErrorForCard: errorTextForDate, isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerReFresh(
      TriggerReFresh event, Emitter<PurchaseWithInitialState> emit) {
    emit(PurchaseWithInitialState.initial());
    debugPrint('Refresh');
    //  emit(state.copyWith(isRefreshedRequired: false, isLoading: false));
  }

  FutureOr<void> _onTriggerOnChangeForCardExpiry(
      TriggerOnChangeForCardExpiry event,
      Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    var text = state.expiryDateEditingController.text;
    String? dateError;
    if (text.length == 2 && !text.contains('/')) {
      int month = int.tryParse(text) ?? 0;
      if (month > 12) {
        state.expiryDateEditingController.text = '0${text[0]}/${text[1]}';
      } else {
        state.expiryDateEditingController.text = '$text/';
      }
      state.expiryDateEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: state.expiryDateEditingController.text.length),
      );
    } else if (text.length == 3 && text.endsWith('/')) {
      state.expiryDateEditingController.text = text.substring(0, 2);
      state.expiryDateEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: state.expiryDateEditingController.text.length),
      );
    } else if (text.length > 2 && !text.contains('/')) {
      state.expiryDateEditingController.text =
          '${text.substring(0, 2)}/${text.substring(2)}';
      state.expiryDateEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: state.expiryDateEditingController.text.length),
      );
    } else if (state.expiryDateEditingController.text.length == 5 &&
        state.expiryDateEditingController.text[2] == '/') {
      int currentMonth = DateTime.now().month;
      int currentYear = DateTime.now().year;
      int cardExpirationMonth = int.tryParse(text.substring(0, 2))!;
      int cardExpirationYearLastTwoDigits = int.tryParse(text.substring(3))!;
      int cardExpirationYear =
          (currentYear ~/ 100 * 100) + cardExpirationYearLastTwoDigits;

      DateTime expirationDate =
          DateTime(cardExpirationYear, cardExpirationMonth);
      if (expirationDate.isBefore(DateTime(currentYear, currentMonth))) {
        dateError = 'Expiry date cannot be in the past';
      }
    }
    debugPrint('dateError: $dateError');

    emit(state.copyWith(
        dateErrorForCard: dateError, isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerStopLoader(
      TriggerStopLoader event, Emitter<PurchaseWithInitialState> emit) {
    emit(state.copyWith(
        isLoading: false,
        couponModule: CouponModules.employeeRegistration,
        isEditRegs: true,
        isRefreshedRequired: false,
        message: AppStrings.global_empty_string));
  }

  FutureOr<void> _onTriggerSwitchTabs(
      TriggerSwitchTabs event, Emitter<PurchaseWithInitialState> emit) {
    emit(state.copyWith(
        isLoading: false,
        isRefreshedRequired: true,
        message: AppStrings.global_empty_string));

    if (!event.isEdit) {
      List<Athlete> readyForRegistrationAthletes =
          List.from(state.readyForRegistrationAthletes);
      List<Registrations> registrations = navigatorKey.currentContext!
              .read<EventDetailsBloc>()
              .state
              .eventResponseData!
              .event!
              .registrations ??
          [];

      for (Products product in state.products) {
        List<String> ids = [];
        List<String> idsForGiveaways = [];
        bool isGiveaway = product.productDetails?.isGiveaway ?? false;
        int giveAwayAvailable = product.availableGiveaways ?? 0;
        product.giveAwayCounts = giveAwayAvailable;

        if (isGiveaway) {
          switch (product.productDetails?.giveAwayType) {
            case 'athlete':
              for (Registrations registration in registrations) {
                ids.add(registration.athleteId!);
              }
              ids = ids.toSet().toList();
              idsForGiveaways = readyForRegistrationAthletes
                  .where((athlete) => (!ids.contains(athlete.underscoreId)))
                  .map((athlete) => athlete.underscoreId!)
                  .toList();
              idsForGiveaways = idsForGiveaways.toSet().toList();
              if (idsForGiveaways.isNotEmpty) {
                product.giveAwayCounts =
                    idsForGiveaways.length + giveAwayAvailable;
              } else {
                product.giveAwayCounts = giveAwayAvailable;
              }
              if (product.giveAwayCounts == 0) {
                product.isMaxGiveawayAdded = true;
              } else {
                product.isMaxGiveawayAdded = null;
              }
              debugPrint('Giveawaytype: athlete:-${product.giveAwayCounts}');
              if ((product.quantity ?? 0) > product.giveAwayCounts!) {
                product.quantity = product.giveAwayCounts;
              }
            case 'account':
              product.giveAwayCounts = giveAwayAvailable;
              if (product.giveAwayCounts == 0) {
                product.isMaxGiveawayAdded = true;
              } else {
                product.isMaxGiveawayAdded = null;
              }
              debugPrint('Giveawaytype: account:-${product.giveAwayCounts}');
              if ((product.quantity ?? 0) > product.giveAwayCounts!) {
                product.quantity = product.giveAwayCounts;
              }
            case 'athlete-bracket':
              // 1. Create a unique identifier including athleteId, divId, and weightClassId
              Set<String> registeredCombinations = {};
              for (Registrations registration in registrations) {
                // Assuming weightClassId is accessible in Registrations, otherwise modify accordingly.
                registeredCombinations.add(
                    "${registration.athleteId!}-${registration.divisionId!}-${registration.weightClassId}");
              }

              // 2. Filter athletes based on the unique combination
              List<Athlete> athletesForGiveAway = [];
              for (Athlete athlete in readyForRegistrationAthletes) {
                // Assuming weightClassId is in athlete.wcList
                for (RegistrationDivision registrationDivision
                    in athlete.athleteRegistrationDivision!) {
                  for (String weightClass
                      in registrationDivision.finalisedWeightIds!) {
                    String combination =
                        "${athlete.underscoreId}-${registrationDivision.divisionId}-$weightClass";
                    if (!registeredCombinations.contains(combination)) {
                      //we need to add the athlete only once per combination
                      bool alreadyAdded = false;
                      for (Athlete addedAthlete in athletesForGiveAway) {
                        for (RegistrationDivision addedRegistrationDivision
                            in addedAthlete.athleteRegistrationDivision!) {
                          // Check against all wc
                          for (String weightClassAdded
                              in addedRegistrationDivision
                                  .finalisedWeightIds!) {
                            String combinationAdded =
                                "${addedAthlete.underscoreId}-${addedRegistrationDivision.divisionId}-$weightClassAdded";
                            if (combination == combinationAdded) {
                              alreadyAdded = true;
                              break;
                            }
                          }
                          if (alreadyAdded) {
                            break; // No need to keep checking if we already find it
                          }
                        }
                        if (alreadyAdded) {
                          break;
                        }
                      }
                      if (!alreadyAdded) {
                        athletesForGiveAway.add(athlete);
                      }
                    }
                  }
                }
              }
              // 3. Count giveaways based on unique combinations
              Map<String, int> combinationCounts = {};

              for (Athlete athlete in athletesForGiveAway) {
                for (RegistrationDivision registrationDivision
                    in athlete.athleteRegistrationDivision!) {
                  for (String weightClass
                      in registrationDivision.finalisedWeightIds!) {
                    String combination =
                        "${athlete.underscoreId}-${registrationDivision.divisionId}-$weightClass";
                    combinationCounts.update(combination, (value) => value + 1,
                        ifAbsent: () => 1);
                  }
                }
              }
              idsForGiveaways = []; // Clear the previous list
              for (String combination in combinationCounts.keys) {
                int count = combinationCounts[combination]!;
                for (int i = 0; i < count; i++) {
                  idsForGiveaways.add(combination);
                }
              }

              print(
                  'length of giveawaysIds = ${idsForGiveaways.length} - $giveAwayAvailable');
              if (idsForGiveaways.isNotEmpty) {
                product.giveAwayCounts =
                    idsForGiveaways.length + giveAwayAvailable;
              } else {
                product.giveAwayCounts = giveAwayAvailable;
              }
              if (product.giveAwayCounts == 0) {
                product.isMaxGiveawayAdded = true;
              } else {
                product.isMaxGiveawayAdded = null;
              }
              if ((product.quantity ?? 0) > product.giveAwayCounts!) {
                product.quantity = product.giveAwayCounts;
              }
          }
        }
      }
    }

    emit(state.copyWith(
        isLoading: false,
        isRefreshedRequired: false,
        tabIndex: event.index,
        message: AppStrings.global_empty_string));
  }

  FutureOr<void> _onTriggerAddSelectedProductToCart(
      TriggerAddSelectedProductToCartP event,
      Emitter<PurchaseWithInitialState> emit) async {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshedRequired: true,
        isFailure: false));

    List<Products> products =
        await processProducts(state.selectedProducts, event.product);
    for (Products p in products) {
      if (event.product.underscoreId == p.underscoreId) {
        bool isMaxed = p.isMaxGiveawayAdded ?? false;
        if (isMaxed) {
          event.product.isMaxGiveawayAdded = true;
          buildCustomToast(msg: 'Giveaway limit reached', isFailure: true);
        } else {
          p.isMaxGiveawayAdded = null;
          event.product.isMaxGiveawayAdded = null;
          buildCustomToast(msg: 'Gift is added!', isFailure: false);
        }
      }
    }

    num productSum = products.fold<num>(0, (previousValue, element) {
      if (element.quantity! > 0) {
        return previousValue + element.quantity! * element.price!;
      }
      return previousValue;
    });

    bool isTargetReached = state.needsGiveaway.every((element) {
      // print('-TT---${state.needsGiveaway} ${element.isMaxGiveawayAdded}');
      return element.isMaxGiveawayAdded != null;
    });
    add(const TriggerArrangeDataForSummary());


    List<Products> allProducts = state.products;
    for (Products prod in allProducts) {
      bool isGiveaway = prod.productDetails?.isGiveaway ?? false;
      if(prod.underscoreId == event.product.underscoreId){
        if(isGiveaway){
          prod.isMaxGiveawayAdded = event.product.isMaxGiveawayAdded;
          // print('------${prod.isMaxGiveawayAdded}');
          // print('------${event.product.isMaxGiveawayAdded}');
        }
      }
    }
    emit(state.copyWith(
        willRegister: isTargetReached,
        selectedProducts: products,
        products: allProducts,
        message: AppStrings.global_empty_string,
        isRefreshedRequired: false,
        productSum: productSum,
        isFailure: false));
    for (Products prod in state.products) {
      print('q s ${prod.isMaxGiveawayAdded}');
    }
  }

  FutureOr<void> _onTriggerChangeProductCartQuantity(
      TriggerChangeProductCartQuantityP event,
      Emitter<PurchaseWithInitialState> emit) async {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshedRequired: true,
        isFailure: false));
    event.product.quantity = event.product.quantity ?? 0;
    bool willRegister = true;
    if (event.isMinus) {
      if (event.product.quantity! > 0) {
        event.product.quantity = event.product.quantity! - 1;
        event.product.isMaxGiveawayAdded = null;
      } else {
        event.product.quantity = 0;
        event.product.isMaxGiveawayAdded = null;
      }
      bool isGiveaway = event.product.productDetails?.isGiveaway ?? false;
    } else {
      event.product.quantity = event.product.quantity! + 1;
      bool isGiveaway = event.product.productDetails?.isGiveaway ?? false;
      if (isGiveaway) {
        num totalQuantity = state.selectedProducts
            .where((p) => p.underscoreId == event.product.underscoreId)
            .fold(0, (sum, p) => sum + (p.quantity ?? 0));
        if (totalQuantity < event.product.giveAwayCounts!) {
          event.product.isMaxGiveawayAdded = null;
        } else {
          event.product.isMaxGiveawayAdded = true;
        }
      } else {
        event.product.isMaxGiveawayAdded = null;
      }
    }

    List<Products> needs = state.needsGiveaway;
    for (Products p in needs) {
      if (event.product.underscoreId == p.underscoreId) {
        p.quantity = event.product.quantity;
        p.isMaxGiveawayAdded = event.product.isMaxGiveawayAdded;
      }
    }
    List<Products> products = state.products;
    for (Products p in products) {
      if (event.product.underscoreId == p.underscoreId) {
        bool isGiveAway = event.product.productDetails?.isGiveaway ?? false;
        if (isGiveAway) {
          p.quantity = event.product.quantity;
          p.isMaxGiveawayAdded = event.product.isMaxGiveawayAdded;
          if (event.product.quantity! < event.product.giveAwayCounts!) {
            p.isMaxGiveawayAdded = null;
            event.product.isMaxGiveawayAdded = null;
          }
        }
      }
    }
    add(const TriggerArrangeDataForSummary());
    emit(state.copyWith(
        needsGiveaway: needs,
        products: products,
        message: AppStrings.global_empty_string,
        isRefreshedRequired: false,
        isFailure: false));

  }

  FutureOr<void> _onTriggerCheckIfApplyActive(
      TriggerCheckIfApplyActive event, Emitter<PurchaseWithInitialState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshedRequired: true,
        isFailure: false));
    emit(state.copyWith(
        isApplyButtonActive: state.couponEditingController.text.isNotEmpty,
        isRefreshedRequired: false));
  }

  FutureOr<void> _onTriggerRemoveItems(
      TriggerRemoveItems event, Emitter<PurchaseWithInitialState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshedRequired: true,
        isFailure: false));
    emit(state.copyWith(
        selectedProducts: [],
        totalWithTransactionWithCouponFee: 0,
        totalWithTransactionWithoutCouponFee: 0,
        registrationForSummary: [],
        message: AppStrings.global_empty_string,
        isRefreshedRequired: false,
        isFailure: false));
  }

  FutureOr<void> _onTriggerCheckForMandatory(
      TriggerCheckForMandatory event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    List<Products> allProducts = List.from(state.products);
    for (int i = 0; i < allProducts.length; i++) {
      allProducts[i].dropDownKeyForProduct = GlobalKey<State<StatefulWidget>>();
      print(
          'allProducts: ${allProducts[i].underscoreId} ${allProducts[i].productDetails?.title}-${allProducts[i].dropDownKeyForProduct}');
    }
    bool isProductGiveAwayMandatory = allProducts
        .any((element) => element.productDetails?.isGiveawayMandatory ?? false);
    bool willRegister = false;


    debugPrint('isProductGiveAwayMandatory: $isProductGiveAwayMandatory');
    if(state.couponModule == CouponModules.registration){
      if (isProductGiveAwayMandatory) {
        List<Products> mandatoryOnes = [];

        for (Products product in allProducts) {
          if (product.productDetails?.isGiveawayMandatory == true) {
            Products productM = Products(
                id: product.id,
                underscoreId: product.underscoreId,
                productDetails: product.productDetails,
                quantity: product.quantity,
                giveAwayCounts: product.giveAwayCounts,
                selectedVariant: product.selectedVariant,
                isMaxGiveawayAdded: product.isMaxGiveawayAdded,
                availableGiveaways: product.availableGiveaways,
                eventId: product.eventId,
                totalPrice: product.totalPrice,
                category: product.category,
                createdAt: product.createdAt,
                endDate: product.endDate,
                externalUrl: product.externalUrl,
                image: product.image,
                isAddedToCart: product.isAddedToCart,
                isGiveaway: product.isGiveaway,
                isGiveawayAdded: product.isGiveawayAdded,
                isOpen: product.isOpen,
                price: product.price,
                purchasedVariant: product.purchasedVariant,
                qrProductTitle: product.qrProductTitle,
                restrictions: product.restrictions,
                seasonId: product.seasonId,
                updatedAt: product.updatedAt,
                variants: product.variants); // Deep copy of the product
            mandatoryOnes.add(productM);
          }
        }
        for (int i = 0; i < mandatoryOnes.length; i++) {
          mandatoryOnes[i].dropDownKeyForProduct =
              GlobalKey<State<StatefulWidget>>();
          print(
              'mandatoryOnes:${mandatoryOnes[i].underscoreId} ${mandatoryOnes[i].productDetails?.title}- ${mandatoryOnes[i].dropDownKeyForProduct}');
        }

        List<Products> selectedProducts = state.selectedProducts
            .where((element) =>
            mandatoryOnes.any((p) => p.underscoreId == element.underscoreId))
            .toList();
        if (selectedProducts.isNotEmpty) {
          bool isQuantityNotEqualToMaxCounts = selectedProducts.every((element) {
            if (element.variants != null && element.variants!.isNotEmpty) {
              num totalQuantity = 0;
              bool isGiveawayMandatory = element.productDetails?.isGiveawayMandatory ?? false;
              if(isGiveawayMandatory){
                totalQuantity = selectedProducts
                    .where((p) => p.underscoreId == element.underscoreId)
                    .fold(0, (sum, p) => sum + (p.quantity ?? 0));
                debugPrint('total: $totalQuantity ${element.giveAwayCounts}');
              }
              // selectedProducts
              //     .where((p) => p.underscoreId == element.underscoreId)
              //     .fold(0, (sum, p) => sum + (p.quantity ?? 0));

              return totalQuantity < element.giveAwayCounts!;
            } else {
              debugPrint('quantity: ${element.quantity} ${element.giveAwayCounts}');
              return element.quantity! < element.giveAwayCounts!;
            }
          });
          print('***');
          print(isQuantityNotEqualToMaxCounts);
          if (isQuantityNotEqualToMaxCounts) {
            willRegister = false;
            List<Products> needsUpdate = mandatoryOnes.where((element) {
              if (element.variants != null && element.variants!.isNotEmpty) {
                num totalQuantity = selectedProducts
                    .where((p) => p.underscoreId == element.underscoreId)
                    .fold(0, (sum, p) => sum + (p.quantity ?? 0));
                return totalQuantity != element.giveAwayCounts;
              } else {
                return element.quantity != element.giveAwayCounts;
              }
            }).toList();
            emit(state.copyWith(
                products: allProducts,
                needsGiveaway: needsUpdate,
                willRegister: willRegister,
                isRefreshedRequired: false,
                message: AppStrings.global_empty_string));
            add(TriggerOpenMBSFORGiveAway());
          } else {
            willRegister = true;
            emit(state.copyWith(
                willRegister: willRegister,
                isRefreshedRequired: false,
                message: AppStrings.global_empty_string));
            add(TriggerPurchaseEvent(
              couponModule: state.couponModule,
            ));
          }
        }
        else {
          willRegister = false;
          emit(state.copyWith(
              products: allProducts,
              willRegister: willRegister,
              needsGiveaway: mandatoryOnes,
              isRefreshedRequired: false,
              message: AppStrings.global_empty_string));
          add(TriggerOpenMBSFORGiveAway());
        }
      }
      else {
        willRegister = true;
        emit(state.copyWith(
            willRegister: willRegister,
            isRefreshedRequired: false,
            message: AppStrings.global_empty_string));
        add(TriggerPurchaseEvent(
          couponModule: state.couponModule,
        ));
      }
    }
    else{
      bool isProductGiveAwayAccountMandatory = allProducts
          .any((element) {
        return (element.productDetails?.isGiveawayMandatory == true &&
            element.productDetails?.giveAwayType == 'account' && element.giveAwayCounts !=0);
      });
      if(isProductGiveAwayAccountMandatory){
        List<Products> mandatoryOnes = [];

        for (Products product in allProducts) {
          if (product.productDetails?.isGiveawayMandatory == true &&
          product.productDetails?.giveAwayType == 'account'  && product.giveAwayCounts !=0) {
            Products productM = Products(
                id: product.id,
                underscoreId: product.underscoreId,
                productDetails: product.productDetails,
                quantity: product.quantity,
                giveAwayCounts: product.giveAwayCounts,
                selectedVariant: product.selectedVariant,
                isMaxGiveawayAdded: product.isMaxGiveawayAdded,
                availableGiveaways: product.availableGiveaways,
                eventId: product.eventId,
                totalPrice: product.totalPrice,
                category: product.category,
                createdAt: product.createdAt,
                endDate: product.endDate,
                externalUrl: product.externalUrl,
                image: product.image,
                isAddedToCart: product.isAddedToCart,
                isGiveaway: product.isGiveaway,
                isGiveawayAdded: product.isGiveawayAdded,
                isOpen: product.isOpen,
                price: product.price,
                purchasedVariant: product.purchasedVariant,
                qrProductTitle: product.qrProductTitle,
                restrictions: product.restrictions,
                seasonId: product.seasonId,
                updatedAt: product.updatedAt,
                variants: product.variants); // Deep copy of the product
            mandatoryOnes.add(productM);
          }

        }
        for (int i = 0; i < mandatoryOnes.length; i++) {
          mandatoryOnes[i].dropDownKeyForProduct =
              GlobalKey<State<StatefulWidget>>();
          print(
              'mandatoryOnes:${mandatoryOnes[i].underscoreId} ${mandatoryOnes[i].productDetails?.title}- ${mandatoryOnes[i].dropDownKeyForProduct}');
        }

        List<Products> selectedProducts = state.selectedProducts
            .where((element) =>
            mandatoryOnes.any((p) => p.underscoreId == element.underscoreId))
            .toList();
        if (selectedProducts.isNotEmpty) {
          bool isQuantityNotEqualToMaxCounts = selectedProducts.every((element) {
            if (element.variants != null && element.variants!.isNotEmpty) {
              num totalQuantity = selectedProducts
                  .where((p) => p.underscoreId == element.underscoreId)
                  .fold(0, (sum, p) => sum + (p.quantity ?? 0));
              return totalQuantity != element.giveAwayCounts;
            } else {
              return element.quantity != element.giveAwayCounts;
            }
          });
          print('***');
          print(isQuantityNotEqualToMaxCounts);
          if (isQuantityNotEqualToMaxCounts) {
            willRegister = false;
            List<Products> needsUpdate = mandatoryOnes.where((element) {
              if (element.variants != null && element.variants!.isNotEmpty) {
                num totalQuantity = selectedProducts
                    .where((p) => p.underscoreId == element.underscoreId)
                    .fold(0, (sum, p) => sum + (p.quantity ?? 0));
                return totalQuantity != element.giveAwayCounts;
              } else {
                return element.quantity != element.giveAwayCounts;
              }
            }).toList();
            emit(state.copyWith(
                products: allProducts,
                needsGiveaway: needsUpdate,
                willRegister: willRegister,
                isRefreshedRequired: false,
                message: AppStrings.global_empty_string));
            add(TriggerOpenMBSFORGiveAway());
          } else {
            willRegister = true;
            emit(state.copyWith(
                willRegister: willRegister,
                isRefreshedRequired: false,
                message: AppStrings.global_empty_string));
            add(TriggerPurchaseEvent(
              couponModule: state.couponModule,
            ));
          }
        } else {

          willRegister = false;
          emit(state.copyWith(
              products: allProducts,
              willRegister: willRegister,
              needsGiveaway: mandatoryOnes,
              isRefreshedRequired: false,
              message: AppStrings.global_empty_string));
          add(TriggerOpenMBSFORGiveAway());
        }
      }
      else {
        willRegister = true;
        emit(state.copyWith(
            willRegister: willRegister,
            isRefreshedRequired: false,
            message: AppStrings.global_empty_string));
        add(TriggerPurchaseEvent(
          couponModule: state.couponModule,
        ));
      }
    }

  }

  FutureOr<void> _onTriggerOpenMBSFORGiveAway(
      TriggerOpenMBSFORGiveAway event, Emitter<PurchaseWithInitialState> emit) {
    PurchaseHandlers.emitRefreshState(emit: emit, state: state);
    Navigator.pop(navigatorKey.currentContext!);
    buildCustomShowModalBottomSheetParent(
        ctx: navigatorKey.currentContext!,
        isNavigationRequired: false,
        // isDismissible: false,
        // isEnableDrag: false,
        child: BlocBuilder<PurchaseBloc, PurchaseWithInitialState>(
          builder: (context, state) {
            return customBottomSheetBasicBody(
                context: navigatorKey.currentContext!,
                title: 'Select Giveaway Product',
                footerNote:
                    'This event includes a giveaway for every participating athlete, that you must add to your shopping cart. Add it to continue:',
                isSubtitleAsFooter: false,
                isSingeButtonPresent: true,
                isButtonPresent: true,
                isActive: state.willRegister,
                highLightedAthleteName: AppStrings.global_empty_string,
                isSingleButtonColorFilled: true,
                leftButtonText: AppStrings.global_empty_string,
                rightButtonText: AppStrings.global_empty_string,
                onLeftButtonPressed: () {},
                onRightButtonPressed: () {},
                singleButtonText: AppStrings.btn_continue,
                afterHighlighterPortionIntitle: AppStrings.global_empty_string,
                singleButtonFunction: state.willRegister
                    ? () {
                        Navigator.pop(navigatorKey.currentContext!);
                        openCheckoutMBS(navigatorKey.currentContext!);
                      }
                    : () {},
                highLightedString: AppStrings.global_empty_string,
                isAccentedHighlight: false,
                isFooterNoteCentered: false,
                isHighlightedTextBold: false,
                widget: Column(
                  children: [
                    Container(
                      // color: Colors.amber,
                      height: state.needsGiveaway.length == 1? Dimensions.getScreenHeight()*0.25:
                      Dimensions.getScreenHeight()*0.5,
                      child: ListView.separated(
                        // shrinkWrap: true,
                        itemCount: state.needsGiveaway.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemBuilder: (context, index) {
                          debugPrint(
                              'mandatory ${state.needsGiveaway[index].productDetails?.title} ${state.needsGiveaway[index].dropDownKeyForProduct} ');
                          return Column(
                            children: [
                              SizedBox(
                                width: Dimensions.getScreenWidth(),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    if (state.needsGiveaway[index].quantity! <
                                        state
                                            .needsGiveaway[index].giveAwayCounts!)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.colorPrimaryAccent,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            '${state.needsGiveaway[index].giveAwayCounts! - state.needsGiveaway[index].quantity!} more required',
                                            style: AppTextStyles.normalPrimary(
                                                isOutfit: false)),
                                      )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              UpdatedProductWidget(
                                isInsideBottomSheet: true,
                                context: context,
                                onChanged: (val) {
                                  BlocProvider.of<RegisterAndSellBloc>(context)
                                      .add(TriggerSelectVariant(
                                          isFromMBS: true,
                                          selectedValue: val,
                                          index: index,
                                          product: state.needsGiveaway));
                                },
                                products: state.needsGiveaway[index],
                                onMenuStateChange: (isOpen) {
                                  BlocProvider.of<PurchaseBloc>(context).add(
                                      TriggerOpenDropDownP(
                                          isAthlete: false,
                                          isOpened: isOpen ?? false));
                                },
                                add: () {
                                  BlocProvider.of<PurchaseBloc>(context).add(
                                      TriggerAddSelectedProductToCartP(
                                          product: state.needsGiveaway[index]));
                                },
                                selectedValueProduct:
                                    state.needsGiveaway[index].selectedVariant,
                                dropDownKeyForProducts: state
                                    .needsGiveaway[index].dropDownKeyForProduct!,
                                isProductDropDownOpened:
                                    state.isProductDropDownOpened,
                                reduce: () {
                                  BlocProvider.of<PurchaseBloc>(context).add(
                                      TriggerChangeProductQuantityP(
                                          isFromMBS: true,
                                          isMinus: true,
                                          index: index,
                                          quantity: state
                                              .needsGiveaway[index].quantity!,
                                          product: state.needsGiveaway));
                                },
                                increase: () {
                                  BlocProvider.of<PurchaseBloc>(context).add(
                                      TriggerChangeProductQuantityP(
                                          isFromMBS: true,
                                          isMinus: false,
                                          index: index,
                                          quantity: state
                                              .needsGiveaway[index].quantity!,
                                          product: state.needsGiveaway));
                                },
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ));
          },
        ));
  }
}

bool isContinueButtonActiveFunction(
    {required List<Products> allProds, required List<Products> selectedProds}) {
  bool isContinueButtonActive = true;
  for (Products product in allProds) {
    if (product.productDetails!.isGiveawayMandatory!) {
      String pId = product.productDetails!.id!;
      bool isProductSelected =
          !(selectedProds.any((e) => (e.productDetails!.id == pId)));
      if (!isProductSelected) {
        isContinueButtonActive = false;
        break;
      } else {
        isContinueButtonActive = product.quantity! == product.giveAwayCounts;
      }
    }
  }
  return isContinueButtonActive;
}

Future<List<Products>> processProducts(
    List<Products> selectedProducts, Products product) async {
  return await compute(_processProducts,
      {'selectedProducts': selectedProducts, 'product': product});
}

// List<Products> _processProducts(Map<String, dynamic> params) {
//   List<Products> products = List.from(params['selectedProducts']);
//   Products product = params['product'];
//
//   if (products.isEmpty) {
//     products.add(product);
//   }
//   else {
//     bool productAdded = false;
//     for (var i = 0; i < products.length; i++) {
//       if (products[i].underscoreId == product.underscoreId) {
//         List<String> variant = product.variants ?? [];
//         bool isGiveaway = product.productDetails?.isGiveaway ?? false;
//         if (isGiveaway) {
//           product.giveAwayCounts =
//               product.giveAwayCounts ?? product.availableGiveaways;
//           if (variant.isNotEmpty) {
//             bool hasSameVariant = products.any((element) =>
//             element.selectedVariant == product.selectedVariant);
//             if (hasSameVariant) {
//               Products theProduct = products.firstWhere((element) =>
//               element.selectedVariant == product.selectedVariant);
//               if (theProduct.quantity! < product.giveAwayCounts!) {
//                 products[i].quantity =
//                     product.quantity! + products[i].quantity!;
//                 if (products[i].quantity! == product.giveAwayCounts) {
//                   products[i].quantity = product.giveAwayCounts;
//                 }
//               } else {
//                 products[i].quantity = product.giveAwayCounts;
//               }
//             }
//             else {
//               if (products[i].quantity! < product.giveAwayCounts!) {
//                 num total = products[i].quantity! + product.quantity!;
//                 if (total > product.giveAwayCounts!) {
//                   products[i].isMaxGiveawayAdded = true;
//                   product.isMaxGiveawayAdded = true;
//                 }else{
//                   if(total == product.giveAwayCounts!){
//                     products[i].isMaxGiveawayAdded = true;
//                     product.isMaxGiveawayAdded = true;
//                     products.add(product);
//                   }else{
//                     products.add(product);
//                   }
//                 }
//               } else {
//                 products[i].quantity = product.giveAwayCounts;
//                 products[i].isMaxGiveawayAdded = true;
//                 product.isMaxGiveawayAdded = true;
//               }
//
//             }
//           }
//           else {
//             if (products[i].quantity! < product.giveAwayCounts!) {
//               products[i].quantity = product.quantity! + products[i].quantity!;
//               if (products[i].quantity! == product.giveAwayCounts) {
//                 products[i].quantity = product.giveAwayCounts;
//               }
//             } else {
//               products[i].quantity = product.giveAwayCounts;
//             }
//           }
//         }
//         else {
//           if (variant.isNotEmpty) {
//             bool hasSameVariant = products.any((element) =>
//             element.selectedVariant == product.selectedVariant);
//             if (hasSameVariant) {
//               Products theProduct = products.firstWhere((element) =>
//               element.selectedVariant == product.selectedVariant);
//               debugPrint('The Product ${theProduct.quantity}');
//               debugPrint('The Product X ${product.quantity}');
//               if (theProduct.productDetails!.isGiveaway!) {
//                 //products[i].quantity = product.quantity!;
//                 theProduct.giveAwayCounts =
//                     theProduct.giveAwayCounts ?? theProduct.availableGiveaways;
//
//                 if (theProduct.quantity! > product.giveAwayCounts!) {
//                   // product.isGiveawayAdded = true;
//                   // products[i].isGiveawayAdded = true;
//                 } else {
//                   theProduct.quantity =
//                       product.quantity! + theProduct.quantity!;
//                   if (theProduct.quantity! >=
//                       (product.giveAwayCounts ?? product.availableGiveaways!)) {
//                     theProduct.quantity =
//                         product.giveAwayCounts ?? product.availableGiveaways;
//                     print('-**%***---${theProduct.quantity}');
//                   }
//                 }
//               } else {
//                 theProduct.quantity = product.quantity! + theProduct.quantity!;
//               }
//             } else {
//               products.add(product);
//             }
//           } else {
//             products.add(product);
//           }
//         }
//
//         // else {
//         //   if (products[i].productDetails!.isGiveaway!) {
//         //     //products[i].quantity = product.quantity!;
//         //     product.giveAwayCounts =
//         //         product.giveAwayCounts ?? product.availableGiveaways;
//         //
//         //     if (products[i].quantity! > product.giveAwayCounts!) {
//         //       // product.isGiveawayAdded = true;
//         //       // products[i].isGiveawayAdded = true;
//         //     } else {
//         //       products[i].quantity = product.quantity! + products[i].quantity!;
//         //       if (products[i].quantity! >=
//         //           (product.giveAwayCounts ?? product.availableGiveaways!)) {
//         //         products[i].quantity =
//         //             product.giveAwayCounts ?? product.availableGiveaways;
//         //         print('-*****---${products[i].quantity}');
//         //       }
//         //     }
//         //   } else {
//         //     products[i].quantity = product.quantity! + products[i].quantity!;
//         //   }
//         // }
//         productAdded = true;
//         break;
//       }
//     }
//     if (!productAdded) {
//       products.add(product);
//     }
//   }
//   return products;
// }
List<Products> _processProducts(Map<String, dynamic> params) {
  List<Products> products = List.from(params['selectedProducts']);
  Products product = params['product'];

  if (products.isEmpty) {
    bool isGiveAway = product.productDetails?.isGiveaway ?? false;
    if (isGiveAway) {
      product.giveAwayCounts =
          product.giveAwayCounts ?? product.availableGiveaways;
      if (product.giveAwayCounts == 0) {
        product.isMaxGiveawayAdded = true;
      } else {
        product.isMaxGiveawayAdded = null;
      }
      if ((product.quantity ?? 0) >= product.giveAwayCounts!) {
        product.quantity = product.giveAwayCounts;
        product.isMaxGiveawayAdded = true;
      }
    } else {
      product.isMaxGiveawayAdded = null;
    }

    products.add(product);
  }
  else {
    bool productAdded = false;

    // Calculate total quantity of all variants of the same product
    num totalQuantity = products
        .where((p) => p.underscoreId == product.underscoreId)
        .fold(0, (sum, p) => sum + (p.quantity ?? 0));

    for (var i = 0; i < products.length; i++) {
      if (products[i].underscoreId == product.underscoreId) {
        List<String> variant = product.variants ?? [];
        bool isGiveaway = product.productDetails?.isGiveaway ?? false;

        if (isGiveaway) {
          product.giveAwayCounts =
              product.giveAwayCounts ?? product.availableGiveaways;

          if (variant.isNotEmpty) {
            bool hasSameVariant = products.any((element) =>
                element.selectedVariant == product.selectedVariant);
            if (hasSameVariant) {
              Products theProduct = products.firstWhere((element) =>
                  element.selectedVariant == product.selectedVariant);

              // Update total quantity with the current variant's quantity
              totalQuantity += product.quantity!;
              num existingProductQuantity = 0;
              if (totalQuantity > product.giveAwayCounts!) {
                // Set isMaxGiveawayAdded for all variants
                for (var p in products.where((p) =>
                    (p.underscoreId == product.underscoreId &&
                        p.selectedVariant != product.selectedVariant))) {
                  existingProductQuantity = p.quantity!;
                }
                theProduct.isMaxGiveawayAdded = true;
                theProduct.quantity =
                    (product.giveAwayCounts! - existingProductQuantity <= 0
                        ? product.giveAwayCounts!
                        : product.giveAwayCounts! - existingProductQuantity);
                product.isMaxGiveawayAdded = true;
              } else {
                theProduct.quantity = product.quantity! + theProduct.quantity!;
                if (totalQuantity == product.giveAwayCounts!) {
                  for (var p in products
                      .where((p) => p.underscoreId == product.underscoreId)) {
                    p.isMaxGiveawayAdded = true;
                  }
                  theProduct.isMaxGiveawayAdded = true;
                  theProduct.quantity = product.giveAwayCounts;
                }
              }
            }
            else {
              // Add new variant and update total quantity
              totalQuantity += product.quantity!;
              if (totalQuantity > product.giveAwayCounts!) {
                num existingProductQuantity = 0;
                for (var p in products
                    .where((p) => p.underscoreId == product.underscoreId)) {
                  p.isMaxGiveawayAdded = true;
                  existingProductQuantity = p.quantity!;
                }

                product.isMaxGiveawayAdded = true;
                product.quantity =
                    (product.giveAwayCounts! - existingProductQuantity <= 0
                        ? product.giveAwayCounts!
                        : product.giveAwayCounts! - existingProductQuantity);
                products.add(product);
              }
              else {
                if (totalQuantity == product.giveAwayCounts!) {
                  for (var p in products
                      .where((p) => p.underscoreId == product.underscoreId)) {
                    p.isMaxGiveawayAdded = true;
                  }
                  product.isMaxGiveawayAdded = true;
                }

                products.add(product);
              }

              print('different variant logic');
              print('different variant logic');
              print('${product.quantity} logic');
              print('${products[i].quantity} logic');
              print('${product.isMaxGiveawayAdded} logic');
              print('${product.giveAwayCounts} logic');
              print('${products[i].isMaxGiveawayAdded} logic');
            }
          }
          else {
            // No variants, handle as a single product
            totalQuantity += product.quantity!;
            if (totalQuantity > product.giveAwayCounts!) {
              for (var p in products
                  .where((p) => p.underscoreId == product.underscoreId)) {
                p.isMaxGiveawayAdded = true;
              }
              product.isMaxGiveawayAdded = true;
            } else {
              products[i].quantity = product.quantity! + products[i].quantity!;
              if (totalQuantity == product.giveAwayCounts!) {
                for (var p in products
                    .where((p) => p.underscoreId == product.underscoreId)) {
                  p.isMaxGiveawayAdded = true;
                }
                product.isMaxGiveawayAdded = true;
              }
            }
          }
        } else {
          // Non-giveaway product logic
          if (variant.isNotEmpty) {
            bool hasSameVariant = products.any((element) =>
                element.selectedVariant == product.selectedVariant);
            if (hasSameVariant) {
              Products theProduct = products.firstWhere((element) =>
                  element.selectedVariant == product.selectedVariant);
              theProduct.quantity = product.quantity! + theProduct.quantity!;
            } else {
              products.add(product);
            }
          } else {
            products.add(product);
          }
        }

        productAdded = true;
        break;
      }
      else{
        bool isGiveAway = product.productDetails?.isGiveaway ?? false;
        if (isGiveAway) {
          product.giveAwayCounts =
              product.giveAwayCounts ?? product.availableGiveaways;
          if (product.giveAwayCounts == 0) {
            product.isMaxGiveawayAdded = true;
          } else {
            product.isMaxGiveawayAdded = null;
          }
          if ((product.quantity ?? 0) >= product.giveAwayCounts!) {
            product.quantity = product.giveAwayCounts;
            product.isMaxGiveawayAdded = true;
          }
        }
        else {
          product.isMaxGiveawayAdded = null;
        }
      }
    }

    if (!productAdded) {
      products.add(product);
    }
  }

  return products;
}
