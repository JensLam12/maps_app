part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class onActivateManualMarkerEvent extends SearchEvent{}
class onDeactivateManualMarkerEvent extends SearchEvent{}
class onNewPlacesFoundEvent extends SearchEvent{
  final List<Feature> places;
  const onNewPlacesFoundEvent(this.places);
}

class onAddHistoryEvent extends SearchEvent{
  final Feature history;
  const onAddHistoryEvent(this.history);
}