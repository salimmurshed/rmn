import '../../../imports/common.dart';

class AuthenticationHandler {
  static bool fieldValidationHandler(
      {required FieldType fieldType,
      required String reTypedValue,
      required String value})
  {
    switch (fieldType) {
      case FieldType.email:
        bool result = GlobalHandlers.emailHandler(value: value);
        return result;
      case FieldType.password:
        bool result = GlobalHandlers.passwordHandler(value: value);
        return result;

      case FieldType.confirmPassword:
        bool result = GlobalHandlers.confirmPasswordHandler(
            value: value, reTypedValue: reTypedValue);
        return result;
      default:
        return false;
    }
  }
}
