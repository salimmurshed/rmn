import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/common/resources/app_enums.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';
import 'package:rmnevents/presentation/my_athletes/bloc/my_athletes_bloc.dart';
import 'package:rmnevents/root_app.dart';
import '../../../common/resources/app_strings.dart';
import '../../../data/models/response_models/notification_response_model.dart';
import '../../../data/repository/notification_repository.dart';
import '../../base/bloc/base_bloc.dart';

part 'notification_event.dart';

part 'notification_state.dart';

part 'notification_bloc.freezed.dart';

class NotificationBloc
    extends Bloc<NotificationEvent, NotificationWithInitialState> {
  NotificationBloc() : super(NotificationWithInitialState.initial()) {
    on<TriggerGetNotifications>(_onTriggerGetNotifications);
    on<TriggerGetNotificationCount>(_onTriggerGetNotificationCount);
  }

  FutureOr<void> _onTriggerGetNotifications(TriggerGetNotifications event,
      Emitter<NotificationWithInitialState> emit) async {
    emit(NotificationWithInitialState.initial());
    try {
      final response = await NotificationRepository.getNotificationList();
      response.fold(
        (failure) {
          emit(state.copyWith(
            isLoading: false,
            isFailure: true,
            message: failure.message,
          ));
        },
        (success) {
          List<Notifications> notifications = [];
          if (event.type == 'event-notification') {
            String id = globalEventResponseData!.event!.id!;
            notifications = success.responseData!.notifications!
                .where((element) =>
                    element.refId == id &&
                    element.notificationType == event.type)
                .toList();
          } else {
            notifications = success.responseData!.notifications!;
          }

          emit(state.copyWith(
            isLoading: false,
            isFailure: false,
            notifications: notifications,
          ));
        },
      );
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
        message: error.toString(),
      ));
    }
  }

  FutureOr<void> _onTriggerGetNotificationCount(
      TriggerGetNotificationCount event,
      Emitter<NotificationWithInitialState> emit) async {
    emit(state.copyWith(isRefreshedRequired: true));
    try {
      final response = await NotificationRepository.getNotificationCount();
      response.fold(
        (failure) {
          emit(state.copyWith(
            isRefreshedRequired: false,
            isFailure: true,
            message: failure.message,
          ));
        },
        (success) {
          emit(state.copyWith(
            isRefreshedRequired: false,
            isFailure: false,
            unreads: success.responseData!.count!.toString(),
          ));
          if (event.messageType == "athlete-request") {
            BlocProvider.of<MyAthletesBloc>(navigatorKey.currentContext!).add(
                TriggerCheckForRequests(
                ));
          }
          if(event.messageType == "event-message"){
            // BlocProvider.of<EventDetailsBloc>(navigatorKey.currentContext!).add(TriggerFetchEventDetails(
            //     eventId: globalEventResponseData!.event!.id!,
            //     isFromDetailView: false,
            // ));
          }
        },
      );
    } catch (error) {
      emit(state.copyWith(
        isRefreshedRequired: false,
        isFailure: true,
        message: error.toString(),
      ));
    }
  }
}
