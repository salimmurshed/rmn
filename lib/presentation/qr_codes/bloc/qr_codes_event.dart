part of 'qr_codes_bloc.dart';

@immutable
sealed class QrCodesEvent extends Equatable {
  const QrCodesEvent();

  @override
  List<Object?> get props => [];
}

class TriggerCheckForQRCodeStatus extends QrCodesEvent {
  final List<Registrations> registrations;

  const TriggerCheckForQRCodeStatus({required this.registrations});

  @override
  List<Object?> get props => [registrations];
}
