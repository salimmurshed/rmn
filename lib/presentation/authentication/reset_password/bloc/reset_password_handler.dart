import 'package:bloc/bloc.dart';
import 'package:rmnevents/presentation/authentication/reset_password/bloc/reset_password_bloc.dart';

import '../../../../imports/common.dart';

class ResetPasswordHandler {
  static void emitInitialState(
      {required Emitter<ResetPasswordWithInitialState> emit,
        required ResetPasswordWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));
  }}