part of 'legals_bloc.dart';

@immutable
sealed class LegalsEvent extends Equatable {
  const LegalsEvent();
  @override
  List<Object?> get props => [];
}


class TriggerCMSFetch extends LegalsEvent {}