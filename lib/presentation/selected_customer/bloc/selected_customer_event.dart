part of 'selected_customer_bloc.dart';

@immutable
sealed class SelectedCustomerEvent extends Equatable{
  const SelectedCustomerEvent();
  @override
  List<Object> get props => [];
}

class TriggerFetchSelectedCustomer extends SelectedCustomerEvent {}
class TriggerReset extends SelectedCustomerEvent {}