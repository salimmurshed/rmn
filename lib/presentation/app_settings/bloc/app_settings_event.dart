part of 'app_settings_bloc.dart';

@immutable
sealed class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();
  @override
  List<Object?> get props => [];
}

class TriggerFetchAppInformation extends AppSettingsEvent {}
class TriggerAppSettingsOptions extends AppSettingsEvent {
  final AppSettingOptions appSettingOptions;
  const TriggerAppSettingsOptions({required this.appSettingOptions});
  @override
  List<Object?> get props => [appSettingOptions];
}
class TriggerToggleExpansionTile extends AppSettingsEvent{
  final bool isExpanded;
  const TriggerToggleExpansionTile({required this.isExpanded});
  @override
  List<Object?> get props => [isExpanded];
}
class TriggerCheckPhoneSettings extends AppSettingsEvent{

}