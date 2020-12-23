part of 'map_bloc.dart';

@immutable
class MapState {
  final bool ready;

  MapState({this.ready = false});

  MapState copyWith({bool ready}) => MapState(ready: ready ?? this.ready);
}
