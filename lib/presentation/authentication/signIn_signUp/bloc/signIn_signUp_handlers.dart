import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rmnevents/presentation/authentication/signIn_signUp/bloc/sign_in_sign_up_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../data/models/response_models/apple_login_response_model.dart';
import '../../../../data/models/social_response_model.dart';
import '../../../../imports/app_configurations.dart';
import '../../../../imports/common.dart';
import '../../../../services/social_auth_services/social_auth_services.dart';

class SignInSignUpHandlers {
  static void emitInitialState(
      {required Emitter<SignInSignUpWithInitialState> emit,
      required SignInSignUpWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));
  }

  static void openNewView(
      {required Emitter<SignInSignUpWithInitialState> emit,
      required SignInSignUpWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        isConfirmPasswordObscure: true,
        isPasswordObscure: true,
        isPasswordCheckerHidden: true,
        isAtLeastEightCharChecked: false,
        isAtLeastOneLowerCaseChecked: false,
        isAtLeastOneUpperCaseChecked: false,
        isAtLeastOneDigitChecked: false,
        isAtLeastOneSpecialCharChecked: false,
        isSignUpButtonActive: false,
        emailEditingController: TextEditingController(),
        passwordEditingController: TextEditingController(),
        confirmPasswordEditingController: TextEditingController(),
        emailFocusNode: FocusNode(),
        passwordFocusNode: FocusNode(),
        confirmPasswordFocusNode: FocusNode(),
        formKey: GlobalKey<FormState>(),
        isBoxChecked: false,
        message: AppStrings.global_empty_string));
  }

  static void emitWithLoader(
      {required Emitter<SignInSignUpWithInitialState> emit,
      required SignInSignUpWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: true,
        message: AppStrings.global_empty_string));
  }

  static Future<SocialResponseModel?> getSocialResponseModel(
      {required Socials social}) async {
    switch (social) {
      case Socials.google:
        try {
          GoogleSignInAccount? user =
              await SocialAuthServices.signInWithGoogle();

          if (user != null) {
            return SocialResponseModel(
              email: GlobalHandlers.dataEncryptionHandler(value: user.email),
              firstName: GlobalHandlers.dataEncryptionHandler(
                  value: user.displayName!.split(' ')[0]),
              lastName: GlobalHandlers.dataEncryptionHandler(
                  value: user.displayName!.split(' ')[1]),
              profile: user.photoUrl ?? AppStrings.global_empty_string,
              socialId: GlobalHandlers.dataEncryptionHandler(value: user.id),
              type: GlobalHandlers.dataEncryptionHandler(
                  value: Socials.google.name),
            );
          } else {
            debugPrint("Google login failed: facebookLogin is null");
            return null;
          }
        } catch (e) {
          debugPrint("Error during Google login: $e");
          return null;
        }
      case Socials.facebook:
        try {
          FacebookLogin? facebookLogin =
              await SocialAuthServices.signInWithFacebook();
          if (facebookLogin != null) {
            String email = await facebookLogin.getUserEmail() ??
                AppStrings.global_empty_string;

            String profile = await facebookLogin.getProfileImageUrl(
                  width: 800,
                  height: 800,
                ) ??
                AppStrings.global_empty_string;

            FacebookUserProfile? facebookUserProfile =
                await facebookLogin.getUserProfile();
            String firstName = AppStrings.global_empty_string;
            String lastName = AppStrings.global_empty_string;
            String socialId = AppStrings.global_empty_string;

            if (facebookUserProfile != null) {
              firstName = facebookUserProfile.firstName ??
                  AppStrings.global_empty_string;
              lastName = facebookUserProfile.lastName ??
                  AppStrings.global_empty_string;
              socialId =
                  facebookUserProfile.userId ?? AppStrings.global_empty_string;
            }

            return SocialResponseModel(
              email: GlobalHandlers.dataEncryptionHandler(value: email),
              firstName: GlobalHandlers.dataEncryptionHandler(value: firstName),
              lastName: GlobalHandlers.dataEncryptionHandler(value: lastName),
              profile: profile,
              socialId: GlobalHandlers.dataEncryptionHandler(value: socialId),
              type: GlobalHandlers.dataEncryptionHandler(
                  value: Socials.facebook.name),
            );
          } else {
            debugPrint("Facebook login failed: facebookLogin is null");
            return null;
          }
        } catch (e) {
          debugPrint("Error during Facebook login: $e");
          return null;
        }
      case Socials.apple:
        try {
          final AuthorizationCredentialAppleID credential =
              await _getAppleIDCredential();
          final appleUserData = await _fetchOrCreateAppleUserData(credential);
          return SocialResponseModel(
            email: GlobalHandlers.dataEncryptionHandler(
                value: appleUserData.email),
            firstName: GlobalHandlers.dataEncryptionHandler(
                value: appleUserData.firstName),
            lastName: GlobalHandlers.dataEncryptionHandler(
                value: appleUserData.lastName),
            profile: appleUserData.photoUrl,
            socialId: GlobalHandlers.dataEncryptionHandler(
                value: appleUserData.userIdentifier),
            type: GlobalHandlers.dataEncryptionHandler(
                value: Socials.facebook.name),
          );
        } catch (e) {
          debugPrint("Error during Apple login: $e");
          return null;
        }
      case Socials.none:
        return null;
    }
  }

  static Future<void> handleAppleSignInRequest(
      {required TriggerSignInViaApple event,
      required Emitter<SignInSignUpWithInitialState> emit,
      required Future<void> function,
      required SignInSignUpWithInitialState state}) async {
    emit(state.copyWith(
      message: '',
      isLoading: true,
      isFailure: false,
    ));
    try {
      final AuthorizationCredentialAppleID credential =
          await _getAppleIDCredential();
      debugPrint("credentials are $credential");
      final appleUserData = await _fetchOrCreateAppleUserData(credential);
      debugPrint("apple user data is $appleUserData");
      await function;
    } on SignInWithAppleAuthorizationException {
      emit(state.copyWith(isLoading: false, message: ''));
    } catch (e) {
      debugPrint("error is $e");
      emit(state.copyWith(message: e.toString(), isFailure: true));
    }
  }

  static _fetchOrCreateAppleUserData(credential) async {
    final AppleUserDataModel appleUserData = AppleUserDataModel(
      firstName: credential.givenName ?? '',
      lastName: credential.familyName ?? '',
      email: credential.email ?? '',
      userIdentifier: credential.userIdentifier!,
    );
    return appleUserData;
  }

  static _getAppleIDCredential() async {
    return await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: AppEnvironments.iOSBundleID,
        redirectUri: Uri.parse(
          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
    );
  }
}
