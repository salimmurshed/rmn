import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'client_registration_event.dart';
part 'client_registration_state.dart';

class ClientRegistrationBloc extends Bloc<ClientRegistrationEvent, ClientRegistrationState> {
  ClientRegistrationBloc() : super(ClientRegistrationInitial()) {
    on<ClientRegistrationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
