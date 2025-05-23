import 'package:intl/intl.dart';
import '../../imports/common.dart';

class TextFieldValidators {
  static String? validateName(
      {required String value, required NameTypes nameTypes}) {
    switch (nameTypes) {
      case NameTypes.firstName:
        if (value.isEmpty) {
          return AppStrings.textfield_addFirstName_emptyField_error;
        } else if (value.length < 2) {
          return AppStrings.textfield_addFirstName_minLength_error;
        } else if (value.length > 20) {
          return AppStrings.textfield_addFirstName_maxLength_error;
        } else {
          return null;
        }
      case NameTypes.lastName:
        if (value.isEmpty) {
          return AppStrings.textfield_addLastName_emptyField_error;
        } else if (value.length < 2) {
          return AppStrings.textfield_addLastName_minLength_error;
        } else if (value.length > 20) {
          return AppStrings.textfield_addLastName_maxLength_error;
        } else {
          return null;
        }
      case NameTypes.cardHolderName:
        if (value.isEmpty) {
          return AppStrings.textfield_addCardHolderName_emptyField_error;
        } else if (value.length < 2) {
          return AppStrings.textfield_addCardHolderName_minLength_error;
        } else if (value.length > 40) {
          return AppStrings.textfield_addCardHolderName_maxLength_error;
        } else {
          return null;
        }
      default:
        return null;
    }
  }

  static String? validateWeight({required String value}) {
    if (value.isEmpty) {
      return AppStrings.textfield_addWeight_emptyField_error;
    } else {
      return null;
    }
  }

  static String? validateBirthday(
      {required String birthDay, required AgeType ageType}) {
    if (birthDay.isEmpty) {
      return AppStrings.textfield_selectDateOfBirth_emptyField_error;
    } else {
      DateTime birthDate =
          DateFormat('MM/dd/yyyy').parse(birthDay);
      DateTime today = DateTime.now();

      int yearDiff = today.year - birthDate.year;
      int monthDiff = today.month - birthDate.month;
      int dayDiff = today.day - birthDate.day;

      switch (ageType) {
        case AgeType.owner:
          if (yearDiff > 13 ||
              yearDiff == 13 && monthDiff >= 0 && dayDiff >= 0) {
            return null;
          } else {
            return AppStrings.textfield_selectDateOfBirth_owner_minYear_error;
          }
        case AgeType.athlete:
          if (yearDiff > 4 || yearDiff == 4 && monthDiff >= 0 && dayDiff >= 0) {
            return null;
          } else {
            return AppStrings.textfield_selectDateOfBirth_athlete_minYear_error;
          }
        default:
          return null;
      }
    }
  }

  static String? validatePostalAddress({required String address, required String city}) {
    if (address.isEmpty || city.isEmpty) {
      return AppStrings.textfield_addPostalAddress_emptyField_error;
    } else {
      return null;
    }
  }

  static String? validateZip({required String value}) {
    if (value.isEmpty) {
      return AppStrings.texfield_addZip_emptyField_error;
    }
    if (!RegexChecker.digitOnlyRegex(value.trim())) {
      return AppStrings.texfield_addZip_invalid_error;
    } else {
      return null;
    }
  }

  static String? validateContactNumber({required String value}) {
    if (value.isEmpty) {
      return AppStrings.textfield_addContactNumber_emptyField_error;
    } else {
      return null;
    }
  }

  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return AppStrings.textfield_addEmail_emptyField_error;
    } else if (!RegexChecker.isEmailValid(value.trim())) {
      return AppStrings.textfield_addEmail_invalidInput_error;
    } else {
      return null;
    }
  }

  static String? validatePasswordSecurityPolicies(String value) {
    if (value.isEmpty) {
      return AppStrings.textfield_addPassword_emptyField_error;
    } else if (!RegexChecker.validatePasswordInputBySecurityPolicies(
        password: value)) {
      return AppStrings.textfield_addPassword_invalidInput_error;
    } else {
      return null;
    }
  }

  static String? validateSignInPassword(String value) {
    if (value.isEmpty) {
      return AppStrings.textfield_addPassword_emptyField_error;
    }  else {
      return null;
    }
  }

  static String? validateConfirmPassword(
      {required String reTypedValue, required String password}) {
    if (reTypedValue.isEmpty) {
      return AppStrings.textfield_addConfirmPassword_emptyField_error;
    } else if (reTypedValue != password) {
      return AppStrings.textfield_addConfirmPassword_invalidInput_error;
    } else {
      return null;
    }
  }

  static bool validateAtLeastEightChar({required String value}) {
    if (value.isEmpty) {
      return false;
    } else if (!RegexChecker.validatePasswordMinLength(password: value)) {
      return false;
    } else {
      return true;
    }
  }

  static bool validateAtLeastOneLowerCase({required String value}) {
    if (value.isEmpty) {
      return false;
    } else if (!RegexChecker.validatePasswordForLowerChar(password: value)) {
      return false;
    } else {
      return true;
    }
  }

  static bool validateAtLeastOneUpperCase({required String value}) {
    if (value.isEmpty) {
      return false;
    } else if (!RegexChecker.validatePasswordForUpperChar(password: value)) {
      return false;
    } else {
      return true;
    }
  }

  static bool validateAtLeastOneDigit({required String value}) {
    if (value.isEmpty) {
      return false;
    } else if (!RegexChecker.validatePasswordForDigits(password: value)) {
      return false;
    } else {
      return true;
    }
  }

  static bool validateAtLeastOneSpecialChar({required String value}) {
    if (value.isEmpty) {
      return false;
    } else if (!RegexChecker.validatePasswordForSpecialCharacter(
        password: value)) {
      return false;
    } else {
      return true;
    }
  }

  static String? validateCardNumber({required String value}) {
    if (value.isEmpty) {
      return AppStrings.textfield_addCardNumber_emptyField_error;
    } else if (!RegexChecker.digitOnlyRegex(value.trim())) {
      return AppStrings.textfield_addCardNumber_invalidInput_error;
    } else {
      return null;
    }
  }

  static String? validateCardCVC({required String value}) {
    if (value.isEmpty) {
      return AppStrings.textfield_addCardNumber_cvc_emptyField_error;
    } else if (!RegexChecker.digitOnlyRegex(value.trim())) {
      return AppStrings.textfield_addCardNumber_cvc_invalidInput_error;
    } else {
      return null;
    }
  }

  static String? validateCardExpiryDate({required String value}) {
    if (value.isEmpty) {
      return AppStrings.textfield_addCardNumber_expiryDate_emptyField_error;
    } else {
      return null;
    }
  }
}
