part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  
  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController controller;

  OnMapInitializedEvent(this.controller);
}

class OnStartFollowingUserEvent extends MapEvent{}
class OnStopFollowingUserEvent extends MapEvent{}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> userLocations;

  UpdateUserPolylineEvent(this.userLocations);
}

class OnToggleUserRoute extends MapEvent {}

class DisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  DisplayPolylinesEvent(this.polylines, this.markers);

}