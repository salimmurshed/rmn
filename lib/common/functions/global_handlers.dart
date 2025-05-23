import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rmnevents/imports/services.dart';

import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';
// import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/response_models/stripe_readers_response_model.dart';
import '../../di/di.dart';
import '../../imports/common.dart';
import '../../imports/data.dart';
import '../../services/shared_preferences_services/stripe_reader_cached_data.dart';
import '../widgets/textfields/custom_month_year_picker.dart';
import 'decrypted_user_data.dart';

final List<String> monthList = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];
List<String> yearList =
    List.generate(2001, (index) => (index + 2000).toString());

class GlobalHandlers {
  static Uint8List convertQRCodeToImage({required String qrCode}) {
    String encodedImage = qrCode.replaceFirst("data:image/png;base64,", "");

    Uint8List decodedBase64 = base64Decode(encodedImage);
    return decodedBase64;
  }

  static EventStatus getStatusEvent(
      {required String startDate, required String endDate}) {
    EventStatus eventStatus = EventStatus.none;
    if (DateTime.parse(startDate).isBefore(DateTime.now()) &&
        DateTime.parse(endDate).isAfter(DateTime.now())) {
      eventStatus = EventStatus.live;
    }
    if (DateTime.parse(startDate).isAfter(DateTime.now())) {
      eventStatus = EventStatus.upcoming;
    }
    if (DateTime.parse(endDate).isBefore(DateTime.now())) {
      eventStatus = EventStatus.past;
    }
    return eventStatus;
  }

  static String eventInDays({required String startDate}) {
    DateTime start = DateTime.parse(startDate);
    Duration difference = start.difference(DateTime.now());
    return difference.inDays.toString();
  }

  static String eventInDaysAgo({required String endDate}) {
    DateTime end = DateTime.parse(endDate);
    Duration difference = DateTime.now().difference(end);
    return difference.inDays.toString();
  }

  static bool isMoreThanTwoLines(
      {required String text, required TextStyle style}) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 2, //
      textAlign: TextAlign.left,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout(
        maxWidth: Dimensions.getScreenWidth() *
            0.3); // Allow text to occupy full width

