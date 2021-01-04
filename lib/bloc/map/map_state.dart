part of 'map_bloc.dart';

@immutable
class MapState {
  final bool ready;
  final bool drawLine;
  final bool followLocation;
  final LatLng centralLocation;

  // Polylines
  final Map<String, Polyline> polyLines;

  MapState(
      {this.ready = false,
      this.drawLine = false,
      this.followLocation = false,
      this.centralLocation,
      Map<String, Polyline> polyLines})
      : this.polyLines = polyLines ?? Map();

  MapState copyWith(
          {bool ready,
          bool drawLine,
          bool followLocation,
          LatLng centralLocation,
          Map<String, Polyline> polyLines}) =>
      MapState(
        ready: ready ?? this.ready,
        drawLine: drawLine ?? this.drawLine,
        followLocation: followLocation ?? this.followLocation,
        centralLocation: centralLocation ?? this.centralLocation,
        polyLines: polyLines ?? this.polyLines,
      );
}
