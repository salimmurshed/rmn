import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/presentation/get_in_touch/bloc/get_in_touch_bloc.dart';

import '../../../imports/common.dart';
import '../../create_edit_profile/widgets/build_name_section.dart';

class GetInTouchContactUsView extends StatefulWidget {
  const GetInTouchContactUsView({super.key});

  @override
  State<GetInTouchContactUsView> createState() =>
      _GetInTouchContactUsViewState();
}

class _GetInTouchContactUsViewState extends State<GetInTouchContactUsView> {
  @override
  void initState() {
    BlocProvider.of<GetInTouchBloc>(context).add(TriggerFetchUserCachedData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetInTouchBloc, GetInTouchWithInitial>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
        }
      },
      child: BlocBuilder<GetInTouchBloc, GetInTouchWithInitial>(
        builder: (context, state) {
          return customScaffold(
              persistentFooterButtons: [
                buildCustomLargeFooterBtn(
                    hasKeyBoardOpened: true,
                    onTap: () {
                      if (state.formKey.currentState!.validate()) {
                        BlocProvider.of<GetInTouchBloc>(context).add(
                          TriggerSubmitData(
                            firstName: state.firstNameController.text,
                            lastName: state.lastNameController.text,
                            emailAddress: state.emailAddressController.text,
                            phoneNumber: state.phoneNumberController.text,
                            message: state.messageController.text,
                          ),
                        );
                      }
                    },
                    btnLabel: AppStrings.btn_sendMessage,
                    isColorFilledButton: true)
              ],
              customAppBar: CustomAppBar(
                title: AppStrings.getInTouch_contactUs_title,
                isLeadingPresent: true,
              ),
              hasForm: true,
              formOrColumnInsideSingleChildScrollView: state.isLoading
                  ? SizedBox(
                      height: Dimensions.getScreenHeight(),
                      child:
                          CustomLoader(child: buildFormLayout(state, context)),
                    )
                  : buildFormLayout(state, context),
              anyWidgetWithoutSingleChildScrollView: null);
        },
      ),
    );
  }

  Form buildFormLayout(GetInTouchWithInitial state, BuildContext context) {
    return Form(
      key: state.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildNameSection(
              onChangedLastName: (value) {
                //state.formKey.currentState!.validate();
              },
              onChangedFirstName: (value) {
                //state.formKey.currentState!.validate();
              },
              firstNameEditingController: state.firstNameController,
              lastNameEditingController: state.lastNameController,
              firstNameFocusNode: state.firstNameFocusNode,
              lastNameFocusNode: state.lastNameFocusNode,
              firstNameValidator: (value) {
                return TextFieldValidators.validateName(
                    value: value ?? AppStrings.global_empty_string,
                    nameTypes: NameTypes.firstName);
              },
              lastNameValidator: (value) {
                return TextFieldValidators.validateName(
                    value: value ?? AppStrings.global_empty_string,
                    nameTypes: NameTypes.lastName);
              }),
          buildCustomPhoneField(
              isContactNumberValid: state.isContactNumberValid,
              phoneNumberController: state.phoneNumberController,
              phoneNumberFocusNode: state.phoneNumberFocusNode,
              context: context,
              onChanged: (value) {},
              validator: (value) {
                BlocProvider.of<GetInTouchBloc>(context).add(
                  TriggerCheckContactNumberValidity(
                    phoneNumber: value ?? AppStrings.global_empty_string,
                  ),
                );
                return TextFieldValidators.validateContactNumber(
                    value: value ?? AppStrings.global_empty_string);
              }),
          buildCustomEmailField(
            onChanged: (value) {
              //state.formKey.currentState!.validate();
            },
            emailAddressController: state.emailAddressController,
            emailFocusNode: state.emailFocusNode,
            validator: (value) {
              return TextFieldValidators.validateEmail(
                  value ?? AppStrings.global_empty_string);
            },
          ),
          CustomTextFormFields(
            textEditingController: state.messageController,
            focusNode: state.messageFocusNode,
            label: AppStrings.textfield_addMessage_label,
            onChanged: (value) {
              //state.formKey.currentState!.validate();
            },
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            isAsteriskPresent: true,
            hint: AppStrings.textfield_addMessage_hint,
            maxLength: 500,
            validator: (value) {
              return value!.isEmpty
                  ? AppStrings.textfield_addMessage_emptyField_error
                  : null;
            },
            textInputType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }
}
