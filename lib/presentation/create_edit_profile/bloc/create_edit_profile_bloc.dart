import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_autocomplete_text_field/model/place_details.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/presentation/athlete_details/bloc/athlete_details_bloc.dart';
import 'package:rmnevents/presentation/authentication/otp/bloc/otp_bloc.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';
import 'package:rmnevents/presentation/home/client_home_bloc/client_home_bloc.dart';
import 'package:rmnevents/presentation/my_athletes/bloc/my_athletes_bloc.dart';
import 'package:rmnevents/presentation/profile/bloc/profile_bloc.dart';
import 'package:rmnevents/presentation/register_and_sell/bloc/register_and_sell_bloc.dart';

import '../../../../imports/common.dart';
import '../../../../imports/data.dart';
import '../../../../root_app.dart';
import '../../../di/di.dart';
import '../../../imports/services.dart';
import '../../../services/shared_preferences_services/athlete_cached_data.dart';
import '../../event_details/bloc/event_details_bloc.dart';
import 'create_edit_profile_handlers.dart';

part 'create_edit_profile_event.dart';

part 'create_edit_profile_state.dart';

part 'create_edit_profile_bloc.freezed.dart';

class CreateEditProfileBloc
    extends Bloc<CreateEditProfileEvent, CreateEditProfileWithInitialState> {
  DataBaseUser? user;

  CreateEditProfileBloc() : super(CreateEditProfileWithInitialState.initial()) {
    on<TriggerInitializationCreateProfileFields>(
        _onTriggerInitializationCreateProfileFields);
    on<TriggerInitializationOfAthleteProfileFields>(
        _onTriggerInitializationOfAthleteProfileFields);
    on<TriggerNavigateToAthlete>(_onTriggerNavigateToAthlete);
    on<TriggerOpenCalendar>(_onTriggerOpenCalendar);
    on<TriggerEditAthleteLocally>(_onTriggerEditAthleteLocally);
    on<TriggerEnableInteractionWithContactField>(
        _onTriggerEnableInteractionWithContactField);
    on<TriggerGenderSelection>(_onTriggerGenderSelection);
    on<TriggerForAddAthleteMBSTappedOutside>(
        _onTriggerForAddAthleteMBSTappedOutside);
    on<TriggerFetchPlaceDetails>(_onTriggerFetchPlaceDetails);
    on<TriggerChangePassword>(_onTriggerChangePassword);
    on<TriggerImageEvent>(_onTriggerImageEvent);
    on<TriggerTeamNameRequest>(_onTriggerTeamNameRequest);
    on<TriggerCreateOwnerProfile>(_onTriggerCreateOwnerProfile);
    on<TriggerCreateAthleteProfile>(_onTriggerCreateAthleteProfile);
    on<TriggerAthleteAccountDeletion>(_onTriggerAthleteAccountDeletion);
    on<TriggerOpenExploreBottomSheet>(_onTriggerOpenExploreBottomSheet);
    on<TriggerCheckForErrorToast>(_onTriggerCheckForErrorToast);
    on<TriggerVerifyEmailChange>(_onTriggerVerifyEmailChange);
    on<TriggerUpdateFieldOnChange>(_onTriggerUpdateFieldOnChange);
    on<TriggerRevealPasswordChecker>(_onTriggerRevealPasswordChecker);
    on<TriggerCheckForUserUpdateButton>(_onTriggerCheckForUserUpdateButton);
    on<TriggerHideUnHideFieldContents>(_onTriggerHideUnHideFieldContents);
    on<TriggerValidateCalenderDate>(_onTriggerValidateCalenderDate);
    on<TriggerCheckZipCodeField>(_onTriggerCheckZipCodeField);
    on<TriggerSwitchToRedshirt>(_onTriggerSwitchToRedshirt);
    on<TriggerCreateAthleteLocally>(_onTriggerCreateAthleteLocally);
    on<TriggerCheckForAddressValidity>(_onTriggerCheckForAddressValidity);
    on<TriggerDeleteLocalAthlete>(_onTriggerDeleteLocalAthlete);
    on<TriggerDropDownSelectionInCreateProfile>(
        _onTriggerDropDownSelectionInCreateProfile);
    on<TriggerGradeSelectionInCreateProfile>(
        _onTriggerGradeSelectionInCreateProfile);
    on<TriggerCheckActivityOfVerifyButton>(
        _onTriggerCheckActivityOfVerifyButton);
    on<TriggerCheckUnCheckParentalInformation>(
        _onTriggerCheckUnCheckParentalInformation);
    on<TriggerCheckChangePasswordActiveState>(
        _onTriggerCheckChangePasswordActiveState);
  }

  FutureOr<void> _onTriggerInitializationCreateProfileFields(
      TriggerInitializationCreateProfileFields event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    emit(CreateEditProfileWithInitialState.initial());
    emit(state.copyWith(isRedshirt: false));
    String firstName = AppStrings.global_empty_string;
    String lastName = AppStrings.global_empty_string;
    String? dob = AppStrings.global_empty_string;
    String bodyWeight = AppStrings.global_empty_string;
    String email = AppStrings.global_empty_string;
    String contactNumber = AppStrings.global_empty_string;
    String postalAddress = AppStrings.global_empty_string;
    String zipCode = AppStrings.global_empty_string;
    String city = AppStrings.global_empty_string;
    String stateOfTheCountry = AppStrings.global_empty_string;
    String imageUrl = AppStrings.global_empty_string;
    String teamId = AppStrings.global_empty_string;
    String label = AppStrings.global_empty_string;
    String title = AppStrings.global_empty_string;
    String gender = AppStrings.global_gender_male;
    String gradeName = AppStrings.global_empty_string;
    String? selectedTeamName;
    bool isSocialId = false;
    bool isRedShirt = false;
    String buttonName = AppStrings.global_empty_string;
    Athlete? athlete;

    emit(state.copyWith(createProfileTypes: event.createProfileTypes));
    String? ownerEmail = await instance<UserCachedData>().getUserEmail();

    if (event.createProfileTypes == CreateProfileTypes.editProfileForOwner) {
      user = await GlobalHandlers.extractUserHandler();
      firstName = user!.firstName.toString();
      String socialId = user?.socialId ?? AppStrings.global_empty_string;
      isSocialId = socialId.isNotEmpty;
      lastName = user!.lastName.toString();
      dob = GlobalHandlers.mmDDYYYYDateFormatHandler(
          dateTime: DateTime.parse(user!.birthDate!));
      email = ownerEmail ?? user!.email.toString();
      contactNumber = user!.phoneNumber.toString();
      postalAddress = user!.mailingAddress.toString();
      zipCode = user!.zipcode.toString();
      city = user!.city ?? AppStrings.global_empty_string;
      stateOfTheCountry = user!.state ?? AppStrings.global_empty_string;
      imageUrl = user!.profile ?? AppStrings.global_empty_string;
      label = user!.label == AppStrings.global_role_user
          ? AppStrings.global_empty_string
          : user!.label!;
      title = AppStrings.profile_EditProfile_title;
      gender = user!.gender ?? AppStrings.global_gender_male;
      buttonName = AppStrings.btn_update;
      await instance<UserCachedData>().removePreselectUserData();
      await instance<UserCachedData>().setUserDataForPreselection(
          email: email,
          phoneNumber: contactNumber,
          address: postalAddress,
          zip: zipCode,
          dob: dob ?? AppStrings.global_empty_string,
          firstName: firstName,
          lastName: lastName);
    }

    if (event.createProfileTypes == CreateProfileTypes.editProfileForAthlete) {
      athlete = navigatorKey.currentContext!
          .read<AthleteDetailsBloc>()
          .state
          .athlete!;

      firstName = athlete.firstName.toString();
      lastName = athlete.lastName.toString();
      if (athlete.grade != null) {
        if (athlete.grade!.isNotEmpty) {
          for (GradeData grade in globalGrades) {
            if (grade.value == athlete.grade) {
              gradeName = grade.name!;
              break;
            }
          }
        }
      }

      isRedShirt = athlete.isRedshirt ?? false;
      dob = athlete.birthDate != null
          ? GlobalHandlers.mmDDYYYYDateFormatHandler(
          dateTime: DateTime.parse(athlete.birthDate!))
          : AppStrings.global_empty_string;
      bodyWeight = athlete.weightClass != null
          ? athlete.weightClass.toString()
          : AppStrings.global_empty_string;
      gender = athlete.gender ?? AppStrings.global_gender_male;
      teamId = athlete.team?.id ?? AppStrings.global_empty_string;
      selectedTeamName = athlete.team?.name;
      athlete.selectedTeam = Team(name: selectedTeamName, id: teamId);
      email = athlete.email != null
          ? athlete.email.toString()
          : AppStrings.global_empty_string;
      contactNumber = athlete.phoneNumber == null
          ? AppStrings.global_empty_string
          : athlete.phoneNumber.toString();
      postalAddress = athlete.mailingAddress == null
          ? AppStrings.global_empty_string
          : athlete.mailingAddress.toString();
      zipCode = athlete.pincode == null
          ? AppStrings.global_empty_string
          : athlete.pincode.toString();
      city = athlete.city ?? AppStrings.global_empty_string;
      stateOfTheCountry = athlete.state ?? AppStrings.global_empty_string;
      imageUrl = athlete.profileImage ?? AppStrings.global_empty_string;
      title = AppStrings.profile_editAthlete_title;
      label = athlete.userStatus == TypeOfAccess.owner.name
          ? 'Owner'
          : athlete.userStatus == TypeOfAccess.view.name
          ? 'Viewer'
          : athlete.userStatus == TypeOfAccess.coach.name
          ? 'Coach'
          : AppStrings.global_empty_string;
      buttonName = AppStrings.btn_update;
      await instance<AthleteCachedData>().removePreselectAthleteData();
      await instance<AthleteCachedData>().setAthleteDataForPreselection(
          email: email,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: contactNumber,
          address: postalAddress,
          zip: zipCode,
          grade: gradeName,
          isRedShirt: isRedShirt,
          dob: dob ?? AppStrings.global_empty_string,
          wc: bodyWeight,
          teamName: selectedTeamName ?? AppStrings.global_empty_string,
          teamId: teamId,
          gender: gender == AppStrings.global_gender_male ? 0 : 1);
    }
    if (event.createProfileTypes == CreateProfileTypes.editAthleteLocally) {
      List<Athlete> athletes = navigatorKey.currentContext!
          .read<RegisterAndSellBloc>()
          .state
          .athletes;
      // List<String> createdProfileModules =
      //     instance<AthleteCachedData>().getAthleteListJson() ?? [];
      // if (createdProfileModules.isNotEmpty) {
      //   List<CreateProfileRequestModel> profiles = createdProfileModules
      //       .map((athleteJson) =>
      //           CreateProfileRequestModel.fromJson(jsonDecode(athleteJson)))
      //       .toList();
      //   athletes = profiles.map((profile) {
      //     debugPrint('profile ${profile.gradeValue}');
      //     return Athlete(
      //       firstName: profile.firstName,
      //       lastName: profile.lastName,
      //       email: profile.email,
      //       birthDate: profile.birthDate,
      //       age: DateTime.now().year -
      //           int.parse(profile.birthDate.split('/').first),
      //       weight: profile.weight,
      //       weightClass: profile.weight,
      //       phoneNumber: num.parse(profile.contactNumber),
      //       city: profile.city,
      //       state: profile.stateName,
      //       grade: profile.gradeValue,
      //       pincode: num.parse(profile.zipCode),
      //       mailingAddress: profile.address,
      //       team: Team(
      //           name: state.selectedTeam ?? AppStrings.global_no_team,
      //           id: profile.teamId),
      //       gender: profile.gender,
      //       isRedshirt: profile.isRedshirt,
      //       underscoreId: profile.athleteId,
      //       id: profile.athleteId,
      //       fileImage: profile.profileImage,
      //       profileImage: profile.profileImage?.path,
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

      for (int i = 0; i < athletes.length; i++) {
        if (athletes[i].underscoreId.toString() == event.athleteId.toString()) {
          athlete = athletes[i];
          break;
        }
      }

      firstName = athlete!.firstName.toString();
      lastName = athlete.lastName.toString();
      gradeName = athlete.grade ?? AppStrings.global_empty_string;
      debugPrint('profile I $gradeName');
      if (gradeName.isNotEmpty) {
        for (GradeData grade in globalGrades) {
          if (grade.value == gradeName) {
            gradeName = grade.name!;
            break;
          }
        }
      }
      isRedShirt = athlete.isRedshirt ?? false;
      dob =
          GlobalHandlers.reverseToMonthDateYear(dateString: athlete.birthDate!);
      bodyWeight = athlete.weightClass != null
          ? athlete.weightClass.toString()
          : AppStrings.global_empty_string;
      gender = athlete.gender ?? AppStrings.global_gender_male;
      teamId = athlete.team?.id ?? AppStrings.global_empty_string;
      selectedTeamName = athlete.team?.name;
      athlete.selectedTeam = Team(name: selectedTeamName, id: teamId);
      email = athlete.email != null
          ? athlete.email.toString()
          : AppStrings.global_empty_string;
      contactNumber = athlete.phoneNumber == null
          ? AppStrings.global_empty_string
          : athlete.phoneNumber.toString();
      postalAddress = athlete.mailingAddress == null
          ? AppStrings.global_empty_string
          : athlete.mailingAddress.toString();
      zipCode = athlete.pincode == null
          ? AppStrings.global_empty_string
          : athlete.pincode.toString();
      city = athlete.city ?? AppStrings.global_empty_string;
      stateOfTheCountry = athlete.state ?? AppStrings.global_empty_string;
      imageUrl = athlete.profileImage ?? AppStrings.global_empty_string;
      title = AppStrings.profile_editAthlete_title;
      label = athlete.userStatus == TypeOfAccess.owner.name
          ? 'Owner'
          : athlete.userStatus == TypeOfAccess.view.name
          ? 'Viewer'
          : athlete.userStatus == TypeOfAccess.coach.name
          ? 'Coach'
          : AppStrings.global_empty_string;
      buttonName = AppStrings.btn_update;
      await instance<AthleteCachedData>().removePreselectAthleteData();
      await instance<AthleteCachedData>().setAthleteDataForPreselection(
          email: email,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: contactNumber,
          address: postalAddress,
          zip: zipCode,
          grade: gradeName,
          isRedShirt: isRedShirt,
          dob: dob,
          wc: bodyWeight,
          teamName: selectedTeamName ?? AppStrings.global_empty_string,
          teamId: teamId,
          gender: gender == AppStrings.global_gender_male ? 0 : 1);
    }

    if (event.createProfileTypes == CreateProfileTypes.createProfileForOwner) {
      title = AppStrings.profile_createOwner_title;
      buttonName = AppStrings.btn_create;
      email = ownerEmail ?? AppStrings.global_empty_string;
      firstName =
          await instance<UserCachedData>().getUserName(isFirstName: true) ??
              AppStrings.global_empty_string;
      lastName =
          await instance<UserCachedData>().getUserName(isFirstName: false) ??
              AppStrings.global_empty_string;
      imageUrl = await instance<UserCachedData>().getUserPhoto() ??
          AppStrings.global_empty_string;
    }
    if (event.createProfileTypes ==
        CreateProfileTypes.addAthleteFromRegistrationSelection ||
        event.createProfileTypes ==
            CreateProfileTypes.addAthleteAfterCreateProfile ||
        event.createProfileTypes == CreateProfileTypes.addAthleteFromMyList ||
        event.createProfileTypes == CreateProfileTypes.createAthleteLocally ||
        event.createProfileTypes ==
            CreateProfileTypes.createAthleteLocallyFromRegs) {
      title = AppStrings.profile_createAthlete_title;
      buttonName = AppStrings.btn_addAthlete;
    }
    emit(
      state.copyWith(
          athlete: athlete,
          createProfileTypes: event.createProfileTypes,
          isAthleteEdited: false,
          emailEditingController: TextEditingController(text: email),
          changeEmailEditingController: TextEditingController(text: ownerEmail),
          firstNameEditingController: TextEditingController(text: firstName),
          lastNameEditingController: TextEditingController(text: lastName),
          dateOfBirthEditingController: TextEditingController(text: dob),
          contactNumberEditingController:
          TextEditingController(text: contactNumber),
          selectedTeam: selectedTeamName,
          selectedGrade: gradeName.isEmpty ? null : gradeName,
          zipCodeEditingController: TextEditingController(text: zipCode),
          postalAddressEditingController:
          TextEditingController(text: postalAddress),
          weightEditingController: TextEditingController(text: bodyWeight),
          state: stateOfTheCountry,
          isUpdateBtnActive: false,
          city: city,
          buttonName: buttonName,
          isRedshirt: isRedShirt,
          title: title,
          label: label,
          zipError: event.createProfileTypes ==
              CreateProfileTypes.editProfileForAthlete
              ? TextFieldValidators.validateZip(value: zipCode)
              : null,
          zipCodeFocusNode: FocusNode(),
          isSocialId: isSocialId,
          isLoading: false,
          radioButtonIndex: gender == AppStrings.global_gender_male ? 0 : 1,
          teamId: teamId,
          imageUrl: imageUrl),
    );
    if (event.createProfileTypes == CreateProfileTypes.editProfileForAthlete ||
        event.createProfileTypes == CreateProfileTypes.editProfileForOwner) {
      add(TriggerCheckForAddressValidity());
    }
  }

  FutureOr<void> _onTriggerCheckUnCheckParentalInformation(
      TriggerCheckUnCheckParentalInformation event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    bool isGuardian = !state.isGuardian;
    DataBaseUser user = await GlobalHandlers.extractUserHandler();
    String? ownerEmail = await instance<UserCachedData>().getUserEmail();

    String email = AppStrings.global_empty_string;
    String contactNumber = AppStrings.global_empty_string;
    String postalAddress = AppStrings.global_empty_string;
    String zipCode = AppStrings.global_empty_string;
    String stateOfTheCountry = AppStrings.global_empty_string;
    String city = AppStrings.global_empty_string;
    if (state.createProfileTypes == CreateProfileTypes.editProfileForAthlete) {
      Athlete athlete = navigatorKey.currentContext!
          .read<AthleteDetailsBloc>()
          .state
          .athlete!;
      email = athlete.email.toString();
      contactNumber = athlete.phoneNumber.toString();
      postalAddress = athlete.mailingAddress.toString();
      zipCode = athlete.pincode.toString();
      city = athlete.city ?? AppStrings.global_empty_string;
      stateOfTheCountry = athlete.state ?? AppStrings.global_empty_string;
    }

    if (state.createProfileTypes == CreateProfileTypes.editAthleteLocally ||
        state.createProfileTypes == CreateProfileTypes.createAthleteLocally) {
      RegisterAndSellState r =
          navigatorKey.currentContext!.read<RegisterAndSellBloc>().state;
      emit(state.copyWith(
          isGuardian: isGuardian,
          isExploreOpened: false,
          emailEditingController: isGuardian
              ? TextEditingController(text: r.emailController.text)
              : TextEditingController(text: email),
          contactNumberEditingController: isGuardian
              ? TextEditingController(text: r.phoneController.text)
              : TextEditingController(text: contactNumber),
          postalAddressEditingController: isGuardian
              ? TextEditingController(text: r.postalAddressController.text)
              : TextEditingController(text: postalAddress),
          zipCodeEditingController: isGuardian
              ? TextEditingController(text: r.zipCodeController.text)
              : TextEditingController(text: zipCode),
          state: isGuardian ? r.stateName : stateOfTheCountry,
          city: isGuardian ? r.city : city,
          isRefreshRequired: false,
          zipError: null
        // isContactNumberValid: isGuardian
        //     ? TextFieldValidators.validateContactNumber(value: user.phoneNumber!) == null
        //     : TextFieldValidators.validateContactNumber(value: contactNumber) == null,
        // zipError: isGuardian
        //     ? TextFieldValidators.validateZip(value: user.zipcode!)
        //     : TextFieldValidators.validateZip(value: zipCode),
      ));
    } else {
      emit(state.copyWith(
          isGuardian: isGuardian,
          isExploreOpened: false,
          emailEditingController: isGuardian
              ? TextEditingController(text: ownerEmail ?? user.email)
              : TextEditingController(text: email),
          contactNumberEditingController: isGuardian
              ? TextEditingController(text: user.phoneNumber)
              : TextEditingController(text: contactNumber),
          postalAddressEditingController: isGuardian
              ? TextEditingController(text: user.mailingAddress)
              : TextEditingController(text: postalAddress),
          zipCodeEditingController: isGuardian
              ? TextEditingController(text: user.zipcode)
              : TextEditingController(text: zipCode),
          state: isGuardian ? user.state! : stateOfTheCountry,
          city: isGuardian ? user.city! : city,
          isRefreshRequired: false,
          zipError: null
        // isContactNumberValid: isGuardian
        //     ? TextFieldValidators.validateContactNumber(value: user.phoneNumber!) == null
        //     : TextFieldValidators.validateContactNumber(value: contactNumber) == null,
        // zipError: isGuardian
        //     ? TextFieldValidators.validateZip(value: user.zipcode!)
        //     : TextFieldValidators.validateZip(value: zipCode),
      ));
    }
    add(TriggerCheckForAddressValidity());
    add(TriggerCheckForUserUpdateButton(
        isOwner: state.createProfileTypes ==
            CreateProfileTypes.editProfileForOwner));
  }

  FutureOr<void> _onTriggerInitializationOfAthleteProfileFields(
      TriggerInitializationOfAthleteProfileFields event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    emit(CreateEditProfileWithInitialState.initial());
    emit(state.copyWith(
        isAddAthleteSelected: true,
        isExploreOpened: false,
        isProfileCreated: false,
        isLoading: false,
        isRefreshRequired: false,
        formKey: GlobalKey<FormState>(),
        title:
        event.createProfileTypes == CreateProfileTypes.editProfileForAthlete
            ? AppStrings.profile_editAthlete_title
            : AppStrings.profile_createAthlete_title,
        buttonName: AppStrings.btn_addAthlete,
        createProfileTypes: event.createProfileTypes));
  }

  FutureOr<void> _onTriggerOpenCalendar(TriggerOpenCalendar event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);

    DateTime? datePicked = await GlobalHandlers.datePickerHandler(
        initialDate: state.dateOfBirthEditingController.text,
        context: navigatorKey.currentState!.context);
    String? dateFormatted =
    GlobalHandlers.mmDDYYYYDateFormatHandler(dateTime: datePicked);
    TextEditingController dateOfBirthEditingController =
    TextEditingController(text: state.dateOfBirthEditingController.text);

    if (dateFormatted != null) {
      dateOfBirthEditingController = TextEditingController(text: dateFormatted);
      emit(state.copyWith(
          dateOfBirthEditingController: dateOfBirthEditingController));
    }

    String? dateError = TextFieldValidators.validateBirthday(
        ageType: event.ageType,
        birthDay: dateFormatted ?? state.dateOfBirthEditingController.text);

    emit(state.copyWith(
      isRefreshRequired: false,
      dateError: dateError,
    ));
    add(TriggerCheckForUserUpdateButton(
        dob: true,
        isOwner: state.createProfileTypes ==
            CreateProfileTypes.editProfileForOwner));
  }

  FutureOr<void> _onTriggerEnableInteractionWithContactField(
      TriggerEnableInteractionWithContactField event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    String? isValid = TextFieldValidators.validateContactNumber(
        value: state.contactNumberEditingController.text);
    debugPrint(
        'isValid ${TextFieldValidators.validateZip(
            value: state.zipCodeEditingController.text)}');
    emit(state.copyWith(
        gradeError: state.gradeValue.isEmpty ? 'Grade is required' : null,
        zipError: TextFieldValidators.validateZip(
            value: state.zipCodeEditingController.text),
        isContactNumberValid: isValid == null,
        isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerGenderSelection(TriggerGenderSelection event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
      isRefreshRequired: false,
      radioButtonIndex: event.index,
    ));
  }

  FutureOr<void> _onTriggerFetchPlaceDetails(TriggerFetchPlaceDetails event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    FocusManager.instance.primaryFocus?.unfocus();
    CreateProfileHandlers.emitWithLoader(emit: emit, state: state);
    String zipCode,
        cityName,
        stateName = AppStrings.global_empty_string;
    try {
      final response = await GooglePlacesRepository.getGooglePlaceApi(
          placeId: event.prediction.placeId!);
      response.fold((failure) {
        emit(state.copyWith(
          isRefreshRequired: false,
          message: failure.message,
          isLoading: false,
        ));
      }, (success) {
        List<AddressComponents> addressComponents =
            success.result!.addressComponents ?? [];
        zipCode = CreateProfileHandlers.zipCodeHandler(
            addressComponents: addressComponents);
        cityName = CreateProfileHandlers.cityNameHandler(
            addressComponents: addressComponents);
        stateName = CreateProfileHandlers.stateNameHandler(
            addressComponents: addressComponents);
        String? zipError = TextFieldValidators.validateZip(value: zipCode);
        String? validateAddress = TextFieldValidators.validatePostalAddress(
            address:
            event.prediction.description ?? AppStrings.global_empty_string,
            city: cityName);

        emit(state.copyWith(
          postalAddressEditingController:
          TextEditingController(text: event.prediction.description),
          isRefreshRequired: false,
          isLoading: false,
          zipError: zipError,
          city: cityName,
          postalAddressError: validateAddress,
          state: stateName,
          zipCodeEditingController: TextEditingController(text: zipCode),
        ));
        add(TriggerCheckForUserUpdateButton(
            isOwner: state.createProfileTypes ==
                CreateProfileTypes.editProfileForOwner));
        if (event.isFromRegisterAndSell) {
          BlocProvider.of<RegisterAndSellBloc>(navigatorKey.currentContext!)
              .add(TriggerRetrieveGoogleCityInfo(
            city: cityName,
            state: stateName,
            zip: zipCode,
            address: event.prediction.description!,
          ));
        }
      });
    } catch (e) {
      emit(state.copyWith(
        isRefreshRequired: false,
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerImageEvent(TriggerImageEvent event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    String? message;
    bool result = false;
    File? file =
    await CreateProfileHandlers.cameraHandler(isFromCamera: event.isCamera);
    if (file != null) {
      message = MediaManager.validateImageSize(file: file);
      result = GlobalHandlers.imageUploadHandler(file: file);
    }
    if (kDebugMode) {
      print('result $result $file');
    }
    emit(state.copyWith(
      isRefreshRequired: false,
      file: result ? null : file,
      isUpdateBtnActive: !result,
      isFailure: result,
      message: message ?? AppStrings.global_empty_string,
    ));
  }

  FutureOr<void> _onTriggerCreateOwnerProfile(TriggerCreateOwnerProfile event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    String? zipError = TextFieldValidators.validateZip(
        value: state.zipCodeEditingController.text);
    String? dateError = TextFieldValidators.validateBirthday(
        ageType: AgeType.owner,
        birthDay: state.dateOfBirthEditingController.text);
    if (zipError != null || dateError != null) {
      emit(state.copyWith(
        isRefreshRequired: false,
        zipError: zipError,
      ));
    } else {
      CreateProfileHandlers.emitWithLoader(emit: emit, state: state);
      emit(state.copyWith(isLoading: true));
      try {
        final response = await OwnerProfileRepository.createOwnerProfile(
            createOwnerProfileRequestModel: CreateProfileRequestModel(
                isCreateProfile: event.isCreateProfile,
                gradeValue: AppStrings.global_empty_string,
                isRedshirt: false,
                firstName: GlobalHandlers.dataEncryptionHandler(
                    value: state.firstNameEditingController.text.trim()),
                lastName: GlobalHandlers.dataEncryptionHandler(
                    value: state.lastNameEditingController.text.trim()),
                birthDate: GlobalHandlers.dataEncryptionHandler(
                  value: GlobalHandlers.yyyyMMddDateFormatHandler(
                      dateString:
                      state.dateOfBirthEditingController.text.trim()),
                ),
                phoneCode: GlobalHandlers.dataEncryptionHandler(
                    value: AppStrings.global_phone_code),
                contactNumber: GlobalHandlers.dataEncryptionHandler(
                    value: state.contactNumberEditingController.text.trim()),
                address: GlobalHandlers.dataEncryptionHandler(
                    value: state.postalAddressEditingController.text.trim()),
                profileImage: state.file,
                athleteFlag: AppStrings.global_owner_flag,
                gender: state.radioButtonIndex == 0
                    ? GlobalHandlers.dataEncryptionHandler(
                    value: AppStrings.global_gender_male)
                    : GlobalHandlers.dataEncryptionHandler(
                    value: AppStrings.global_gender_female),
                zipCode: GlobalHandlers.dataEncryptionHandler(
                    value: state.zipCodeEditingController.text.trim()),
                isPolicyAccepted: true,
                city: state.city.isNotEmpty
                    ? GlobalHandlers.dataEncryptionHandler(value: state.city)
                    : AppStrings.global_empty_string,
                stateName: state.state.isNotEmpty
                    ? GlobalHandlers.dataEncryptionHandler(value: state.state)
                    : AppStrings.global_empty_string));
        response.fold((failure) {
          emit(state.copyWith(
            isFailure: true,
            isLoading: false,
            isRefreshRequired: false,
            message: failure.message,
          ));
        }, (success) async {
          user = success.responseData!.user!;
          if (event.isCreateProfile) {
            emit(state.copyWith(
              isFailure: false,
              isLoading: false,
              isProfileCreated: event.isCreateProfile,
              message: success.responseData?.message ??
                  AppStrings.global_empty_string,
            ));
          } else {
            emit(state.copyWith(
              isFailure: false,
              isLoading: false,
              isUpdateBtnActive: false,
              isRefreshRequired: false,
              isProfileCreated: event.isCreateProfile,
              firstNameEditingController:
              TextEditingController(text: user!.firstName),
              dateOfBirthEditingController: TextEditingController(
                  text: GlobalHandlers.mmDDYYYYDateFormatHandler(
                      dateTime: DateTime.parse(user!.birthDate!))),
              lastNameEditingController:
              TextEditingController(text: user!.lastName),
              contactNumberEditingController:
              TextEditingController(text: user!.phoneNumber),
              postalAddressEditingController:
              TextEditingController(text: user!.mailingAddress),
              message: success.responseData?.message ??
                  AppStrings.global_empty_string,
            ));
            await instance<UserCachedData>().removePreselectUserData();
            await instance<UserCachedData>().setUserDataForPreselection(
                email: user!.email!,
                phoneNumber: user!.phoneNumber!,
                address: user!.mailingAddress!,
                zip: user!.zipcode!,
                dob: GlobalHandlers.mmDDYYYYDateFormatHandler(
                    dateTime: DateTime.parse(user!.birthDate!)) ??
                    AppStrings.global_empty_string,
                firstName: user!.firstName!,
                lastName: user!.lastName!);
            Navigator.pop(navigatorKey.currentContext!);
          }
        });
      } catch (error) {
        emit(state.copyWith(
          isFailure: true,
          isLoading: false,
          isRefreshRequired: false,
          message: error.toString(),
        ));
      }
    }
  }

  FutureOr<void> _onTriggerCreateAthleteProfile(
      TriggerCreateAthleteProfile event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));

    String? zipError = TextFieldValidators.validateZip(
        value: state.zipCodeEditingController.text);
    if (zipError != null || state.gradeValue.isEmpty) {
      emit(state.copyWith(
        isRefreshRequired: false,
        zipError: zipError,
      ));
    } else {
      emit(state.copyWith(isCreateButtonActive: false, isLoading: true));
      String athleteId = AppStrings.global_empty_string;
      bool isProfileCreated = true;
      if (state.createProfileTypes ==
          CreateProfileTypes.editProfileForAthlete) {
        isProfileCreated = false;
        athleteId = state.athlete!.underscoreId!;
      }
      try {
        final response = await AthleteRepository.createAthlete(
            createProfileRequestModel: CreateProfileRequestModel(
              isRedshirt: state.isRedshirt ?? false,
              gradeValue: state.gradeValue,
              athleteId: athleteId,
              isCreateProfile: isProfileCreated,
              firstName: state.firstNameEditingController.text.trim(),
              lastName: state.lastNameEditingController.text.trim(),
              email: state.emailEditingController.text.trim(),
              birthDate: GlobalHandlers.yyyyMMddDateFormatHandler(
                  dateString: state.dateOfBirthEditingController.text.trim()),
              weight: state.weightEditingController.text.trim(),
              phoneCode: AppStrings.global_phone_code,
              contactNumber: state.contactNumberEditingController.text.trim(),
              gender: state.radioButtonIndex == 0
                  ? AppStrings.global_gender_male
                  : AppStrings.global_gender_female,
              address: state.postalAddressEditingController.text.trim(),
              zipCode: state.zipCodeEditingController.text.trim(),
              city: state.city,
              stateName: state.state,
              profileImage: state.file,
              athleteFlag: AppStrings.global_athlete_flag,
              isUserParent: state.isGuardian.toString(),
              teamId: state.athlete != null
                  ? (state.athlete?.selectedTeam?.id ?? '0')
                  : state.teamId,
            ));
        response.fold((failure) {
          emit(state.copyWith(
            isFailure: true,
            isLoading: false,
            isRefreshRequired: false,
            message: failure.message,
          ));
        }, (success) async {
          emit(state.copyWith(
            isFailure: false,
            isLoading: false,
            isRefreshRequired: false,
            isUpdateBtnActive: false,
            isAthleteEdited: state.createProfileTypes ==
                CreateProfileTypes.editProfileForAthlete
                ? true
                : false,
            isProfileCreated: state.createProfileTypes ==
                CreateProfileTypes.createProfileForOwner,
            message:
            success.responseData?.message ?? AppStrings.global_empty_string,
          ));
          if (state.createProfileTypes ==
              CreateProfileTypes.addAthleteAfterCreateProfile) {
            BlocProvider.of<ProfileBloc>(navigatorKey.currentContext!)
                .add(const TriggerUpdateProfile());
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                AppRouteNames.routeBase, (route) => false,
                arguments: true);
          }
          if (state.createProfileTypes ==
              CreateProfileTypes.addAthleteFromMyList) {
            BlocProvider.of<MyAthletesBloc>(navigatorKey.currentContext!).add(
                TriggerFetchAthletes(
                    searchKey: AppStrings.global_empty_string,
                    page: 1,
                    athletes: const [],
                    isSearch: false,
                    selectedTabIndex: 0,
                    isNewTab: AthleteApiCallType.newTab));
            add(const TriggerInitializationOfAthleteProfileFields(
                createProfileTypes: CreateProfileTypes.addAthleteFromMyList));
            BlocProvider.of<ProfileBloc>(navigatorKey.currentContext!)
                .add(const TriggerUpdateProfile());
            BlocProvider.of<ClientHomeBloc>(navigatorKey.currentContext!)
                .add(TriggerHomeDataFetch());
            Navigator.pop(navigatorKey.currentContext!);
          }
          if (state.createProfileTypes ==
              CreateProfileTypes.addAthleteFromRegistrationSelection) {
            int divIndex = navigatorKey.currentContext!
                .read<EventDetailsBloc>()
                .state
                .parentIndex;
            int ageGroupIndex = navigatorKey.currentContext!
                .read<EventDetailsBloc>()
                .state
                .childIndex;
            BlocProvider.of<EventDetailsBloc>(navigatorKey.currentContext!).add(
                TriggerFetchEventWiseAthletes(
                    divIndex: divIndex,
                    childIndex: ageGroupIndex,
                    isEnteringPurchaseView: CouponModules.registration,
                    eventId: globalEventResponseData!.event!.id!));
            // BlocProvider.of<EventDetailsBloc>(navigatorKey.currentContext!).add(
            //     TriggerFetchEventDetails(
            //         eventId: globalEventResponseData!.event!.id!,
            //         divIndex: divIndex,
            //         isEnteringPurchaseView: CouponModules.registration,
            //         childIndex: ageGroupIndex));
            BlocProvider.of<ProfileBloc>(navigatorKey.currentContext!)
                .add(const TriggerUpdateProfile());
            BlocProvider.of<ClientHomeBloc>(navigatorKey.currentContext!)
                .add(TriggerHomeDataFetch());
            Navigator.pop(navigatorKey.currentContext!);
          }
          if (state.createProfileTypes ==
              CreateProfileTypes.editProfileForAthlete) {
            String athleteId = navigatorKey.currentContext!
                .read<AthleteDetailsBloc>()
                .state
                .athlete!
                .underscoreId!;
            String seasonId = navigatorKey.currentContext!
                .read<AthleteDetailsBloc>()
                .state
                .seasonId;
            BlocProvider.of<AthleteDetailsBloc>(navigatorKey.currentContext!)
                .add(TriggerAthleteDetailsFetch(
              seasons: globalSeasons,
              athleteId: athleteId,
              seasonId: seasonId,
            ));
            await instance<AthleteCachedData>().removePreselectAthleteData();
            await instance<AthleteCachedData>().setAthleteDataForPreselection(
                gender: success.responseData!.data!.gender ==
                    AppStrings.global_gender_male
                    ? 0
                    : 1,
                isRedShirt: success.responseData!.data!.isRedshirt!,
                grade: success.responseData!.data?.grade ??
                    AppStrings.global_empty_string,
                email: success.responseData!.data!.email!,
                firstName: success.responseData!.data!.firstName!,
                lastName: success.responseData!.data!.lastName!,
                phoneNumber:
                success.responseData!.data!.phoneNumber!.toString(),
                address: success.responseData!.data!.mailingAddress!,
                zip: success.responseData!.data!.pincode!.toString(),
                dob: GlobalHandlers.mmDDYYYYDateFormatHandler(
                    dateTime: DateTime.parse(
                        success.responseData!.data!.birthDate!)) ??
                    AppStrings.global_empty_string,
                wc: success.responseData!.data!.weight!.toString(),
                teamName: state.selectedTeam ?? AppStrings.global_empty_string,
                teamId: success.responseData!.data!.teamId!);
            Navigator.pop(navigatorKey.currentContext!);
            BlocProvider.of<MyAthletesBloc>(navigatorKey.currentContext!)
                .add(TriggerCleanScreen());
            BlocProvider.of<MyAthletesBloc>(navigatorKey.currentContext!).add(
                TriggerFetchAthletes(
                    searchKey: AppStrings.global_empty_string,
                    page: 1,
                    athletes: const [],
                    isSearch: false,
                    isRequestClearTime: false,
                    selectedTabIndex: 0,
                    isNewTab: AthleteApiCallType.newTab));
            // BlocProvider.of<MyAthletesBloc>(context).add(TriggerCheckForRequests(
            //     ));
          }
        });
      } catch (e) {
        emit(state.copyWith(
          isFailure: true,
          isLoading: false,
          isRefreshRequired: false,
          message: e.toString(),
        ));
      }
    }
  }

  FutureOr<void> _onTriggerOpenExploreBottomSheet(
      TriggerOpenExploreBottomSheet event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
        isRefreshRequired: false,
        isProfileCreated: false,
        isExploreOpened: true));
  }

  FutureOr<void> _onTriggerForAddAthleteMBSTappedOutside(
      TriggerForAddAthleteMBSTappedOutside event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
        isExploreOpened: state.isAddAthleteSelected ? false : true,
        isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerCheckActivityOfVerifyButton(
      TriggerCheckActivityOfVerifyButton event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    String? isEmailValid = TextFieldValidators.validateEmail(
        state.changeEmailEditingController.text);
    bool isButtonActive = isEmailValid == null &&
        state.emailEditingController.text.trim() !=
            state.changeEmailEditingController.text.trim();
    emit(state.copyWith(
        isVerifyBtnActive: isButtonActive, isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerVerifyEmailChange(TriggerVerifyEmailChange event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    CreateProfileHandlers.emitWithLoader(emit: emit, state: state);
    try {
      final response = await OwnerProfileRepository.changeEmail(
          email: GlobalHandlers.dataEncryptionHandler(
              value: state.changeEmailEditingController.text));
      response.fold((failure) {
        emit(state.copyWith(
          isFailure: true,
          isLoading: false,
          isVerifyBtnActive: false,
          message: failure.message,
        ));
      }, (success) {
        emit(state.copyWith(
          isFailure: false,
          isLoading: false,
          emailEditingController: TextEditingController(
              text: state.changeEmailEditingController.text),
          isVerifyBtnActive: false,
          message:
          success.responseData?.message ?? AppStrings.global_empty_string,
        ));
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          AppRouteNames.routeOtp,
          arguments: OtpArgument(
            encryptedUserId:
            GlobalHandlers.dataEncryptionHandler(value: user!.id!),
            userEmail: state.changeEmailEditingController.text,
            isFromChangeEmail: true,
          ),
        ).then((value) {
          add(TriggerInitializationCreateProfileFields(
              createProfileTypes: CreateProfileTypes.editProfileForOwner));
        });
      });
    } catch (e) {
      emit(state.copyWith(
        isFailure: true,
        isVerifyBtnActive: false,
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerChangePassword(TriggerChangePassword event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    CreateProfileHandlers.emitWithLoader(emit: emit, state: state);
    try {
      final response = await OwnerProfileRepository.changePassword(
          oldPassword: GlobalHandlers.dataEncryptionHandler(
              value: state.oldPasswordController.text),
          newPassword: GlobalHandlers.dataEncryptionHandler(
              value: state.confirmPasswordController.text));
      response.fold((failure) {
        emit(state.copyWith(
          isFailure: true,
          isLoading: false,
          message: failure.message,
        ));
      }, (success) {
        emit(state.copyWith(
          isFailure: false,
          isLoading: false,
          message:
          success.responseData?.message ?? AppStrings.global_empty_string,
          confirmPasswordController: TextEditingController(),
          oldPasswordController: TextEditingController(),
          newPasswordController: TextEditingController(),
          newFocusNode: FocusNode(),
          oldFocusNode: FocusNode(),
          confirmFocusNode: FocusNode(),
          isPasswordCheckerHidden: true,
          formKeyForChangePassword: GlobalKey<FormState>(),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        isFailure: true,
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerDropDownSelectionInCreateProfile(
      TriggerDropDownSelectionInCreateProfile event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    String teamId = AppStrings.global_empty_string;

    for (Team team in event.teams) {
      if (team.name == event.selectedValue) {
        teamId = team.id!;
        if (event.athlete != null) {
          event.athlete!.selectedTeam = Team(name: team.name, id: team.id);
        }
      }
    }
    emit(state.copyWith(
        teamId: teamId,
        athlete: event.athlete,
        selectedTeam: event.selectedValue,
        isRefreshRequired: false));
    if (state.createProfileTypes == CreateProfileTypes.editProfileForAthlete ||
        state.createProfileTypes == CreateProfileTypes.editAthleteLocally) {
      add(TriggerCheckForUserUpdateButton(isOwner: false));
    }
  }

  FutureOr<void> _onTriggerGradeSelectionInCreateProfile(
      TriggerGradeSelectionInCreateProfile event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    String gradeValue = AppStrings.global_empty_string;
    for (GradeData grade in event.grades) {
      if (grade.name == event.selectedValue) {
        gradeValue = grade.value!;
        if (event.athlete != null) {
          event.athlete!.selectedGrade =
              GradeData(name: grade.name, value: grade.value);
        }
      }
    }
    emit(state.copyWith(
        gradeError: gradeValue.isEmpty ? 'Grade is required' : null,
        gradeValue: gradeValue,
        athlete: event.athlete,
        selectedGrade: event.selectedValue,
        isRefreshRequired: false));
    if (state.createProfileTypes == CreateProfileTypes.editProfileForAthlete ||
        state.createProfileTypes == CreateProfileTypes.editAthleteLocally) {
      add(TriggerCheckForUserUpdateButton(isOwner: false));
    }
  }

  FutureOr<void> _onTriggerAthleteAccountDeletion(
      TriggerAthleteAccountDeletion event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    CreateProfileHandlers.emitWithLoader(emit: emit, state: state);
    Navigator.pop(navigatorKey.currentContext!);
    try {
      final response = await AthleteRepository.deleteAthleteAccount(
          athleteId: event.athleteId);
      response.fold((failure) {
        emit(state.copyWith(
          isFailure: true,
          isLoading: false,
          message: failure.message,
        ));
      }, (success) {
        emit(state.copyWith(
          isFailure: false,
          isLoading: false,
          message:
          success.responseData?.message ?? AppStrings.global_empty_string,
        ));
        Navigator.pop(navigatorKey.currentContext!, false);
        Navigator.pop(
          navigatorKey.currentContext!,
        );
        BlocProvider.of<MyAthletesBloc>(navigatorKey.currentContext!).add(
            TriggerFetchAthletes(
                searchKey: AppStrings.global_empty_string,
                page: 1,
                athletes: const [],
                isSearch: false,
                selectedTabIndex: 0,
                isNewTab: AthleteApiCallType.newTab));
        BlocProvider.of<ProfileBloc>(navigatorKey.currentContext!)
            .add(const TriggerUpdateProfile());
      });
    } catch (e) {
      emit(state.copyWith(
        isFailure: true,
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerTeamNameRequest(TriggerTeamNameRequest event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    CreateProfileHandlers.emitWithLoader(emit: emit, state: state);
    Navigator.pop(navigatorKey.currentContext!);
    try {
      final response =
      await AthleteRepository.teamNameRequest(teamName: event.teamName);
      response.fold((failure) {
        emit(state.copyWith(
          isFailure: true,
          isLoading: false,
          message: failure.message,
        ));
      }, (success) {
        emit(state.copyWith(
          isFailure: false,
          isLoading: false,
          message:
          success.responseData?.message ?? AppStrings.global_empty_string,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        isFailure: true,
        isLoading: false,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerCheckForErrorToast(TriggerCheckForErrorToast event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    String? isValid = TextFieldValidators.validateContactNumber(
        value: state.contactNumberEditingController.text);
    String? isZipCodeValid = TextFieldValidators.validateZip(
        value: state.zipCodeEditingController.text);
    if (!state.formKey.currentState!.validate() || isValid != null) {
      emit(state.copyWith(
        isRefreshRequired: false,
        message: AppStrings.global_empty_string,
        zipError: isZipCodeValid,
      ));
      buildCustomToast(
          msg: AppStrings.global_fillUpAllFields_text, isFailure: true);
    }
  }

  FutureOr<void> _onTriggerUpdateFieldOnChange(TriggerUpdateFieldOnChange event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);

    bool isAtLeastEightCharChecked =
    GlobalHandlers.passwordFieldValidationAgainstChecker(
        passwordChecker: PasswordChecker.isAtLeastEightCharChecked,
        value: event.value);
    bool isAtLeastOneLowerCaseChecked =
    GlobalHandlers.passwordFieldValidationAgainstChecker(
        passwordChecker: PasswordChecker.isAtLeastOneLowerCaseChecked,
        value: event.value);
    bool isAtLeastOneUpperCaseChecked =
    GlobalHandlers.passwordFieldValidationAgainstChecker(
        passwordChecker: PasswordChecker.isAtLeastOneUpperCaseChecked,
        value: event.value);
    bool isAtLeastOneDigitChecked =
    GlobalHandlers.passwordFieldValidationAgainstChecker(
        passwordChecker: PasswordChecker.isAtLeastOneDigitChecked,
        value: event.value);
    bool isAtLeastOneSpecialCharChecked =
    GlobalHandlers.passwordFieldValidationAgainstChecker(
        passwordChecker: PasswordChecker.isAtLeastOneSpecialCharChecked,
        value: event.value);
    emit(state.copyWith(
      isRefreshRequired: false,
      isAtLeastEightCharChecked: isAtLeastEightCharChecked,
      isAtLeastOneLowerCaseChecked: isAtLeastOneLowerCaseChecked,
      isAtLeastOneUpperCaseChecked: isAtLeastOneUpperCaseChecked,
      isAtLeastOneDigitChecked: isAtLeastOneDigitChecked,
      isAtLeastOneSpecialCharChecked: isAtLeastOneSpecialCharChecked,
    ));
  }

  FutureOr<void> _onTriggerRevealPasswordChecker(
      TriggerRevealPasswordChecker event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
      isRefreshRequired: false,
      isPasswordCheckerHidden: false,
    ));
  }

  FutureOr<void> _onTriggerCheckForUserUpdateButton(
      TriggerCheckForUserUpdateButton event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    String? isFirstNameValid = TextFieldValidators.validateName(
        nameTypes: NameTypes.firstName,
        value: state.firstNameEditingController.text);
    String? isLastNameValid = TextFieldValidators.validateName(
        nameTypes: NameTypes.lastName,
        value: state.lastNameEditingController.text);
    String? isDobValid = TextFieldValidators.validateBirthday(
        birthDay: state.dateOfBirthEditingController.text,
        ageType: event.isOwner ? AgeType.owner : AgeType.athlete);
    String? isWcValid = TextFieldValidators.validateWeight(
        value: state.weightEditingController.text);
    String? isEmailValid =
    TextFieldValidators.validateEmail(state.emailEditingController.text);
    String? isContactNumberValid = TextFieldValidators.validateContactNumber(
        value: state.contactNumberEditingController.text);
    String? isPostalAddressValid = TextFieldValidators.validatePostalAddress(
        address: state.postalAddressEditingController.text, city: state.city);
    String? isZipCodeValid = TextFieldValidators.validateZip(
        value: state.zipCodeEditingController.text);

    String? gradeValue;
    //---------------------------------Preselection Data---------------------------------
    bool isInfoValid = false;
    bool isInfoMatched = false;
    if (event.isOwner) {
      String firstName = await instance<UserCachedData>()
          .getUserPreselectionNameSeparately(isFirstName: true) ??
          AppStrings.global_empty_string;
      String lastName = await instance<UserCachedData>()
          .getUserPreselectionNameSeparately(isFirstName: false) ??
          AppStrings.global_empty_string;
      String dob = await instance<UserCachedData>().getUserPreselectionDob() ??
          AppStrings.global_empty_string;
      String phoneNumber =
          await instance<UserCachedData>().getUserPreselectionContact() ??
              AppStrings.global_empty_string;
      String address =
          await instance<UserCachedData>().getUserPreselectionAddress() ??
              AppStrings.global_empty_string;
      String zip = await instance<UserCachedData>().getUserPreselectionZip() ??
          AppStrings.global_empty_string;

      isInfoValid = isFirstNameValid == null &&
          isLastNameValid == null &&
          isDobValid == null &&
          isContactNumberValid == null &&
          isPostalAddressValid == null &&
          isZipCodeValid == null;

      isInfoMatched =
          state.contactNumberEditingController.text != phoneNumber ||
              state.postalAddressEditingController.text != address ||
              state.dateOfBirthEditingController.text != dob ||
              state.firstNameEditingController.text != firstName ||
              state.lastNameEditingController.text != lastName ||
              state.zipCodeEditingController.text != zip;
    } else {
      String firstName = await instance<AthleteCachedData>()
          .getAthletePreselectionNameSeparately(isFirstName: true) ??
          AppStrings.global_empty_string;
      String lastName = await instance<AthleteCachedData>()
          .getAthletePreselectionNameSeparately(isFirstName: false) ??
          AppStrings.global_empty_string;
      String dob =
          await instance<AthleteCachedData>().getAthletePreselectionDob() ??
              AppStrings.global_empty_string;
      String wc =
          await instance<AthleteCachedData>().getAthletePreselectionWC() ??
              AppStrings.global_empty_string;
      int gender =
          await instance<AthleteCachedData>().getAthletePreselectionGender() ??
              0;
      String email =
          await instance<AthleteCachedData>().getAthletePreselectionEmail() ??
              AppStrings.global_empty_string;
      String phoneNumber =
          await instance<AthleteCachedData>().getAthletePreselectionContact() ??
              AppStrings.global_empty_string;
      String address =
          await instance<AthleteCachedData>().getAthletePreselectionAddress() ??
              AppStrings.global_empty_string;
      String zip =
          await instance<AthleteCachedData>().getAthletePreselectionZip() ??
              AppStrings.global_empty_string;
      bool isRedshirt = await instance<AthleteCachedData>().getRedshirt();
      String teamId =
          await instance<AthleteCachedData>().getAthletePreselectionTeamId() ??
              AppStrings.global_empty_string;
      gradeValue =
      state.gradeValue.isEmpty ? state.athlete?.grade : state.gradeValue;

      isInfoValid = isFirstNameValid == null &&
          isLastNameValid == null &&
          isDobValid == null &&
          isWcValid == null &&
          isEmailValid == null &&
          isContactNumberValid == null &&
          isPostalAddressValid == null &&
          isZipCodeValid == null;

      isInfoMatched = state.firstNameEditingController.text != firstName ||
          state.lastNameEditingController.text != lastName ||
          state.dateOfBirthEditingController.text != dob ||
          state.weightEditingController.text != wc ||
          state.emailEditingController.text != email ||
          state.contactNumberEditingController.text != phoneNumber ||
          state.postalAddressEditingController.text != address ||
          state.zipCodeEditingController.text != zip ||
          state.teamId != teamId ||
          state.athlete?.grade != gradeValue ||
          isRedshirt != state.isRedshirt ||
          state.radioButtonIndex != gender;

      debugPrint(
          '''isInfoValid ${state.firstNameEditingController.text !=
              firstName} ||${state.lastNameEditingController.text !=
              lastName} ||${state.dateOfBirthEditingController.text != dob} ||
      ${state.weightEditingController.text != wc} ||
          ${state.emailEditingController.text != email} ||
          ${state.contactNumberEditingController.text != phoneNumber} ||
          ${state.postalAddressEditingController.text != address} ||
          ${state.zipCodeEditingController.text != zip} ||
          ${state.teamId} != $teamId ||
          ${state.athlete?.grade} != $gradeValue ||
          ${isRedshirt != state.isRedshirt} ||
          ${state.radioButtonIndex != gender}
          ---$isRedshirt---${state.isRedshirt}
    ''');
    }

    debugPrint('isInfoValid $isInfoMatched');
    emit(state.copyWith(
      isRefreshRequired: false,
      zipError: event.dob != null ? null : isZipCodeValid,
      isUpdateBtnActive: isInfoValid && isInfoMatched,
    ));
  }

  FutureOr<void> _onTriggerHideUnHideFieldContents(
      TriggerHideUnHideFieldContents event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    if (event.fieldType == FieldType.password) {
      emit(state.copyWith(
        isRefreshRequired: false,
        isNewObscure: !state.isNewObscure,
      ));
    }
    if (event.fieldType == FieldType.confirmPassword) {
      emit(state.copyWith(
        isRefreshRequired: false,
        isConfirmObscure: !state.isConfirmObscure,
      ));
    }
    if (event.fieldType == FieldType.oldPassword) {
      emit(state.copyWith(
        isRefreshRequired: false,
        isOldObscure: !state.isOldObscure,
      ));
    }
  }

  FutureOr<void> _onTriggerValidateCalenderDate(
      TriggerValidateCalenderDate event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    String? dateError = TextFieldValidators.validateBirthday(
        ageType: event.ageType,
        birthDay: state.dateOfBirthEditingController.text);
    emit(state.copyWith(
      isRefreshRequired: false,
      dateError: dateError,
    ));
  }

  FutureOr<void> _onTriggerCheckZipCodeField(TriggerCheckZipCodeField event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    CreateProfileHandlers.emitInitialState(emit: emit, state: state);
    String? zipError = TextFieldValidators.validateZip(
        value: state.zipCodeEditingController.text);
    emit(state.copyWith(
      isRefreshRequired: false,
      zipError: zipError,
    ));
  }

  FutureOr<void> _onTriggerCheckForAddressValidity(
      TriggerCheckForAddressValidity event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isLoading: false));
    String? addressValid = TextFieldValidators.validatePostalAddress(
        address: state.postalAddressEditingController.text, city: state.city);
    emit(state.copyWith(
      isRefreshRequired: false,
      postalAddressError: addressValid,
    ));
  }

  FutureOr<void> _onTriggerSwitchToRedshirt(TriggerSwitchToRedshirt event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isLoading: false));
    bool isRedshirt = !(state.isRedshirt ?? false);
    emit(state.copyWith(
      isRefreshRequired: false,
      isRedshirt: isRedshirt,
    ));
    add(TriggerCheckForUserUpdateButton(
        isOwner: state.createProfileTypes ==
            CreateProfileTypes.editProfileForOwner));
  }

  FutureOr<void> _onTriggerCheckChangePasswordActiveState(
      TriggerCheckChangePasswordActiveState event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isLoading: false));
    bool isButtonActive = state.oldPasswordController.text.isNotEmpty &&
        state.newPasswordController.text.isNotEmpty &&
        state.confirmPasswordController.text.isNotEmpty &&
        (state.newPasswordController.text ==
            state.confirmPasswordController.text);
    emit(state.copyWith(
      isRefreshRequired: false,
      isChangePasswordActive: isButtonActive,
    ));
  }

  FutureOr<void> _onTriggerNavigateToAthlete(TriggerNavigateToAthlete event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isRefreshRequired: true,
        isAddAthleteSelected: true,
        isExploreOpened: false,
        isLoading: false));
    add(const TriggerInitializationOfAthleteProfileFields(
        createProfileTypes: CreateProfileTypes.addAthleteAfterCreateProfile));
  }

  FutureOr<void> _onTriggerCreateAthleteLocally(
      TriggerCreateAthleteLocally event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));

    String? zipError = TextFieldValidators.validateZip(
        value: state.zipCodeEditingController.text);
    String? gradeError = state.gradeValue.isEmpty ? 'Grade is required' : null;
    if (zipError != null || gradeError != null) {
      emit(state.copyWith(
        isRefreshRequired: false,
        zipError: zipError,
        gradeError: gradeError,
      ));
    } else {
      emit(state.copyWith(isCreateButtonActive: false, isLoading: true));
      String? message;
      List<String> createdProfileModules =
          instance<AthleteCachedData>().getAthleteListJson() ?? [];

      if (createdProfileModules.isNotEmpty) {
        List<CreateProfileRequestModel> profiles = createdProfileModules
            .map((athleteJson) =>
            CreateProfileRequestModel.fromJson(jsonDecode(athleteJson)))
            .toList();
        if (profiles.isNotEmpty) {
          for (CreateProfileRequestModel profile in profiles) {
            if (profile.firstName.trim().toLowerCase() ==
                state.firstNameEditingController.text
                    .trim()
                    .toLowerCase() &&
                profile.lastName.trim().toLowerCase() ==
                    state.lastNameEditingController.text.trim().toLowerCase()) {
              message =
                  AppStrings.registerAndSell_alreadyExistingAthlete_message;
              break;
            }
          }
        }
      }
      if (message == null) {
        String athleteId = Random().nextInt(100000).toString();
        bool isProfileCreated = true;

        Athlete athlete = Athlete(
          isRedshirt: state.isRedshirt,
          grade: state.gradeValue,
          underscoreId: athleteId,
          isAthleteTaken: false,
          chosenWCs: [],
          athleteStyles: [],
          id: athleteId,
          team: null,
          selectedTeam: state.selectedTeam != null
              ? Team(name: state.selectedTeam, id: state.teamId)
              : null,
          selectedGrade: null,
          teamId: null,
          age: DateTime
              .now()
              .year -
              int.parse(
                  state.dateOfBirthEditingController.text
                      .split('/')
                      .last),
          uniqueId: athleteId,
          firstName: state.firstNameEditingController.text.trim(),
          lastName: state.lastNameEditingController.text.trim(),
          email: state.emailEditingController.text.trim(),
          birthDate: GlobalHandlers.yyyyMMddDateFormatHandler(
              dateString: state.dateOfBirthEditingController.text.trim()),
          weight: state.weightEditingController.text.trim(),
          weightClass: state.weightEditingController.text.trim(),
          phoneCode: 1,
          phoneNumber:
          num.parse(state.contactNumberEditingController.text.trim()),
          gender: state.radioButtonIndex == 0
              ? AppStrings.global_gender_male
              : AppStrings.global_gender_female,
          mailingAddress: state.postalAddressEditingController.text.trim(),
          pincode: num.parse(state.zipCodeEditingController.text.trim()),
          city: state.city,
          state: state.state,
          profileImage: state.file?.path,
          fileImage: state.file,
          isUserParent: state.isGuardian,
        );
        try {
          await instance<AthleteCachedData>()
              .addAthleteToList(CreateProfileRequestModel(
            isRedshirt: state.isRedshirt ?? false,
            gradeValue: state.gradeValue,
            athleteId: athleteId,
            uniqueId: athleteId,
            isCreateProfile: isProfileCreated,
            firstName: state.firstNameEditingController.text.trim(),
            lastName: state.lastNameEditingController.text.trim(),
            email: state.emailEditingController.text.trim(),
            birthDate: GlobalHandlers.yyyyMMddDateFormatHandler(
                dateString: state.dateOfBirthEditingController.text.trim()),
            weight: state.weightEditingController.text.trim(),
            phoneCode: AppStrings.global_phone_code,
            contactNumber: state.contactNumberEditingController.text.trim(),
            gender: state.radioButtonIndex == 0
                ? AppStrings.global_gender_male
                : AppStrings.global_gender_female,
            address: state.postalAddressEditingController.text.trim(),
            zipCode: state.zipCodeEditingController.text.trim(),
            city: state.city,
            stateName: state.state,
            teamId: state.teamId,
            profileImage: state.file,
            athleteFlag: AppStrings.global_athlete_flag,
            isUserParent: state.isGuardian.toString(),
          ));

          emit(CreateEditProfileWithInitialState.initial());
          emit(state.copyWith(
              message: 'Athlete Created Successfully',
              createProfileTypes: CreateProfileTypes.createAthleteLocally));

          BlocProvider.of<RegisterAndSellBloc>(navigatorKey.currentContext!)
              .add(TriggerGenerateAthleteList(athlete: athlete));
          List<Athlete> athletes = [athlete];

          int divIndex = navigatorKey.currentContext!
              .read<EventDetailsBloc>()
              .state
              .parentIndex;
          int ageGroupIndex = navigatorKey.currentContext!
              .read<EventDetailsBloc>()
              .state
              .childIndex;
          List<DivisionTypes> divisionTypes = navigatorKey.currentContext!
              .read<EventDetailsBloc>()
              .state
              .divisionsTypes;

          if (divisionTypes.isNotEmpty) {
            BlocProvider.of<EventDetailsBloc>(navigatorKey.currentContext!)
                .add(TriggerAssembleForDivision(
              athletes: athletes,
              childIndex: ageGroupIndex,
              divIndex: divIndex,
              divisionTypes: divisionTypes,
            ));
          }
          Navigator.pop(navigatorKey.currentContext!);
        } catch (e) {
          debugPrint('Error: $e');
          emit(state.copyWith(
            isFailure: true,
            isLoading: false,
            isRefreshRequired: false,
            message: e.toString(),
          ));
        }
      } else {
        emit(state.copyWith(
          isFailure: true,
          isLoading: false,
          isRefreshRequired: false,
          message: message,
        ));
      }
    }
  }

  FutureOr<void> _onTriggerEditAthleteLocally(TriggerEditAthleteLocally event,
      Emitter<CreateEditProfileWithInitialState> emit) async {
    List<Athlete> athletes = [];
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));
    String? zipError = TextFieldValidators.validateZip(
        value: state.zipCodeEditingController.text);
    if (zipError != null) {
      emit(state.copyWith(
        isRefreshRequired: false,
        zipError: zipError,
      ));
    } else {
      emit(state.copyWith(isCreateButtonActive: false, isLoading: true));

      String? message;
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
            age: DateTime
                .now()
                .year -
                int.parse(profile.birthDate
                    .split('/')
                    .first),
            weight: profile.weight,
            athleteStyles: [],
            chosenWCs: [],
            phoneCode: 1,
            uniqueId: profile.athleteId,
            isAthleteTaken: false,
            weightClass: profile.weight,
            phoneNumber: int.parse(profile.contactNumber),
            city: profile.city,
            state: profile.stateName,
            pincode: int.parse(profile.zipCode),
            mailingAddress: profile.address,
            team: null,
            selectedTeam: Team(
                name: state.selectedTeam ?? AppStrings.global_no_team,
                id: state.teamId),
            teamId: state.teamId,
            gender: profile.gender,
            grade: profile.gradeValue,
            isRedshirt: profile.isRedshirt,
            underscoreId: profile.athleteId,
            id: profile.athleteId,
            fileImage: profile.profileImage,
            profileImage: profile.profileImage?.path,
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

      for (int i = 0; i < athletes.length; i++) {
        if (athletes[i].underscoreId.toString() == event.athleteId.toString()) {
          athletes[i].isRedshirt = state.isRedshirt ?? athletes[i].isRedshirt;
          athletes[i].grade =
          state.gradeValue.isEmpty ? athletes[i].grade : state.gradeValue;
          athletes[i].id = event.athleteId;
          athletes[i].underscoreId = event.athleteId;
          athletes[i].firstName = state.firstNameEditingController.text.trim();
          athletes[i].lastName = state.lastNameEditingController.text.trim();
          athletes[i].email = state.emailEditingController.text.trim();
          athletes[i].age = DateTime
              .now()
              .year -
              int.parse(
                  state.dateOfBirthEditingController.text
                      .split('/')
                      .last);
          athletes[i].birthDate = GlobalHandlers.yyyyMMddDateFormatHandler(
              dateString: state.dateOfBirthEditingController.text.trim());
          athletes[i].weight = state.weightEditingController.text.trim();
          athletes[i].phoneNumber =
              int.parse(state.contactNumberEditingController.text.trim());
          athletes[i].city = state.city;
          athletes[i].state = state.state;
          athletes[i].isRedshirt = state.isRedshirt;
          athletes[i].pincode =
              int.parse(state.zipCodeEditingController.text.trim());
          athletes[i].mailingAddress =
              state.postalAddressEditingController.text.trim();
          athletes[i].selectedTeam = Team(
              name: state.selectedTeam ?? AppStrings.global_no_team,
              id: state.teamId);
          athletes[i].profileImage =
          state.file == null ? athletes[i].profileImage : state.file?.path;
          debugPrint('Edit ${athletes[i].profileImage}');
          athletes[i].gender = state.radioButtonIndex == 0
              ? AppStrings.global_gender_male
              : AppStrings.global_gender_female;
          athletes[i].selectedGrade = GradeData(
              name: state.gradeValue.isNotEmpty
                  ? globalGrades
                  .firstWhere((e) => e.value == state.gradeValue)
                  .name
                  : AppStrings.global_empty_string,
              value: state.gradeValue);
          athletes[i].fileImage = state.file;
          athletes[i].teamId =
          state.teamId.isEmpty ? athletes[i].teamId : state.teamId;
        }
      }
      String firstName = AppStrings.global_empty_string;
      String lastName = AppStrings.global_empty_string;
      for (int i = 0; i < athletes.length; i++) {
        if (athletes[i].underscoreId.toString() == event.athleteId.toString()) {
          firstName = athletes[i].firstName!;
          lastName = athletes[i].lastName!;
          break;
        }
      }
      for (int i = 0; i < athletes.length; i++) {
        if (athletes[i].firstName == firstName &&
            athletes[i].lastName == lastName &&
            athletes[i].underscoreId.toString() != event.athleteId.toString()) {
          message = AppStrings.registerAndSell_alreadyExistingAthlete_message;
          break;
        }
      }
      if (message == null) {
        instance<AthleteCachedData>().removeAthleteFromList(event.athleteId);
        try {
          Athlete athlete = athletes.firstWhere((element) =>
          element.underscoreId.toString() == event.athleteId.toString());
          await instance<AthleteCachedData>()
              .addAthleteToList(CreateProfileRequestModel(
            isRedshirt: athlete.isRedshirt ?? false,
            gradeValue: athlete.grade!,
            athleteId: event.athleteId,
            isCreateProfile: false,
            firstName: athlete.firstName!,
            lastName: athlete.lastName!,
            email: athlete.email!,
            birthDate: GlobalHandlers.yyyyMMddDateFormatHandler(
                dateString: state.dateOfBirthEditingController.text.trim()),
            weight: athlete.weight!,
            phoneCode: AppStrings.global_phone_code,
            contactNumber: state.contactNumberEditingController.text.trim(),
            gender: state.radioButtonIndex == 0
                ? AppStrings.global_gender_male
                : AppStrings.global_gender_female,
            address: state.postalAddressEditingController.text.trim(),
            zipCode: state.zipCodeEditingController.text.trim(),
            city: state.city,
            stateName: state.state,
            profileImage: state.file,
            athleteFlag: AppStrings.global_athlete_flag,
            isUserParent: state.isGuardian.toString(),
            teamId: athlete.teamId!,
          ));
          emit(state.copyWith(
            message: 'Athlete Edited Successfully',
            isFailure: false,
            isLoading: false,
          ));

          BlocProvider.of<RegisterAndSellBloc>(navigatorKey.currentContext!)
              .add(TriggerGenerateAthleteList(athlete: athlete));

          Navigator.pop(navigatorKey.currentContext!);
        } catch (e) {
          emit(state.copyWith(
            isFailure: true,
            isLoading: false,
            isRefreshRequired: false,
            message: e.toString(),
          ));
        }
      } else {
        emit(state.copyWith(
          isFailure: true,
          isLoading: false,
          isRefreshRequired: false,
          message: message,
        ));
      }
    }
  }

  FutureOr<void> _onTriggerDeleteLocalAthlete(TriggerDeleteLocalAthlete event,
      Emitter<CreateEditProfileWithInitialState> emit) {
    emit(state.copyWith(

        isFailure: false,
        isLoading: true,
        message: AppStrings.global_empty_string));

    instance<AthleteCachedData>().removeAthleteFromList(event.athleteId);
    List<Athlete> athletes = List.from(navigatorKey.currentContext!
        .read<RegisterAndSellBloc>()
        .state
        .athletes);
    athletes.removeWhere((element) => element.underscoreId == event.athleteId);
    BlocProvider.of<RegisterAndSellBloc>(navigatorKey.currentContext!)
        .add(TriggerRegenerateAthleteListAfterDeletion(
      athletes: athletes,
    ));
    Navigator.pop(navigatorKey.currentContext!);
    emit(state.copyWith(

        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));
  }

}
