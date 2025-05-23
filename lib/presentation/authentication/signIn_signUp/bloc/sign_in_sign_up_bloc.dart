import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/models/social_response_model.dart';
import 'package:rmnevents/presentation/authentication/signIn_signUp/bloc/signIn_signUp_handlers.dart';
import 'package:rmnevents/root_app.dart';
import '../../../../data/models/arguments/athlete_argument.dart';
import '../../../../device_variables.dart';
import '../../../../imports/common.dart';
import '../../../../imports/data.dart';
import '../../otp/bloc/otp_bloc.dart';

part 'sign_in_sign_up_event.dart';

part 'sign_in_sign_up_state.dart';

part 'sign_in_sign_up_bloc.freezed.dart';

class SignInSignUpBloc
    extends Bloc<SignInSignUpEvent, SignInSignUpWithInitialState> {
  SignInSignUpBloc() : super(SignInSignUpWithInitialState.initial()) {
    on<TriggerReInitializeAuthenticationType>(
        _onTriggerReInitializeAuthenticationType);
    on<TriggerUpdateFieldOnChange>(_onTriggerUpdateFieldOnChange);
    on<TriggerHideUnHideFieldContents>(_onTriggerHideUnHideFieldContents);
    on<TriggerRevealPasswordChecker>(_onTriggerRevealPasswordChecker);
    on<TriggerSwitchBetweenSignInSignUpView>(_onTriggerSwitchToSignUpView);
    on<TriggerCheckBoxToAgree>(_onTriggerCheckBoxToAgree);
    on<TriggerSignInViaEmail>(_onTriggerSignInViaEmail);
    on<TriggerSignUpViaEmailP>(_onTriggerSignUpViaEmail);
    on<TriggerOpenSignUpMask>(_onTriggerOpenSignUpMask);
    on<TriggerActivateSignInButton>(_onTriggerActivateSignInButton);
    on<TriggerSubmitSignUpMaskData>(_onTriggerSubmitSignUpMaskData);
    on<TriggerSignInSignUpViaGoogle>(_onTriggerSignInSignUpViaGoogle);
    on<TriggerSignInSignUpViaFacebook>(_onTriggerSignInSignUpViaFacebook);
    on<TriggerSignInViaApple>(_onTriggerSignInViaApple);
    on<TriggerCheckForButtonActivity>(_onTriggerCheckForButtonActivity);
  }

  FutureOr<void> _onTriggerReInitializeAuthenticationType(
      TriggerReInitializeAuthenticationType event,
      Emitter<SignInSignUpWithInitialState> emit) {
    emit(SignInSignUpWithInitialState.initial());
  }

  FutureOr<void> _onTriggerUpdateFieldOnChange(TriggerUpdateFieldOnChange event,
      Emitter<SignInSignUpWithInitialState> emit) {
    SignInSignUpHandlers.emitInitialState(emit: emit, state: state);

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

  FutureOr<void> _onTriggerHideUnHideFieldContents(
      TriggerHideUnHideFieldContents event,
      Emitter<SignInSignUpWithInitialState> emit) {
    SignInSignUpHandlers.emitInitialState(emit: emit, state: state);
    if (event.fieldType == FieldType.password) {
      emit(state.copyWith(
        isRefreshRequired: false,
        isPasswordObscure: !state.isPasswordObscure,
      ));
    }
    if (event.fieldType == FieldType.confirmPassword) {
      emit(state.copyWith(
        isRefreshRequired: false,
        isConfirmPasswordObscure: !state.isConfirmPasswordObscure,
      ));
    }
  }

  FutureOr<void> _onTriggerRevealPasswordChecker(
      TriggerRevealPasswordChecker event,
      Emitter<SignInSignUpWithInitialState> emit) {
    SignInSignUpHandlers.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
      isRefreshRequired: false,
      isPasswordCheckerHidden: false,
    ));
  }

  FutureOr<void> _onTriggerSwitchToSignUpView(
      TriggerSwitchBetweenSignInSignUpView event,
      Emitter<SignInSignUpWithInitialState> emit) {
    SignInSignUpHandlers.openNewView(emit: emit, state: state);
    Authentication authenticationType = state.authenticationType;
    Authentication type = authenticationType == Authentication.signIn
        ? Authentication.signUp
        : Authentication.signIn;
    emit(state.copyWith(authenticationType: type));
  }

  FutureOr<void> _onTriggerCheckBoxToAgree(TriggerCheckBoxToAgree event,
      Emitter<SignInSignUpWithInitialState> emit) {
    SignInSignUpHandlers.emitInitialState(emit: emit, state: state);
    bool isCheck = !state.isBoxChecked;
    bool isActive = state.emailEditingController.text.isNotEmpty &&
        state.passwordEditingController.text.isNotEmpty &&
        isCheck &&
        state.confirmPasswordEditingController.text.isNotEmpty;
    emit(state.copyWith(
      isRefreshRequired: false,
      isBoxChecked: isCheck,
      isSignUpButtonActive:
          state.authenticationType == Authentication.signUpMask
              ? isCheck
              : isActive,
    ));
  }

  FutureOr<void> _onTriggerSignInViaEmail(TriggerSignInViaEmail event,
      Emitter<SignInSignUpWithInitialState> emit) async {
    SignInSignUpHandlers.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
      isRefreshRequired: false,
      isLoading: true,
    ));
    try {
      final response = await AuthenticationRepository.signIn(
        signInSignUpRequestModel: AuthenticationSignUpSignInRequestModel(
          email: GlobalHandlers.dataEncryptionHandler(
              value: state.emailEditingController.text),
          password: GlobalHandlers.dataEncryptionHandler(
              value: state.passwordEditingController.text),
          isLogin: '1',
          deviceType: DeviceVariables.deviceType,
          deviceToken: kDebugMode
              ? "wbcd"
              : await DeviceVariables.deviceToken(), //todo:salim
        ),
      );
      response.fold((failure) {
        emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          message: failure.message,
        ));
      }, (success) async {
        DataBaseUser user = success.responseData!.user!;
        TextInput.finishAutofillContext();
        bool needsToChangePassword =  user.isPasswordChangeRequired ?? false;
        if(needsToChangePassword){

          buildCustomToast(msg: success.responseData!.message!, isFailure: false);
          Navigator.pushNamed(
              navigatorKey.currentContext!,
              AppRouteNames.routeResetPassword,
            arguments: user.token
          );
          emit(state.copyWith(
            isLoading: false,
            isFailure: false,
            message: AppStrings.global_empty_string,
          ));
          await RepositoryDependencies.userCachedData
              .setUserSession(value: true);
        }
        else{
          if (user.moveToCreateProfile!) {
            emit(state.copyWith(
              isLoading: false,
              isFailure: false,
              message: success.responseData!.message!,
              routeName: AppRouteNames.routeCreateOrEditAthleteProfile,
            ));
            Navigator.pushNamedAndRemoveUntil(
                navigatorKey.currentContext!,
                AppRouteNames.routeCreateOrEditAthleteProfile,
                arguments: AthleteArgument(
                    createProfileType: CreateProfileTypes.createProfileForOwner
                ),
                    (route) => false);
          }
          else {
            emit(state.copyWith(
              isLoading: false,
              isFailure: false,
              message: success.responseData!.message!,
              routeName: AppRouteNames.routeBase,
            ));

            await RepositoryDependencies.userCachedData
                .setUserSession(value: true);
            Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
                AppRouteNames.routeBase, (route) => false,
                arguments: true);
          }
        }

      });
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
        message: extractErrorMessage(e),
      ));
    }
  }

  FutureOr<void> _onTriggerSignInSignUpViaGoogle(
      TriggerSignInSignUpViaGoogle event,
      Emitter<SignInSignUpWithInitialState> emit) async {
    SignInSignUpHandlers.emitWithLoader(emit: emit, state: state);
    //await SocialAuthServices.signOutSocially();
    SocialResponseModel? socialResponseModel =
        await SignInSignUpHandlers.getSocialResponseModel(
      social: Socials.google,
    );
    if (socialResponseModel != null) {
      try {
        final response = await AuthenticationRepository.signInSignUpSocially(
            signInSignUpRequestModel: AuthenticationSignUpSignInRequestModel(
                firstName: socialResponseModel.firstName!,
                lastName: socialResponseModel.lastName!,
                profile: socialResponseModel.profile ??
                    AppStrings.global_empty_string,
                type:
                    socialResponseModel.type ?? AppStrings.global_empty_string,
                socialId: socialResponseModel.socialId!,
                email: socialResponseModel.email!,
                deviceType: DeviceVariables.deviceType,
                deviceToken: await DeviceVariables.deviceToken(),
                isEmailVerified: true,
                isPolicyAccepted: false));

        response.fold((failure) {
          emit(state.copyWith(
            isLoading: false,
            isFailure: true,
            message: failure.message,
          ));
        }, (success) async {
          DataBaseUser user = success.responseData!.user!;
          bool isPolicyAccepted = user.policyAcceptedOn != null;
          bool isProfileComplete = user.isProfileComplete ?? false;
          if (isPolicyAccepted) {
            if (isProfileComplete) {
              emit(state.copyWith(
                isLoading: false,
                isFailure: false,
                message: success.responseData!.message!,
                routeName: AppRouteNames.routeBase,
              ));
              await RepositoryDependencies.userCachedData
                  .setUserSession(value: true);
              Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
                  AppRouteNames.routeBase, (route) => false,
                  arguments: true);
            } else {
              emit(state.copyWith(
                isLoading: false,
                isFailure: false,
                message: success.responseData!.message!,
                routeName: AppRouteNames.routeCreateOrEditAthleteProfile,
              ));
              Navigator.pushNamedAndRemoveUntil(
                  navigatorKey.currentContext!,
                  AppRouteNames.routeCreateOrEditAthleteProfile,
                  arguments: AthleteArgument(createProfileType: CreateProfileTypes.createProfileForOwner),
                  (route) => false);
            }
          } else {
            emit(state.copyWith(
              authenticationType: Authentication.signUpMask,
              formKey: GlobalKey<FormState>(),
              emailEditingController: TextEditingController(text: user.email),
              isBoxChecked: false,
              isPasswordObscure: true,
              isConfirmPasswordObscure: true,
              isPasswordCheckerHidden: true,
              message: AppStrings.global_empty_string,
              isFailure: false,
              isLoading: false,
              socialResponseModel: socialResponseModel,
            ));
          }
        });
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          message: e.toString(),
        ));
      }
    } else {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
        message: AppStrings.global_empty_string,
      ));
    }
  }

  FutureOr<void> _onTriggerSignUpViaEmail(TriggerSignUpViaEmailP event,
      Emitter<SignInSignUpWithInitialState> emit) async {
    SignInSignUpHandlers.emitWithLoader(emit: emit, state: state);
    try {
      final response = await AuthenticationRepository.signUp(
        signInSignUpRequestModel: AuthenticationSignUpSignInRequestModel(
          email: GlobalHandlers.dataEncryptionHandler(
              value: state.emailEditingController.text),
          password: GlobalHandlers.dataEncryptionHandler(
              value: state.confirmPasswordEditingController.text),
        ),
      );
      response.fold((failure) {
        emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          message: failure.message,
        ));
      }, (success) {
        String userId = GlobalHandlers.dataEncryptionHandler(
            value: success.responseData!.userId!);
        OtpArgument otpArgument = OtpArgument(
            userEmail: state.emailEditingController.text,
            encryptedUserId: userId);
        emit(state.copyWith(
          isLoading: false,
          isFailure: false,
          message: success.responseData!.message!,
        ));
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          AppRouteNames.routeOtp,
          arguments: otpArgument,
        );
      });
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerOpenSignUpMask(
      TriggerOpenSignUpMask event, Emitter<SignInSignUpWithInitialState> emit) {
    emit(state.copyWith(
      authenticationType: Authentication.signUpMask,
      formKey: GlobalKey<FormState>(),
      isBoxChecked: false,
      message: AppStrings.global_empty_string,
      isFailure: false,
      emailEditingController: event.email.isNotEmpty
          ? TextEditingController(text: event.email)
          : TextEditingController(),
    ));
  }

  FutureOr<void> _onTriggerSubmitSignUpMaskData(
      TriggerSubmitSignUpMaskData event,
      Emitter<SignInSignUpWithInitialState> emit) async {
    SignInSignUpHandlers.emitWithLoader(emit: emit, state: state);
    try {
      final response = await AuthenticationRepository.signInSignUpSocially(
          signInSignUpRequestModel: AuthenticationSignUpSignInRequestModel(
              firstName: state.socialResponseModel!.firstName!,
              lastName: state.socialResponseModel!.lastName!,
              profile: state.socialResponseModel!.profile ??
                  AppStrings.global_empty_string,
              type: state.socialResponseModel!.type ??
                  AppStrings.global_empty_string,
              socialId: state.socialResponseModel!.socialId!,
              email: state.socialResponseModel!.email!,
              deviceType: DeviceVariables.deviceType,
              deviceToken: await DeviceVariables.deviceToken(),
              isEmailVerified: true,
              isPolicyAccepted: true));

      response.fold((failure) {
        emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          message: failure.message,
        ));
      }, (success) {
        DataBaseUser user = success.responseData!.user!;
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!,
            AppRouteNames.routeCreateOrEditAthleteProfile,
            arguments: AthleteArgument(createProfileType: CreateProfileTypes.createProfileForOwner),
            (route) => false);
      });
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerSignInSignUpViaFacebook(
      TriggerSignInSignUpViaFacebook event,
      Emitter<SignInSignUpWithInitialState> emit) async {
    SignInSignUpHandlers.emitWithLoader(emit: emit, state: state);

    SocialResponseModel? socialResponseModel =
        await SignInSignUpHandlers.getSocialResponseModel(
      social: Socials.facebook,
    );
    if (socialResponseModel != null) {
      try {
        final response = await AuthenticationRepository.signInSignUpSocially(
            signInSignUpRequestModel: AuthenticationSignUpSignInRequestModel(
                firstName: socialResponseModel.firstName!,
                lastName: socialResponseModel.lastName!,
                profile: socialResponseModel.profile ??
                    AppStrings.global_empty_string,
                type:
                    socialResponseModel.type ?? AppStrings.global_empty_string,
                socialId: socialResponseModel.socialId!,
                email: socialResponseModel.email!,
                deviceType: DeviceVariables.deviceType,
                deviceToken: await DeviceVariables.deviceToken(),
                isEmailVerified: true,
                isPolicyAccepted: false));
        response.fold((failure) {
          emit(state.copyWith(
            isLoading: false,
            isFailure: true,
            message: failure.message,
          ));
        }, (success) async {
          DataBaseUser user = success.responseData!.user!;
          bool isPolicyAccepted = user.policyAcceptedOn != null;
          bool isProfileComplete = user.isProfileComplete ?? false;
          if (isPolicyAccepted) {
            if (isProfileComplete) {
              emit(state.copyWith(
                isLoading: false,
                isFailure: false,
                message: success.responseData!.message!,
                routeName: AppRouteNames.routeBase,
              ));
              await RepositoryDependencies.userCachedData
                  .setUserSession(value: true);
              Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
                  AppRouteNames.routeBase, (route) => false,
                  arguments: true);
            } else {
              emit(state.copyWith(
                isLoading: false,
                isFailure: false,
                message: success.responseData!.message!,
                routeName: AppRouteNames.routeCreateOrEditAthleteProfile,
              ));
              Navigator.pushNamedAndRemoveUntil(
                  navigatorKey.currentContext!,
                  AppRouteNames.routeCreateOrEditAthleteProfile,
                  arguments: AthleteArgument(createProfileType: CreateProfileTypes.createProfileForOwner),
                  (route) => false);
            }
          } else {
            emit(state.copyWith(
              authenticationType: Authentication.signUpMask,
              formKey: GlobalKey<FormState>(),
              emailEditingController: TextEditingController(text: user.email),
              isBoxChecked: false,
              isPasswordObscure: true,
              isConfirmPasswordObscure: true,
              isPasswordCheckerHidden: true,
              message: AppStrings.global_empty_string,
              isFailure: false,
              isLoading: false,
              socialResponseModel: socialResponseModel,
            ));
          }
        });
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          message: e.toString(),
        ));
      }
    } else {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
        message: AppStrings.global_empty_string,
      ));
    }

    // if (await networkInfo.isConnected) {
    //   emit(FacebookLoginLoadingState());
    //   try {
    //     await SocialAuthService.facebookAuthentication()
    //         .then((FacebookLogin? facebookData) async {
    //       FacebookUserProfile? facebookUser =
    //       await facebookData!.getUserProfile();
    //       debugPrint("facebook value--> ${facebookData.getUserProfile()}");
    //       final accessToken = await facebookData.accessToken;
    //       profileImageFaceBookUrl = await facebookData.getProfileImageUrl(
    //           width: LoginScreenValues.fbIconWidth,
    //           height: LoginScreenValues.fbIconHeight);
    //
    //       if (accessToken!.permissions
    //           .contains(FacebookPermission.email.name)) {
    //         userEmail = await facebookData.getUserEmail();
    //         isEmailVerified = true;
    //         userData.isEmailVerified = true;
    //         if (userEmail == null) {
    //           isEmailVerified = false;
    //           userEmail = "";
    //           userData.isEmailVerified = false;
    //           // userEmail = AppKeywords.noEmailProvided;
    //         }
    //       }
    //       debugPrint(
    //           "socialLoginEncryptedData userEmail--> ${profileImageFaceBookUrl}");
    //
    //       try {
    //         (await socialLoginUseCase!.execute(SocialLoginUseCaseInput(
    //             firstName:
    //             dataEncryptionHandler(value: facebookUser!.firstName!),
    //             lastName:
    //             dataEncryptionHandler(value: facebookUser.lastName!),
    //             email: userEmail != null
    //                 ? dataEncryptionHandler(value: userEmail!)
    //                 : "",
    //             profile: profileImageFaceBookUrl.toString(),
    //             type: dataEncryptionHandler(
    //                 value: AppKeywords.socialLoginFacebook),
    //             socialId: dataEncryptionHandler(value: facebookUser.userId),
    //             isEmailVerified: isEmailVerified,
    //             isPolicyAccepted: isPolicyAccepted)))
    //             .fold((failure) {}, (success) {
    //           if(success.responseData!.user!.roles!.isNotEmpty){
    //             if (!success.responseData!.user!.roles!.contains('user')) {
    //               emit(FacebookLoginLoadedState(success.status!,
    //                   success.responseData!.message!, userEmail.toString()));
    //             }
    //             if (success.responseData!.user!.roles!.contains('user')) {
    //               if (success.responseData!.user!.policyAcceptedOn!.isNotEmpty) {
    //                 if (success.responseData!.user!.isProfileComplete!) {
    //                   emit(FacebookLoginLoadedState(success.status!,
    //                       success.responseData!.message!, userEmail.toString()));
    //                 } else {
    //                   emit(CreateProfileState(
    //
    //                       email: userEmail!,
    //                       fName: facebookUser.firstName! ?? "",
    //                       lName: facebookUser.lastName! ?? ""));
    //                 }
    //               } else {
    //                 emit(SignUpMaskState(
    //
    //                 ));
    //               }
    //             }
    //           }else{
    //             emit(SignUpMaskState(
    //             ));
    //           }
    //         });
    //       } catch (e) {
    //         emit(FacebookLoginErrorState());
    //       }
    //     }); //.facebookLogin();
    //   } catch (e) {
    //     emit(FacebookLoginErrorState());
    //   }
    // } else {
    //   emit(FacebookLoginErrorState());
    // }
  }

  FutureOr<void> _onTriggerCheckForButtonActivity(
      TriggerCheckForButtonActivity event,
      Emitter<SignInSignUpWithInitialState> emit) {
    SignInSignUpHandlers.emitInitialState(emit: emit, state: state);
    bool isActive = state.emailEditingController.text.isNotEmpty &&
        state.passwordEditingController.text.isNotEmpty &&
        state.isBoxChecked &&
        state.confirmPasswordEditingController.text.isNotEmpty &&
        state.confirmPasswordEditingController.text ==
            state.passwordEditingController.text;

    print(
        'isActive: ${state.authenticationType} $isActive - ${state.isBoxChecked}');
    emit(state.copyWith(
      isRefreshRequired: false,
      isSignUpButtonActive: isActive,
    ));
  }

  FutureOr<void> _onTriggerActivateSignInButton(
      TriggerActivateSignInButton event,
      Emitter<SignInSignUpWithInitialState> emit) {
    SignInSignUpHandlers.emitInitialState(emit: emit, state: state);
    emit(state.copyWith(
      isRefreshRequired: false,
      isSignInButtonActive: state.emailEditingController.text.isNotEmpty &&
          state.passwordEditingController.text.isNotEmpty,
    ));
  }

  FutureOr<void> _onTriggerSignInViaApple(TriggerSignInViaApple event,
      Emitter<SignInSignUpWithInitialState> emit) async {
    SignInSignUpHandlers.emitWithLoader(emit: emit, state: state);

    SocialResponseModel? socialResponseModel =
        await SignInSignUpHandlers.getSocialResponseModel(
      social: Socials.apple,
    );
    if (socialResponseModel != null) {
      try {
        final response = await AuthenticationRepository.signInSignUpSocially(
            signInSignUpRequestModel: AuthenticationSignUpSignInRequestModel(
                firstName: socialResponseModel.firstName ?? "",
                lastName: socialResponseModel.lastName ?? "",
                profile: socialResponseModel.profile ??
                    AppStrings.global_empty_string,
                type:
                    socialResponseModel.type ?? AppStrings.global_empty_string,
                socialId: socialResponseModel.socialId!,
                email: socialResponseModel.email ?? "",
                deviceType: DeviceVariables.deviceType,
                deviceToken: await DeviceVariables.deviceToken(),
                isEmailVerified: true,
                isPolicyAccepted: false));
        response.fold((failure) {
          emit(state.copyWith(
            isLoading: false,
            isFailure: true,
            message: failure.message,
          ));
        }, (success) async {
          DataBaseUser user = success.responseData!.user!;
          bool isPolicyAccepted = user.policyAcceptedOn != null;
          bool isProfileComplete = user.isProfileComplete ?? false;
          if (isPolicyAccepted) {
            if (isProfileComplete) {
              emit(state.copyWith(
                isLoading: false,
                isFailure: false,
                message: success.responseData!.message!,
                routeName: AppRouteNames.routeBase,
              ));
              await RepositoryDependencies.userCachedData
                  .setUserSession(value: true);
              Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
                  AppRouteNames.routeBase, (route) => false,
                  arguments: true);
            } else {
              emit(state.copyWith(
                isLoading: false,
                isFailure: false,
                message: success.responseData!.message!,
                routeName: AppRouteNames.routeCreateOrEditAthleteProfile,
              ));
              Navigator.pushNamedAndRemoveUntil(
                  navigatorKey.currentContext!,
                  AppRouteNames.routeCreateOrEditAthleteProfile,
                  arguments: CreateProfileTypes.createProfileForOwner,
                  (route) => false);
            }
          } else {
            emit(state.copyWith(
              authenticationType: Authentication.signUpMask,
              formKey: GlobalKey<FormState>(),
              emailEditingController: TextEditingController(text: user.email),
              isBoxChecked: false,
              isPasswordObscure: true,
              isConfirmPasswordObscure: true,
              isPasswordCheckerHidden: true,
              message: AppStrings.global_empty_string,
              isFailure: false,
              isLoading: false,
              socialResponseModel: socialResponseModel,
            ));
          }
        });
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          message: e.toString(),
        ));
      }
    } else {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
        message: AppStrings.global_empty_string,
      ));
    }
  }
}
