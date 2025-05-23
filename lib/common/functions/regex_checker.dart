import '../../imports/common.dart';

class RegexChecker {
  static bool digitOnlyRegex(String value) =>
      RegExp(r'^[0-9]+$').hasMatch(value);

  static bool isEmailValid(String email) =>
      TextFieldRegex.emailRegex.hasMatch(email);

  static bool validatePasswordInputBySecurityPolicies(
      {required String password}) {
    if (validatePasswordForLowerChar(password: password) &&
        validatePasswordForUpperChar(password: password) &&
        validatePasswordMinLength(password: password) &&
        validatePasswordForSpecialCharacter(password: password) &&
        validatePasswordForDigits(password: password)) {
      return true;
    } else {
      return false;
    }
  }

  static bool validatePasswordForUpperChar({required String password}) {
    return TextFieldRegex.passwordUpperRegex.hasMatch(password.trim());
  }

  static bool validatePasswordForLowerChar({required String password}) {
    return TextFieldRegex.passwordLowerRegex.hasMatch(password.trim());
  }

  static bool validatePasswordMinLength({required String password}) {
    if (password.length > 8) {
      return true;
    } else {
      return false;
    }
  }

  static bool validatePasswordForSpecialCharacter({required String password}) {
    return TextFieldRegex.passwordSpecialRegex.hasMatch(password.trim());
  }

  static bool validatePasswordForDigits({required String password}) {
    return TextFieldRegex.passwordDigitRegex.hasMatch(password.trim());
  }
}
