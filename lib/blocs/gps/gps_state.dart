part of 'gps_bloc.dart';

class GpsState extends Equatable {
  final bool isGpsEnabled;
  final bool isGPSPermissionGranted;
  
  bool get isAllGranted => isGpsEnabled && isGPSPermissionGranted;

  const GpsState({
    required this.isGpsEnabled, 
    required this.isGPSPermissionGranted, 
  });

  GpsState copyWith({
    required isGpsEnabled,
    required isGPSPermissionGranted
  }) => GpsState(
    isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled, 
    isGPSPermissionGranted: isGPSPermissionGranted ?? this.isGPSPermissionGranted
  );
  
  @override
  List<Object> get props => [ isGpsEnabled, isGPSPermissionGranted];
}