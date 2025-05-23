import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/presentation/find_customer/bloc/find_customer_bloc.dart';
import 'package:rmnevents/root_app.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../home/staff_home_bloc/staff_home_bloc.dart';

part 'selected_customer_event.dart';

part 'selected_customer_state.dart';

part 'selected_customer_bloc.freezed.dart';

class SelectedCustomerBloc
    extends Bloc<SelectedCustomerEvent, SelectedCustomerState> {
  SelectedCustomerBloc() : super(SelectedCustomerState.initial()) {
    on<TriggerFetchSelectedCustomer>(_onTriggerFetchSelectedCustomer);
    on<TriggerReset>(_onTriggerReset);
  }

  FutureOr<void> _onTriggerFetchSelectedCustomer(
      TriggerFetchSelectedCustomer event, Emitter<SelectedCustomerState> emit) {
    emit(SelectedCustomerState.initial());
    DataBaseUser customer = navigatorKey.currentContext!
        .read<FindCustomerBloc>()
        .state
        .selectedCustomer!;
    EventData eventData = navigatorKey.currentContext!.read<StaffHomeBloc>().state.eventData!;
    emit(state.copyWith(
        isRefreshRequired: false,
        isFailure: false,
        isFromOnBehalf: true,
        eventData: eventData,
        message: AppStrings.global_empty_string,
        customer: customer));
  }

  FutureOr<void> _onTriggerReset(TriggerReset event, Emitter<SelectedCustomerState> emit) {
    emit(SelectedCustomerState.initial());
    BlocProvider.of<FindCustomerBloc>(navigatorKey.currentContext!).add(TriggerResetCustomer());
  }
}
