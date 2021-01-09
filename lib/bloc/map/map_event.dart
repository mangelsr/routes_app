part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class OnMapReady extends MapEvent {}

class OnToggleRoute extends MapEvent {}

class OnToggleFollow extends MapEvent {}

class OnMapMoved extends MapEvent {
  final LatLng location;
  OnMapMoved(this.location);
}

class OnLocationUpdated extends MapEvent {
  final LatLng location;
  OnLocationUpdated(this.location);
}

class OnDrawRoute extends MapEvent {
  final List<LatLng> route;
  final double distance;
  final double duration;
  final String destinyName;
  OnDrawRoute(this.route, this.distance, this.duration, this.destinyName);
}
