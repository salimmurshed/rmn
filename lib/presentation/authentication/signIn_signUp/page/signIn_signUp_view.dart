import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/presentation/authentication/signIn_signUp/bloc/sign_in_sign_up_bloc.dart';

import '../../../../imports/common.dart';
import '../../widgets/build_forgot_password_text_btn.dart';
import '../../widgets/build_authentication_checkbox.dart';
import '../../widgets/build_authentication_column.dart';
import '../../widgets/build_authentication_langing_image.dart';
import '../../widgets/build_authentication_routing_text_btn.dart';
import '../../widgets/build_authentication_social_btns.dart';
import '../../widgets/build_authentication_social_option_text.dart';
import '../../widgets/build_authentication_subtitle.dart';
import '../../widgets/build_authentication_title.dart';

class SigInSignUpView extends StatefulWidget {
  final Authentication authenticationType;

  const SigInSignUpView({super.key, required this.authenticationType});

  @override
  State<SigInSignUpView> createState() => _SigInSignUpViewState();
}

class _SigInSignUpViewState extends State<SigInSignUpView> {
  @override
  initState() {
    BlocProvider.of<SignInSignUpBloc>(context).add(
        TriggerReInitializeAuthenticationType(
            authenticationType: widget.authenticationType));
    super.initState();
  }

