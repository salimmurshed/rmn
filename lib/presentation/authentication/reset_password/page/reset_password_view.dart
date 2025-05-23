import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/authentication/reset_password/bloc/reset_password_bloc.dart';
import 'package:rmnevents/presentation/authentication/widgets/build_title.dart';

import '../../../../imports/common.dart';
import '../../widgets/build_authentication_routing_text_btn.dart';
import '../../widgets/build_top_space.dart';

class ResetPasswordView extends StatefulWidget {
  final String? token;

  const ResetPasswordView({super.key, this.token});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>(); //
  @override
  void initState() {
    BlocProvider.of<ResetPasswordBloc>(context)
        .add(TriggerRebuildFromScratch());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordWithInitialState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
          if(state.isPasswordChangeRequired){
            if(!state.isFailure){
              Navigator.pushNamedAndRemoveUntil(context,
                  AppRouteNames.routeBase, (route) => false,
                  arguments: true);
            }
          }
         else{
            if (widget.token != null && !state.isFailure) {
              buildBottomSheetWithBodyImage(
                  context: context,
                  title: AppStrings.bottomSheet_resetPassword_title,
                  footerNote: AppStrings.bottomSheet_resetPassword_subtitle,
                  buttonText: AppStrings.authentication_signIn_signInBtn,
                  imageUrl: AppAssets.icResetPass,
                  isSingleButtonPresent: true,
                  isFooterNoteCentered: true,
                  onButtonPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context,
                        AppRouteNames.routeSignInSignUp, (route) => false,
                        arguments: Authentication.signIn);
                  },
                  navigatorFunction: () {
                    Navigator.pushNamedAndRemoveUntil(context,
                        AppRouteNames.routeSignInSignUp, (route) => false,
                        arguments: Authentication.signIn);
                  });
            }
          }
        }
      },
      child: BlocBuilder<ResetPasswordBloc, ResetPasswordWithInitialState>(
        builder: (context, state) {
          return customScaffold(
            hasForm: true,
            customAppBar: CustomAppBar(
              title: AppStrings.global_empty_string,
              isLeadingPresent: widget.token == null,
            ),
            anyWidgetWithoutSingleChildScrollView: null,
            persistentFooterButtons: [
              buildAuthenticationRoutingTextBtn(
                  onTapGestureRecogniser: () {
                    Navigator.pushNamedAndRemoveUntil(context,
                        AppRouteNames.routeSignInSignUp, (route) => false,
                        arguments: Authentication.signIn);
                  },
                  authentication: Authentication.rememberPassword),
            ],
            formOrColumnInsideSingleChildScrollView: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTopSpace(context),
                  buildOtpResetTitle(isOtp: false,
                    isChangePassword: state.isPasswordChangeRequired == false ? null: true
                  ),
                  customDivider(),
                  buildCustomSvgHolder(imageUrl: AppAssets.icOtpLandingVector),
                  Padding(
                    padding:  EdgeInsets.symmetric(
                        horizontal: 10.w),
                    child: Text(
                      state.isPasswordChangeRequired
                          ? AppStrings
                              .authentication_resetPassword_isRequired_title
                          : AppStrings.authentication_resetPassword_subTitle,
                      style: AppTextStyles.regularPrimary(
                          color: AppColors.colorPrimaryNeutralText),
                    ),
                  ),
                  if (widget.token == null) ...[
                    buildCustomEmailField(
                      emailAddressController: state.emailController,
                      emailFocusNode: state.emailFocus,
                      onChanged: (value) {
                        BlocProvider.of<ResetPasswordBloc>(context).add(
                            const TriggerCheckResetPasswordButtonActivity(
                                isForgotPassword: true));
                      },
                      validator: (value) {
                        return TextFieldValidators.validateEmail(
                            value ?? AppStrings.global_empty_string);
                      },
                    )
                  ],
                  if (widget.token != null) ...[
                    buildCustomPasswordField(
                      isObscure: state.isPasswordObscure,
                      label: AppStrings.textfield_password_label,
                      hint: AppStrings.textfield_password_hint,
                      textEditingController: state.passwordController,
                      focusNode: state.passwordFocus,
                      onChanged: (value) {
                        BlocProvider.of<ResetPasswordBloc>(context).add(
                            TriggerUpdateFieldOnChangeReset(
                                fieldType: FieldType.password,
                                value: value,
                                retypedValue: AppStrings.global_empty_string));
                        BlocProvider.of<ResetPasswordBloc>(context).add(
                            const TriggerCheckResetPasswordButtonActivity(
                              isForgotPassword: false,
                            ));
                      },
                      validator: (value) {
                        return TextFieldValidators
                            .validatePasswordSecurityPolicies(
                                value ?? AppStrings.global_empty_string);
                      },
                      onTapToHideUnhide: () {
                        BlocProvider.of<ResetPasswordBloc>(context).add(
                            const TriggerHideUnHideFieldContentsReset(
                                fieldType: FieldType.password));
                      },
                      onTap: () {
                        BlocProvider.of<ResetPasswordBloc>(context)
                            .add(TriggerRevealPasswordCheckerReset());
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
                        isAtLeastOneDigitChecked:
                            state.isAtLeastOneDigitChecked,
                        isAtLeastOneSpecialCharChecked:
                            state.isAtLeastOneSpecialCharChecked,
                      ),
                    buildCustomPasswordField(
                        isObscure: state.isConfirmPasswordObscure,
                        label: AppStrings.textfield_confirmPassword_label,
                        hint: AppStrings.textfield_confirmPassword_hint,
                        textEditingController: state.confirmPasswordController,
                        focusNode: state.confirmPasswordFocus,
                        onChanged: (value) {
                          BlocProvider.of<ResetPasswordBloc>(context).add(
                              const TriggerCheckResetPasswordButtonActivity(
                            isForgotPassword: false,
                          ));
                        },
                        validator: (reTypedValue) {
                          return TextFieldValidators.validateConfirmPassword(
                              reTypedValue: reTypedValue ??
                                  AppStrings.global_empty_string,
                              password: state.passwordController.text);
                        },
                        onTapToHideUnhide: () {
                          BlocProvider.of<ResetPasswordBloc>(context).add(
                              const TriggerHideUnHideFieldContentsReset(
                                  fieldType: FieldType.confirmPassword));
                        })
                  ],
                  SizedBox(height: Dimensions.generalGap),
                  buildCustomLargeFooterBtn(
                      hasKeyBoardOpened: true,
                      isColorFilledButton: true,
                      isActive: state.isVerifyButtonActive,
                      onTap: state.isVerifyButtonActive
                          ? () {
                              if (widget.token == null) {
                                BlocProvider.of<ResetPasswordBloc>(context)
                                    .add(TriggerRequestForResetPasswordLink());
                              } else {
                                BlocProvider.of<ResetPasswordBloc>(context).add(
                                    TriggerSubmitNewPassword(
                                        token: widget.token!));
                              }
                            }
                          : () {},
                      btnLabel: AppStrings
                          .authentication_resetPassword_resetPasswordBtn),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
