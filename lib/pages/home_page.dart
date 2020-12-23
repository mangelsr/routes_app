import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:routes_app/bloc/map/map_bloc.dart';
import 'package:routes_app/bloc/my_location/my_location_bloc.dart';
import 'package:routes_app/widgets/widgets.dart';

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
      body: BlocBuilder<MyLocationBloc, MyLocationState>(
        builder: (_, MyLocationState state) => buildMap(state),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LocationBtn()
        ],
      ),
    );
  }

  Widget buildMap(MyLocationState state) {
    if (!state.haveLastLocation) return Center(child: Text('Locating...'));
    
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final initialPositon = CameraPosition(
      target: state.location,
      zoom: 15
    );
    return GoogleMap(
      initialCameraPosition: initialPositon,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: mapBloc.initMap,
    );
  }
}
