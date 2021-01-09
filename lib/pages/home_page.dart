import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:routes_app/bloc/map/map_bloc.dart';
import 'package:routes_app/bloc/my_location/my_location_bloc.dart';
import 'package:routes_app/widgets/widgets.dart';

import '../bloc/map/map_bloc.dart';
import '../bloc/my_location/my_location_bloc.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<MyLocationBloc>().startTracking();
    super.initState();
  }

  @override
  void dispose() {
    context.read<MyLocationBloc>().endTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MyLocationBloc, MyLocationState>(
            builder: (_, MyLocationState state) => buildMap(state),
          ),
          Positioned(
            top: 15,
            child: SearchBar(),
          ),
          ManualMarker(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LocationBtn(),
          FollowLocationBtn(),
          MyRouteBtn(),
        ],
      ),
    );
  }

  Widget buildMap(MyLocationState state) {
    if (!state.haveLastLocation) return Center(child: Text('Locating...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    mapBloc.add(OnLocationUpdated(state.location));

    final initialPositon = CameraPosition(target: state.location, zoom: 15);

    return BlocBuilder<MapBloc, MapState>(
        builder: (BuildContext context, MapState state) {
      return GoogleMap(
        initialCameraPosition: initialPositon,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: mapBloc.initMap,
        polylines: mapBloc.state.polyLines.values.toSet(),
        markers: mapBloc.state.markers.values.toSet(),
        onCameraMove: (CameraPosition cameraPosition) =>
            mapBloc.add(OnMapMoved(cameraPosition.target)),
      );
    });
  }
}
