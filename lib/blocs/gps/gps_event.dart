part of 'gps_bloc.dart';

abstract class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object> get props => [];
}

class onGPSAndPermissionEvent extends GpsEvent {
  final bool isGpsEnabled;
  final bool isGPSPermissionGranted;

  onGPSAndPermissionEvent({
    required this.isGpsEnabled,
    required this.isGPSPermissionGranted
  });
}