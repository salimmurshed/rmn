import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:notification_permissions/notification_permissions.dart';

import '../../../di/di.dart';
import '../../../services/shared_preferences_services/app_data.dart';

class AppSettingsHandler {
  static Future<bool> setLocation() async {
    bool isLocationDetectionActive =
        await Geolocator.isLocationServiceEnabled();
    await instance<AppData>()
        .setLocationDetection(value: isLocationDetectionActive);
    return isLocationDetectionActive;
  }

  static Future<bool> setNotification() async {

    PermissionStatus status = await Permission.notification.request();
    bool isOn = false;
    debugPrint('Notification status: $status ');
    if (status == PermissionStatus.granted) {
      await instance<AppData>().setNotificationPermission(value: true);
      isOn = true;
    } else {
      await instance<AppData>().setNotificationPermission(value: false);
      isOn = false;
    }

    debugPrint('Notification status 1: $isOn');
    return isOn;

  }

  static Future<bool> setCrashCollection(
      {required bool isCrashCollectionActive}) async {
    const fatalError = true;
    bool isOn = false;
    if (isCrashCollectionActive) {
      // Non-async exceptions
      FlutterError.onError = (errorDetails) {
        if (fatalError) {
          // If you want to record a "fatal" exception
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
          // ignore: dead_code
        } else {
          // If you want to record a "non-fatal" exception
          FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
        }
      };
      // Async exceptions
      PlatformDispatcher.instance.onError = (error, stack) {
        if (fatalError) {
          // If you want to record a "fatal" exception
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          // ignore: dead_code
        } else {
          // If you want to record a "non-fatal" exception
          FirebaseCrashlytics.instance.recordError(error, stack);
        }
        return true;
      };

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      await instance<AppData>().setCrashCollectionData(value: true);
      isOn = true;
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      await instance<AppData>().setCrashCollectionData(value: false);
      isOn = false;
    }
    debugPrint('Crash collection status: $isOn');
    return isOn;
  }
}
