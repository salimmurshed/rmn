import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import '../../../data/models/arguments/athlete_argument.dart';
import '../../../imports/common.dart';
import '../../base/bloc/base_bloc.dart';
import '../bloc/create_edit_profile_bloc.dart';
import '../widgets/build_name_section.dart';
import '../widgets/build_profile_image_placeholder.dart';
import '../widgets/build_zip_code_field.dart';

class CreateEditProfileView extends StatefulWidget {
  const CreateEditProfileView({super.key, required this.createProfileType});

  final AthleteArgument createProfileType;

  @override
  State<CreateEditProfileView> createState() => _CreateEditProfileViewState();
}

class _CreateEditProfileViewState extends State<CreateEditProfileView> {
  late CreateEditProfileBloc createEditProfileBloc;

  @override
  initState() {
    createEditProfileBloc = BlocProvider.of<CreateEditProfileBloc>(context);
    createEditProfileBloc.add(TriggerInitializationCreateProfileFields(
      createProfileTypes: widget.createProfileType.createProfileType,
      athleteId: widget.createProfileType.athleteId,
    ));

    super.initState();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateEditProfileBloc,
        CreateEditProfileWithInitialState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
          if (state.isProfileCreated) {
            buildAddAthleteMBS(context);
          }
        }
        if (state.isExploreOpened) {
          buildProfileCreateSuccessMBS(context);
        }
      },
      child:
          BlocBuilder<CreateEditProfileBloc, CreateEditProfileWithInitialState>(
        builder: (context, state) {
          debugPrint(
              'CreateEditProfileView: ${state.createProfileTypes} ${state.buttonName}');
          return customScaffold(
            hasForm: true,
            anyWidgetWithoutSingleChildScrollView: null,
            persistentFooterButtons: [
              Column(
                children: [
                  if (state.createProfileTypes !=
                          CreateProfileTypes.editProfileForOwner &&
                      state.createProfileTypes !=
                          CreateProfileTypes.editProfileForAthlete &&
                      state.createProfileTypes !=
                          CreateProfileTypes.editAthleteLocally)
                    buildLargeFooterBTN(
                        isActive: state.isCreateButtonActive,
                        btnText: state.buttonName,
                        state: state,
                        context: context),
                  if (state.createProfileTypes ==
                          CreateProfileTypes.editProfileForAthlete ||
                      state.createProfileTypes ==
                          CreateProfileTypes.editAthleteLocally) ...[
                    buildLargeFooterBTN(
                        isActive: state.isUpdateBtnActive,
                        btnText: state.buttonName,
                        state: state,
                        context: context),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 10.h),
                        child: TextButton(
                          onPressed: () {
                            buildBottomSheetWithBodyText(
                                context: context,
                                title:
                                    AppStrings.bottomSheet_athleteDelete_title,
                                subtitle: AppStrings
                                    .bottomSheet_athleteDelete_subtitle,
                                isSingeButtonPresent: false,
                                leftButtonText: AppStrings.btn_delete,
                                rightButtonText: AppStrings.btn_goBack,
                                onLeftButtonPressed: () {
                                  if(state.createProfileTypes == CreateProfileTypes.editAthleteLocally){
                                    BlocProvider.of<CreateEditProfileBloc>(
                                        context)
                                        .add(TriggerDeleteLocalAthlete(
                                      athleteId: state.athlete!.underscoreId!,
                                    ));
                                    Navigator.pop(context);
                                  }
                                  else{
                                    BlocProvider.of<CreateEditProfileBloc>(
                                            context)
                                        .add(TriggerAthleteAccountDeletion(
                                      athleteId: state.athlete!.underscoreId!,
                                    ));
                                  }
                                },
                                onRightButtonPressed: () {
                                  Navigator.pop(context);
                                });
                          },
                          child: Text(
                            AppStrings.btn_deleteAthlete,
                            style: AppTextStyles.buttonTitle(
                                color: AppColors.colorPrimaryAccent),
                          ),
                        ),
                      ),
                    )
                  ]
                ],
              )
            ],
            customAppBar: CustomAppBar(
                appBarActionFunction: () {
                  if (state.createProfileTypes ==
                      CreateProfileTypes.addAthleteAfterCreateProfile) {
                    createEditProfileBloc.add(
                      TriggerOpenExploreBottomSheet(),
                    );
                  }
                },
                customActionWidget: state.createProfileTypes ==
                        CreateProfileTypes.addAthleteAfterCreateProfile
                    ? Container(
                        margin: EdgeInsets.only(top: 8.h),
                        child: Text(
                          AppStrings.btn_skip,
                          style: AppTextStyles.subtitle(),
                        ),
                      )
                    : null,
                navigatorValue: state.isAthleteEdited,
                title: state.title,
                isLeadingPresent: state.createProfileTypes !=
                            CreateProfileTypes.addAthleteAfterCreateProfile &&
                        state.createProfileTypes !=
                            CreateProfileTypes.createProfileForOwner
                    ? true
                    : false),
            formOrColumnInsideSingleChildScrollView: state.isLoading
                ? Column(
                    children: [
                      CustomLoader(
                          isForSingleWidget: true,
                          child: state.createProfileTypes ==
                                  CreateProfileTypes.createProfileForOwner
                              ? buildFormForCreateOwnerProfile(state, context)
                              : state.createProfileTypes ==
                                      CreateProfileTypes.editProfileForOwner
                                  ? buildFormForEditOwnerProfile(state, context)
                                  : buildFormForCreateEditAthleteProfile(
                                      state, context)),
                    ],
                  )
                : state.createProfileTypes ==
                        CreateProfileTypes.createProfileForOwner
                    ? buildFormForCreateOwnerProfile(state, context)
                    : state.createProfileTypes ==
                            CreateProfileTypes.editProfileForOwner
                        ? buildFormForEditOwnerProfile(state, context)
                        : buildFormForCreateEditAthleteProfile(state, context),
          );
        },
      ),
    );
  }

  Widget buildLargeFooterBTN(
      {String? btnText,
      void Function()? onTap,
      required CreateEditProfileWithInitialState state,
      bool isActive = true,
      required BuildContext context}) {
    return buildCustomLargeFooterBtn(
        hasKeyBoardOpened: true,
        isColorFilledButton: true,
        isActive: isActive,
        onTap: onTap ??
            () {
              if (isActive) {
                if (state.formKey.currentState!.validate()) {
                  if (state.createProfileTypes ==
                      CreateProfileTypes.createProfileForOwner) {
                    createEditProfileBloc.add(
                      const TriggerCreateOwnerProfile(),
                    );
                  } else {
                    if (state.createProfileTypes ==
                            CreateProfileTypes.createAthleteLocally ||
                        state.createProfileTypes ==
                            CreateProfileTypes.createAthleteLocallyFromRegs) {
                      createEditProfileBloc.add(
                        TriggerCreateAthleteLocally(),
                      );
                    } else if (state.createProfileTypes ==
                        CreateProfileTypes.editAthleteLocally) {
                      createEditProfileBloc.add(TriggerEditAthleteLocally(
                          athleteId: widget.createProfileType.athleteId!));
                    } else {
                      createEditProfileBloc.add(
                        TriggerCreateAthleteProfile(),
                      );
                    }
                  }
                }
                createEditProfileBloc.add(
                  TriggerCheckForErrorToast(),
                );
                createEditProfileBloc.add(
                  TriggerEnableInteractionWithContactField(),
                );
              }
            },
        btnLabel: btnText ?? AppStrings.btn_create);
  }

  buildProfileCreateSuccessMBS(BuildContext context) {
    buildBottomSheetWithBodyImage(
        isSingleButtonPresent: true,
        context: context,
        highlightedString: AppStrings
            .bottomSheet_successfulRegistrationStatus_title_secondLine,
        title:
            AppStrings.bottomSheet_successfulRegistrationStatus_title_firstLine,
        footerNote:
            AppStrings.bottomSheet_successfulRegistrationStatus_subtitle,
        buttonText: AppStrings.btn_explore,
        imageUrl: AppAssets.icSuccessfulRegistration,
        onButtonPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRouteNames.routeBase, (route) => false,
              arguments: true);
        },
        navigatorFunction: () {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRouteNames.routeBase, (route) => false,
              arguments: true);
        });
  }

  buildAddAthleteMBS(BuildContext context) {
    buildBottomSheetWithBodyText(
        context: context,
        title: AppStrings.bottomSheet_addAthlete_title,
        subtitle: AppStrings.bottomSheet_addAthlete_subtitle,
        isSingeButtonPresent: false,
        rightButtonText: AppStrings.btn_yes,
        leftButtonText: AppStrings.btn_no,
        onLeftButtonPressed: () {
          Navigator.pop(context);
          createEditProfileBloc.add(
            TriggerOpenExploreBottomSheet(),
          );
        },
        onRightButtonPressed: () {
          Navigator.pop(context);
          createEditProfileBloc.add(
            TriggerNavigateToAthlete(),
          );
          setState(() {});
        },
        navigatorFunction: () {
          createEditProfileBloc.add(
            TriggerForAddAthleteMBSTappedOutside(),
          );
        });
  }

  //
  Form buildFormForCreateOwnerProfile(
      CreateEditProfileWithInitialState state, BuildContext context) {
    return Form(
      key: state.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: Dimensions.screenVerticalSpacing,
          ),
          buildProfileImage(context, state),
          SizedBox(
            height: Dimensions.screenVerticalSpacing,
          ),
          buildNames(state),
          buildCustomNonEditableField(
            textEditingController: state.emailEditingController,
            focusNode: state.emailFocusNode,
          ),
          buildDOBField(state, context, AgeType.owner),
          buildGenders(state),
          buildPhoneField(context, state),
          buildAddressField(state: state, context: context),
          buildZipField(state),
          SizedBox(
            height: Dimensions.screenVerticalSpacing,
          ),
        ],
      ),
    );
  }

  Form buildFormForEditOwnerProfile(
      CreateEditProfileWithInitialState state, BuildContext context) {
    return Form(
      key: state.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: Dimensions.screenVerticalSpacing,
          ),
          buildProfileImage(context, state),
          SizedBox(
            height: Dimensions.screenVerticalSpacing,
          ),
          buildNames(state),
          buildDOBField(state, context, AgeType.owner),
          buildPhoneField(context, state),
          buildAddressField(
              state: state, context: context, zip: buildZipField(state)),
          SizedBox(
            height: Dimensions.generalGap,
          ),
          buildLargeFooterBTN(
              btnText: AppStrings.profile_EditProfile_update_btn_text,
              onTap: state.isUpdateBtnActive
                  ? () {
                      if (state.formKey.currentState!.validate()) {
                        createEditProfileBloc.add(
                          const TriggerCreateOwnerProfile(
                              isCreateProfile: false),
                        );
                      }
                    }
                  : () {},
              isActive: state.isUpdateBtnActive,
              state: state,
              context: context),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(10.r),
            margin: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.colorTertiary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.emailEditingController.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.buttonTitle(),
                      ),
                    ),
                  ],
                ),
                Text(
                  'You can change your email here.',
                  textAlign: TextAlign.start,
                  style: AppTextStyles.regularPrimary(
                      color: AppColors.colorPrimaryNeutral),
                ),
                SizedBox(
                  height: 10.h,
                ),
                GestureDetector(
                  onTap: () {
                    state.changeEmailEditingController.text =
                        state.emailEditingController.text;
                    buildCustomShowModalBottomSheetParent(
                        ctx: context,
                        isNavigationRequired: false,
                        navigatorFunction: () {},
                        child: BlocBuilder<CreateEditProfileBloc,
                            CreateEditProfileWithInitialState>(
                          builder: (context, state) {
                            return buildBottomSheetWithBodyTextField(
                                navigatorFunction: () {},
                                context: context,
                                title: AppStrings
                                    .profile_EditProfile_emailUpdate_bottomSheet_title,
                                subtitle: AppStrings
                                    .profile_EditProfile_emailUpdate_bottomSheet_subtitle,
                                onButtonPressed: () {},
                                textEditingController:
                                    state.changeEmailEditingController,
                                focusNode: state.changeEmailFocusNode,
                                label: AppStrings.textfield_addEmail_label,
                                hint: AppStrings.textfield_addEmail_hint,
                                textInputType: TextInputType.emailAddress,
                                isSingeButtonPresent: false,
                                rightButtonText: AppStrings.btn_verify,
                                leftButtonText: AppStrings.btn_cancel,
                                onRightButtonPressed: () {
                                  if (state.isVerifyBtnActive) {
                                    Navigator.pop(context);
                                    BlocProvider.of<CreateEditProfileBloc>(
                                            context)
                                        .add(TriggerVerifyEmailChange());
                                  }
                                },
                                onLeftButtonPressed: () {
                                  Navigator.pop(context);
                                },
                                onChanged: (value) {
                                  createEditProfileBloc.add(
                                      TriggerCheckActivityOfVerifyButton());
                                },
                                isActive: state.isVerifyBtnActive,
                                isSubtitleAsFooter: false);
                          },
                        ));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.colorPrimaryAccent),
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    child: Text(
                      AppStrings.btn_change_email,
                      style: AppTextStyles.buttonTitle(
                          color: AppColors.colorPrimaryAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!state.isSocialId)
            Form(
              key: state.formKeyForChangePassword,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: Dimensions.generalGapSmall, bottom: 5.h),
                    child: Text(
                      'Change Password',
                      style: AppTextStyles.largeTitle(),
                    ),
                  ),
                  buildCustomPasswordField(
                    isObscure: state.isOldObscure,
                    label: AppStrings.textfield_oldPassword_label,
                    hint: AppStrings.textfield_oldPassword_hint,
                    textEditingController: state.oldPasswordController,
                    focusNode: state.oldFocusNode,
                    onChanged: (value) {
                      BlocProvider.of<CreateEditProfileBloc>(context)
                          .add(TriggerCheckChangePasswordActiveState());
                      //state.formKeyForChangePassword.currentState!.validate();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppStrings
                            .textfield_addOldPassword_emptyField_error;
                      } else {
                        return null;
                      }
                    },
                    onTapToHideUnhide: () {
                      createEditProfileBloc.add(
                          const TriggerHideUnHideFieldContents(
                              fieldType: FieldType.oldPassword));
                    },
                    onTap: () {},
                  ),
                  buildCustomPasswordField(
                    isObscure: state.isNewObscure,
                    label: AppStrings.textfield_newPassword_label,
                    hint: AppStrings.textfield_newPassword_hint,
                    textEditingController: state.newPasswordController,
                    focusNode: state.newFocusNode,
                    onChanged: (value) {
                      BlocProvider.of<CreateEditProfileBloc>(context)
                          .add(TriggerCheckChangePasswordActiveState());
                      createEditProfileBloc.add(TriggerUpdateFieldOnChange(
                          fieldType: FieldType.password,
                          value: value,
                          retypedValue: AppStrings.global_empty_string));
                    },
                    validator: (value) {
                      return TextFieldValidators
                          .validatePasswordSecurityPolicies(
                              value ?? AppStrings.global_empty_string);
                    },
                    onTapToHideUnhide: () {
                      createEditProfileBloc.add(
                          const TriggerHideUnHideFieldContents(
                              fieldType: FieldType.password));
                    },
                    onTap: () {
                      createEditProfileBloc.add(TriggerRevealPasswordChecker());
                    },
                  ),
                  if (!state.isPasswordCheckerHidden)
                    buildCustomCheckboxesForPasswordField(
                      isAtLeastEightCharChecked:
                          state.isAtLeastEightCharChecked,
                      isAtLeastOneLowerCaseChecked:
                          state.isAtLeastOneLowerCaseChecked,
                      isAtLeastOneUpperCaseChecked:
                          state.isAtLeastOneUpperCaseChecked,
                      isAtLeastOneDigitChecked: state.isAtLeastOneDigitChecked,
                      isAtLeastOneSpecialCharChecked:
                          state.isAtLeastOneSpecialCharChecked,
                    ),
                  buildCustomPasswordField(
                    isObscure: state.isConfirmObscure,
                    label: AppStrings.textfield_confirmPassword_label,
                    hint: AppStrings.textfield_confirmPassword_hint,
                    textEditingController: state.confirmPasswordController,
                    focusNode: state.confirmFocusNode,
                    onChanged: (value) {
                      BlocProvider.of<CreateEditProfileBloc>(context)
                          .add(TriggerCheckChangePasswordActiveState());
                    },
                    validator: (value) {
                      return TextFieldValidators.validateConfirmPassword(
                          reTypedValue: state.newPasswordController.text,
                          password: state.confirmPasswordController.text);
                    },
                    onTapToHideUnhide: () {
                      createEditProfileBloc.add(
                          const TriggerHideUnHideFieldContents(
                              fieldType: FieldType.confirmPassword));
                    },
                    onTap: () {},
                  ),
                  SizedBox(
                    height: Dimensions.screenVerticalSpacing,
                  ),
                  buildLargeFooterBTN(
                      isActive: state.isChangePasswordActive,
                      btnText: AppStrings
                          .profile_EditProfile_changePassword_btn_text,
                      onTap: state.isChangePasswordActive
                          ? () {
                              if (state.formKeyForChangePassword.currentState!
                                  .validate()) {
                                createEditProfileBloc.add(
                                  TriggerChangePassword(),
                                );
                              }
                            }
                          : () {},
                      state: state,
                      context: context),
                ],
              ),
            ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.h),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRouteNames.routeDeleteAccount);
                },
                child: Text(
                  AppStrings.btn_deleteAccount,
                  style: AppTextStyles.buttonTitle(
                      color: AppColors.colorPrimaryAccent),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Form buildFormForCreateEditAthleteProfile(
      CreateEditProfileWithInitialState state, BuildContext context) {
    return Form(
      key: state.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.createProfileTypes ==
                  CreateProfileTypes.addAthleteAfterCreateProfile ||
              state.createProfileTypes ==
                  CreateProfileTypes.addAthleteFromMyList ||
          state.createProfileTypes == CreateProfileTypes.addAthleteFromRegistrationSelection ||
              state.createProfileTypes ==
                  CreateProfileTypes.editProfileForAthlete
          ) ...[
            SizedBox(
              height: Dimensions.screenVerticalSpacing,
            ),
            buildProfileImage(context, state),
            SizedBox(
              height: Dimensions.screenVerticalSpacing,
            )
          ],
          buildNames(state),
          buildGenders(state),
          buildDOBField(state, context, AgeType.athlete),
          createAthleteDropdown(
            dropDownType: DropDownTypeForCreateAthlete.gradeSelection,
            searchController: state.searchController,
            onChanged: (value) {
              BlocProvider.of<CreateEditProfileBloc>(context).add(
                  TriggerGradeSelectionInCreateProfile(
                      grades: globalGrades,
                      selectedValue: value,
                      athlete: state.athlete));
            },
            context: context,
            gradeError: state.gradeError,
            showLabel: true,
            dropDownKey: state.dropDownKeyForGrade,
            selectedValue: state.selectedGrade,
            otherTeamController: state.findOtherTeamNames,
            onRightTap: () {},
            otherTeamFocusNode: state.findOtherTeamNamesFocusNode,
          ),
          SizedBox(
            height: 5.h,
          ),
          if (!state.isLoading)
            GestureDetector(
              onTap: () {
                BlocProvider.of<CreateEditProfileBloc>(context)
                    .add(TriggerSwitchToRedshirt());
              },
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Redshirt',
                        style: AppTextStyles.subtitle(isOutFit: false)),
                    Container(
                      margin:
                          EdgeInsets.only(left: 10.w, top: 5.h, bottom: 5.h),
                      child: SvgPicture.asset(
                        (state.isRedshirt ?? true)
                            ? AppAssets.icActiveRedshirt
                            : AppAssets.icInActiveRedshirt,
                        width: 14.w,
                        height: 14.h,
                      ),
                    ),
                  ]),
            ),
          createAthleteDropdown(
            dropDownType: DropDownTypeForCreateAthlete.teamSelection,
            searchController: state.searchController,
            onChanged: (value) {
              BlocProvider.of<CreateEditProfileBloc>(context).add(
                  TriggerDropDownSelectionInCreateProfile(
                      teams: globalTeams,
                      selectedValue: value,
                      athlete: state.athlete));
            },
            context: context,
            gradeError: null,
            showLabel: true,
            isAsteriskPresent: false,
            dropDownKey: state.dropDownKey,
            selectedValue: state.selectedTeam,
            otherTeamController: state.findOtherTeamNames,
            onRightTap: () {},
            otherTeamFocusNode: state.findOtherTeamNamesFocusNode,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(top: 20.h, bottom: 10.h),
              child: Text('Contact Details', style: AppTextStyles.largeTitle()),
            ),
          ),
          buildCustomCheckBoxWithSingleText(
              isChecked: state.isGuardian,
              noTopMargin: true,
              onChanged: (value) {
                createEditProfileBloc
                    .add(TriggerCheckUnCheckParentalInformation());
                if (!state.isContactNumberValid) {
                  Future.delayed(const Duration(milliseconds: 400), () {
                    state.formKey.currentState!.validate();
                    createEditProfileBloc.add(
                      TriggerEnableInteractionWithContactField(),
                    );
                    createEditProfileBloc.add(
                      TriggerCheckZipCodeField(),
                    );
                  });
                }
              },
              singleText: AppStrings.checkbox_agreeAsParentOrGuardian_label),
          buildCustomEmailField(
            validator: (value) {
              return TextFieldValidators.validateEmail(
                  value ?? AppStrings.global_empty_string);
            },
            onChanged: (value) {
              // state.formKey.currentState!.validate();
            },
            emailAddressController: state.emailEditingController,
            emailFocusNode: state.emailFocusNode,
          ),
          buildPhoneField(context, state),
          buildAddressField(state: state, context: context),
          buildZipField(state),
          SizedBox(
            height: Dimensions.screenVerticalSpacing,
          ),
        ],
      ),
    );
  }

