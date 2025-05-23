import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/models/request_models/employee_checkout_request_model.dart';
import 'package:rmnevents/data/models/response_models/stripe_readers_response_model.dart';
import 'package:rmnevents/data/repository/register_and_sell_repository.dart';
import 'package:rmnevents/di/di.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';
import 'package:rmnevents/presentation/home/staff_home_bloc/staff_home_bloc.dart';
import 'package:rmnevents/presentation/register_and_sell/widgets/show_payment_success_dialog.dart';
import 'package:rmnevents/root_app.dart';

import '../../../data/models/response_models/purchase_socket_response_model.dart';
import '../../../data/repository/coupon_details_repository.dart';
import '../../../data/repository/download_pdf_repository.dart';
import '../../../data/repository/staff_event_repository.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../services/shared_preferences_services/athlete_cached_data.dart';
import '../../base/bloc/base_bloc.dart';
import '../../create_edit_profile/bloc/create_edit_profile_bloc.dart';
import '../../purchase/bloc/purchase_handlers.dart';
import '../../purchase/page/client_registration_view.dart';
import '../../purchase/widgets/updated_product_widget.dart';
import '../../selected_customer/bloc/selected_customer_bloc.dart';
import '../view/register_and_sell_view.dart';

part 'register_and_sell_event.dart';

part 'register_and_sell_state.dart';

part 'register_and_sell_bloc.freezed.dart';

