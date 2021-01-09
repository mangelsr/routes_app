part of 'widgets.dart';

class ManualMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (BuildContext context, SearchState state) {
      return state.manualSelection ? _BuildManualMarker() : Container();
    });
  }
}

class _BuildManualMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Back button
        Positioned(
          top: 70,
          left: 20,
          child: FadeInLeft(
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
                onPressed: () {
                  context.read<SearchBloc>().add(OnManualMarkerDeactivation());
                },
              ),
            ),
          ),
        ),

        Center(
          child: Transform.translate(
            offset: Offset(0, -25),
            child: BounceInDown(
              child: Icon(
                Icons.location_on,
                size: 50,
              ),
            ),
          ),
        ),

        // Confirm location button

        Positioned(
            bottom: 40,
            left: 40,
            child: FadeIn(
              child: MaterialButton(
                minWidth: width - 125,
                child: Text(
                  'Confirm destination',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.black,
                shape: StadiumBorder(),
                elevation: 0,
                splashColor: Colors.transparent,
                onPressed: () => this.getRoute(context),
              ),
            )),
      ],
    );
  }

  void getRoute(BuildContext context) async {
    loadingAler(context);

    final routeService = RouteService();
    final start = context.read<MyLocationBloc>().state.location;
    final end = context.read<MapBloc>().state.centralLocation;
    final RouteResponse result = await routeService.getRoute(start, end);
    final route = result.routes[0];

    // Get end point info
    final LocationInfoResponse info = await routeService.getLocationInfo(end);

    // Geometry decode
    final List<LatLng> points =
        Poly.Polyline.Decode(encodedString: route.geometry, precision: 6)
            .decodedCoords
            .map((List<double> e) => LatLng(e[0], e[1]))
            .toList();

    context.read<MapBloc>().add(OnDrawRoute(
          points,
          route.distance,
          route.duration,
          info.features.first.text,
        ));

    context.read<SearchBloc>().add(OnManualMarkerDeactivation());

    Navigator.of(context).pop();
  }
}