//
  Widget buildZipField(CreateEditProfileWithInitialState state) {
    debugPrint('ZipError: ${state.zipError}');
    return buildZipCodeField(
      zipError: state.zipError,
      onChanged: (value) {
        createEditProfileBloc.add(TriggerCheckForUserUpdateButton(
            isOwner: state.createProfileTypes ==
                CreateProfileTypes.editProfileForOwner));
      },
      zipCodeEditingController: state.zipCodeEditingController,
      zipCodeFocusNode: state.zipCodeFocusNode,
      // validator: (value) {
      //   return TextFieldValidators.validateZip(
      //       value: value ?? AppStrings.global_empty_string);
      // },
    );
  }

  Widget buildAddressField(
      {required CreateEditProfileWithInitialState state,
      required BuildContext context,
      Widget? zip}) {
    return zip == null
        ? buildCustomGooglePlacesTextFormField(
            onChanged: (value) {
              createEditProfileBloc.add(TriggerCheckForUserUpdateButton(
                  isOwner: state.createProfileTypes ==
                      CreateProfileTypes.editProfileForOwner));

              //state.formKey.currentState!.validate();
            },
            textEditingController: state.postalAddressEditingController,
            validator: (value) {
              return TextFieldValidators.validatePostalAddress(
                  address: value ?? AppStrings.global_empty_string,
                  city: state.city);
            },
            itmClick: (Prediction prediction) async {
              createEditProfileBloc.add(TriggerFetchPlaceDetails(
                prediction: prediction,
              ));
            })
        : SizedBox(
            width: Dimensions.getScreenWidth(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: buildCustomGooglePlacesTextFormField(
                        onChanged: (value) {
                          createEditProfileBloc.add(
                              TriggerCheckForUserUpdateButton(
                                  isOwner: state.createProfileTypes ==
                                      CreateProfileTypes.editProfileForOwner));

                          // state.formKey.currentState!.validate();
                        },
                        textEditingController:
                            state.postalAddressEditingController,
                        validator: (value) {
                          return TextFieldValidators.validatePostalAddress(
                              address: value ?? AppStrings.global_empty_string,
                              city: state.city);
                        },
                        itmClick: (Prediction prediction) async {
                          createEditProfileBloc.add(
                              TriggerFetchPlaceDetails(prediction: prediction));
                        }),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(child: zip)
              ],
            ),
          );
  }

  Widget buildPhoneField(
      BuildContext context, CreateEditProfileWithInitialState state) {
    return buildCustomPhoneField(
      onChanged: (value) {
        createEditProfileBloc.add(TriggerCheckForUserUpdateButton(
            isOwner: state.createProfileTypes ==
                CreateProfileTypes.editProfileForOwner));
        createEditProfileBloc.add(TriggerEnableInteractionWithContactField());
      },
      isContactNumberValid: state.isContactNumberValid,
      context: context,
      phoneNumberController: state.contactNumberEditingController,
      phoneNumberFocusNode: state.contactNumberFocusNode,
      validator: (value) {
        return TextFieldValidators.validateContactNumber(
            value: value ?? AppStrings.global_empty_string);
      },
    );
  }

  Row buildNames(CreateEditProfileWithInitialState state) {
    return buildNameSection(
      onChangedFirstName: (value) {
        createEditProfileBloc.add(TriggerCheckForUserUpdateButton(
            isOwner: state.createProfileTypes ==
                CreateProfileTypes.editProfileForOwner));
        //state.formKey.currentState!.validate();
      },
      onChangedLastName: (value) {
        createEditProfileBloc.add(TriggerCheckForUserUpdateButton(
            isOwner: state.createProfileTypes ==
                CreateProfileTypes.editProfileForOwner));
        //state.formKey.currentState!.validate();
      },
      firstNameEditingController: state.firstNameEditingController,
      firstNameFocusNode: state.firstNameFocusNode,
      lastNameEditingController: state.lastNameEditingController,
      lastNameFocusNode: state.lastNameFocusNode,
      lastNameValidator: (value) {
        return TextFieldValidators.validateName(
          value: value ?? AppStrings.global_empty_string,
          nameTypes: NameTypes.lastName,
        );
      },
      firstNameValidator: (value) {
        return TextFieldValidators.validateName(
          value: value ?? AppStrings.global_empty_string,
          nameTypes: NameTypes.firstName,
        );
      },
    );
  }

  Widget buildProfileImage(
      BuildContext context, CreateEditProfileWithInitialState state) {
    return buildProfileImagePlaceHolder(
      membership: state.athlete?.membership,
      isEditAthlete: state.createProfileTypes ==
              CreateProfileTypes.editProfileForAthlete ||
          state.createProfileTypes == CreateProfileTypes.editAthleteLocally,
      label: state.label,
      onTap: () {
        buildBottomSheetWithBodyText(
            context: context,
            title: AppStrings.bottomSheet_uploadProfilePicture_title,
            subtitle: AppStrings.bottomSheet_uploadProfilePicture_subtitle,
            isSingeButtonPresent: false,
            leftButtonText: AppStrings.btn_camera,
            rightButtonText: AppStrings.btn_gallery,
            onLeftButtonPressed: () {
              createEditProfileBloc.add(
                const TriggerImageEvent(isCamera: true),
              );
              Navigator.of(context).pop();
            },
            onRightButtonPressed: () {
              createEditProfileBloc.add(
                const TriggerImageEvent(isCamera: false),
              );
              Navigator.of(context).pop();
            });
      },
      file: state.file,
      networkImageUrl: state.imageUrl,
    );
  }

  List<Widget> buildOwnerCalendarAndGenderSection(
      CreateEditProfileWithInitialState state) {
    return [
      buildDOBField(state, context, AgeType.owner),
      buildGenders(state),
    ];
  }

  Widget buildGenders(CreateEditProfileWithInitialState state) {
    return customGenderRadioButtons(
        onTapSelectMale: () {
          createEditProfileBloc.add(
            const TriggerGenderSelection(index: 0),
          );
          createEditProfileBloc.add(TriggerCheckForUserUpdateButton(
              isOwner: state.createProfileTypes ==
                  CreateProfileTypes.editProfileForOwner));
        },
        onTapSelectFemale: () {
          createEditProfileBloc.add(
            const TriggerGenderSelection(index: 1),
          );
          createEditProfileBloc.add(TriggerCheckForUserUpdateButton(
              isOwner: state.createProfileTypes ==
                  CreateProfileTypes.editProfileForOwner));
        },
        currentlySelectedGroupValue: state.radioButtonIndex);
  }

  Widget buildDOBField(CreateEditProfileWithInitialState state,
      BuildContext context, AgeType ageType) {
    return buildCustomCalendarWithOrWithoutWeightField(
      isWithWeightInARow: ageType == AgeType.athlete,
      weightFocusNode: state.weightFocusNode,
      weightField: state.weightEditingController,
      calendarField: state.dateOfBirthEditingController,
      calendarFocusNode: state.dateOfBirthFocusNode,
      calendarLabel: AppStrings.textfield_selectDateOfBirth_label,
      calendarHint: AppStrings.textfield_selectDateOfBirth_hint,
      isStaff: state.createProfileTypes ==
              CreateProfileTypes.editAthleteLocally ||
          state.createProfileTypes == CreateProfileTypes.createAthleteLocally,
      calendarIsAsteriskPresent: true,
      onFieldSubmitted: (value) {
        return TextFieldValidators.validateBirthday(
            ageType: ageType,
            birthDay: value ?? AppStrings.global_empty_string);
      },
      onChangedCalendar: (value) {
        createEditProfileBloc.add(TriggerCheckForUserUpdateButton(
            dob: true,
            isOwner: state.createProfileTypes ==
                CreateProfileTypes.editProfileForOwner));
        //state.formKey.currentState!.validate();
      },
      onChangedWeight: (value) {
        createEditProfileBloc.add(TriggerCheckForUserUpdateButton(
            isOwner: state.createProfileTypes ==
                CreateProfileTypes.editProfileForOwner));
      },
      calendarSuffixIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          AppAssets.icCalendar,
          fit: BoxFit.contain,
        ),
      ),
      onTapToOpenCalendar: () {
        createEditProfileBloc.add(TriggerOpenCalendar(ageType: ageType));
        createEditProfileBloc.add(TriggerCheckForUserUpdateButton(
            dob: true,
            isOwner: state.createProfileTypes ==
                CreateProfileTypes.editProfileForOwner));
      },
      dateErrorText: state.dateError,
      calendarValidator: (value) {
        createEditProfileBloc
            .add(TriggerValidateCalenderDate(ageType: ageType));

        return null;
      },
      weightValidator: ageType == AgeType.athlete
          ? (value) {
              return TextFieldValidators.validateWeight(
                  value: value ?? AppStrings.global_empty_string);
            }
          : null,
    );
  }
}
