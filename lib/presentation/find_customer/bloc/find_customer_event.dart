part of 'find_customer_bloc.dart';

@immutable
sealed class FindCustomerEvent extends Equatable {
  const FindCustomerEvent();

  @override
  List<Object> get props => [];
}

class TriggerFetchUsersList extends FindCustomerEvent {}
class TriggerSearchForCustomer extends FindCustomerEvent {}
class TriggerSearchForCustomerRemotely extends FindCustomerEvent {}
class TriggerOpenDropDown extends FindCustomerEvent {}
class TriggerRefreshScreen extends FindCustomerEvent {}
class TriggerMoreUserFetch extends FindCustomerEvent {}
class TriggerSelectCustomer extends FindCustomerEvent {
  final int index;
  const TriggerSelectCustomer({required this.index});
  @override
  List<Object> get props => [index];
}
class TriggerResetCustomer extends FindCustomerEvent {}