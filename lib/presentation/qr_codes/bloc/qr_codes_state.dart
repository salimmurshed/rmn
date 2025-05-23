part of 'qr_codes_bloc.dart';

@freezed
class QRCodesWithInitialState with _$QRCodesWithInitialState {
  const factory QRCodesWithInitialState({
    required List<Registrations> registration,
    required bool isLoading,
  }) = _QRCodesWithInitialState;

  factory QRCodesWithInitialState.initial() =>
      const QRCodesWithInitialState(isLoading: true, registration: []);
}
