part of 'pos_settings_bloc.dart';

@immutable
sealed class PosSettingsEvent extends Equatable {
  const PosSettingsEvent();

  @override
  List<Object> get props => [];
}

class TriggerFetchReaders extends PosSettingsEvent {}

class TriggerDisconnectReader extends PosSettingsEvent {}

class TriggerConnectToAReader extends PosSettingsEvent {
  final int deviceIndex;
  final bool isConnect;
  final bool shouldCallDisconnectEmit;
  const TriggerConnectToAReader({required this.deviceIndex, required this.isConnect, this.shouldCallDisconnectEmit = false});

  @override
  List<Object> get props => [deviceIndex, isConnect, shouldCallDisconnectEmit];
}


class TriggerRefreshPosSettings extends PosSettingsEvent {}