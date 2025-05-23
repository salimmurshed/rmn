part of 'qr_scan_bloc.dart';

@immutable
sealed class QrScanEvent extends Equatable {
  const QrScanEvent();

  @override
  List<Object?> get props => [];
}

class TriggerCreationOfQRView extends QrScanEvent {
  final QRViewController controller;

  const TriggerCreationOfQRView(this.controller);

  @override
  List<Object?> get props => [controller];
}

class TriggerScanQrCode extends QrScanEvent {}

class TriggerQRScanUpload extends QrScanEvent {
  final String id;

  const TriggerQRScanUpload({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class TriggerStoreQRScannedData extends QrScanEvent {
  final String id;
  final bool isSuccessful;

  const TriggerStoreQRScannedData(
      {required this.id, required this.isSuccessful});

  @override
  List<Object?> get props => [id, isSuccessful];
}

class TriggerFetchHistory extends QrScanEvent {}

class TriggerQRScanResume extends QrScanEvent {}

class TriggerQRCameraReassemble extends QrScanEvent {}

class TriggerCallPopUp extends QrScanEvent {
  final String id;

  const TriggerCallPopUp(this.id);
}

class TriggerReloadHistory extends QrScanEvent {}



class TriggerFetchSales extends QrScanEvent {
  final bool isFirstTime;

  const TriggerFetchSales({required this.isFirstTime});
}

class TriggerStartDownload extends QrScanEvent {
  final int index;

  const TriggerStartDownload(this.index);
}

class TriggerStopDownload extends QrScanEvent {
  final int index;
  final String message;
  final bool isFailure;

  const TriggerStopDownload(this.index, this.message, this.isFailure);
}

class TriggerSwitchTabs extends QrScanEvent {
  final int index;

  const TriggerSwitchTabs({required this.index});

  @override
  List<Object?> get props => [index];
}


class TriggerScrollSales extends QrScanEvent{}
class TriggerHistoryTabEvents extends QrScanEvent {
  final HistoryTabEvents historyTabEvents;
  const TriggerHistoryTabEvents(this.historyTabEvents);
  @override
  List<Object?> get props => [historyTabEvents];
}