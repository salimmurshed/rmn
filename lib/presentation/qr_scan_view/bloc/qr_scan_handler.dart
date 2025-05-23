import 'package:bloc/bloc.dart';
import 'package:rmnevents/presentation/qr_scan_view/bloc/qr_scan_bloc.dart';

import '../../../imports/common.dart';

class QRScanHandler {
  static String extractQRID({required String code}) {
    RegExp regExp = RegExp(r'/(\w+)$');
    Match? match = regExp.firstMatch(code);

    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }

    return '';
  }

  static void emitInitialState(
      {required Emitter<QrScanState> emit, required QrScanState state}) {
    emit(state.copyWith(
        isRefreshedRequired: false,
        isFailure: false,
        isLoading: true,
        message: AppStrings.global_empty_string));
  }

  static void emitRefreshState(
      {required Emitter<QrScanState> emit, required QrScanState state}) {
    emit(state.copyWith(
        isRefreshedRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));
  }
}
