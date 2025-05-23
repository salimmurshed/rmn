
import 'package:bloc/bloc.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'profile_bloc.dart';

class AccountSettingsHandlers {
  static String extractFullNameHandler({required DataBaseUser user}) {

    String fullName = StringManipulation.combineFirstNameWithLastName(
      firstName: user.firstName ?? AppStrings.global_empty_string,
      lastName: user.lastName ?? AppStrings.global_empty_string,
    );
    return fullName;
  }
  // static String extractEmailHandler({required User user}) {
  //   String encodedEmail = user.email ?? AppStrings.global_empty_string;
  //   String email = encodedEmail.isNotEmpty
  //       ? EncryptionDecryptionHelper.decryption(encodedEmail)
  //       : AppStrings.global_empty_string;
  //   return email;
  // }
  //
  // static String extractPhoneHandler({required User user}) {
  //   String encodedPhone = user.phoneNumber ?? AppStrings.global_empty_string;
  //   String phone = encodedPhone.isNotEmpty
  //       ? EncryptionDecryptionHelper.decryption(encodedPhone)
  //       : AppStrings.global_empty_string;
  //   return phone;
  // }

  static void emitRefreshState(
      {required Emitter<ProfileWithInitialState> emit,
        required ProfileWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        message: AppStrings.global_empty_string));
  }

 static String switchToHighestRole(List<String> roles) {
    if (roles.contains('owner')) {
      return 'owner';
    } else if (roles.contains('admin')) {
      return 'admin';
    } else if (roles.contains('employee')) {
      return 'employee';
    } else {
      return 'user'; // Default to 'user' if none of the above roles are found
    }
  }

}
