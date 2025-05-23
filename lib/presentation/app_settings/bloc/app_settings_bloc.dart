import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rmnevents/services/shared_preferences_services/app_data.dart';

import '../../../di/di.dart';
import '../../../imports/common.dart';
import 'app_setting_handler.dart';

part 'app_settings_event.dart';

part 'app_settings_state.dart';

part 'app_settings_bloc.freezed.dart';

class AppSettingsBloc
    extends Bloc<AppSettingsEvent, AppSettingsWithInitialStates> {
  AppData appData = instance<AppData>();

  AppSettingsBloc() : super(AppSettingsWithInitialStates.initial()) {
    on<TriggerFetchAppInformation>(_onTriggerFetchAppInformation);
    on<TriggerAppSettingsOptions>(_onTriggerAppSettingsOptions);
    on<TriggerToggleExpansionTile>(_onTriggerToggleExpansionTile);
    on<TriggerCheckPhoneSettings>(_onTriggerCheckPhoneSettings);
  }

  FutureOr<void> _onTriggerFetchAppInformation(TriggerFetchAppInformation event,
      Emitter<AppSettingsWithInitialStates> emit) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = 'RMN Events';
    String appBuildVersion = packageInfo.version;
    String appBuildNumber = packageInfo.buildNumber;


    // appName = StringManipulation.capitalizeFirstLetterOfEachWord(value: appName);
    bool isLocationDetectionActivated =
    await AppSettingsHandler.setLocation();
    bool isNotificationActivated = await AppSettingsHandler.setNotification();
    bool isCrashCollectionActivated =
    await appData.isCrashCollectionActivated();
    emit(state.copyWith(
      isLocationDetectionActivated: isLocationDetectionActivated,
      isNotificationActivated: isNotificationActivated,
      isCrashCollectionActivated: isCrashCollectionActivated,
      appName: appName,
      appBuildVersion: appBuildVersion,
      appBuildNumber: appBuildNumber,
    ));
  }

  FutureOr<void> _onTriggerAppSettingsOptions(TriggerAppSettingsOptions event,
      Emitter<AppSettingsWithInitialStates> emit) async {
    emit(state.copyWith(
        isRefreshRequired: true, message: AppStrings.global_empty_string));
    switch (event.appSettingOptions) {
      case AppSettingOptions.notification:
        AppSettings.openAppSettings(type: AppSettingsType.notification);
        break;
      case AppSettingOptions.location:
        AppSettings.openAppSettings(type: AppSettingsType.location);
        break;
      case AppSettingOptions.crashCollection:
        bool isOn = await AppSettingsHandler.setCrashCollection(
            isCrashCollectionActive: !state.isCrashCollectionActivated);
        emit(state.copyWith(
            isCrashCollectionActivated: isOn,
            appSettingOptions: AppSettingOptions.crashCollection));

        break;
    }
    emit(state.copyWith(isRefreshRequired: false));
  }

  FutureOr<void> _onTriggerToggleExpansionTile(TriggerToggleExpansionTile event,
      Emitter<AppSettingsWithInitialStates> emit) {
    emit(state.copyWith(isRefreshRequired: true));
    emit(state.copyWith(
        isRefreshRequired: false, isExpansionTileOpened: event.isExpanded));
  }

  FutureOr<void> _onTriggerCheckPhoneSettings(TriggerCheckPhoneSettings event,
      Emitter<AppSettingsWithInitialStates> emit) async {
    emit(state.copyWith(
        isRefreshRequired: true, message: AppStrings.global_empty_string));

      bool isOnLoco = await AppSettingsHandler.setLocation();
      bool isOn = await AppSettingsHandler.setNotification();
      emit(state.copyWith(
          isNotificationActivated: isOn,
          isLocationDetectionActivated: isOnLoco,
          isRefreshRequired: false,
          appSettingOptions: AppSettingOptions.notification));

  }
}