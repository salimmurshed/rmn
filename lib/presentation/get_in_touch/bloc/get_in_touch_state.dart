part of 'get_in_touch_bloc.dart';

@freezed
class GetInTouchWithInitial with _$GetInTouchWithInitial {
  const factory GetInTouchWithInitial({
    required String message,
    required bool isLoading,
    required bool isRefreshedRequired,
    required bool isFailure,
    required List<String> getInTouchTitles,
    required List<FaqData> faqData,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailAddressController,
    required TextEditingController phoneNumberController,
    required TextEditingController messageController,
    required FocusNode firstNameFocusNode,
    required FocusNode lastNameFocusNode,
    required FocusNode emailFocusNode,
    required FocusNode phoneNumberFocusNode,
    required FocusNode messageFocusNode,
    required GlobalKey<FormState> formKey,
    required bool isContactNumberValid,
  }) = _GetInTouchWithInitial;

  factory GetInTouchWithInitial.initial() => GetInTouchWithInitial(
        isFailure: false,
        isLoading: true,
        faqData: [],
        getInTouchTitles: [
          AppStrings.getInTouch_aboutUs_title,
          AppStrings.getInTouch_faq_title,
          AppStrings.getInTouch_contactUs_title,
        ],
        isRefreshedRequired: false,
        message: AppStrings.global_empty_string,
        firstNameController: TextEditingController(),
        lastNameController: TextEditingController(),
        emailAddressController: TextEditingController(),
        phoneNumberController: TextEditingController(),
        messageController: TextEditingController(),
        firstNameFocusNode: FocusNode(),
        lastNameFocusNode: FocusNode(),
        emailFocusNode: FocusNode(),
        phoneNumberFocusNode: FocusNode(),
        messageFocusNode: FocusNode(),
        formKey: GlobalKey<FormState>(),
        isContactNumberValid: true,
      );
}
