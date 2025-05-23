import 'dart:core';
import 'package:rmnevents/common/resources/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StripeReaderCachedData {
  final SharedPreferences _sharedPreferences;

  StripeReaderCachedData(this._sharedPreferences);

  Future<void> setStripeReader({required String value}) async {
    _sharedPreferences.setString(StripeReaderManager.stripeReader, value);
  }

  Future<String> getStripeReader() async {
    return _sharedPreferences.getString(StripeReaderManager.stripeReader) ?? AppStrings.global_empty_string;
  }

  removeSharedPreferencesGeneralFunction(String key) async {
    return _sharedPreferences.remove(key);
  }
}

class StripeReaderManager {
  static const String stripeReader = 'stripe-reader';
}