class RegisterAndSellBloc
    extends Bloc<RegisterAndSellEvent, RegisterAndSellState> {
  RegisterAndSellBloc() : super(RegisterAndSellState.initial()) {
    on<TriggerToCheckSaveButtonStatus>(_onTriggerToCheckSaveButtonStatus);
    on<TriggerRegenerateAthleteListAfterDeletion>(
        _onTriggerRegenerateAthleteListAfterDeletion);
    on<TriggerSaveAndContinue>(_onTriggerSaveAndContinue);
    on<TriggerMakeItAtToCart>(_onTriggerMakeItAtToCart);
    on<TriggerClickGoogleCity>(_onTriggerClickGoogleCity);
    on<TriggerRetrieveGoogleCityInfo>(_onTriggerRetrieveGoogleCityInfo);
    on<TriggerFormExpansion>(_onTriggerFormExpansion);
    on<TriggerInitialize>(_onTriggerInitialize);
    on<TriggerGenerateAthleteList>(_onTriggerGenerateAthleteList);
    on<TriggerRemoveAthlete>(_onTriggerRemoveAthlete);
    on<TriggerSwitchTab>(_onTriggerSwitchTab);
    on<TriggerRemoveAllItems>(_onTriggerRemoveAllItems);
    on<TriggerUpdateProductUI>(_onTriggerUpdateProductUI);
    on<TriggerRemoveCoupon>(_onTriggerRemoveCoupon);
    on<TriggerFetchEmployeeEventDetails>(_onTriggerFetchEmployeeEventDetails);
    on<TriggerAddToCart>(_onTriggerAddToCart);
    on<TriggerInteractWithContactField>(_onTriggerInteractWithContactField);
    on<TriggerRefreshRegistrationAndSellForm>(
        _onTriggerRefreshRegistrationAndSellForm);
    on<TriggerCheckOut>(_onTriggerCheckOut);
    on<TriggerSuccessDialog>(_onTriggerSuccessDialog);
    on<TriggerPurchaseFail>(_onTriggerPurchaseFail);
    on<TriggerDownloadPdf>(_onTriggerDownloadPdf);
    on<TriggerChangeCartQuantity>(_onTriggerChangeCartQuantity);
    on<TriggerCancelPurchase>(_onTriggerCancelPurchase);
    on<TriggerOnClickOfBack>(_onTriggerClickOfBack);
    on<TriggerFetchCustomerAthletes>(_onTriggerFetchCustomerAthletes);
    on<TriggerCheckMandatoryT>(_onTriggerCheckMandatory);
    on<TriggerOpenMBSFORGiveAwayT>(_onTriggerOpenMBSFORGiveAway);
    on<TriggerChangeProductQuantity>(_onTriggerChangeProductQuantity);
    on<TriggerSelectVariant>(_onTriggerSelectVariant);
    on<TriggerOpenDropDown>(_onTriggerOpenDropDown);
    on<TriggerChangeProductCartQuantity>(_onTriggerChangeProductCartQuantity);
    on<TriggerAddSelectedProductToCart>(_onTriggerAddSelectedProductToCart);
    on<TriggerArrangeDataForSummaryT>(_onTriggerArrangeDataForSummaryT);
    on<TriggerCouponApplicationT>(_onTriggerCouponApplicationT);
    on<TriggerCouponRemovalT>(_onTriggerCouponRemovalT);
    on<TriggerCheckIfApplyActiveT>(_onTriggerCheckIfApplyActiveT);
    on<TriggerRemoveItemsT>(_oonTriggerRemoveItemsT);
  }

  FutureOr<void> _onTriggerToCheckSaveButtonStatus(
      TriggerToCheckSaveButtonStatus event,
      Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isFailure: false));

    bool isFormFilled = TextFieldValidators.validateName(
                value: state.firstNameController.text,
                nameTypes: NameTypes.firstName) ==
            null &&
        TextFieldValidators.validateName(
                value: state.lastNameController.text,
                nameTypes: NameTypes.lastName) ==
            null &&
        TextFieldValidators.validateEmail(state.emailController.text) == null &&
        TextFieldValidators.validatePostalAddress(
                city: state.city,
                address: state.postalAddressController.text) ==
            null &&
        TextFieldValidators.validateZip(value: state.zipCodeController.text) ==
            null;
    emit(state.copyWith(
      isFormFilled: isFormFilled,
      isRefreshRequired: false,
    ));
  }

  FutureOr<void> _onTriggerSaveAndContinue(
      TriggerSaveAndContinue event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isFailure: false));
    if (!state.isButtonLabelledSaved) {
      emit(state.copyWith(isButtonLabelledSaved: true));
      List<Athlete> athletes = [];
      List<String> createdProfileModules =
          instance<AthleteCachedData>().getAthleteListJson() ?? [];

      if (createdProfileModules.isNotEmpty) {
        List<CreateProfileRequestModel> profiles = createdProfileModules
            .map((athleteJson) =>
                CreateProfileRequestModel.fromJson(jsonDecode(athleteJson)))
            .toList();
        athletes = profiles.map((profile) {
          debugPrint('Create ${profile.birthDate}');
          return Athlete(
            firstName: profile.firstName,
            lastName: profile.lastName,
            email: profile.email,
            birthDate: profile.birthDate,
            age: DateTime.now().year -
                num.parse(profile.birthDate.split('/').first),
            weight: profile.weight,
            weightClass: profile.weight,
            phoneNumber: num.parse(profile.contactNumber),
            city: profile.city,
            state: profile.stateName,
            uniqueId: profile.athleteId,
            pincode: num.parse(profile.zipCode),
            mailingAddress: profile.address,
            team: Team(
                name: profile.teamId.isNotEmpty
                    ? globalTeams.firstWhere((e) => e.id == profile.teamId).name
                    : AppStrings.global_empty_string,
                id: profile.teamId),
            gender: profile.gender,
            grade: profile.gradeValue,
            isRedshirt: profile.isRedshirt,
            underscoreId: profile.athleteId,
            id: profile.athleteId,
            fileImage: profile.profileImage,
            teamId: profile.teamId,
            selectedGrade: GradeData(
                name: profile.gradeValue.isNotEmpty
                    ? globalGrades
                        .firstWhere((e) => e.value == profile.gradeValue)
                        .name
                    : AppStrings.global_empty_string,
                value: profile.gradeValue),
          );
        }).toList();
      }
      emit(state.copyWith(
          athletes: athletes,
          isRefreshRequired: false,
          message: AppStrings.global_empty_string));
    }
    emit(state.copyWith(isFormExpanded: false, isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerClickGoogleCity(
      TriggerClickGoogleCity event, Emitter<RegisterAndSellState> emit) {
    BlocProvider.of<CreateEditProfileBloc>(navigatorKey.currentContext!).add(
      TriggerFetchPlaceDetails(
          prediction: event.item, isFromRegisterAndSell: true),
    );
  }

  FutureOr<void> _onTriggerRetrieveGoogleCityInfo(
      TriggerRetrieveGoogleCityInfo event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isFailure: false));
    String city =
        navigatorKey.currentContext!.read<CreateEditProfileBloc>().state.city;
    String zipCode = navigatorKey.currentContext!
        .read<CreateEditProfileBloc>()
        .state
        .zipCodeEditingController
        .text;
    String address = navigatorKey.currentContext!
        .read<CreateEditProfileBloc>()
        .state
        .postalAddressEditingController
        .text;
    String stateName =
        navigatorKey.currentContext!.read<CreateEditProfileBloc>().state.state;
    emit(state.copyWith(
      isRefreshRequired: false,
      city: city,
      zipCodeController: TextEditingController(text: zipCode),
      postalAddressController: TextEditingController(text: address),
      stateName: stateName,
    ));
    add(TriggerToCheckSaveButtonStatus());
  }

  FutureOr<void> _onTriggerFormExpansion(
      TriggerFormExpansion event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isFailure: false));
    emit(state.copyWith(isFormExpanded: true, isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerInitialize(
      TriggerInitialize event, Emitter<RegisterAndSellState> emit) {
    emit(RegisterAndSellState.initial());

    if (event.isInit) {
      bool? isFromOnBehalf = navigatorKey.currentContext!
          .read<SelectedCustomerBloc>()
          .state
          .isFromOnBehalf;
      emit(state.copyWith(isFromOnBehalf: isFromOnBehalf));
      emit(state.copyWith(
        isStaffRegistration: true,
      ));
      if (isFromOnBehalf != null) {
        add(TriggerFetchCustomerAthletes());
      }
    }
  }

  FutureOr<void> _onTriggerGenerateAthleteList(
      TriggerGenerateAthleteList event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(isRefreshRequired: true, isFailure: false));

    List<Athlete> athletes = List.from(state.athletes);
    for (Athlete athlete in athletes) {
      if (athlete.underscoreId == event.athlete.underscoreId) {
        athletes.remove(athlete);
        break;
      }
    }

    athletes.add(event.athlete);
    // if(state.isFromOnBehalf != null){
    //   List<Products> products = List.from(state.products);
    //   for (Products product in products) {
    //     if(product.productDetails!.isGiveaway!) {
    //       product.giveAwayCounts = product.giveAwayCounts! + product.availableGiveaways!;
    //     }
    //   }
    // }
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        athletes: athletes,
        isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerRemoveAthlete(
      TriggerRemoveAthlete event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(isRefreshRequired: true, isFailure: false));
    instance<AthleteCachedData>().removeAthleteFromList(event.athleteId);
    List<String> createdProfileModules =
        instance<AthleteCachedData>().getAthleteListJson() ?? [];

    List<Athlete> athletes = List.from(state.athletes);
    List<Athlete> selectedAthletes = List.from(state.selectedAthletes);

    selectedAthletes
        .removeWhere((element) => element.underscoreId == event.athleteId);
    athletes.removeWhere((element) => element.underscoreId == event.athleteId);

    // if (createdProfileModules.isNotEmpty) {
    //   List<CreateProfileRequestModel> profiles = createdProfileModules
    //       .map((athleteJson) =>
    //           CreateProfileRequestModel.fromJson(jsonDecode(athleteJson)))
    //       .toList();
    //   athletes = profiles.map((profile) {
    //     debugPrint('Create ${profile.gradeValue}');
    //     return Athlete(
    //       firstName: profile.firstName,
    //       lastName: profile.lastName,
    //       email: profile.email,
    //       birthDate: profile.birthDate,
    //       age: DateTime.now().year -
    //           num.parse(profile.birthDate.split('/').first),
    //       weight: profile.weight,
    //       weightClass: profile.weight,
    //       phoneNumber: num.parse(profile.contactNumber),
    //       city: profile.city,
    //       state: profile.stateName,
    //       pincode: num.parse(profile.zipCode),
    //       mailingAddress: profile.address,
    //       team: Team(
    //           name: globalTeams.firstWhere((e) => e.id == profile.teamId).name,
    //           id: profile.teamId),
    //       gender: profile.gender,
    //       grade: profile.gradeValue,
    //       isRedshirt: profile.isRedshirt,
    //       underscoreId: profile.athleteId,
    //       id: profile.athleteId,
    //       uniqueId: profile.athleteId,
    //       fileImage: profile.profileImage,
    //       teamId: profile.teamId,
    //       selectedGrade: GradeData(
    //           name: profile.gradeValue.isNotEmpty
    //               ? globalGrades
    //                   .firstWhere((e) => e.value == profile.gradeValue)
    //                   .name
    //               : AppStrings.global_empty_string,
    //           value: profile.gradeValue),
    //     );
    //   }).toList();
    // }
    if (state.isFromOnBehalf != null) {
      for (Products p in state.products) {
        if (p.productDetails!.isGiveaway!) {
          debugPrint('giveAwayCounts: ${p.giveAwayCounts}');
          debugPrint('availableGiveaways: ${p.availableGiveaways}');
          p.giveAwayCounts = (p.giveAwayCounts! > p.availableGiveaways!)
              ? p.giveAwayCounts! - p.availableGiveaways!
              : 0;
          debugPrint('giveAwayCounts: ${p.giveAwayCounts}');
          if (p.quantity! >= p.giveAwayCounts!) {
            p.quantity = p.giveAwayCounts! < 0 ? 0 : p.giveAwayCounts!;
          }
        }
      }
      for (Products p in state.selectedProducts) {
        if (p.productDetails!.isGiveaway!) {
          debugPrint('giveAwayCounts: ${p.giveAwayCounts}');
          debugPrint('availableGiveaways: ${p.availableGiveaways}');
          p.giveAwayCounts = (p.giveAwayCounts! > p.availableGiveaways!)
              ? p.giveAwayCounts! - p.availableGiveaways!
              : 0;
          debugPrint('giveAwayCounts: ${p.giveAwayCounts}');
          if (p.quantity! >= p.giveAwayCounts!) {
            p.quantity = p.giveAwayCounts! < 0 ? 0 : p.giveAwayCounts!;
          }
        }
      }
    }

    emit(state.copyWith(
        athletes: athletes,
        selectedAthletes: selectedAthletes,
        isRefreshRequired: false,
        message: AppStrings.global_empty_string));
    List<DivisionTypes> divisionTypes = navigatorKey.currentContext!
        .read<EventDetailsBloc>()
        .state
        .divisionsTypes;
    if (divisionTypes.isNotEmpty) {
      for (int i = 0; i < divisionTypes.length; i++) {
        List<AgeGroups> ageGroups = divisionTypes[i].ageGroups!;
        for (int j = 0; j < ageGroups.length; j++) {
          List<Athlete> athletesList = ageGroups[j].expansionPanelAthlete!;
          List<Athlete> selected = ageGroups[j].selectedAthletes =
              ageGroups[j].selectedAthletes ?? [];
          List<Athlete> your = ageGroups[j].availableAthletes =
              ageGroups[j].selectedAthletes ?? [];
          for (int k = 0; k < athletesList.length; k++) {
            if (athletesList[k].underscoreId == event.athleteId) {
              ageGroups[j].expansionPanelAthlete!.removeAt(k);
            }
          }
          for (int k = 0; k < selected.length; k++) {
            if (selected[k].underscoreId == event.athleteId) {
              ageGroups[j].selectedAthletes!.removeAt(k);
            }
          }
          for (int k = 0; k < your.length; k++) {
            if (your[k].underscoreId == event.athleteId) {
              ageGroups[j].availableAthletes!.removeAt(k);
            }
          }
        }
      }
    }
  }

  FutureOr<void> _onTriggerSwitchTab(
      TriggerSwitchTab event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        selectedTabIndex: event.index,
        isFailure: false,
        isFromCancel: false));
    emit(state.copyWith(isRefreshRequired: false, isFromCancel: false));
  }

  FutureOr<void> _onTriggerFetchEmployeeEventDetails(
      TriggerFetchEmployeeEventDetails event,
      Emitter<RegisterAndSellState> emit) async {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isLoading: true,
        isFailure: false));
    try {
      final response =
          await StaffEventRepository.getStaffEventData(id: event.eventId);
      response.fold((failure) {
        emit(state.copyWith(
            message: failure.message, isLoading: false, isFailure: true));
      }, (data) {
        List<Products> products = data.responseData?.data?.products ?? [];
        if (products.isNotEmpty) {
          for (int i = 0; i < products.length; i++) {
            products[i].productDetails!.image =
                StringManipulation.combineStings(
                    prefix: data.responseData!.assetsUrl!,
                    suffix: products[i].productDetails!.image!);
            products[i].quantity = 0;
            products[i].isOpen = false;
            products[i].isAddedToCart = false;
            products[i].giveAwayCounts = products[i].availableGiveaways;
            if (products[i].giveAwayCounts == 0) {
              products[i].isMaxGiveawayAdded = true;
            } else {
              products[i].isMaxGiveawayAdded = null;
            }
            debugPrint(
                'giveAwayCountsgiveAwayCounts: ${products[i].giveAwayCounts}');
            data.responseData!.data!.products![i].variants =
                data.responseData?.data?.products?[i].variants ?? [];
            products[i].selectedVariant =
                data.responseData!.data!.products![i].variants!.isNotEmpty
                    ? data.responseData!.data!.products![i].variants!.first
                    : AppStrings.global_empty_string;
            products[i].dropDownKeyForProduct =
                GlobalKey<State<StatefulWidget>>();
          }
        }
        List<String> createdProfileModules =
            instance<AthleteCachedData>().getAthleteListJson() ?? [];

        List<Athlete> athletes = [];
        bool? isFromOnBehalf = navigatorKey.currentContext!
            .read<SelectedCustomerBloc>()
            .state
            .isFromOnBehalf;
        if (isFromOnBehalf != null) {
          athletes = state.athletes;
        } else {
          if (createdProfileModules.isNotEmpty) {
            List<CreateProfileRequestModel> profiles = createdProfileModules
                .map((athleteJson) =>
                    CreateProfileRequestModel.fromJson(jsonDecode(athleteJson)))
                .toList();
            athletes = profiles.map((profile) {
              debugPrint('bb ${profile.gradeValue}');
              return Athlete(
                firstName: profile.firstName,
                lastName: profile.lastName,
                email: profile.email,
                birthDate: profile.birthDate,
                age: DateTime.now().year -
                    num.parse(profile.birthDate.split('/').first),
                weight: profile.weight,
                weightClass: profile.weight,
                phoneNumber: num.parse(profile.contactNumber),
                city: profile.city,
                state: profile.stateName,
                pincode: num.parse(profile.zipCode),
                mailingAddress: profile.address,
                team: Team(
                    name: profile.teamId.isNotEmpty
                        ? globalTeams
                            .firstWhere((e) => e.id == profile.teamId)
                            .name
                        : AppStrings.global_empty_string,
                    id: profile.teamId),
                gender: profile.gender,
                grade: profile.gradeValue,
                isRedshirt: profile.isRedshirt,
                underscoreId: profile.athleteId,
                id: profile.athleteId,
                uniqueId: profile.athleteId,
                profileImage: profile.profileImage?.path,
                fileImage: profile.profileImage,
                teamId: profile.teamId,
                selectedGrade: GradeData(
                    name: profile.gradeValue.isNotEmpty
                        ? globalGrades
                            .firstWhere((e) => e.value == profile.gradeValue)
                            .name
                        : AppStrings.global_empty_string,
                    value: profile.gradeValue),
              );
            }).toList();
          }
        }

        emit(state.copyWith(
            message: AppStrings.global_empty_string,
            products: products,
            athletes: athletes,
            eventData: data.responseData?.data ?? EventData(),
            divisionTypes: data.responseData?.data?.divisionTypes ?? [],
            isLoading: false,
            isFailure: false));
        BlocProvider.of<EventDetailsBloc>(navigatorKey.currentContext!).add(
            TriggerGetDivisionForEmployee(
                divisionTypes: data.responseData?.data?.divisionTypes ?? []));
      });
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(), isLoading: false, isFailure: true));
    }
  }

  FutureOr<void> _onTriggerUpdateProductUI(
      TriggerUpdateProductUI event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isFailure: false));

    // debugPrint('Quantity Bloc ${event.products[event.index].quantity}');
    // num productSum = 0;
    // for (Products product in state.selectedProducts) {
    //   if (product.quantity! > 0) {
    //     productSum += product.quantity! * product.price!;
    //   }
    // }
    // List<Products> selectedProducts = List.from(state.selectedProducts);
    // if (selectedProducts.isNotEmpty) {
    //   selectedProducts.removeWhere((element) => element.quantity! == 0);
    // }
    // debugPrint('Selected Products ${selectedProducts.length}');
    //
    // num athleteSum = 0;
    // for (StaffCheckoutRegistrations registration in state.registrations) {
    //   athleteSum += registration.totalPrice;
    // }
    List<Products> products = List.from(state.products);
    for (int i = 0; i < products.length; i++) {
      if (products[i].underscoreId ==
          event.products[event.index].underscoreId) {
        products[i] = event.products[event.index];
        break;
      }
    }
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        products: products,
        // selectedProducts: selectedProducts,
        // athleteSum: athleteSum,
        // productSum: productSum,
        isRefreshRequired: false,
        isFailure: false));
  }

  // FutureOr<void> _onTriggerAddSelectedProduct(TriggerAddSelectedProduct event,
  //     Emitter<RegisterAndSellState> emit)
  // async {
  //   emit(state.copyWith(
  //       message: AppStrings.global_empty_string,
  //       isRefreshRequired: true,
  //       isFailure: false));
  //   if (event.product.productDetails!.isGiveaway!) {
  //     if (state.selectedProducts.isNotEmpty) {
  //       bool isProductPresent = state.selectedProducts.any((element) {
  //         debugPrint(
  //             '--Selected ${element.underscoreId} ${event.product.underscoreId}');
  //         return element.underscoreId == event.product.underscoreId;
  //       });
  //       if (isProductPresent) {
  //         Products selectedProduct =
  //             state.selectedProducts.firstWhere((element) {
  //           debugPrint(
  //               '--Selected ${element.underscoreId} ${event.product.underscoreId}');
  //           return element.underscoreId == event.product.underscoreId;
  //         });
  //         if (selectedProduct.quantity ==
  //             (event.product.giveAwayCounts ??
  //                 event.product.availableGiveaways!)) {
  //           event.product.isMaxGiveawayAdded = true;
  //           event.product.quantity = 0;
  //           buildCustomToast(msg: 'Giveaway limit reached', isFailure: true);
  //         } else {
  //           buildCustomToast(msg: 'Gift is added!', isFailure: false);
  //         }
  //       } else {
  //         buildCustomToast(msg: 'Gift is added!', isFailure: false);
  //       }
  //     } else {
  //       buildCustomToast(msg: 'Gift is added!', isFailure: false);
  //     }
  //   } else {
  //     buildCustomToast(
  //         msg: '${event.product.productDetails?.title} added to cart',
  //         isFailure: false);
  //   }
  //   List<Products> products =
  //       await processProducts(state.selectedProducts, event.product);
  //
  //   num productSum = products.fold<num>(0, (previousValue, element) {
  //     if (element.quantity! > 0) {
  //       return previousValue + element.quantity! * element.price!;
  //     }
  //     return previousValue;
  //   });
  //
  //   emit(state.copyWith(
  //       selectedProducts: products,
  //       message: AppStrings.global_empty_string,
  //       isRefreshRequired: false,
  //       productSum: productSum,
  //       isFailure: false));
  // }

  FutureOr<void> _onTriggerAddToCart(
      TriggerAddToCart event, Emitter<RegisterAndSellState> emit) {
    List<Athlete> collection = [];
    List<String> athleteDivIds = [];
    List<DivisionTypes> divisionTypes = navigatorKey.currentContext!
        .read<EventDetailsBloc>()
        .state
        .divisionsTypes;

    for (DivisionTypes divType in divisionTypes) {
      debugPrint('Processing Division Type: ${divType.divisionType}');
      for (AgeGroups ageGroup in divType.ageGroups!) {
        debugPrint('Processing Age Group: $ageGroup');
        List<Athlete> athletesList = ageGroup.expansionPanelAthlete!;
        for (Athlete athlete in athletesList) {
          debugPrint('Processing Athlete: ${athlete.underscoreId}');
          for (Styles style in athlete.athleteStyles!) {
            style.ageGroup = ageGroup.title;
            bool completeEmpty = athlete.athleteStyles!
                .every((element) => element.finalizedSelectedWeights!.isEmpty);
            if (completeEmpty) {
              athlete.isAthleteTaken = false;
              collection.remove(athlete);
              athleteDivIds.remove(athlete.underscoreId);
            } else {
              if (style.temporarilySelectedWeights!.isNotEmpty) {
                String athleteId =
                    '${athlete.underscoreId}-${divType.divisionType}-${ageGroup.title}-${style.style}';
                if (athleteDivIds.contains(athleteId)) {
                  debugPrint('Athlete ID already exists: $athleteId');
                  Athlete athleteMatch = collection.firstWhere((element) =>
                      element.underscoreId == athlete.underscoreId);

                  bool isEmpty = athleteMatch.athleteStyles!.every(
                      (element) => element.finalizedSelectedWeights!.isEmpty);
                  if (isEmpty) {
                    athleteMatch.isAthleteTaken = false;
                    collection.remove(athleteMatch);
                    athleteDivIds.remove(athleteId);
                  }
                } else {
                  debugPrint('Adding Athlete ID: $athleteId');
                  athleteDivIds.add(athleteId);
                  collection.add(athlete);
                  athlete.isAthleteTaken = true;
                }
              }
            }
          }
        }
      }
    }

    debugPrint('Collection ${collection.length}');
    for (Athlete athlete in collection) {
      debugPrint(
          'Athlete ${athlete.underscoreId}---${athlete.athleteStyles!.map((e) => '${e.style}  ${e.finalizedSelectedWeights!} ${e.finalizedSelectedWeightClasses}')}--${athlete.chosenWCs}');
    }

    List<Athlete> existingAthletes = List.from(state.athletes);
    for (Athlete athlete in existingAthletes) {
      if (collection.isNotEmpty) {
        debugPrint('Collection ${collection.length}');
        bool isThereAMatch = collection
            .any((element) => element.underscoreId == athlete.underscoreId);

        if (isThereAMatch) {
          Athlete athleteMatch = collection.firstWhere(
              (element) => element.underscoreId == athlete.underscoreId);
          if (athleteMatch.chosenWCs!.isNotEmpty) {
            print('&&&&&&&&&&&&&');
            for(var i  = 0; i<athlete.athleteStyles!.length; i++){
              print('${athlete.athleteStyles![i].toJson()}\n');
            }
            print('000000');
            for(var i  = 0; i<athleteMatch.athleteStyles!.length; i++){
              print('${athleteMatch.athleteStyles![i].toJson()}\n');
            }

            print(athlete.athleteStyles!.map((e) => e.toJson()));
            athlete.athleteStyles = athleteMatch.athleteStyles;
            athlete.isAthleteTaken = true;
            athleteMatch.isAthleteTaken = true;
            athlete.chosenWCs = athleteMatch.chosenWCs;
          } else {
            athleteMatch.isAthleteTaken = false;
            collection.remove(athleteMatch);
          }
        }
      } else {
        athlete.isAthleteTaken = false;
        athlete.chosenWCs = [];
        for (var element in athlete.athleteStyles!) {
          element.temporarySelectedWeightClasses = [];
          element.temporarilySelectedWeights = [];
          element.finalizedSelectedWeights = [];
          element.finalizedSelectedWeightClasses = [];
        }
      }
    }
    List<StaffCheckoutRegistrations> registrations = [];
    List<String> registerIds = [];
    for (var i = 0; i < collection.length; i++) {
      for (Styles style in collection[i].athleteStyles!) {
        String registerId =
            '${collection[i].underscoreId!} - ${style.style!} - ${style.divisionType!} - ${style.ageGroup!}';
        if (style.finalizedSelectedWeights!.isNotEmpty) {
          if (!registerIds.contains(registerId)) {
            registerIds.add(registerId);
            List<String> wcList = [];
            List<String> wcNumber = [];
            for (WeightClass wc in style.division!.weightClasses!) {
              for (String weight in style.finalizedSelectedWeights!) {
                if (wc.weight == weight && !wcList.contains(wc.id!)) {
                  wcList.add(wc.id!);
                  wcNumber.add(weight);
                }
              }
            }
            print('*******style div id:${style.division?.divisionType} ${style.division!.title} ${style.division!.id}');
            StaffCheckoutRegistrations staffCheckoutRegistrations =
                StaffCheckoutRegistrations(
                  ageGroup: style.ageGroup!,
                  wcNumbers: wcNumber,
              divId: style.division!.id!,
              styleId: style.id!,
              wcList: wcList,
              athleteId: collection[i].underscoreId!,
              id: registerId,
              divisionName: style.divisionType!,
              styleName: style.style!,
              absolutePrice: style.division!.guestRegistrationPrice!,
              athleteName: StringManipulation.combineFirstNameWithLastName(
                  firstName: collection[i].firstName!,
                  lastName: collection[i].lastName!),
              quantity: wcList.length,
              totalPrice:
                  style.division!.guestRegistrationPrice! * wcList.length,
              wc: wcList.join(', '),
            );
            registrations.add(staffCheckoutRegistrations);
          }
        }
      }
    }
    num athleteSum = 0;
    List<StaffCheckoutRegistrations> reducedList = [];
    List<String> reducedListIds = [];
    for (StaffCheckoutRegistrations registration in registrations) {
      athleteSum += registration.totalPrice;
      String id =
          '${registration.athleteId} - ${registration.styleName} - ${registration.divisionName}';
      if (!reducedListIds.contains(id)) {
        reducedListIds.add(id);
        reducedList.add(registration);
      } else {
        StaffCheckoutRegistrations existing = reducedList.firstWhere((element) =>
            ('${element.athleteId} - ${element.styleName} - ${element.divisionName}') ==
            id);
        existing.quantity += registration.quantity;
        existing.wcList.addAll(registration.wcList);
        existing.wcNumbers.addAll(registration.wcNumbers);
        existing.wc = '${existing.wc}, ${registration.wc}';
        existing.totalPrice = existing.absolutePrice * existing.quantity;
      }
    }
    List<Registrations> registerList = state.eventData.registrations ?? [];

    for (Products product in state.products) {
      List<String> ids = [];
      List<String> idsForGiveaways = [];
      bool isGiveaway = product.productDetails?.isGiveaway ?? false;

      if (isGiveaway) {
        int giveAwayAvailable = product.availableGiveaways ?? 0;
        print('--------${giveAwayAvailable} ** ${product.availableGiveaways}');
        switch (product.productDetails?.giveAwayType) {
          case 'athlete':
            for (Registrations registration in registerList) {
              ids.add(registration.athleteId!);
            }
            ids = ids.toSet().toList();

            idsForGiveaways = reducedList
                .where((athlete) {

              return (!ids.contains(athlete.athleteId));
            }).map((athlete)  {
              return athlete.athleteId;})
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
            if(product.quantity!> product.giveAwayCounts!){
              product.quantity = product.giveAwayCounts;
            }
            debugPrint('Giveawaytype: athlete:-${product.giveAwayCounts}');
          case 'account':
            product.giveAwayCounts = giveAwayAvailable;

            if (product.giveAwayCounts == 0) {
              product.isMaxGiveawayAdded = true;
            } else {
              product.isMaxGiveawayAdded = null;
            }
            if(product.quantity!> product.giveAwayCounts!){
              product.quantity = product.giveAwayCounts;
            }
            debugPrint('Giveawaytype: account:-${product.giveAwayCounts}');
          // case 'athlete-bracket':
          //   for (Registrations registration in registerList) {
          //     ids.add(registration.athleteId! + registration.divisionId!);
          //   }
          //   ids = ids.toSet().toList();
          //   List<StaffCheckoutRegistrations> athletesForGiveAway = [];
          //   for (StaffCheckoutRegistrations athlete in reducedList) {
          //     if (!(ids.contains(athlete.athleteId + athlete.divId))) {
          //       debugPrint('-->>-${athlete.athleteId} ++ ${athlete.divisionName}: ${athlete.divId} +${athlete.styleName}: ${athlete.styleId}');
          //       athletesForGiveAway.add(athlete);
          //     }
          //   }
          //
          //   Map<String, int> athleteIdCounts = {};
          //
          //   for (StaffCheckoutRegistrations athlete in athletesForGiveAway) {
          //     athleteIdCounts.update(athlete.athleteId, (value) => value + 1,
          //         ifAbsent: () => 1);
          //   }
          //   idsForGiveaways = []; // Clear the previous list
          //   for (String athleteId in athleteIdCounts.keys) {
          //     int count = athleteIdCounts[athleteId]!;
          //     for (int i = 0; i < count; i++) {
          //       idsForGiveaways.add(athleteId);
          //     }
          //   }
          //   if (idsForGiveaways.isNotEmpty) {
          //     product.giveAwayCounts =
          //         idsForGiveaways.length + giveAwayAvailable;
          //   }
          //   else {
          //     product.giveAwayCounts = giveAwayAvailable;
          //   }
          //   if (product.giveAwayCounts == 0) {
          //     product.isMaxGiveawayAdded = true;
          //   } else {
          //     product.isMaxGiveawayAdded = null;
          //   }
          //   print('^^^^athlete^^^^^^${idsForGiveaways}');
          //   debugPrint('Giveawaytype: bracket:-${product.giveAwayCounts}');
          case 'athlete-bracket':
          // 1. Create a unique identifier including athleteId, divId, and weightClassId
            Set<String> registeredCombinations = {};
            for (Registrations registration in registerList) {
              // Assuming weightClassId is accessible in Registrations, otherwise modify accordingly.

                registeredCombinations.add(
                    "${registration.athleteId!}-${registration.divisionId!}-${registration.weightClassId}");


            }

            // 2. Filter athletes based on the unique combination
            List<StaffCheckoutRegistrations> athletesForGiveAway = [];
            for (StaffCheckoutRegistrations athlete in reducedList) {
              // Assuming weightClassId is in athlete.wcList
              for (String weightClass in athlete.wcList) {
                String combination = "${athlete.athleteId}-${athlete.divId}-$weightClass";
                if (!registeredCombinations.contains(combination)) {
                  //we need to add the athlete only once per combination
                  bool alreadyAdded = false;
                  for(StaffCheckoutRegistrations addedAthlete in athletesForGiveAway){
                    for(String weightClassAdded in addedAthlete.wcList){ // Check against all wc
                      String combinationAdded = "${addedAthlete.athleteId}-${addedAthlete.divId}-$weightClassAdded";
                      if(combination == combinationAdded){
                        alreadyAdded = true;
                        break;
                      }
                    }
                    if(alreadyAdded){
                      break; // No need to keep checking if we already find it
                    }
                  }
                  if(!alreadyAdded){
                    athletesForGiveAway.add(athlete);
                  }
                }
              }
            }
            // 3. Count giveaways based on unique combinations
            Map<String, int> combinationCounts = {};

            for (StaffCheckoutRegistrations athlete in athletesForGiveAway) {
              for (String weightClass in athlete.wcList) {
                String combination = "${athlete.athleteId}-${athlete.divId}-$weightClass";
                combinationCounts.update(combination, (value) => value + 1,
                    ifAbsent: () => 1);
              }

            }
            idsForGiveaways = []; // Clear the previous list
            for (String combination in combinationCounts.keys) {
              int count = combinationCounts[combination]!;
              for (int i = 0; i < count; i++) {
                idsForGiveaways.add(combination);
              }
            }

            //('length of giveawaysIds = ${idsForGiveaways.length} - $giveAwayAvailable');
            if (idsForGiveaways.isNotEmpty) {
              product.giveAwayCounts = idsForGiveaways.length + giveAwayAvailable;
            } else {
              product.giveAwayCounts = giveAwayAvailable;
            }
            if (product.giveAwayCounts == 0) {
              product.isMaxGiveawayAdded = true;
            } else {
              product.isMaxGiveawayAdded = null;
            }
            if(product.quantity!> product.giveAwayCounts!){
              product.quantity = product.giveAwayCounts;
            }
            //print('^^^^bracket^^^^^^${idsForGiveaways}');
            debugPrint(
                'Giveawaytype: bracket:-${product.giveAwayCounts}T max:${product.isMaxGiveawayAdded}');
        }
      }
    }
    for (Products product in state.selectedProducts) {
      List<String> ids = [];
      List<String> idsForGiveaways = [];
      bool isGiveaway = product.productDetails?.isGiveaway ?? false;

      if (isGiveaway) {
        int giveAwayAvailable = product.availableGiveaways ?? 0;
        print('--------${giveAwayAvailable} ** ${product.availableGiveaways}');
        switch (product.productDetails?.giveAwayType) {
          case 'athlete':
            for (Registrations registration in registerList) {
              ids.add(registration.athleteId!);
            }
            ids = ids.toSet().toList();

            idsForGiveaways = reducedList
                .where((athlete) {

              return (!ids.contains(athlete.athleteId));
            }).map((athlete)  {
              return athlete.athleteId;})
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
            if(product.quantity!> product.giveAwayCounts!){
              product.quantity = product.giveAwayCounts;
            }
            debugPrint('Giveawaytype: athlete:-${product.giveAwayCounts}');
          case 'account':
            product.giveAwayCounts = giveAwayAvailable;

            if (product.giveAwayCounts == 0) {
              product.isMaxGiveawayAdded = true;
            } else {
              product.isMaxGiveawayAdded = null;
            }
            if(product.quantity!> product.giveAwayCounts!){
              product.quantity = product.giveAwayCounts;
            }
            debugPrint('Giveawaytype: account:-${product.giveAwayCounts}');
        // case 'athlete-bracket':
        //   for (Registrations registration in registerList) {
        //     ids.add(registration.athleteId! + registration.divisionId!);
        //   }
        //   ids = ids.toSet().toList();
        //   List<StaffCheckoutRegistrations> athletesForGiveAway = [];
        //   for (StaffCheckoutRegistrations athlete in reducedList) {
        //     if (!(ids.contains(athlete.athleteId + athlete.divId))) {
        //       debugPrint('-->>-${athlete.athleteId} ++ ${athlete.divisionName}: ${athlete.divId} +${athlete.styleName}: ${athlete.styleId}');
        //       athletesForGiveAway.add(athlete);
        //     }
        //   }
        //
        //   Map<String, int> athleteIdCounts = {};
        //
        //   for (StaffCheckoutRegistrations athlete in athletesForGiveAway) {
        //     athleteIdCounts.update(athlete.athleteId, (value) => value + 1,
        //         ifAbsent: () => 1);
        //   }
        //   idsForGiveaways = []; // Clear the previous list
        //   for (String athleteId in athleteIdCounts.keys) {
        //     int count = athleteIdCounts[athleteId]!;
        //     for (int i = 0; i < count; i++) {
        //       idsForGiveaways.add(athleteId);
        //     }
        //   }
        //   if (idsForGiveaways.isNotEmpty) {
        //     product.giveAwayCounts =
        //         idsForGiveaways.length + giveAwayAvailable;
        //   }
        //   else {
        //     product.giveAwayCounts = giveAwayAvailable;
        //   }
        //   if (product.giveAwayCounts == 0) {
        //     product.isMaxGiveawayAdded = true;
        //   } else {
        //     product.isMaxGiveawayAdded = null;
        //   }
        //   print('^^^^athlete^^^^^^${idsForGiveaways}');
        //   debugPrint('Giveawaytype: bracket:-${product.giveAwayCounts}');
          case 'athlete-bracket':
          // 1. Create a unique identifier including athleteId, divId, and weightClassId
            Set<String> registeredCombinations = {};
            for (Registrations registration in registerList) {
              // Assuming weightClassId is accessible in Registrations, otherwise modify accordingly.

              registeredCombinations.add(
                  "${registration.athleteId!}-${registration.divisionId!}-${registration.weightClassId}");


            }

            // 2. Filter athletes based on the unique combination
            List<StaffCheckoutRegistrations> athletesForGiveAway = [];
            for (StaffCheckoutRegistrations athlete in reducedList) {
              // Assuming weightClassId is in athlete.wcList
              for (String weightClass in athlete.wcList) {
                String combination = "${athlete.athleteId}-${athlete.divId}-$weightClass";
                if (!registeredCombinations.contains(combination)) {
                  //we need to add the athlete only once per combination
                  bool alreadyAdded = false;
                  for(StaffCheckoutRegistrations addedAthlete in athletesForGiveAway){
                    for(String weightClassAdded in addedAthlete.wcList){ // Check against all wc
                      String combinationAdded = "${addedAthlete.athleteId}-${addedAthlete.divId}-$weightClassAdded";
                      if(combination == combinationAdded){
                        alreadyAdded = true;
                        break;
                      }
                    }
                    if(alreadyAdded){
                      break; // No need to keep checking if we already find it
                    }
                  }
                  if(!alreadyAdded){
                    athletesForGiveAway.add(athlete);
                  }
                }
              }
            }
            // 3. Count giveaways based on unique combinations
            Map<String, int> combinationCounts = {};

            for (StaffCheckoutRegistrations athlete in athletesForGiveAway) {
              for (String weightClass in athlete.wcList) {
                String combination = "${athlete.athleteId}-${athlete.divId}-$weightClass";
                combinationCounts.update(combination, (value) => value + 1,
                    ifAbsent: () => 1);
              }

            }
            idsForGiveaways = []; // Clear the previous list
            for (String combination in combinationCounts.keys) {
              int count = combinationCounts[combination]!;
              for (int i = 0; i < count; i++) {
                idsForGiveaways.add(combination);
              }
            }

            print('length of giveawaysIds = ${idsForGiveaways.length} - $giveAwayAvailable');
            if (idsForGiveaways.isNotEmpty) {
              product.giveAwayCounts = idsForGiveaways.length + giveAwayAvailable;
            }
            else {
              product.giveAwayCounts = giveAwayAvailable;
            }
            if (product.giveAwayCounts == 0) {
              product.isMaxGiveawayAdded = true;
            }
            else {
              product.isMaxGiveawayAdded = null;
            }
            if(product.quantity!> product.giveAwayCounts!){
              product.quantity = product.giveAwayCounts;
            }
            print('^^^^bracket^^^^^^${idsForGiveaways}');
            debugPrint(
                'Giveawaytype: bracket:-${product.giveAwayCounts}T max:${product.isMaxGiveawayAdded}');
        }
      }
    }

    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        selectedAthletes: collection,
        athletes: existingAthletes,
        registrations: reducedList,
        athleteSum: athleteSum,
        isRefreshRequired: true,
        isAddToCard: false,
        isFailure: false));
    add( TriggerArrangeDataForSummaryT());
    Navigator.of(navigatorKey.currentContext!).pop();
  }

  bool checkForSelectedAthlete({required String id}) {
    List<Athlete> athletes = state.selectedAthletes;
    bool isSelected = false;
    for (int i = 0; i < athletes.length; i++) {
      if (athletes[i].underscoreId == id) {
        isSelected = true;
        break;
      }
    }
    return isSelected;
  }

  FutureOr<void> _onTriggerRemoveAllItems(
      TriggerRemoveAllItems event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        couponError: null,
        isFailure: false));
    for (Products product in state.products) {
      product.quantity = 0;
      product.isAddedToCart = false;
      product.giveAwayCounts = product.availableGiveaways;
      product.isMaxGiveawayAdded = null;
    }
    emit(state.copyWith(
      selectedProducts: [],
      selectedAthletes: [],
      registrations: [],
      athleteSum: 0,
      productSum: 0,
      isRefreshRequired: false,
    ));
  }

  // FutureOr<void> _onTriggerApplyCoupon(
  //     TriggerApplyCoupon event, Emitter<RegisterAndSellState> emit)
  // {
  //   emit(state.copyWith(
  //       isApplyActive: false,
  //       message: AppStrings.global_empty_string,
  //       isRefreshRequired: true,
  //       couponError: null,
  //       isLoadingCoupon: true,
  //       isFailure: false));
  //   emit(state.copyWith(
  //     couponError: event.couponError,
  //     isFix: event.isFix,
  //     isLoadingCoupon: false,
  //     couponAmount: event.couponAmount,
  //     isRefreshRequired: false,
  //   ));
  // }

  FutureOr<void> _onTriggerRemoveCoupon(
      TriggerRemoveCoupon event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isApplyActive: true,
        couponError: null,
        isFailure: false));
    emit(state.copyWith(
      couponAmount: null,
      couponEditingController: TextEditingController(),
      couponNode: FocusNode(),
      isRefreshRequired: false,
    ));
  }

  FutureOr<void> _onTriggerCheckOut(
      TriggerCheckOut event, Emitter<RegisterAndSellState> emit) async {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isApplyActive: true,
        isProcessingPurchase: true,
        isLoading: true,
        isFailure: false));


    StripeReaderData? stripeReaderString =
        await GlobalHandlers.extractStripeReaderHandler();
    String readerId = stripeReaderString?.id ?? '';
    debugPrint('Reader ID $readerId');
    if (state.registrations.isNotEmpty) {
      List<String> storedProfileModules =
          instance<AthleteCachedData>().getAthleteListJson() ?? [];
      List<CreateProfileRequestModel> profiles = storedProfileModules
          .map((athleteJson) =>
              CreateProfileRequestModel.fromJson(jsonDecode(athleteJson)))
          .toList();
      List<Athlete> athletes = profiles.map((e) {
        debugPrint('Create ${e.isUserParent}');
        return Athlete(
          uniqueId: e.athleteId,
          firstName: e.firstName,
          lastName: e.lastName,
          //to be generated from FE for registrations mapping, can be any string
          email: e.email,
          gender: e.gender,
          birthDate: e.birthDate,
          grade: e.gradeValue,
          isRedshirt: e.isRedshirt,
          weight: e.weight,
          phoneCode: 1,
          phoneNumber: num.parse(e.contactNumber),
          mailingAddress: e.address,
          city: e.city,
          state: e.stateName,
          pincode: num.parse(e.zipCode),
          isUserParent: e.isUserParent.toString() == 'true',
          teamId: e.teamId,
        );
      }).toList();
      List chosenAthletes = [];
      List chosenIds = [];
      for (Athlete a in athletes) {
        for (StaffCheckoutRegistrations s in state.registrations) {
          if (a.uniqueId == s.athleteId) {
            if (!chosenIds.contains(a.uniqueId)) {
              chosenAthletes.add(a);
              chosenIds.add(a.uniqueId);
            }
          }
        }
      }
      List<RegistrationsSelection> registrationSelection = [];
      List<String> registeredIds = [];
      for (StaffCheckoutRegistrations s in state.registrations) {
        if (registeredIds.contains(s.athleteId)) {
          for (RegistrationsSelection r in registrationSelection) {
            if (r.athleteId == s.athleteId) {
              r.divisions!.add(DivisionsSelected(
                  divisionId: s.divId,
                  eventDivisionId: s.styleId,
                  weightClasses: s.wcList));
            }
          }
        } else {
          List<DivisionsSelected> divisions = [];
          divisions.add(DivisionsSelected(
              divisionId: s.divId,
              eventDivisionId: s.styleId,
              weightClasses: s.wcList));
          RegistrationsSelection reg = RegistrationsSelection(
              athleteId: s.athleteId, divisions: divisions);
          registrationSelection.add(reg);
          registeredIds.add(s.athleteId);
        }
      }
      bool? isFromOnBehalf = navigatorKey.currentContext!
          .read<SelectedCustomerBloc>()
          .state
          .isFromOnBehalf;
      EmployeeCheckoutRequestModel employeeCheckoutRequestModel =
          EmployeeCheckoutRequestModel(
        readerId: navigatorKey.currentContext!
            .read<StaffHomeBloc>()
            .state
            .readerData!
            .id!,
        userId: isFromOnBehalf == null
            ? null
            : navigatorKey.currentContext!
                .read<SelectedCustomerBloc>()
                .state
                .customer!
                .underScoreId!,
        coupon: event.couponCode,
        parent: isFromOnBehalf == null
            ? Parent(
                firstName: GlobalHandlers.dataEncryptionHandler(
                    value: state.firstNameController.text),
                lastName: GlobalHandlers.dataEncryptionHandler(
                    value: state.lastNameController.text),
                email: GlobalHandlers.dataEncryptionHandler(
                    value: state.emailController.text),
                phoneCode: GlobalHandlers.dataEncryptionHandler(value: '1'),
                phoneNumber: GlobalHandlers.dataEncryptionHandler(
                    value: state.phoneController.text),
                mailingAddress: GlobalHandlers.dataEncryptionHandler(
                    value: state.postalAddressController.text),
                city: GlobalHandlers.dataEncryptionHandler(value: state.city),
                state: state.stateName.isNotEmpty
                    ? GlobalHandlers.dataEncryptionHandler(
                        value: state.stateName)
                    : AppStrings.global_empty_string,
                zipcode: GlobalHandlers.dataEncryptionHandler(
                    value: state.zipCodeController.text),
              )
            : null,
        athletes: chosenAthletes
            .map((e) => AthletesSelection(
                uniqueId: e.uniqueId,
                firstName: e.firstName,
                lastName: e.lastName,
                email: e.email,
                gender: e.gender,
                birthDate: e.birthDate,
                grade: e.grade,
                isRedshirt: e.isRedshirt,
                //true/false,
                weight: num.parse(e.weight),
                phoneCode: e.phoneCode,
                phoneNumber: e.phoneNumber,
                address: e.mailingAddress,
                city: e.city,
                state: e.state,
                pincode: e.pincode.toString(),
                isUserParent: e.isUserParent,
                teamId: e.teamId))
            .toList(),
        registrations: registrationSelection,
        products: state.selectedProducts
            .map((e) => ProductsSelection(
                productId: e.underscoreId,
                qty: e.quantity,
                variant: e.selectedVariant))
            .toList(),
      );

      debugPrint(
          'Employee Checkout Request Model ${employeeCheckoutRequestModel.toJson()}',
          wrapWidth: 3024);
      try {
        final response = await RegisterAndSellRepository.postRegistration(
            eventId: state.eventData.id!,
            registrations: employeeCheckoutRequestModel);

        response.fold(
            (l) => {
                  emit(state.copyWith(
                      isLoading: false,
                      isLoadingCoupon: false,
                      isFailure: true,
                      isProcessingPurchase: false)),
                  buildCustomToast(msg: l.message, isFailure: true),
            Navigator.pop(navigatorKey.currentContext!)
                },
            (s) => {
                  debugPrint('paymentId: ${s.responseData?.data?.paymentId}'),
                  debugPrint('reader id $readerId'),

                  emit(state.copyWith(
                      isLoading: true,
                      isLoadingCoupon: false,
                      isFailure: false,
                      showCancelButton: true,
                      paymentId: s.responseData?.data?.paymentId ??
                          AppStrings.global_empty_string,
                      readerId: readerId)),
                  buildCustomToast(
                      msg: s.responseData?.message ??
                          AppStrings.global_empty_string,
                      isFailure: false),
                Navigator.pop(navigatorKey.currentContext!)
                });
      } catch (e) {
        emit(state.copyWith(
            message: e.toString(),
            isRefreshRequired: false,
            isLoadingCoupon: false,
            isFailure: true));
        Navigator.pop(navigatorKey.currentContext!);
      }
    } else {
      EmployeeCheckoutRequestModel employeeCheckoutRequestModel =
          EmployeeCheckoutRequestModel(
        readerId: navigatorKey.currentContext!
            .read<StaffHomeBloc>()
            .state
            .readerData!
            .id!,
        coupon: event.couponCode,
        products: state.selectedProducts
            .map((e) => ProductsSelection(
                productId: e.underscoreId,
                qty: e.quantity,
                variant: e.selectedVariant))
            .toList(),
      );
      debugPrint(
          'Employee Checkout Request Model ${employeeCheckoutRequestModel.toJson()}',
          wrapWidth: 1024);
      try {
        final response = await RegisterAndSellRepository.postProduct(
            eventId: state.eventData.id!,
            products: employeeCheckoutRequestModel);

        response.fold(
            (l) => {
                  emit(state.copyWith(
                      isLoading: false,
                      isLoadingCoupon: false,
                      isFailure: true,
                      isProcessingPurchase: false)),
                  buildCustomToast(msg: l.message, isFailure: true),
              Navigator.pop(navigatorKey.currentContext!)
                },
            (s) => {
                  debugPrint('paymentId: ${s.responseData?.data?.paymentId}'),
                  debugPrint('reader id $readerId'),
                  emit(state.copyWith(
                      isLoading: true,
                      isLoadingCoupon: false,
                      showCancelButton: true,
                      paymentId: s.responseData?.data?.paymentId ??
                          AppStrings.global_empty_string,
                      readerId: readerId,
                      isFailure: false,
                      isProcessingPurchase: false)),
                  buildCustomToast(
                      msg: s.responseData?.message ??
                          AppStrings.global_empty_string,
                      isFailure: false),
              Navigator.pop(navigatorKey.currentContext!)
                });
      } catch (e) {
        emit(state.copyWith(
            message: e.toString(),
            isRefreshRequired: false,
            isLoadingCoupon: false,
            isFailure: true));
        Navigator.pop(navigatorKey.currentContext!);
      }
    }

    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: false,
        isLoadingCoupon: true,
        isFailure: false));
  }

  FutureOr<void> _onTriggerSuccessDialog(
      TriggerSuccessDialog event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isLoadingCoupon: false,
        showCancelButton: false,
        isLoading: false,
        selectedProducts: [],
        registrations: [],
        productSum: 0,
        athleteSum: 0,
        couponError: null,
        isApplyActive: true,
        selectedAthletes: [],
        products: state.products.map((e) {
          e.quantity = 0;
          e.isAddedToCart = false;
          return e;
        }).toList(), couponEditingController: TextEditingController(),
        couponNode: FocusNode(),
        firstNameController: TextEditingController(),
        lastNameController: TextEditingController(),
        emailController: TextEditingController(),
        postalAddressController: TextEditingController(),
        zipCodeController: TextEditingController(),
        firstNameFocusNode: FocusNode(),
        lastNameFocusNode: FocusNode(),
        emailFocusNode: FocusNode(),
        postalAddressFocusNode: FocusNode(),
        zipCodeFocusNode: FocusNode(),
        zipCodeError: null,
        couponAmount: null,
        city: AppStrings.global_empty_string,
        stateName: AppStrings.global_empty_string,
        isButtonLabelledSaved: false,
        isFormExpanded: false,
        isFormFilled: false,
        isFailure: false));
    if (event.purchaseResponse != null) {
      if (event.purchaseResponse!.readerId ==
          navigatorKey.currentContext!
              .read<StaffHomeBloc>()
              .state
              .readerData!
              .id) {
        emit(state.copyWith(
          invoiceUrl: event.purchaseResponse!.purchase!.invoiceUrl!,
        ));
        PurchaseSocketResponseModel purchaseResponse = event.purchaseResponse!;
        String paymentDate = GlobalHandlers.dateFormatterForPaymentDate(
            dateString: purchaseResponse.purchase!.date!);
        String paymentMethod =
            purchaseResponse.purchase?.paymentMethodType ?? 'None';
        paymentMethod = paymentMethod.toLowerCase();
        String brand = purchaseResponse.purchase?.cardBrand ??
            AppStrings.global_empty_string;
        if (brand.isNotEmpty) {
          brand =
              StringManipulation.capitalizeFirstLetterOfEachWord(value: brand);
        }
        String soldBy = StringManipulation.combineFirstNameWithLastName(
            firstName:
                purchaseResponse.purchase!.soldBy!.firstName!.contains('=')
                    ? GlobalHandlers.dataDecryptionHandler(
                        value: purchaseResponse.purchase!.soldBy!.firstName!)
                    : purchaseResponse.purchase!.soldBy!.firstName!,
            lastName: purchaseResponse.purchase!.soldBy!.lastName!.contains('=')
                ? GlobalHandlers.dataDecryptionHandler(
                    value: purchaseResponse.purchase!.soldBy!.lastName!)
                : purchaseResponse.purchase!.soldBy!.lastName!);
        num amount = purchaseResponse.purchase!.amount!;
        paymentMethod = paymentMethod.toLowerCase() == 'card'
            ? brand.toLowerCase()
            : paymentMethod.toLowerCase();
        emit(state.copyWith(isFromCancel: false));
        showPaymentSuccessDialog(
            brand: brand,
            context: navigatorKey.currentContext!,
            paymentDate: paymentDate,
            isLoading: state.isLoadingPdf,
            paymentMethod: paymentMethod,
            soldBy: soldBy,
            amount: amount);
      } else {
        buildCustomToast(msg: 'Reader id does not match', isFailure: true);
      }
    } else {
      buildCustomToast(msg: 'Unsuccessful purchase', isFailure: true);
    }
  }

  FutureOr<void> _onTriggerRefreshRegistrationAndSellForm(
      TriggerRefreshRegistrationAndSellForm event,
      Emitter<RegisterAndSellState> emit) {
    emit(RegisterAndSellState.initial());
    instance<AthleteCachedData>()
        .removeSharedPreferencesGeneralFunction('athlete_list');

    emit(state.copyWith(
      isLoading: false,
      isLoadingCoupon: false,
    ));
  }

  FutureOr<void> _onTriggerInteractWithContactField(
      TriggerInteractWithContactField event,
      Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isApplyActive: true,
        couponError: null,
        isFailure: false));
    String? isValid = TextFieldValidators.validateContactNumber(
        value: state.phoneController.text);
    debugPrint(
        'isValid ${TextFieldValidators.validateZip(value: state.zipCodeController.text)}');
    emit(state.copyWith(
        zipCodeError: null,
        isContactNumberValid: isValid == null,
        isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerPurchaseFail(
      TriggerPurchaseFail event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
      isLoadingCoupon: false,
      isLoading: false,
      showCancelButton: false,
      isProcessingPurchase: false,
      message: AppStrings.global_empty_string,
    ));
    if (!state.isCancelled) {
      buildCustomToast(
          msg: AppStrings.registerAndSell_unsuccessfulPayment, isFailure: true);
    } else {
      add(TriggerRefreshRegistrationAndSellForm());
      add(TriggerMakeItAtToCart());
    }
  }

  FutureOr<void> _onTriggerDownloadPdf(
      TriggerDownloadPdf event, Emitter<RegisterAndSellState> emit) async {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isLoadingPdf: true,
        isFailure: false));
    try {
      final regex = RegExp(r'\/purchases\/([A-Z0-9_]+)\/pdf');
      final match = regex.firstMatch(event.invoiceUrl);
      String fileName = match?.group(1) ?? AppStrings.global_empty_string;
      debugPrint('File Name $fileName');
      final response = await DownloadPdfRepository.downloadAndSavePdf(
          url: event.invoiceUrl, fileName: fileName);
      response.fold((l) {
        emit(state.copyWith(
          message: l.message,
          isFailure: true,
        ));
        buildCustomToast(msg: l.message, isFailure: true);
      }, (r) {
        emit(state.copyWith(
            message: AppStrings.global_empty_string,
            isFailure: false,
            isLoadingPdf: false));
        buildCustomToast(
            msg: AppStrings.myPurchases_invoiceDownloaded_success_text,
            isFailure: false);
        // Navigator.of(navigatorKey.currentContext!).pop();
        // Navigator.of(navigatorKey.currentContext!).pop();
      });
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        isFailure: true,
      ));
      buildCustomToast(msg: e.toString(), isFailure: true);
    }
  }

  // FutureOr<void> _onTriggerChangeListQuantity(
  //     TriggerChangeListQuantity event, Emitter<RegisterAndSellState> emit)
  // {
  //   emit(state.copyWith(
  //       message: AppStrings.global_empty_string,
  //       isRefreshRequired: true,
  //       isFailure: false));
  //   if (event.reduce) {
  //     if (state.products[event.index].quantity! > 0) {
  //       state.products[event.index].quantity =
  //           state.products[event.index].quantity! - 1;
  //     } else {
  //       state.products[event.index].quantity = 0;
  //     }
  //   } else {
  //     state.products[event.index].quantity =
  //         state.products[event.index].quantity! + 1;
  //   }
  //
  //   state.products[event.index].isGiveawayAdded = null;
  //   // if (state.products[event.index].productDetails!.isGiveaway!) {
  //   //   if (state.selectedProducts.isNotEmpty) {
  //   //     Products selectedProduct = state.selectedProducts.firstWhere(
  //   //         (element) =>
  //   //             element.underscoreId ==
  //   //             state.products[event.index].underscoreId);
  //   //     num productQuantity =
  //   //         state.products[event.index].quantity! + selectedProduct.quantity!;
  //   //     bool isTrue = productQuantity >=
  //   //         (state.products[event.index].giveAwayCounts ??
  //   //             state.products[event.index].availableGiveaways!);
  //   //     state.products[event.index].isGiveawayAdded = isTrue ? true : null;
  //   //   }
  //   // }
  //
  //   emit(state.copyWith(
  //       message: AppStrings.global_empty_string,
  //       isRefreshRequired: false,
  //       isFailure: false));
  // }
