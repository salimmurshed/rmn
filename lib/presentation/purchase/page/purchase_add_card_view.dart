import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/presentation/purchase/bloc/purchase_bloc.dart';

import '../../../imports/common.dart';

class PurchaseAddCardView extends StatefulWidget {
  const PurchaseAddCardView({super.key});

  @override
  State<PurchaseAddCardView> createState() => _PurchaseAddCardViewState();
}

class _PurchaseAddCardViewState extends State<PurchaseAddCardView> {
  @override
  void initState() {
    BlocProvider.of<PurchaseBloc>(context).add(TriggerOpenAddCardView());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PurchaseBloc, PurchaseWithInitialState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
        }
      },
      child: BlocBuilder<PurchaseBloc, PurchaseWithInitialState>(
        builder: (context, state) {

          return customScaffold(
              persistentFooterButtons: [
                buildCustomLargeFooterBtn(
                    hasKeyBoardOpened: true,
                    onTap: () {
                      if (state.formKey.currentState!.validate()) {
                        BlocProvider.of<PurchaseBloc>(context).add(
                            TriggerAddCard(
                                cardNumber:
                                    state.cardNumberEditingController.text,
                                name: state.nameEditingController.text,
                                cvc: state.cvcEditingController.text,
                                expiryDate:
                                    state.expiryDateEditingController.text));
                      }
                    },
                    btnLabel: AppStrings.btn_addCard,
                    isColorFilledButton: true)
              ],
              customAppBar: CustomAppBar(
                title: AppStrings.payment_addCard_title,
                isLeadingPresent: true,
              ),
              hasForm: true,
              formOrColumnInsideSingleChildScrollView: Form(
                key: state.formKey,
                child: state.isLoading
                    ? SizedBox(
                        height: Dimensions.getScreenHeight(),
                        child: CustomLoader(
                          child: buildFormLayout(
                            state,
                          ),
                        ))
                    : buildFormLayout(
                        state,
                      ),
              ),
              anyWidgetWithoutSingleChildScrollView: null);
        },
      ),
    );
  }

  Column buildFormLayout(PurchaseWithInitialState state) {
    debugPrint('Add Card View ${state.dateErrorForCard}');
    return Column(
      children: [
        CustomTextFormFields(
          textEditingController: state.nameEditingController,
          focusNode: state.nameFocusNode,
          maxLength: 40,
          label: AppStrings.textfield_addCardHolderName_label,
          hint: AppStrings.textfield_addCardHolderName_hint,
          textInputType: TextInputType.name,
          validator: (value) {
            return TextFieldValidators.validateName(
                nameTypes: NameTypes.cardHolderName,
                value: value ?? AppStrings.global_empty_string);
          },
        ),
        CustomTextFormFields(
          textEditingController: state.cardNumberEditingController,
          focusNode: state.cardNumberFocusNode,
          label: AppStrings.textfield_addCardNumber_label,
          hint: AppStrings.textfield_addCardNumber_hint,
          textInputType: TextInputType.number,
          maxLength: 16,
          validator: (value) {
            return TextFieldValidators.validateCardNumber(
                value: value ?? AppStrings.global_empty_string);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextFormFields(
                textInputType: TextInputType.number,
                textEditingController: state.cvcEditingController,
                focusNode: state.cvcFocusNode,
                label: AppStrings.textfield_addCardNumber_cvc_label,
                hint: AppStrings.textfield_addCardNumber_cvc_hint,
                isAsteriskPresent: true,
                maxLength: 4,
                validator: (value) {
                  return TextFieldValidators.validateCardCVC(
                      value: value ?? AppStrings.global_empty_string);
                },
              ),
            ),
            SizedBox(width: Dimensions.generalGap),
            Expanded(
              child: CustomTextFormFields(
                textInputType: TextInputType.phone,
                textEditingController: state.expiryDateEditingController,
                focusNode: state.expiryDateFocusNode,
                label: AppStrings.textfield_addCardNumber_expiryDate_label,
                hint: AppStrings.textfield_addCardNumber_expiryDate_hint,
                maxLength: 5,
                isAsteriskPresent: true,
                onChanged: (val) {
                  BlocProvider.of<PurchaseBloc>(context)
                      .add(TriggerOnChangeForCardExpiry());
                },
                errorText: state.dateErrorForCard,
                validator: (value) {
                  BlocProvider.of<PurchaseBloc>(context)
                      .add(TriggerValidateCardDate(expiryDate: value ?? ''));
                  return null;
                },
                onTap: () async {
                  // var selectedDate =
                  //     await GlobalHandlers.monthYearPickerHandler(
                  //   context: context,
                  // );
                  // BlocProvider.of<PurchaseBloc>(context)
                  //     .add(TriggerSelectMonthYear(monthYear: selectedDate));
                },
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<PurchaseBloc>(context).add(TriggerSaveCard());
          },
          child: Container(
            margin: EdgeInsets.only(top: Dimensions.generalGap),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildCustomCheckbox(
                    isChecked: state.isCardSaved,
                    onChanged: (value) {
                      BlocProvider.of<PurchaseBloc>(context)
                          .add(TriggerSaveCard());
                    },
                    isDisabled: false),
                RichText(
                  text: TextSpan(
                    text: AppStrings.payment_addCard_saveText,
                    style: AppTextStyles.subtitle(
                        color: AppColors.colorPrimaryInverseText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
