import 'package:flutter/cupertino.dart';
import 'package:rmnevents/common/resources/app_enums.dart';

import '../../imports/common.dart';

class StringManipulation {
  static String capitalizeTheInitial({required String value}) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  static String upperCaseEveryLetter({required String value}) {
    if (value.isEmpty) {
      return value;
    }
    return value.toUpperCase();
  }

  static String lowerCaseEveryLetter({required String value}) {
    if (value.isEmpty) {
      return value;
    }
    return value.toLowerCase();
  }

  static String capitalizeFirstLetterOfEachWord({required String value}) {
    return value
        .split(' ')
        .map((word) => capitalizeTheInitial(value: word))
        .join(' ');
  }

  static String trimString({required dynamic value}) {
    return value.toString().trim();
  }

  static String combineFirstNameWithLastName(
      {required String firstName, required String lastName}) {
    return '${firstName.trim()} ${lastName.trim()}';
  }

  static String combineStringWithSpaceBetween(
      {required String firstPart, required String lastPart}) {
    return '$firstPart $lastPart';
  }

  static String combineStings(
      {required String prefix, required String suffix}) {
    debugPrint('prefix: $prefix, suffix: $suffix');
    debugPrint('combined: ${prefix + suffix}');
    return prefix + suffix;
  }

  static TypeOfAccess convertToEnumFromAccessString({required String text}) {
    return text.toLowerCase() == 'owner'
        ? TypeOfAccess.owner
        : text.toLowerCase() == 'viewer'
            ? TypeOfAccess.view
            : TypeOfAccess.coach;
  }

  static addADollarSign({required num price}) {
    return '\$${price.toStringAsFixed(2)}';
  }

  static String removeDivision({required String division}) {
    return division.replaceAll(" Division", "");
  }
}
