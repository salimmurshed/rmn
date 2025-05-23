import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

part 'qr_codes_event.dart';

part 'qr_codes_state.dart';

part 'qr_codes_bloc.freezed.dart';

class QrCodesBloc extends Bloc<QrCodesEvent, QRCodesWithInitialState> {
  QrCodesBloc() : super(QRCodesWithInitialState.initial()) {
    on<TriggerCheckForQRCodeStatus>(_onTriggerCheckForQRCodeStatus);
  }

  FutureOr<void> _onTriggerCheckForQRCodeStatus(
      TriggerCheckForQRCodeStatus event,
      Emitter<QRCodesWithInitialState> emit) {
    emit(state.copyWith(isLoading: true));

    final List<Registrations> updatedRegistrations = event.registrations;
    for (Registrations registrations in updatedRegistrations) {

      if (registrations.scanDetails == null) {
        if(registrations.isCancelled!) {
          registrations.qrCodeStatus =
              AppStrings.myPurchases_qrCode_noScanDetailsCancelled_text;
        } else {
          registrations.qrCodeStatus =
              AppStrings.myPurchases_qrCode_noScanDetails_text;
        }

      } else {
        if (registrations.isCancelled!) {
          registrations.qrCodeStatus =
              AppStrings.myPurchases_qrCode_noScanDetailsCancelled_text;
        } else {
          registrations.qrCodeStatus =
              AppStrings.myPurchases_qrCode_scanDetailsConfirmed_text;
        }
      }
      emit(
          state.copyWith(isLoading: false, registration: updatedRegistrations));
    }
  }
}
