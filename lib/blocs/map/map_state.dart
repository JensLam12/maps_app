part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowingUser;
  final Map<String, Polyline> polylines;
  final bool showMyRoute;

  const MapState({
    this.isMapInitialized = false, 
    this.isFollowingUser = true,
    final Map<String, Polyline>? polylines,
    this.showMyRoute = true
  }): polylines = polylines ?? const {};

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    Map<String, Polyline>? polylines,
    bool? showMyRoute
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isFollowingUser: isFollowingUser ?? this.isFollowingUser,
    polylines: polylines ?? this.polylines,
    showMyRoute: showMyRoute ?? this.showMyRoute
  );

  List<Object> get props => [ isMapInitialized, isFollowingUser, polylines, showMyRoute];
}
