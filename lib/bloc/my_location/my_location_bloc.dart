import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

part 'my_location_event.dart';
part 'my_location_state.dart';

class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState> {
  MyLocationBloc() : super(MyLocationState());

  StreamSubscription<Position> _positionSubscription;

  void startTracking() {
    this._positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10
    ).listen((Position position) {
      final newLocation = LatLng(position.latitude, position.longitude);
      add(OnLocationChange(newLocation));
    });
  }

  void endTracking() {
    this._positionSubscription?.cancel();
  }

  @override
  Stream<MyLocationState> mapEventToState(MyLocationEvent event) async* {
    if (event is OnLocationChange) {
      yield state.copyWith(
        haveLastLocation: true,
        location: event.newLocation
      );
    }
  }
}
