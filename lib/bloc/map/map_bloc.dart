import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:routes_app/helpers/helpers.dart';

import 'package:routes_app/themes/map_theme.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState());

  GoogleMapController _mapController;

  //Polylines
  Polyline _myRoute = Polyline(
    polylineId: PolylineId('my_route'),
    width: 5,
    color: Colors.transparent,
  );

  Polyline _myDestinyRoute = Polyline(
    polylineId: PolylineId('my_destiny_route'),
    width: 5,
    color: Colors.black87,
  );

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
    } else if (event is OnLocationUpdated) {
      yield* this._onLocationUpdated(event);
    } else if (event is OnToggleRoute) {
      yield* this._onToggleRoute(event);
    } else if (event is OnToggleFollow) {
      yield* this._onToggleFollow(event);
    } else if (event is OnMapMoved) {
      yield this.state.copyWith(centralLocation: event.location);
    } else if (event is OnDrawRoute) {
      yield* this._onDrawRoute(event);
    }
  }

  Stream<MapState> _onLocationUpdated(OnLocationUpdated event) async* {
    if (state.followLocation) {
      this.moveCamera(event.location);
    }

    final List<LatLng> points = [...this._myRoute.points, event.location];
    this._myRoute = this._myRoute.copyWith(pointsParam: points);
    final currentPolylines = state.polyLines;
    currentPolylines['my_route'] = this._myRoute;
    yield state.copyWith(polyLines: currentPolylines);
  }

  Stream<MapState> _onToggleRoute(OnToggleRoute event) async* {
    if (!state.drawLine) {
      this._myRoute = this._myRoute.copyWith(colorParam: Colors.black87);
    } else {
      this._myRoute = this._myRoute.copyWith(colorParam: Colors.transparent);
    }
    final currentPolylines = state.polyLines;
    currentPolylines['my_route'] = this._myRoute;
    yield state.copyWith(
        drawLine: !state.drawLine, polyLines: currentPolylines);
  }

  Stream<MapState> _onToggleFollow(OnToggleFollow event) async* {
    if (!state.followLocation) {
      moveCamera(this._myRoute.points.last);
    }
    yield state.copyWith(followLocation: !state.followLocation);
  }

  Stream<MapState> _onDrawRoute(OnDrawRoute event) async* {
    this._myDestinyRoute = this._myDestinyRoute.copyWith(
          pointsParam: event.route,
        );

    final currentPolylines = state.polyLines;
    currentPolylines['my_destiny_route'] = this._myDestinyRoute;

    final double distanceInKm =
        (((event.distance / 1000) * 100).floor().toDouble()) / 100;

    // Start Icon
    // final BitmapDescriptor assetsIcon = await getAssetImageMarker();
    final BitmapDescriptor startIcon =
        await getStartMarkerIcon(event.duration.toInt());
    // final BitmapDescriptor networkIcon = await getNetworkImageMarker();
    final BitmapDescriptor endIcon =
        await getEndtMarkerIcon(event.destinyName, distanceInKm);

    //Markers
    final startMarker = Marker(
      markerId: MarkerId('start'),
      position: event.route.first,
      icon: startIcon,
      anchor: Offset(0.0, 1.0),
      infoWindow: InfoWindow(
        title: 'Start location',
        snippet: 'Trip time: ${(event.duration / 60).floor()} min',
      ),
    );

    final endMarker = Marker(
      markerId: MarkerId('end'),
      position: event.route.last,
      icon: endIcon,
      anchor: Offset(0.0, 0.8),
      infoWindow: InfoWindow(
        title: event.destinyName,
        snippet: 'Distance: $distanceInKm Km',
      ),
    );

    // final Map newMarkers = Map.from(state.markers);
    final Map<String, Marker> newMarkers = {...state.markers};
    newMarkers['start'] = startMarker;
    newMarkers['end'] = endMarker;

    Future.delayed(Duration(milliseconds: 300)).then((value) {
      // Can't open more than one InfoWindow at same time
      // _mapController.showMarkerInfoWindow(MarkerId('start'));
      // _mapController.showMarkerInfoWindow(MarkerId('end'));
    });

    yield state.copyWith(
      polyLines: currentPolylines,
      markers: newMarkers,
    );
  }
}