//----------------------------------------------
  // FutureOr<void> _onTriggerChangeVariant(
  //     TriggerChangeVariant event, Emitter<RegisterAndSellState> emit)
  // {
  //   emit(state.copyWith(
  //       message: AppStrings.global_empty_string,
  //       isRefreshRequired: true,
  //       isFailure: false));
  //
  //   List<Products> products = List.from(state.products);
  //   products[event.index].selectedVariant = event.variant;
  //   emit(state.copyWith(
  //       message: AppStrings.global_empty_string,
  //       isRefreshRequired: false,
  //       products: products,
  //       isFailure: false));
  // }

  FutureOr<void> _onTriggerChangeCartQuantity(
      TriggerChangeCartQuantity event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isFailure: false,
        isFromCancel: false));

    bool hasProduct = true;
    Products? product;
    if (state.selectedProducts.isNotEmpty) {
      hasProduct = state.products.any((element) =>
          element.underscoreId ==
          state.selectedProducts[event.index].underscoreId);
      if (hasProduct) {
        product = state.products.firstWhere((element) =>
            element.underscoreId ==
            state.selectedProducts[event.index].underscoreId);
      }
    }
    if (event.reduce) {
      if (state.selectedProducts[event.index].quantity! > 0) {
        state.selectedProducts[event.index].quantity =
            state.selectedProducts[event.index].quantity! - 1;
      }
    } else {
      state.selectedProducts[event.index].quantity =
          state.selectedProducts[event.index].quantity! + 1;
    }

    if (state.selectedProducts[event.index].quantity == 0) {
      if (product != null) {
        product.isMaxGiveawayAdded = null;
      }
    }

    num productSum =
        state.selectedProducts.fold<num>(0, (previousValue, element) {
      if (element.quantity! > 0) {
        return previousValue + element.quantity! * element.price!;
      }
      return previousValue;
    });

    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: false,
        productSum: productSum,
        isFailure: false));
  }

  FutureOr<void> _onTriggerMakeItAtToCart(
      TriggerMakeItAtToCart event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isRefreshRequired: true,
    ));
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: false,
        isAddToCard: true,
        isStaffRegistration: false));
  }

  FutureOr<void> _onTriggerCancelPurchase(
      TriggerCancelPurchase event, Emitter<RegisterAndSellState> emit) async {
    // emit(state.copyWith(
    //     message: AppStrings.global_empty_string,
    //     isRefreshRequired: true,
    //     isApplyActive: true,
    //     isLoading: true,
    //     isCancelled: true,
    //     isFailure: false));
    try {
      final response = await RegisterAndSellRepository.cancelPurchase(
          readerId: state.readerId, paymentId: state.paymentId);
      response.fold((l) {
        emit(state.copyWith(
          isLoading: false,
          isLoadingCoupon: false,
          isFailure: true,
        ));
        buildCustomToast(msg: l.message, isFailure: true);
      }, (r) {
        emit(state.copyWith(
            isLoading: false,
            isLoadingCoupon: false,
            isFailure: false,
            showCancelButton: false,
            isFromCancel: true));
        buildCustomToast(
            msg: r.responseData?.message ?? AppStrings.global_empty_string,
            isFailure: false);
      });
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(),
          isRefreshRequired: false,
          isLoadingCoupon: false,
          isLoading: false,
          isFailure: true));
    }
  }

  FutureOr<void> _onTriggerClickOfBack(
      TriggerOnClickOfBack event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        isProcessingPurchase: false,
        showCancelButton: false,
        isFromCancel: state.showCancelButton,
        isLoading: false));
  }

  FutureOr<void> _onTriggerFetchCustomerAthletes(
      TriggerFetchCustomerAthletes event,
      Emitter<RegisterAndSellState> emit) async {
    String userId = navigatorKey.currentContext!
        .read<SelectedCustomerBloc>()
        .state
        .customer!
        .underScoreId!;
    String eventId =
        navigatorKey.currentContext!.read<StaffHomeBloc>().state.eventData!.id!;
    DataBaseUser user = navigatorKey.currentContext!
        .read<SelectedCustomerBloc>()
        .state
        .customer!;
    try {
      final response = await AthleteRepository.getCustomerAthletes(
        userId: userId,
        eventId: eventId,
      );
      response.fold((l) {
        emit(state.copyWith(
          message: l.message,
          isFailure: true,
        ));
        buildCustomToast(msg: l.message, isFailure: true);
      }, (r) {
        List<Athlete> data = r.responseData?.data ?? [];
        for (Athlete athlete in data) {
          athlete.id = athlete.id ?? athlete.underscoreId;
          athlete.profileImage = StringManipulation.combineStings(
              prefix: r.responseData!.assetsUrl!,
              suffix: athlete.profileImage!);
          athlete.isAthleteTaken = false;
          athlete.athleteStyles = [];
          athlete.chosenWCs = [];
          athlete.isLocal = false;
          athlete.weight = athlete.weight ?? athlete.weightClass;
        }

        emit(state.copyWith(
          athletes: data,
          message: AppStrings.global_empty_string,
          isFailure: false,
          firstNameController: user.firstName != null
              ? TextEditingController(text: user.firstName)
              : TextEditingController(),
          lastNameController: user.lastName != null
              ? TextEditingController(text: user.lastName)
              : TextEditingController(),
          emailController: user.email != null
              ? TextEditingController(text: user.email)
              : TextEditingController(),
          postalAddressController: user.mailingAddress != null
              ? TextEditingController(text: user.mailingAddress)
              : TextEditingController(),
          zipCodeController: user.zipcode != null
              ? TextEditingController(text: user.zipcode.toString())
              : TextEditingController(),
          phoneController: user.phoneNumber != null
              ? TextEditingController(text: user.phoneNumber.toString())
              : TextEditingController(),
          city: user.city ?? AppStrings.global_empty_string,
          stateName: user.state ?? AppStrings.global_empty_string,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        isFailure: true,
      ));
    }
  }

  FutureOr<void> _onTriggerRegenerateAthleteListAfterDeletion(
      TriggerRegenerateAthleteListAfterDeletion event,
      Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
      isRefreshRequired: true,
      message: AppStrings.global_empty_string,
    ));
    emit(state.copyWith(
      isRefreshRequired: false,
      isLoading: false,
      athletes: event.athletes,
    ));
  }

  FutureOr<void> _onTriggerCheckMandatory(TriggerCheckMandatoryT event, Emitter<RegisterAndSellState> emit)
  {
    emit(state.copyWith(isRefreshRequired: true, isLoading: false, message: AppStrings.global_empty_string));
    List<Products> allProducts = List.from(state.products);
    for (int i = 0; i < allProducts.length; i++) {
      allProducts[i].dropDownKeyForProduct = GlobalKey<State<StatefulWidget>>();
      print(
          'allProducts: ${allProducts[i].underscoreId} ${allProducts[i].productDetails?.title}-${allProducts[i].dropDownKeyForProduct}');
    }
    bool isProductGiveAwayMandatory = allProducts
        .any((element) => element.productDetails?.isGiveawayMandatory ?? false);
    bool willRegister = false;

    // if (isProductGiveAwayMandatory) {
    //   List<Products> mandatoryOnes = [];
    //
    //   for (Products product in allProducts) {
    //     if (product.productDetails?.isGiveawayMandatory == true) {
    //       Products productM = Products(
    //           id: product.id,
    //           underscoreId: product.underscoreId,
    //           productDetails: product.productDetails,
    //           quantity: product.quantity,
    //           giveAwayCounts: product.giveAwayCounts,
    //           selectedVariant: product.selectedVariant,
    //           isMaxGiveawayAdded: product.isMaxGiveawayAdded,
    //           availableGiveaways: product.availableGiveaways,
    //           eventId: product.eventId,
    //           totalPrice: product.totalPrice,
    //           category: product.category,
    //           createdAt: product.createdAt,
    //           endDate: product.endDate,
    //           externalUrl: product.externalUrl,
    //           image: product.image,
    //           isAddedToCart: product.isAddedToCart,
    //           isGiveaway: product.isGiveaway,
    //           isGiveawayAdded: product.isGiveawayAdded,
    //           isOpen: product.isOpen,
    //           price: product.price,
    //           purchasedVariant: product.purchasedVariant,
    //           qrProductTitle: product.qrProductTitle,
    //           restrictions: product.restrictions,
    //           seasonId: product.seasonId,
    //           updatedAt: product.updatedAt,
    //           variants: product.variants); // Deep copy of the product
    //       mandatoryOnes.add(productM);
    //     }
    //   }
    //   for (int i = 0; i < mandatoryOnes.length; i++) {
    //     mandatoryOnes[i].dropDownKeyForProduct =
    //         GlobalKey<State<StatefulWidget>>();
    //     print(
    //         'mandatoryOnes:${mandatoryOnes[i].underscoreId} ${mandatoryOnes[i].quantity} ${mandatoryOnes[i].productDetails?.title}- ${mandatoryOnes[i].dropDownKeyForProduct}');
    //   }
    //
    //   List<Products> selectedProducts = state.selectedProducts
    //       .where((element) =>
    //       mandatoryOnes.any((p)
    //       { print('## ${p.underscoreId} ${element.underscoreId} ${element.productDetails?.title}');
    //         return p.underscoreId == element.underscoreId;}))
    //       .toList();
    //
    //   if (selectedProducts.isNotEmpty) {
    //     bool isQuantityNotEqualToMaxCounts = selectedProducts.every((element) {
    //       if (element.variants != null && element.variants!.isNotEmpty) {
    //         num totalQuantity = selectedProducts
    //             .where((p) => p.underscoreId == element.underscoreId)
    //             .fold(0, (sum, p) => sum + (p.quantity ?? 0));
    //         return totalQuantity != element.giveAwayCounts;
    //       } else {
    //         return element.quantity != element.giveAwayCounts;
    //       }
    //     });
    //
    //     print('***');
    //     print(isQuantityNotEqualToMaxCounts);
    //     if (isQuantityNotEqualToMaxCounts) {
    //       willRegister = false;
    //       List<Products> needsUpdate = mandatoryOnes.where((element) {
    //         if (element.variants != null && element.variants!.isNotEmpty) {
    //           num totalQuantity = selectedProducts
    //               .where((p) => p.underscoreId == element.underscoreId)
    //               .fold(0, (sum, p) => sum + (p.quantity ?? 0));
    //           return totalQuantity != element.giveAwayCounts;
    //         } else {
    //           return element.quantity != element.giveAwayCounts;
    //         }
    //       }).toList();
    //       emit(state.copyWith(
    //           products: allProducts,
    //           needsUpdate: needsUpdate,
    //           willRegister: willRegister,
    //           isRefreshRequired: false,
    //           message: AppStrings.global_empty_string));
    //       add(TriggerOpenMBSFORGiveAwayT());
    //     } else {
    //       willRegister = true;
    //       emit(state.copyWith(
    //           willRegister: willRegister,
    //           isRefreshRequired: false,
    //           message: AppStrings.global_empty_string));
    //       // add(TriggerCheckout(
    //       //   couponModule: state.couponModule,
    //       // ));
    //     }
    //   }
    //   else {
    //     // bool isQuantityNotEqualToMaxCounts = mandatoryOnes.every((element) {
    //     //   debugPrint(
    //     //       '-: ${element.quantity} ${element.selectedVariant}- ${element.giveAwayCounts}');
    //     //   return element.quantity != element.giveAwayCounts;
    //     // });
    //     // List<Products> needsUpdate = mandatoryOnes
    //     //     .where((element) => element.quantity != element.giveAwayCounts)
    //     //     .toList();
    //     //
    //     // if (isQuantityNotEqualToMaxCounts) {
    //     //   willRegister = false;
    //     //   emit(state.copyWith(
    //     //       products: allProducts,
    //     //       needsUpdate: needsUpdate,
    //     //       willRegister: willRegister,
    //     //       isRefreshRequired: false,
    //     //       message: AppStrings.global_empty_string));
    //     //   add(TriggerOpenMBSFORGiveAwayT());
    //     // }
    //     // else {
    //     //   willRegister = true;
    //     //   emit(state.copyWith(
    //     //       willRegister: willRegister,
    //     //       isRefreshRequired: false,
    //     //       message: AppStrings.global_empty_string));
    //     //   // add(TriggerCheckout(
    //     //   //   couponModule: state.couponModule,
    //     //   // ));
    //     // }
    //     willRegister = false;
    //     emit(state.copyWith(
    //         products: allProducts,
    //         needsUpdate: mandatoryOnes,
    //         willRegister: willRegister,
    //         isRefreshRequired: false,
    //         message: AppStrings.global_empty_string));
    //     add(TriggerOpenMBSFORGiveAwayT());
    //   }
    // }
    // else {
    //   willRegister = true;
    //   emit(state.copyWith(
    //       willRegister: willRegister,
    //       isRefreshRequired: false,
    //       message: AppStrings.global_empty_string));
    //   // add(TriggerCheckout(
    //   //   couponModule: state.couponModule,
    //   // ));
    // }
    // print('will $willRegister');
    if(state.registrations.isNotEmpty){
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
                needsUpdate: needsUpdate,
                willRegister: willRegister,
                isRefreshRequired: false,
                message: AppStrings.global_empty_string));
            add(TriggerOpenMBSFORGiveAwayT());
          } else {
            willRegister = true;
            emit(state.copyWith(
                willRegister: willRegister,
                isRefreshRequired: false,
                message: AppStrings.global_empty_string));
            add(TriggerCheckOut(
              couponCode: state.couponEditingController.text,
            ));
          }
        } else {
          willRegister = false;
          emit(state.copyWith(
              products: allProducts,
              willRegister: willRegister,
              needsUpdate: mandatoryOnes,
              isRefreshRequired: false,
              message: AppStrings.global_empty_string));
          add(TriggerOpenMBSFORGiveAwayT());
        }
      }
      else {
        willRegister = true;
        emit(state.copyWith(
            willRegister: willRegister,
            isRefreshRequired: false,
            message: AppStrings.global_empty_string));
        add(TriggerCheckOut(
          couponCode: state.couponEditingController.text,
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
                needsUpdate: needsUpdate,
                willRegister: willRegister,
                isRefreshRequired: false,
                message: AppStrings.global_empty_string));
            add(TriggerOpenMBSFORGiveAwayT());
          } else {
            willRegister = true;
            emit(state.copyWith(
                willRegister: willRegister,
                isRefreshRequired: false,
                message: AppStrings.global_empty_string));
            add(TriggerCheckOut(
              couponCode: state.couponEditingController.text,
            ));
          }
        } else {

          willRegister = false;
          emit(state.copyWith(
              products: allProducts,
              willRegister: willRegister,
              needsUpdate: mandatoryOnes,
              isRefreshRequired: false,
              message: AppStrings.global_empty_string));
          add(TriggerOpenMBSFORGiveAwayT());
        }
      }
      else {
        willRegister = true;
        emit(state.copyWith(
            willRegister: willRegister,
            isRefreshRequired: false,
            message: AppStrings.global_empty_string));
        add(TriggerCheckOut(
          couponCode: state.couponEditingController.text,
        ));
      }
    }
  }


  FutureOr<void> _onTriggerOpenMBSFORGiveAway(TriggerOpenMBSFORGiveAwayT event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        isRefreshRequired: true,
        message: AppStrings.global_empty_string));
    Navigator.pop(navigatorKey.currentContext!);
    buildCustomShowModalBottomSheetParent(
        ctx: navigatorKey.currentContext!,
        isNavigationRequired: false,
        // isDismissible: false,
        // isEnableDrag: false,
        child: BlocBuilder<RegisterAndSellBloc,
            RegisterAndSellState>(
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
                singleButtonFunction: state.willRegister ? () {
                  Navigator.pop(navigatorKey.currentContext!);
                  openRegisterCheckout(navigatorKey.currentContext!);
                }:(){},
                highLightedString: AppStrings.global_empty_string,
                isAccentedHighlight: false,
                isFooterNoteCentered: false,
                isHighlightedTextBold: false,
                widget: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.needsUpdate.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (context, index) {
                        debugPrint(
                            'mandatory ${state.needsUpdate[index].productDetails?.title} ${state.needsUpdate[index].dropDownKeyForProduct} ');
                        return Column(
                          children: [
                            SizedBox(
                              width: Dimensions.getScreenWidth(),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  if (state.needsUpdate[index].quantity! <
                                      state
                                          .needsUpdate[index].giveAwayCounts!)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.colorPrimaryAccent,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                          '${state.needsUpdate[index].giveAwayCounts! - state.needsUpdate[index].quantity!} more required',
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
                                add(
                                    TriggerSelectVariant(
                                        isFromMBS: true,
                                        selectedValue: val,
                                        index: index,
                                        product: state.needsUpdate));
                              },
                              products: state.needsUpdate[index],
                              onMenuStateChange: (isOpen) {
                                add(
                                    TriggerOpenDropDown(
                                        isAthlete: false,
                                        isOpened: isOpen ?? false));
                              },
                              add: () {
                                add(
                                    TriggerAddSelectedProductToCart(
                                        product: state.needsUpdate[index]));
                              },
                              selectedValueProduct:
                              state.needsUpdate[index].selectedVariant,
                              dropDownKeyForProducts: state
                                  .needsUpdate[index].dropDownKeyForProduct!,
                              isProductDropDownOpened:
                              state.isProductDropDownOpened,
                              reduce: () {
                                add(
                                    TriggerChangeProductQuantity(
                                        isFromMBS: true,
                                        isMinus: true,
                                        index: index,
                                        quantity: state
                                            .needsUpdate[index].quantity!,
                                        product: state.needsUpdate));
                              },
                              increase: () {
                                add(
                                    TriggerChangeProductQuantity(
                                        isFromMBS: true,
                                        isMinus: false,
                                        index: index,
                                        quantity: state
                                            .needsUpdate[index].quantity!,
                                        product: state.needsUpdate));
                              },
                            )
                          ],
                        );
                      },
                    )
                  ],
                ));
          },
        ));
  }

  FutureOr<void> _onTriggerChangeProductQuantity(TriggerChangeProductQuantity event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));
    num quantity = event.quantity;
    if (event.isMinus) {
      if (quantity > 0) {
        quantity = quantity - 1;
      } else {
        quantity = 0;
      }
    }
    else {
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
      // bool isTargetReached = event.product
      //     .every((element) => element.quantity == element.giveAwayCounts!);
      emit(state.copyWith(
          products: allProducts,
          needsUpdate: event.product,
          // willRegister: isTargetReached,
          isRefreshRequired: false));
    } else {
      emit(state.copyWith(products: event.product, isRefreshRequired: false));
    }

    debugPrint('quantity --: ${state.products}');
  }

  FutureOr<void> _onTriggerSelectVariant(TriggerSelectVariant event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));
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
          needsUpdate: event.product,
          willRegister: isTargetReached,
          isRefreshRequired: false));
    }
    else {
      emit(state.copyWith(
          products: event.product,
          selectedValueProduct: event.selectedValue,
          isRefreshRequired: false));
    }
  }

  FutureOr<void> _onTriggerOpenDropDown(TriggerOpenDropDown event, Emitter<RegisterAndSellState> emit) {
    if (!event.isOpened) {
      state.searchController.clear();
      state.otherTeamController.clear();
    }
    if (event.isAthlete) {
      emit(state.copyWith(
          isDropDownOpened: event.isOpened, isRefreshRequired: false));
    } else {
      emit(state.copyWith(
          isProductDropDownOpened: event.isOpened, isRefreshRequired: false));
    }
  }

  FutureOr<void> _onTriggerChangeProductCartQuantity(TriggerChangeProductCartQuantity event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
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
    }
    else {
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

    List<Products>needs = state.needsUpdate;
    for(Products p in needs){
      if(event.product.underscoreId == p.underscoreId){
        p.quantity = event.product.quantity;
        p.isMaxGiveawayAdded = event.product.isMaxGiveawayAdded;
      }
    }
    List<Products> products = state.products;
    for(Products p in products){
      if(event.product.underscoreId == p.underscoreId){
        bool isGiveAway = event.product.productDetails?.isGiveaway ?? false;
        if(isGiveAway){
          p.quantity = event.product.quantity;
          p.isMaxGiveawayAdded = event.product.isMaxGiveawayAdded;
          if (event.product.quantity! < event.product.giveAwayCounts!) {
            p.isMaxGiveawayAdded = null;
            event.product.isMaxGiveawayAdded = null;
          }
        }
      }
    }
    add( TriggerArrangeDataForSummaryT());
    emit(state.copyWith(
      products: products,
      needsUpdate: needs,
        message: AppStrings.global_empty_string,
        isRefreshRequired: false,
        isFailure: false));
  }

  FutureOr<void> _onTriggerAddSelectedProductToCart(TriggerAddSelectedProductToCart event, Emitter<RegisterAndSellState> emit) async {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isFailure: false));

    List<Products> products =
        await processProducts(state.selectedProducts, event.product);
    for (Products p in products) {
      if (event.product.underscoreId == p.underscoreId) {
        bool isMaxed = p.isMaxGiveawayAdded ?? false;
        if (isMaxed) {
          event.product.quantity = 0;
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


    bool isTargetReached = state.needsUpdate
        .every((element)  {
          // print('-TT---${state.needsUpdate}');
          return element.isMaxGiveawayAdded != null;});


    add( TriggerArrangeDataForSummaryT());
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
        isRefreshRequired: false,
        productSum: productSum,
        isFailure: false));
  }

  FutureOr<void> _onTriggerArrangeDataForSummaryT(TriggerArrangeDataForSummaryT event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isFailure: false));


    List<StaffCheckoutRegistrations> registrationForSummary =
        state.registrations;

    List<Products> selectedProducts =
    PurchaseHandlers.updateProductsForRegistration(
        products: state.selectedProducts);

    print('---^$registrationForSummary');
    bool isProductsSelected = selectedProducts.isNotEmpty;

    num registrationSubTotal = registrationForSummary.fold(
        0,
            (previousValue, element)
            {
              num total = element.absolutePrice * element.wcNumbers.length;
              print('total${total} $previousValue');
              return previousValue + double.parse(element.totalPrice.toString());});
    // num reducedSubTotalForRegistration = 0;
    // num nonReducedSubTotalForRegistration = 0;
    // bool isPriceReducedForRegs = false;
    // for (int i = 0; i < registrationForSummary.length; i++) {
    //   if (registrationForSummary[i].reducedPrice != null) {
    //     isPriceReducedForRegs = true;
    //     reducedSubTotalForRegistration =
    //         registrationForSummary[i].reducedPrice! +
    //             reducedSubTotalForRegistration;
    //   }
    // }

    // for (int i = 0; i < registrationForSummary.length; i++) {
    //   if (registrationForSummary[i].reducedPrice == null) {
    //     nonReducedSubTotalForRegistration =
    //         registrationForSummary[i].totalPrice +
    //             nonReducedSubTotalForRegistration;
    //   }
    // }

    num productSubTotal = selectedProducts.fold(
        0, (previousValue, element) => previousValue + element.totalPrice!);


    num totalWithOutCoupon = registrationSubTotal +
        productSubTotal ;
    num transactionFee = 0;
    num totalWithTransactionFee = 0;

    transactionFee = totalWithOutCoupon * globalTransactionFee / 100;
    totalWithTransactionFee = totalWithOutCoupon + transactionFee;

    emit(state.copyWith(
        isProductsSelected: isProductsSelected,
        selectedProducts: selectedProducts,
        productSubTotal:
        StringManipulation.addADollarSign(price: productSubTotal),
        registrationSubTotal:
        StringManipulation.addADollarSign(price: registrationSubTotal),
        totalWithOutCoupon: totalWithOutCoupon,
        athleteSum: registrationSubTotal,
        productSum: productSubTotal,
        isLoading: false,
        isFailure: false,
        transactionFee:
        '${StringManipulation.addADollarSign(price: transactionFee)}',
        totalWithTransactionWithoutCouponFee: totalWithTransactionFee,
        isRefreshRequired: false));
    if (state.couponCode.isNotEmpty) {
      add(TriggerCouponApplicationT(
        ));
    }
    print('sele ${state.selectedProducts}');
  }

  FutureOr<void> _onTriggerCouponApplicationT(TriggerCouponApplicationT event, Emitter<RegisterAndSellState> emit) async {
    emit(state.copyWith(
        isCouponLoading: true,
        couponMessage: AppStrings.global_empty_string,
        isRefreshRequired: false));
    try {
      final response = await CouponDetailsRepository.getCouponDetails(
          couponCode:  state.couponEditingController.text,
          module:  state.couponModule == CouponModules.registration
      ? 'registrations'
          : state.couponModule == CouponModules.tickets
      ? 'tickets'
        : 'season-pass',);
      response.fold(
              (failure) => {
            emit(state.copyWith(
                isLoading: false,
                isCouponLoading: false,
                isRefreshRequired: false,
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
  isRefreshRequired: false));
        debugPrint('couponAmount: $couponAmount $isFix');

      });
    } catch (e) {
      emit(state.copyWith(
          isCouponLoading: false,
          couponMessage: e.toString(),
          isLoading: false,
  isRefreshRequired: false));
    }
  }

  FutureOr<void> _onTriggerCouponRemovalT(TriggerCouponRemovalT event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
      isRefreshRequired: true,
      isLoading: false,
      message: AppStrings.global_empty_string,
    ));
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
        isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerCheckIfApplyActiveT(TriggerCheckIfApplyActiveT event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isFailure: false));
    emit(state.copyWith(
        isApplyButtonActive: state.couponEditingController.text.isNotEmpty,
        isRefreshRequired: false));
  }

  FutureOr<void> _oonTriggerRemoveItemsT(TriggerRemoveItemsT event, Emitter<RegisterAndSellState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isFailure: false));
    emit(state.copyWith(
        selectedProducts: [],
        totalWithTransactionWithCouponFee: 0,
        totalWithTransactionWithoutCouponFee: 0,
        registrations: [],
        message: AppStrings.global_empty_string,
        isRefreshRequired: false,
        isFailure: false));
  }
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
//                 element.selectedVariant == product.selectedVariant);
//             if (hasSameVariant) {
//               Products theProduct = products.firstWhere((element) =>
//                   element.selectedVariant == product.selectedVariant);
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
//                 element.selectedVariant == product.selectedVariant);
//             if (hasSameVariant) {
//               Products theProduct = products.firstWhere((element) =>
//                   element.selectedVariant == product.selectedVariant);
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
//     // if (!productAdded) {
//     //   products.add(product);
//     // }
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
  } else {
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
                for (var p in products
                    .where((p) => (p.underscoreId == product.underscoreId &&
                    p.selectedVariant != product.selectedVariant))) {

                  existingProductQuantity = p.quantity!;
                }
                theProduct.isMaxGiveawayAdded = true;
                theProduct.quantity = product.giveAwayCounts! - existingProductQuantity;
                product.isMaxGiveawayAdded = true;

              }
              else {
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
            } else {
              // Add new variant and update total quantity
              totalQuantity += product.quantity!;
              if (totalQuantity > product.giveAwayCounts!) {
                print(totalQuantity);
                num existingProductQuantity = 0;
                for (var p in products
                    .where((p) => p.underscoreId == product.underscoreId)) {
                  p.isMaxGiveawayAdded = true;
                  existingProductQuantity = p.quantity!;
                }
                print('--%%%%-$existingProductQuantity');
                product.isMaxGiveawayAdded = true;
                product.quantity =
                    product.giveAwayCounts! - existingProductQuantity;
                products.add(product);
              } else {
                if (totalQuantity == product.giveAwayCounts!) {
                  for (var p in products
                      .where((p) => p.underscoreId == product.underscoreId)) {
                    p.isMaxGiveawayAdded = true;
                  }
                  product.isMaxGiveawayAdded = true;
                }
                print(
                    '-------${product.productType} ${product.giveAwayCounts}');
                products.add(product);
              }

              print('different variant logic');
              print('different variant logic');
              print('${product.quantity} logic');
              print('${products[i].quantity} logic');
              print('${product.isMaxGiveawayAdded} logic');
              print('${products[i].isMaxGiveawayAdded} logic');
            }
          } else {
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
