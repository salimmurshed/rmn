import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'staff_products_n_registrations_event.dart';
part 'staff_products_n_registrations_state.dart';

class StaffProductsNRegistrationsBloc extends Bloc<StaffProductsNRegistrationsEvent, StaffProductsNRegistrationsState> {
  StaffProductsNRegistrationsBloc() : super(StaffProductsNRegistrationsInitial()) {
    on<StaffProductsNRegistrationsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
