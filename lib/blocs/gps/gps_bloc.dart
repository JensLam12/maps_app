import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;

  GpsBloc() : super( const GpsState( isGpsEnabled: false, isGPSPermissionGranted: false )) {
    
    on<onGPSAndPermissionEvent>((event, emit) => emit( state.copyWith(
      isGpsEnabled: event.isGpsEnabled, 
      isGPSPermissionGranted: event.isGPSPermissionGranted)
    ));

    _init();
  }

  Future<void> _init() async{
    final gpsInitialStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted()
    ]);

    add( onGPSAndPermissionEvent(
      isGpsEnabled: gpsInitialStatus[0], 
      isGPSPermissionGranted: gpsInitialStatus[1]
    ));
  }

  Future<bool> _checkGpsStatus() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();

    Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = event.index == 1 ? true : false;
      add( onGPSAndPermissionEvent(
        isGpsEnabled: isEnabled, 
        isGPSPermissionGranted: state.isGPSPermissionGranted
      ));
    });
    return isEnabled;
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();
    
    switch(status){
      case PermissionStatus.granted:
        add(onGPSAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled, 
          isGPSPermissionGranted: true
        ));
      break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        add(onGPSAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled, 
          isGPSPermissionGranted: true
        ));
        openAppSettings();
        break;
    }
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();
    return super.close();
  }
}
