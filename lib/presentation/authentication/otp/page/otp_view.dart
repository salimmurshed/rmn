import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../imports/common.dart';
import '../bloc/otp_bloc.dart';
import '../widgets/build_didnot_receive_code_text.dart';
import '../widgets/build_footer_text.dart';
import '../widgets/build_otp_fields.dart';
import '../widgets/build_otp_timer.dart';
import '../widgets/build_resend_code_btn.dart';
import '../widgets/build_resend_code_time_text.dart';
import '../../widgets/build_subtitle.dart';
import '../../widgets/build_title.dart';
import '../../widgets/build_top_space.dart';

class OtpView extends StatefulWidget {
  final OtpArgument otpArgument;

  const OtpView({
    super.key,
    required this.otpArgument,
  });

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> with TickerProviderStateMixin {
  late OtpBloc otpBloc;
  late AnimationController animationController;

  @override
  void initState() {
    otpBloc = BlocProvider.of<OtpBloc>(context);
    otpBloc.add(TriggerAnimationInitialization(
        isFromChangeEmail: widget.otpArgument.isFromChangeEmail,
        vsync: this, isResendCode: false, email: widget.otpArgument.userEmail));
    super.initState();
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpBloc, OtpWithInitialState>(
      listener: (context, state) {
        if (state.animationController != null) {
          animationController = state.animationController!;
        }
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
        }
      },
      child:
      BlocBuilder<OtpBloc, OtpWithInitialState>(

        builder: (context, state) {
          return state.isLoading
              ? CustomLoader(child: createOtpLayout(state, context))
              : createOtpLayout(state, context);
        },
      ),
    );
  }

  Widget createOtpLayout(OtpWithInitialState state, BuildContext context) {
    return customScaffold(
      resizeToAvoidBottomInset: false,
      hasForm: true,
      customAppBar: CustomAppBar(
        title: AppStrings.global_empty_string,
        isLeadingPresent: true,
      ),
      anyWidgetWithoutSingleChildScrollView: null,
      formOrColumnInsideSingleChildScrollView: Form(
        key: state.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTopSpace(context),
            buildOtpResetTitle(),
            customDivider(),
            buildCustomSvgHolder(imageUrl: AppAssets.icOtpLandingVector),
            buildSubtitle(email: state.email),

            BlocBuilder<OtpBloc, OtpWithInitialState>(
              buildWhen: (previous, current)  {
                print('previous.isOnChange: ${previous.isOnChange}');
                return previous.isOnChange;},
              builder: (context, state) {
                return OtpFields(
                  isFromChangeEmail: widget.otpArgument.isFromChangeEmail,
                  encryptedUserId: widget.otpArgument.encryptedUserId,
                  isFailure: state.isFailure,
                  pinControllers: state.pinControllers,
                  noOfPinFields: state.noOfPinFields,
                  pinFocusNodes: state.pinFocusNodes,
                  isErrorTextHidden: state.isErrorTextHidden,
                );
              },
            ),
            // buildOtpFields(
            //   isFromChangeEmail: widget.otpArgument.isFromChangeEmail,
            //   encryptedUserId: widget.otpArgument.encryptedUserId,
            //   isFailure: state.isFailure,
            //   pinControllers: state.pinControllers,
            //   noOfPinFields: state.noOfPinFields,
            //   pinFocusNodes: state.pinFocusNodes,
            //   context: context,
            //   isErrorTextHidden: state.isErrorTextHidden,
            // ),
            // buildCustomLargeFooterBtn(
            //     hasKeyBoardOpened: true,
            //     isColorFilledButton: true,
            //     isActive: state.isVerifyButtonActive,
            //     onTap: state.isVerifyButtonActive
            //         ? () {
            //             if (state.formKey.currentState!.validate()) {
            //               if (widget.otpArgument.isFromChangeEmail) {
            //                 otpBloc.add(TriggerUpdateEmail());
            //               } else {
            //                 otpBloc.add(
            //                   TriggerVerifyEmail(
            //                       encryptedUserId:
            //                           widget.otpArgument.encryptedUserId),
            //                 );
            //               }
            //             } else {
            //               otpBloc.add(TriggerShowErrorText());
            //             }
            //           }
            //         : () {},
            //     btnLabel: AppStrings.authentication_otpVerification_verifyBtn),
            buildDidNotReceiveCodeText(),
            if (!state.isAnimationTerminated) ...[
              buildResendCodeTimeText(),
              if (state.animationController != null) ...[
                buildOtpTimer(
                  animationValueProgressValue:
                  state.animationValueProgressValue,
                  animationController: state.animationController!,
                  animationPercentValue: state.animationPercentValue,
                ),
              ],
              buildFooterText()
            ] else
              ...[
                buildResendCodeBtn(onPressed: () {
                  otpBloc.add(TriggerResendCode(
                    email: widget.otpArgument.userEmail,
                    vsync: this,
                    isFromChangeEmail: widget.otpArgument.isFromChangeEmail,
                  ));
                })
              ]
          ],
        ),
      ),
    );
  }
}

class OtpFields extends StatefulWidget {
  final bool isFromChangeEmail;
  final String encryptedUserId;
  final bool isFailure;
  final List<TextEditingController> pinControllers;
  final int noOfPinFields;
  final List<FocusNode> pinFocusNodes;
  final bool isErrorTextHidden;

  const OtpFields({
    super.key,
    required this.isFromChangeEmail,
    required this.encryptedUserId,
    required this.isFailure,
    required this.pinControllers,
    required this.noOfPinFields,
    required this.pinFocusNodes,
    required this.isErrorTextHidden,
  });

  @override
  _OtpFieldsState createState() => _OtpFieldsState();
}

class _OtpFieldsState extends State<OtpFields> {
  @override
  Widget build(BuildContext context) {
    return buildOtpFields(
      isFromChangeEmail: widget.isFromChangeEmail,
      encryptedUserId: widget.encryptedUserId,
      isFailure: widget.isFailure,
      pinControllers: widget.pinControllers,
      noOfPinFields: widget.noOfPinFields,
      pinFocusNodes: widget.pinFocusNodes,
      context: context,
      isErrorTextHidden: widget.isErrorTextHidden,
    );
  }
}