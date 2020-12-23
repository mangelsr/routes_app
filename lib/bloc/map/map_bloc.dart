import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

import 'package:routes_app/themes/map_theme.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState());

  GoogleMapController _mapController;

  void initMap(GoogleMapController controller) {
    if (!state.ready) {
      this._mapController = controller;
      this._mapController.setMapStyle(jsonEncode(mapTheme));
      add(OnMapReady());
    }
  }

  void moveCamera(LatLng destiny) {
    final cameraUpdate = CameraUpdate.newLatLng(destiny);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is OnMapReady) {
      yield state.copyWith(ready: true);
    }
  }
}
