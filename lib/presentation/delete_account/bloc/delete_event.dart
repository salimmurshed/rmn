part of 'delete_bloc.dart';

@immutable
sealed class DeleteEvent extends Equatable {
  const DeleteEvent();

  @override
  List<Object> get props => [];
}

class TriggerDeleteAccountEvent extends DeleteEvent {

}