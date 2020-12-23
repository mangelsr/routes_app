part of 'my_location_bloc.dart';

@immutable
class MyLocationState {
  final bool tracking;
  final bool haveLastLocation;
  final LatLng location;

  MyLocationState(
      {this.tracking = true, this.haveLastLocation = false, this.location});

  MyLocationState copyWith(
          {bool tracking, bool haveLastLocation, LatLng location}) =>
      MyLocationState(
          tracking: tracking ?? this.tracking,
          haveLastLocation: haveLastLocation ?? this.haveLastLocation,
          location: location ?? this.location);
}
