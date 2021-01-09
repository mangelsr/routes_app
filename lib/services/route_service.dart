import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:routes_app/helpers/debouncer.dart';
import 'package:routes_app/models/location_info_response.dart';
import 'package:routes_app/models/route_response.dart';
import 'package:routes_app/models/search_response.dart';

class RouteService {
  RouteService._privateConstructor();

  static final RouteService _instance = RouteService._privateConstructor();

  factory RouteService() {
    return _instance;
  }

  final _dio = Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 1000));
  final StreamController<SearchResponse> _sugestionsStreamController =
      StreamController<SearchResponse>.broadcast();

  Stream<SearchResponse> get sugestionsStream =>
      this._sugestionsStreamController.stream;

  final _BASE_URL_DIR = 'https://api.mapbox.com/directions/v5';
  final _BASE_URL_GEO = 'https://api.mapbox.com/geocoding/v5';
  final _API_KEY = 'YOUR API KEY HERE';

  Future<RouteResponse> getRoute(LatLng start, LatLng end) async {
    final coordsString =
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '${this._BASE_URL_DIR}/mapbox/driving/$coordsString';
    final response = await this._dio.get(url, queryParameters: {
      'alternatives': 'false',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this._API_KEY,
    });

    return RouteResponse.fromJson(response.data);
  }

  Future<SearchResponse> getQueryResult(String query, LatLng proximity) async {
    final url = '${this._BASE_URL_GEO}/mapbox.places/$query.json?';

    try {
      final response = await this._dio.get(url, queryParameters: {
        'access_token': this._API_KEY,
        'autocomplete': 'true',
        'proximity': '${proximity.longitude},${proximity.latitude}',
      });
      return searchResponseFromJson(response.data);
    } catch (e) {
      return SearchResponse(features: []);
    }
  }

  void getSugestionsByQuery(String query, LatLng proximity) {
    debouncer.value = '';
    debouncer.onValue = (String value) async {
      final results = await this.getQueryResult(value, proximity);
      this._sugestionsStreamController.add(results);
    };

    final timer = Timer.periodic(
        Duration(milliseconds: 200), (_) => debouncer.value = query);

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  Future<LocationInfoResponse> getLocationInfo(LatLng location) async {
    final coordsString = '${location.longitude},${location.latitude}';
    final url = '${this._BASE_URL_GEO}/mapbox.places/$coordsString.json';
    final response = await this._dio.get(url, queryParameters: {
      'access_token': this._API_KEY,
    });

    return locationInfoResponseFromJson(response.data);
  }
}
