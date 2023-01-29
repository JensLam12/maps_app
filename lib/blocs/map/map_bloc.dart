import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/helpers/custom_image_marker.dart';
import 'package:maps_app/helpers/helpers.dart';
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
    on<DisplayPolylinesEvent>( (event, emit) => emit( state.copyWith( polylines: event.polylines, markers: event.markers )) );

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

    double kms = destination.distance / 1000;
    kms = ( kms * 100).floorToDouble();
    kms /= 100;
    int tripDuration = (destination.duration /60).floorToDouble().toInt();

    // final startMaker = await getAssetImageMarker();
    final startMaker = await getStartCustomMarker( tripDuration, "My location" );
    // final endMaker = await getNetworkAssetImageMarker();
    final endMaker = await getEndCustomMarker( kms.toInt(), destination.endPlace.placeName);

    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: destination.points.first,
      icon: startMaker,
      anchor: const Offset(0.1, 1),
      // infoWindow: InfoWindow(
      //   title: 'Inicio',
      //   snippet: 'Kms: $kms, duration: $tripDuration',
      // )
    );

    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,
      icon: endMaker,
      //anchor: const Offset(0, 0),
    );

    final currentPolylines = Map<String, Polyline>.from( state.polylines );
    currentPolylines["route"] = myRoute;

    final currentMarkers = Map<String, Marker>.from( state.markers );
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;

    add( DisplayPolylinesEvent(currentPolylines, currentMarkers) );

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
