import 'dart:convert';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/response_models/event_details_response_model.dart';

class StaffEventCachedData {
  final SharedPreferences _sharedPreferences;

  StaffEventCachedData(this._sharedPreferences);

  Future<void> setEventData({required String value}) async {
    _sharedPreferences.setString(EventDataManager.eventData, value);
  }

  Future<EventData?> getEventData() async {
    String? eventDataJson = _sharedPreferences.getString(EventDataManager.eventData);
    if (eventDataJson != null && eventDataJson.isNotEmpty) {
      Map<String, dynamic> eventDataMap = jsonDecode(eventDataJson);
      return EventData.fromJson(eventDataMap);
    }
    return null;
  }

  removeSharedPreferencesGeneralFunction(String key) async {
    return _sharedPreferences.remove(key);
  }
}

class EventDataManager {
  static const String eventData = 'event-data';
}
