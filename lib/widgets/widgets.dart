import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polyline/polyline.dart' as Poly;

import 'package:routes_app/bloc/map/map_bloc.dart';
import 'package:routes_app/bloc/my_location/my_location_bloc.dart';
import 'package:routes_app/bloc/search/search_bloc.dart';
import 'package:routes_app/helpers/helpers.dart';
import 'package:routes_app/models/location_info_response.dart';
import 'package:routes_app/models/route_response.dart';
import 'package:routes_app/models/search_result.dart';
import 'package:routes_app/search/search_destination.dart';
import 'package:routes_app/services/route_service.dart';

part 'location_btn.dart';
part 'my_route_btn.dart';
part 'follow_location_btn.dart';
part 'search_bar.dart';
part 'manual_marker.dart';
