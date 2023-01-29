import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/blocs.dart';

class MapView extends StatelessWidget {
  final LatLng initialLocation;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  const MapView({
    super.key, 
    required this.initialLocation, 
    required this.polylines,
    required this.markers
  });

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition _kLake = CameraPosition(
      target: initialLocation,
      zoom: 17
    );

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (pointerMovement) => mapBloc.add( OnStopFollowingUserEvent()),
        child: GoogleMap(
          initialCameraPosition: _kLake,
          compassEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          myLocationEnabled: true,
          polylines: polylines,
          onMapCreated: ( controller) => mapBloc.add( OnMapInitializedEvent(controller) ),
          onCameraMove: (position) => mapBloc.mapCenter = position.target,
          markers: markers,
        ),
      ),
    );
  }
}