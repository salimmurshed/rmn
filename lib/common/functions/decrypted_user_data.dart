import 'package:rmnevents/common/functions/global_handlers.dart';

import '../../imports/data.dart';

class DecryptedUserData {
  static DataBaseUser decryptUserData({required DataBaseUser user}) {
    if (user.firstName != null) {
      if (user.firstName!.isNotEmpty) {
        user.firstName =
            GlobalHandlers.dataDecryptionHandler(value: user.firstName!);
      }
    }
    if (user.lastName != null) {
      if (user.lastName!.isNotEmpty) {
        user.lastName =
            GlobalHandlers.dataDecryptionHandler(value: user.lastName!);
      }
    }
    if (user.email != null) {
      if (user.email!.isNotEmpty) {
        user.email = GlobalHandlers.dataDecryptionHandler(value: user.email!);
      }
    }
    if (user.phoneCode != null) {
      if (user.phoneCode!.isNotEmpty) {
        user.phoneCode =
            GlobalHandlers.dataDecryptionHandler(value: user.phoneCode!);
      }
    }
    if (user.gender != null) {
      if (user.gender!.isNotEmpty) {
        user.gender = GlobalHandlers.dataDecryptionHandler(value: user.gender!);
      }
    }
    if (user.phoneNumber != null) {
      if (user.phoneNumber!.isNotEmpty) {
        user.phoneNumber =
            GlobalHandlers.dataDecryptionHandler(value: user.phoneNumber!);
      }
    }
    if (user.mailingAddress != null) {
      if (user.mailingAddress!.isNotEmpty) {
        user.mailingAddress =
            GlobalHandlers.dataDecryptionHandler(value: user.mailingAddress!);
      }
    }
    if (user.city != null) {
      if (user.city!.isNotEmpty) {
        if (!user.city!.contains("null")) {
          user.city = GlobalHandlers.dataDecryptionHandler(value: user.city!);
        }
      }
    }
    if (user.state != null) {
      if (user.state!.isNotEmpty) {
        if (!user.state!.contains("null")) {
          user.state = GlobalHandlers.dataDecryptionHandler(value: user.state!);
        }
      }
    }
    if (user.zipcode != null) {
      if (user.zipcode!.isNotEmpty) {
        user.zipcode =
            GlobalHandlers.dataDecryptionHandler(value: user.zipcode!);
      }
    }
    return user;
  }
}