    // Print the result (true/false
    return textPainter
        .didExceedMaxLines; // Return true if it fits in a single line
  }
  static List<String> sortWeights({required List<String> weightClasses}) {
    weightClasses.sort((a, b) {
      if (a.toUpperCase() == "HWT") return 1; // 'HWT' always comes last
      if (b.toUpperCase() == "HWT") return -1;

      // Check if both are valid integers
      final isANumber = int.tryParse(a) != null;
      final isBNumber = int.tryParse(b) != null;

      if (isANumber && isBNumber) {
        return int.parse(a).compareTo(int.parse(b)); // Compare as integers
      } else if (isANumber) {
        return -1; // Numbers come before non-numbers
      } else if (isBNumber) {
        return 1; // Non-numbers come after numbers
      }

      return a.compareTo(b); // Fallback for non-numeric comparison
    });

    return weightClasses;
  }

  //static methods
  static bool passwordFieldValidationAgainstChecker(
      {required PasswordChecker passwordChecker, required String value}) {
    switch (passwordChecker) {
      case PasswordChecker.isAtLeastEightCharChecked:
        bool result =
            TextFieldValidators.validateAtLeastEightChar(value: value);
        return result;
      case PasswordChecker.isAtLeastOneLowerCaseChecked:
        bool result =
            TextFieldValidators.validateAtLeastOneLowerCase(value: value);
        return result;
      case PasswordChecker.isAtLeastOneUpperCaseChecked:
        bool result =
            TextFieldValidators.validateAtLeastOneUpperCase(value: value);
        return result;
      case PasswordChecker.isAtLeastOneDigitChecked:
        bool result = TextFieldValidators.validateAtLeastOneDigit(value: value);
        return result;
      case PasswordChecker.isAtLeastOneSpecialCharChecked:
        bool result =
            TextFieldValidators.validateAtLeastOneSpecialChar(value: value);
        return result;
      default:
        return false;
    }
  }

  static String? mmDDYYYYDateFormatHandler({required DateTime? dateTime}) {
    String? formattedDate;
    if (dateTime != null) {
      formattedDate = StringManipulation.trimString(
          value: DateFormat('MM/dd/yyyy').format(dateTime));
    }
    //10/18/2024
    return formattedDate;
  }


  static String formatDateToThMonthYear({required String dateString}) {
    // Parse the input date string to a DateTime object.
    DateTime dateTime = DateTime.parse(dateString).toLocal();

    // Create a DateFormat object with the desired format.
    final formatter = DateFormat('d');

    // Get the day.
    String day = formatter.format(dateTime);
    String suffix = '';
    if (day == '1' || day == '21' || day == '31') {
      suffix = 'st';
    } else if (day == '2' || day == '22') {
      suffix = 'nd';
    } else if (day == '3' || day == '23') {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }

    // Create a new DateFormat with the rest of the format
    final formattedDate = DateFormat("MMMM yyyy").format(dateTime);

    // Return the format.
    return '$day$suffix $formattedDate';
    //10th August 2024
  }


  static String yyyyMMddDateFormatHandler({required String dateString}) {
    DateTime dateTime = DateFormat('MM/dd/yyyy').parse(dateString);

    // Format the DateTime object to the desired output format
    String formattedDate = DateFormat('yyyy/MM/dd').format(dateTime);
//2024/10/18
    return formattedDate;
  }
  static String reverseToMonthDateYear({required String dateString}) {
    debugPrint('Date String: $dateString');
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(dateString); // Try parsing ISO 8601 format
    } catch (e) {
      dateTime = DateFormat('yyyy/MM/dd').parse(dateString); // Fallback to custom format
    }

    // Format the DateTime object to the desired output format
    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
