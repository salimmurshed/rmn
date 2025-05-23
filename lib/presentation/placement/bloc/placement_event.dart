part of 'placement_bloc.dart';

@immutable
sealed class PlacementEvent extends Equatable{
  const PlacementEvent();
  @override
  List<Object> get props => [];
}
class TriggerPlacementList extends PlacementEvent {
  final String eventId;
  const TriggerPlacementList(this.eventId);
  @override
  List<Object> get props => [eventId];
}

class TriggerSelectDivision extends PlacementEvent {
  final int index;
  const TriggerSelectDivision(this.index);
  @override
  List<Object> get props => [index];
}