  bool emailIsAutofilled = false;
  bool passwordIsAutofilled = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInSignUpBloc, SignInSignUpWithInitialState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
        }
      },
      child: BlocBuilder<SignInSignUpBloc, SignInSignUpWithInitialState>(
        builder: (context, state) {
          return state.isLoading
              ? CustomLoader(
                  child: buildSignInSignUpLayout(state, context),
                )
              : buildSignInSignUpLayout(state, context);
        },
      ),
    );
  }

  Widget buildSignInSignUpLayout(
      SignInSignUpWithInitialState state, BuildContext context) {
    return customScaffold(
      persistentFooterButtons: [
        buildAuthenticationRoutingTextBtn(
            onTapGestureRecogniser: () {
              BlocProvider.of<SignInSignUpBloc>(context)
                  .add(TriggerSwitchBetweenSignInSignUpView());
            },
            authentication: state.authenticationType)
      ],
      hasForm: true,
      anyWidgetWithoutSingleChildScrollView: null,
      formOrColumnInsideSingleChildScrollView: AutofillGroup(
        child: buildAuthenticationColumn(
            authenticationType: state.authenticationType,
            formKey: state.formKey,
            children: [
              buildAuthenticationLandingImage(),
              buildAuthenticationTitle(
                  authentication: state.authenticationType),
              customDivider(),
              buildAuthenticationSubtitle(
                  authentication: state.authenticationType),
              buildCustomEmailField(
                authenticationType: state.authenticationType,
                onChanged: (value) {
                  emailIsAutofilled = true;
                  if (state.authenticationType == Authentication.signUp) {
                    BlocProvider.of<SignInSignUpBloc>(context)
                        .add(TriggerCheckForButtonActivity());
                  }
                  if (state.authenticationType == Authentication.signIn) {
                    BlocProvider.of<SignInSignUpBloc>(context)
                        .add(TriggerActivateSignInButton());
                    Future.delayed(const Duration(seconds: 1)).whenComplete(() {
                      if (state.passwordEditingController.text.isNotEmpty) {
                        if (emailIsAutofilled && passwordIsAutofilled) {
                          FocusScope.of(context).unfocus();

                          emailIsAutofilled = false;
                          passwordIsAutofilled = false;
                          BlocProvider.of<SignInSignUpBloc>(context)
                              .add(TriggerSignInViaEmail());
                        }
                      }
                    });
                  }
                  //state.formKey.currentState!.validate();
                },
                onTap: () {
                  emailIsAutofilled = false;
                },
                isDisabled:
                    state.authenticationType == Authentication.signUpMask,
                isReadOnly:
                    state.authenticationType == Authentication.signUpMask,
                emailAddressController: state.emailEditingController,
                emailFocusNode: state.emailFocusNode,
                validator: (value) {
                  return TextFieldValidators.validateEmail(
                      value ?? AppStrings.global_empty_string);
                },
              ),
              if (state.authenticationType != Authentication.signUpMask)
                ...passwordField(state, context),
              if (!state.isPasswordCheckerHidden) ...passwordChecker(state),
              if (state.authenticationType == Authentication.signUp)
                ...confirmPasswordField(state, context),
              if (state.authenticationType != Authentication.signIn)
                ...checkboxText(state, context),
              if (state.authenticationType == Authentication.signIn)
                buildForgotPasswordTextBtn(),
              if (state.authenticationType == Authentication.signIn)
                ...signInBtn(state, context)
              else
                ...signUpBtn(state, context),
              if (state.authenticationType != Authentication.signUpMask)
                ...socialOptions(state, context),
            ]),
      ),
    );
  }

  List<Widget> socialOptions(
      SignInSignUpWithInitialState state, BuildContext context) {
    return [
      buildAuthenticationSocialOptionText(
          authentication: state.authenticationType),
      buildAuthenticationSocialBtns(googleOnTap: () {
        BlocProvider.of<SignInSignUpBloc>(context)
            .add(TriggerSignInSignUpViaGoogle());
      }, faceBookOnTap: () {
        BlocProvider.of<SignInSignUpBloc>(context)
            .add(TriggerSignInSignUpViaFacebook());
      }, appleOnTap: () {
        BlocProvider.of<SignInSignUpBloc>(context).add(TriggerSignInViaApple());
      })
    ];
  }

  List<Widget> signUpBtn(
      SignInSignUpWithInitialState state, BuildContext context) {
    return [
      buildCustomLargeFooterBtn(
          hasKeyBoardOpened: true,
          isColorFilledButton: true,
          isActive: state.isSignUpButtonActive,
          onTap: state.isSignUpButtonActive
              ? () {
                  if (state.authenticationType == Authentication.signUp) {
                    if (state.formKey.currentState!.validate()) {
                      BlocProvider.of<SignInSignUpBloc>(context)
                          .add(TriggerSignUpViaEmailP());
                    }
                  } else if (state.authenticationType ==
                      Authentication.signUpMask) {
                    if (state.formKey.currentState!.validate()) {
                      BlocProvider.of<SignInSignUpBloc>(context)
                          .add(TriggerSubmitSignUpMaskData());
                    }
                  }
                }
              : () {},
          btnLabel: AppStrings.authentication_signUp_signUpBtn),
    ];
  }

  List<Widget> signInBtn(
      SignInSignUpWithInitialState state, BuildContext context) {
    return [
      buildCustomLargeFooterBtn(
          hasKeyBoardOpened: true,
          isActive: state.isSignInButtonActive,
          isColorFilledButton: true,
          onTap: state.isSignInButtonActive
              ? () {
                  if (state.formKey.currentState!.validate()) {
                    BlocProvider.of<SignInSignUpBloc>(context)
                        .add(TriggerSignInViaEmail());
                  }
                }
              : () {},
          btnLabel: AppStrings.authentication_signIn_signInBtn),
    ];
  }

  List<Widget> checkboxText(
      SignInSignUpWithInitialState state, BuildContext context) {
    return [
      SizedBox(
        height: Dimensions.screenVerticalGap,
      ),
      buildAuthenticationCheckBox(
          isChecked: state.isBoxChecked,
          //state.isBoxChecked,
          onChanged: (isChecked) {
            BlocProvider.of<SignInSignUpBloc>(context)
                .add(TriggerCheckBoxToAgree());
          }),
      SizedBox(
        height: Dimensions.screenVerticalGap,
      ),
    ];
  }

  List<Widget> confirmPasswordField(
      SignInSignUpWithInitialState state, BuildContext context) {
    return [
      buildCustomPasswordField(
          isObscure: state.isConfirmPasswordObscure,
          label: AppStrings.textfield_confirmPassword_label,
          hint: AppStrings.textfield_confirmPassword_hint,
          textEditingController: state.confirmPasswordEditingController,
          focusNode: state.confirmPasswordFocusNode,
          onChanged: (value) {
            if (state.authenticationType == Authentication.signUp) {
              BlocProvider.of<SignInSignUpBloc>(context)
                  .add(TriggerCheckForButtonActivity());
            }
          },
          validator: (reTypedValue) {
            return TextFieldValidators.validateConfirmPassword(
                reTypedValue: reTypedValue ?? AppStrings.global_empty_string,
                password: state.passwordEditingController.text);
          },
          onTapToHideUnhide: () {
            BlocProvider.of<SignInSignUpBloc>(context).add(
                const TriggerHideUnHideFieldContents(
                    fieldType: FieldType.confirmPassword));
          })
    ];
  }

  List<Widget> passwordChecker(SignInSignUpWithInitialState state) {
    return [
      buildCustomCheckboxesForPasswordField(
        isAtLeastEightCharChecked: state.isAtLeastEightCharChecked,
        isAtLeastOneLowerCaseChecked: state.isAtLeastOneLowerCaseChecked,
        isAtLeastOneUpperCaseChecked: state.isAtLeastOneUpperCaseChecked,
        isAtLeastOneDigitChecked: state.isAtLeastOneDigitChecked,
        isAtLeastOneSpecialCharChecked: state.isAtLeastOneSpecialCharChecked,
      )
    ];
  }

  List<Widget> passwordField(
      SignInSignUpWithInitialState state, BuildContext context) {
    return [
      buildCustomPasswordField(
        isObscure: state.isPasswordObscure,
        label: AppStrings.textfield_password_label,
        hint: AppStrings.textfield_password_hint,
        authenticationType: state.authenticationType,
        textEditingController: state.passwordEditingController,
        focusNode: state.passwordFocusNode,
        onChanged: (value) {
          passwordIsAutofilled = true;
          if (state.authenticationType == Authentication.signUp) {
            BlocProvider.of<SignInSignUpBloc>(context).add(
                TriggerUpdateFieldOnChange(
                    fieldType: FieldType.password,
                    value: value,
                    retypedValue: AppStrings.global_empty_string));

            BlocProvider.of<SignInSignUpBloc>(context)
                .add(TriggerCheckForButtonActivity());
          }
          if (state.authenticationType == Authentication.signIn) {
            BlocProvider.of<SignInSignUpBloc>(context)
                .add(TriggerActivateSignInButton());
          }
        },
        validator: (value) {
          return TextFieldValidators.validateSignInPassword(
              value ?? AppStrings.global_empty_string);
        },
        onTapToHideUnhide: () {
          BlocProvider.of<SignInSignUpBloc>(context).add(
              const TriggerHideUnHideFieldContents(
                  fieldType: FieldType.password));
        },
        onTap: state.authenticationType == Authentication.signIn
            ? () {
                passwordIsAutofilled = false;
              }
            : () {
                BlocProvider.of<SignInSignUpBloc>(context)
                    .add(TriggerRevealPasswordChecker());
              },
      ),
    ];
  }

}
