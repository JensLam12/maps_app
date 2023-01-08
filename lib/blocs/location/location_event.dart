part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class onNewUserLocationEvent extends LocationEvent {
  final LatLng newLocation;
  const onNewUserLocationEvent(this.newLocation);
}

class OnStartFollowingUser extends LocationEvent{}
class OnStopFollowingUser extends LocationEvent{}