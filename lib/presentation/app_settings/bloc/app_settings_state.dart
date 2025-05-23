part of 'app_settings_bloc.dart';

@freezed
class AppSettingsWithInitialStates with _$AppSettingsWithInitialStates {
  const factory AppSettingsWithInitialStates({
    required String message,
    required bool isNotificationActivated,
    required bool isLocationDetectionActivated,
    required bool isCrashCollectionActivated,
    required bool isAppInformationPanelExpanded,
    required bool isRefreshRequired,
    required bool isExpansionTileOpened,
    required String appName,
    required String appBuildVersion,
    required String appBuildNumber,
    required bool isAppOpenedFirstTime,
    required bool isLoadingForTabs,
    required AppSettingOptions appSettingOptions,
  }) = _AppSettingsWithInitialStates;

  factory AppSettingsWithInitialStates.initial() =>
      const AppSettingsWithInitialStates(
        message: AppStrings.global_empty_string,
        isNotificationActivated: true,
        isExpansionTileOpened:false,
        isLocationDetectionActivated: true,
        isCrashCollectionActivated: true,
        isLoadingForTabs: false,
        isRefreshRequired: false,
        appBuildNumber: AppStrings.global_empty_string,
        appBuildVersion: AppStrings.global_empty_string,
        appName: AppStrings.global_empty_string,
        isAppInformationPanelExpanded: false,
        isAppOpenedFirstTime: true,
        appSettingOptions: AppSettingOptions.notification,
      );
}
