import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchResult {
  final bool canceled;
  final bool manual;
  final LatLng location;
  final String name;
  final String description;

  SearchResult({
    @required this.canceled,
    this.manual,
    this.location,
    this.name,
    this.description,
  });
}
