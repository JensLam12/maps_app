import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  StreamSubscription<LocationState>? locationStateSubscription;
  LatLng? mapCenter;

  MapBloc({ 
    required this.locationBloc 
  }) : super(const MapState() ) {

    on<OnMapInitializedEvent>(_onInitMap );
    on<OnStartFollowingUserEvent>( _onStartFollowingUser );
    on<OnStopFollowingUserEvent>( (event, emit) => emit( state.copyWith( isFollowingUser: false) ) );
    on<UpdateUserPolylineEvent>( _onPolylineNewPoint );
    on<OnToggleUserRoute>( (event, emit) => emit( state.copyWith( showMyRoute: !state.showMyRoute )) );
    on<DisplayPolylinesEvent>( (event, emit) => emit( state.copyWith( polylines: event.polylines )) );

    locationStateSubscription = locationBloc.stream.listen((locationState ) {
      if( locationState.lastKnownLocation != null ){
        add( UpdateUserPolylineEvent( locationState.locationHistory));
      }

      if(!state.isFollowingUser) return;

      if( locationState.lastKnownLocation == null) return;

      moveCamera(locationState.lastKnownLocation!);
    });
  }

  _onInitMap( OnMapInitializedEvent event, Emitter emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle( jsonEncode(DarkThemeMap));
    emit( state.copyWith( isMapInitialized: true) );
  }

  _onStartFollowingUser( OnStartFollowingUserEvent event, Emitter<MapState> emit ) {
    
    emit( state.copyWith( isFollowingUser: true) );
    if( locationBloc.state.lastKnownLocation == null ) return;
    moveCamera(locationBloc.state.lastKnownLocation!);
  }

  moveCamera( LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng( newLocation );
    _mapController?.animateCamera( cameraUpdate);
  }

  Future drawRoutePolyline( RouteDestination destination ) async {
    final myRoute = Polyline( 
      polylineId: const PolylineId('route'),
      color: Colors.red,
      width: 4,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap
    );

    final currentPolylines = Map<String, Polyline>.from( state.polylines );
    currentPolylines["route"] = myRoute;
    add( DisplayPolylinesEvent(currentPolylines) );
  }

  _onPolylineNewPoint( UpdateUserPolylineEvent event, Emitter<MapState> emit ) {
    final myRoute = Polyline(
      polylineId: const PolylineId("myRoute"),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.userLocations
    );

    final currentPolylines = Map<String, Polyline>.from( state.polylines );
    currentPolylines["myRoute"] = myRoute;
    emit( state.copyWith( polylines: currentPolylines ));
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
