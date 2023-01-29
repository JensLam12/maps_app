part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowingUser;
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
  final bool showMyRoute;

  const MapState({
    this.isMapInitialized = false, 
    this.isFollowingUser = true,
    final Map<String, Polyline>? polylines,
    final Map<String, Marker>? markers,
    this.showMyRoute = true
  }): polylines = polylines ?? const {},
      markers = markers ?? const {};

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
    bool? showMyRoute
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isFollowingUser: isFollowingUser ?? this.isFollowingUser,
    polylines: polylines ?? this.polylines,
    markers: markers ?? this.markers,
    showMyRoute: showMyRoute ?? this.showMyRoute
  );

  List<Object> get props => [ isMapInitialized, isFollowingUser, polylines, showMyRoute, markers ];
}