//2024/10/18
    return formattedDate;
  }

  static String mmDDYYDateFormatHandler({required DateTime? dateTime}) {
    String formattedDate = AppStrings.global_empty_string;
    if (dateTime != null) {
      formattedDate = StringManipulation.trimString(
          value: DateFormat('MMMM dd, yyyy').format(dateTime));
    }
    //September 30, 2024
    return formattedDate;
  }

  static String calculateTransactionFee({required String amount}) {
    double transactionFee = double.parse(amount) * globalTransactionFee / 100;
    return '\$${transactionFee.toStringAsFixed(2)}';
  }

  static Future<DateTime?> datePickerHandler({
    required BuildContext context,
    required String initialDate,
    DateTime? lastDate,
  })
  async {
    DateTime initialDateForCalendar = initialDate.isEmpty
        ? DateTime.now()
        : DateFormat('MM/dd/yyyy').parse(initialDate);
    return await showDatePicker(
      context: context,
      initialDate: initialDateForCalendar,
      firstDate: DateTime(1950),
      lastDate: lastDate ?? DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      useRootNavigator: false,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.colorPrimaryAccent,
              onPrimary: AppColors.colorPrimaryInverseText,
              onSurface: AppColors.colorPrimaryNeutralText,
              outlineVariant: AppColors.colorPrimaryNeutralText,
            ),
            dividerTheme: DividerThemeData(
              color: AppColors.colorPrimaryNeutralText,
              space: 0,
              thickness: 1,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static String formatDateStringForExpiryDate(String dateString) {
    // Parse the input date string
    DateTime dateTime = DateTime.parse(dateString);

    // Create a DateFormat object with the desired output format ('MM/yy')
    DateFormat formatter = DateFormat('MM/yy');

    // Format the DateTime object to get the desired output string
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }

  static monthYearPickerHandler({
    required BuildContext context,
  }) async {
    return await SimpleMonthYearPicker.showMonthYearPickerDialog(
        context: context,
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: AppColors.colorPrimaryInverseText,
        ),
        monthTextStyle: TextStyle(
          color: AppColors.colorPrimaryInverseText,
        ),
        yearTextStyle: TextStyle(
          color: AppColors.colorPrimaryInverseText,
        ),
        backgroundColor: AppColors.colorSecondary,
        selectionColor: AppColors.colorPrimaryAccent,
        disableFuture:
            false // This will disable future years. it is false by default.
        );
  }

  static String dataEncryptionHandler({required String value}) {
    String trimmedValue = value.toString().trim();
    String encryptedValue = value.isEmpty
        ? AppStrings.global_empty_string :
    EncryptionDecryptionHelper.encryption(trimmedValue);
    debugPrint('Encrypted Value: $encryptedValue');
    return encryptedValue;
  }

  static String dataDecryptionHandler({required String value}) {
    String trimmedValue = value.toString().trim();
    String decryptedValue = value.isEmpty
        ? AppStrings.global_empty_string:
    EncryptionDecryptionHelper.decryption(trimmedValue);
    debugPrint('Decrypted Value: $decryptedValue');
    return decryptedValue;
  }

  static String dateFormatterForPaymentDate({required String dateString}) {
    DateFormat formatter = DateFormat('MMM dd, yyyy hh:mm a');

    // Parse the input date string
    DateTime parsedDate = DateTime.parse(dateString);

    // Convert to local time
    DateTime localDate = parsedDate.toLocal();

    // Format the date in the local timezone
    return formatter.format(localDate);
  }
  static Future<DataBaseUser> extractUserHandler() async {
    UserCachedData userData = instance<UserCachedData>();
    String getProfileData = await userData.getUserInfo() ?? '';
    var profileMap = jsonDecode(getProfileData);
    DataBaseUser user = DataBaseUser.fromJson(profileMap);
    return user;
  }

  static Future<UserResponseModel> updateResponseModel(
      {required UserResponseModel responseModel})
  async {
    UserResponseModel signInResponseModel = responseModel;
    DataBaseUser user =
        signInResponseModel.responseData!.user ?? DataBaseUser();

    user.canSwitch = false;
    user.label = AppStrings.global_empty_string;
    user = DecryptedUserData.decryptUserData(user: user);
    bool isProfileComplete = user.isProfileComplete ?? false;
    bool isPolicyAccepted = user.policyAcceptedOn != null;
    String socialUserId = user.socialId ?? AppStrings.global_empty_string;
    user.socialId = socialUserId;
    if(socialUserId.isEmpty){
      user.profile =  StringManipulation.combineStings(
          prefix: signInResponseModel.responseData!.assetsUrl!,
          suffix: user.profile!);
    }else{
      user.profile = !user.profile!.contains('http')
          ? StringManipulation.combineStings(
          prefix: signInResponseModel.responseData!.assetsUrl!,
          suffix: user.profile!)
          : user.profile;
    }


    if (isProfileComplete && socialUserId.isEmpty) {
      if (user.roles!.contains(AppStrings.global_role_owner) &&
          user.roles!.length == 1) {
        user.roles!.add(AppStrings.global_role_user);
      }
      user.moveToCreateProfile = false;

      user.currentRole = absoluteUser(roles: user.roles!);

      if (user.roles!.contains(AppStrings.global_role_user) &&
          user.roles!.length > 1) {
        user.canSwitch = true;
      } else if (user.roles!.contains(AppStrings.global_role_owner)) {
        user.canSwitch = true;
      } else {
        user.canSwitch = false;
      }
      user.label = GlobalHandlers.absoluteUser(roles: user.roles!);

      await RepositoryDependencies.userCachedData.setUserData(
          url: user.profile ?? AppStrings.global_empty_string,
          firstName: user.firstName ?? AppStrings.global_empty_string,
          lastName: user.lastName ?? AppStrings.global_empty_string,
          email: user.email ?? AppStrings.global_empty_string,
          accessToken: user.token ?? AppStrings.global_empty_string,
          userId: user.id ?? AppStrings.global_empty_string,
          userInfo: jsonEncode(
            user,
          )); //
    } //
    else if(isProfileComplete && socialUserId.isNotEmpty){
      if(isPolicyAccepted){
        if (user.roles!.contains(AppStrings.global_role_owner) &&
            user.roles!.length == 1) {
          user.roles!.add(AppStrings.global_role_user);
        }
        user.moveToCreateProfile = false;

        user.currentRole = absoluteUser(roles: user.roles!);

        if (user.roles!.contains(AppStrings.global_role_user) &&
            user.roles!.length > 1) {
          user.canSwitch = true;
        } else if (user.roles!.contains(AppStrings.global_role_owner)) {
          user.canSwitch = true;
        } else {
          user.canSwitch = false;
        }
        user.label = GlobalHandlers.absoluteUser(roles: user.roles!);

        await RepositoryDependencies.userCachedData.setUserData(
            url: user.profile ?? AppStrings.global_empty_string,
            firstName: user.firstName ?? AppStrings.global_empty_string,
            lastName: user.lastName ?? AppStrings.global_empty_string,
            email: user.email ?? AppStrings.global_empty_string,
            accessToken: user.token ?? AppStrings.global_empty_string,
            userId: user.id ?? AppStrings.global_empty_string,
            userInfo: jsonEncode(
              user,
            )); //
      }
      else{
        if (user.email != null && user.token != null && user.id != null) {
          await RepositoryDependencies.userCachedData.setUserId(value: user.id!);
          await RepositoryDependencies.userCachedData
              .setUserAccessToken(value: user.token!);
          await RepositoryDependencies.userCachedData
              .setUserEmail(email: user.email!);
        }
        if (user.firstName != null && user.lastName != null) {
          await RepositoryDependencies.userCachedData
              .setUserName(isFirstName: true, name: user.firstName!);
          await RepositoryDependencies.userCachedData
              .setUserName(isFirstName: false, name: user.lastName!);
        }
        if (user.profile != null) {
          await RepositoryDependencies.userCachedData
              .setUserPhoto(url: user.profile!);
        }
        user.moveToCreateProfile = true;
      }
    }
    else {
      if (user.email != null && user.token != null && user.id != null) {
        await RepositoryDependencies.userCachedData.setUserId(value: user.id!);
        await RepositoryDependencies.userCachedData
            .setUserAccessToken(value: user.token!);
        await RepositoryDependencies.userCachedData
            .setUserEmail(email: user.email!);
      }
      if (user.firstName != null && user.lastName != null) {
        await RepositoryDependencies.userCachedData
            .setUserName(isFirstName: true, name: user.firstName!);
        await RepositoryDependencies.userCachedData
            .setUserName(isFirstName: false, name: user.lastName!);
      }
      if (user.profile != null) {
        await RepositoryDependencies.userCachedData
            .setUserPhoto(url: user.profile!);
      }
      user.moveToCreateProfile = true;
    }
    return responseModel;
  }

  static String absoluteUser({required List<String> roles})
  {
    if (roles.contains(UserTypes.owner.name)) {
      return UserTypes.owner.name;
    } else if (roles.contains(UserTypes.admin.name)) {
      return UserTypes.admin.name;
    } else if (roles.contains(UserTypes.employee.name)) {
      return UserTypes.employee.name;
    } else {
      return UserTypes.user
          .name; // Default to AppStrings.global_role.user if none of the above roles are found
    }
  }

  static bool passwordHandler({required String value}) {
    String? result =
        TextFieldValidators.validatePasswordSecurityPolicies(value);
    return result == null ? false : true;
  }

  static bool confirmPasswordHandler(
      {required String value, required String reTypedValue}) {
    String? result = TextFieldValidators.validateConfirmPassword(
        password: value, reTypedValue: reTypedValue);
    return result == null ? false : true;
  }

  static bool hidePasswordHandler({required bool isPasswordVisible}) {
    return !isPasswordVisible;
  }

  static bool nameHandler(
      {required String value, required NameTypes nameTypes}) {
    String? result =
        TextFieldValidators.validateName(value: value, nameTypes: nameTypes);
    return result == null ? false : true;
  }

  static bool birthDayHandler(
      {required String value, required AgeType ageType}) {
    String? result =
        TextFieldValidators.validateBirthday(birthDay: value, ageType: ageType);
    return result == null ? false : true;
  }

  static bool emailHandler({required String value}) {
    String? result = TextFieldValidators.validateEmail(value);
    return result == null ? false : true;
  }

  static bool postalAddressHandler({required String value, required String city}) {
    String? result = TextFieldValidators.validatePostalAddress(address: value,city: city);
    return result == null ? false : true;
  }

  static bool zipHandler({required String value}) {
    String? result = TextFieldValidators.validateZip(value: value);
    return result == null ? false : true;
  }

  static bool weightHandler({required String value}) {
    String? result = TextFieldValidators.validateWeight(value: value);
    return result == null ? false : true;
  }

  static bool contactNumberHandler({required String value}) {
    String? result = TextFieldValidators.validateContactNumber(value: value);
    return result == null ? false : true;
  }

  static bool imageUploadHandler({required File file}) {
    String? result = MediaManager.validateImageSize(file: file);
    debugPrint('Image Size: $result');
    return result == null ? false : true;
  }

  static TypeOfAccess accessTypeHandler({required int apiAccessType}) {
    return apiAccessType == 0
        ? TypeOfAccess.view
        : apiAccessType == 1
            ? TypeOfAccess.owner
            : TypeOfAccess.coach;
  }

  static String getHumanReadableTimeStampInAgoFormat(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp).toLocal();
    DateTime now = DateTime.now();

    Duration difference = now.difference(dateTime);

    String formattedTime = '';

    if (difference.inDays > 365) {
      int years = (difference.inDays / 365).floor();
      formattedTime = years > 1 ? '$years years ago' : '1 year ago';
    } else if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      formattedTime = months > 1 ? '$months months ago' : '1 month ago';
    } else if (difference.inDays > 7) {
      int weeks = (difference.inDays / 7).floor();
      formattedTime = weeks > 1 ? '$weeks weeks ago' : '1 week ago';
    } else if (difference.inDays > 1) {
      formattedTime = '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      formattedTime = '1 day ago';
    } else if (difference.inHours > 1) {
      formattedTime = '${difference.inHours} hours ago';
    } else if (difference.inHours == 1) {
      formattedTime = '1 hour ago';
    } else if (difference.inMinutes > 1) {
      formattedTime = '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes == 1) {
      formattedTime = '1 minute ago';
    } else {
      formattedTime = 'Just now';
    }

    return formattedTime;
  }

  static urlLaunch(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw '${AppStrings.global_url_no_launch} $url';
    }
  }
  static bool validateGradeWithGradesRange(
      {String? grade,
      required String minGrade,
     required  String maxGrade,
      required List<String> gradeValues}) {
    if (grade == null) {
      return false;
    }

    int index = gradeValues.indexOf(grade);
    if (index == -1) {
      return false;
    }

    int lower = gradeValues.indexOf(minGrade);
    int higher = gradeValues.indexOf(maxGrade);

    debugPrint('Index: $index, Lower: $lower, Higher: $higher');
    debugPrint('Index: $index, minGrade: $minGrade, maxGrade: $maxGrade');
    debugPrint('Index: $index, gradeValues: $gradeValues');
    debugPrint('index >= lower $lower, index <=: $higher');
    return index >= lower && index <= higher;
  }

  static Future<StripeReaderData?> extractStripeReaderHandler() async {
    String stripeReaderString =
    await instance<StripeReaderCachedData>().getStripeReader();
    StripeReaderData? stripeReaderData;

    if (stripeReaderString.isNotEmpty) {
      var stripeReaderMap = jsonDecode(stripeReaderString);
      stripeReaderData = StripeReaderData.fromJson(stripeReaderMap);
    }

    return stripeReaderData;
  }
}
