part of 'map_bloc.dart';

@immutable
class MapState {
  final bool ready;
  final bool drawLine;
  final bool followLocation;
  final LatLng centralLocation;

  // Polylines
  final Map<String, Polyline> polyLines;
  final Map<String, Marker> markers;

  MapState({
    this.ready = false,
    this.drawLine = false,
    this.followLocation = false,
    this.centralLocation,
    Map<String, Polyline> polyLines,
    Map<String, Marker> markers,
  })  : this.polyLines = polyLines ?? Map(),
        this.markers = markers ?? Map();

  MapState copyWith({
    bool ready,
    bool drawLine,
    bool followLocation,
    LatLng centralLocation,
    Map<String, Polyline> polyLines,
    Map<String, Marker> markers,
  }) =>
      MapState(
        ready: ready ?? this.ready,
        drawLine: drawLine ?? this.drawLine,
        followLocation: followLocation ?? this.followLocation,
        centralLocation: centralLocation ?? this.centralLocation,
        polyLines: polyLines ?? this.polyLines,
        markers: markers ?? this.markers,
      );
}
