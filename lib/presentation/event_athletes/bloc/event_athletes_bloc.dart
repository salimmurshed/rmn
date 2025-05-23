import 'package:bloc/bloc.dart';
import 'package:rmnevents/data/models/response_models/athlete_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../imports/common.dart';

part 'event_athletes_event.dart';
part 'event_athletes_state.dart';
part 'event_athletes_bloc.freezed.dart';

class EventAthletesBloc extends Bloc<EventAthletesEvent, EventAthletesWithInitialState> {
  EventAthletesBloc() : super(EventAthletesWithInitialState.initial()) {
    on<EventAthletesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
