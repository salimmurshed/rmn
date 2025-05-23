part of 'all_events_bloc.dart';

@immutable
sealed class AllEventsEvent extends Equatable {
  const AllEventsEvent();

  @override
  List<Object?> get props => [];
}

class TriggerOnChangeSearchEvent extends AllEventsEvent {
  final String searchValue;

  const TriggerOnChangeSearchEvent({required this.searchValue});

  @override
  List<Object?> get props => [searchValue];
}

class TriggerEraseSearchKeywordEvent extends AllEventsEvent {}

class TriggerFetchAllEvents extends AllEventsEvent {}

class TriggerFetchAllEventsOnMap extends AllEventsEvent {
  final bool isFirstTime;
  const TriggerFetchAllEventsOnMap({this.isFirstTime = false});
  @override
  List<Object?> get props => [isFirstTime];
}

class TriggerAddScrollControllerListener extends AllEventsEvent {}

class TriggerFetchFilterResults extends AllEventsEvent {
  final FilterType filterType;
  final bool isSwitch;
  num? page;
  bool isList;
   TriggerFetchFilterResults({required this.filterType, required this.isSwitch, this.isList = false, this.page});

  @override
  List<Object?> get props => [filterType, isList, page, isSwitch];
}

class TriggerFetchFilterEventsOnMap extends AllEventsEvent {
  final FilterType filterType;

  const TriggerFetchFilterEventsOnMap({required this.filterType});

  @override
  List<Object?> get props => [filterType];
}

class TriggerTapOnFilter extends AllEventsEvent {
  final bool isMap;

  const TriggerTapOnFilter({this.isMap = false});

  @override
  List<Object?> get props => [isMap];
}

class TriggerSearchEvent extends AllEventsEvent {
  bool isList;
  final FilterType filterType;
  TriggerSearchEvent({this.isList = false, required this.filterType});
  @override
  List<Object?> get props => [isList, filterType];
}

class TriggerSearchEventsOnMap extends AllEventsEvent {}

class TriggerAddUserLocation extends AllEventsEvent {}

class TriggerGetUserLocation extends AllEventsEvent {}
class TriggerRefreshPage extends AllEventsEvent {}
class TriggerPagination extends AllEventsEvent {}