import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription? positionStream;
  
  LocationBloc() : super( const LocationState() ) {

    on<OnStartFollowingUser>( (event, emit) => emit(state.copyWith( followingUser: true)) );
    on<OnStopFollowingUser>( (event, emit) => emit(state.copyWith( followingUser: false)) );

    on<onNewUserLocationEvent>((event, emit) {
      print(state.locationHistory);
      emit(
        state.copyWith(
          lastKnownLocation: event.newLocation,
          locationHistory: [ ...state.locationHistory, event.newLocation ]
        )
      );
    });
  }

  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    add( onNewUserLocationEvent( LatLng(position.latitude, position.longitude ) ) );
  }

  void startFollowingUser() {
    add( OnStartFollowingUser() );
    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      add( onNewUserLocationEvent( LatLng(position.latitude, position.longitude ) ) );
    });
  }

  void stopFollowingUser() {
    add( OnStopFollowingUser() );
    positionStream?.cancel();
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }
}
