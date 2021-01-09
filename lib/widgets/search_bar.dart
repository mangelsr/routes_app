part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (BuildContext context, SearchState state) {
      return state.manualSelection ? Container() : buildSearchBar(context);
    });
  }

  Widget buildSearchBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return FadeInDown(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: width,
          child: GestureDetector(
            onTap: () async {
              final LatLng lastLocation =
                  context.read<MyLocationBloc>().state.location;
              final List<SearchResult> history =
                  context.read<SearchBloc>().state.history;
              final SearchResult result = await showSearch(
                  context: context,
                  delegate: SearchDestination(lastLocation, history));
              this.searchResult(context, result);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              width: double.infinity,
              child: Text(
                'Where to go?',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void searchResult(BuildContext context, SearchResult result) async {
    if (result.canceled) return;
    if (result.manual) {
      context.read<SearchBloc>().add(OnManualMarkerActivation());
      return;
    }

    loadingAler(context);

    final RouteService routeService = RouteService();
    final MapBloc mapBloc = context.read<MapBloc>();
    final LatLng start = context.read<MyLocationBloc>().state.location;
    final LatLng end = result.location;

    final routeResponse = await routeService.getRoute(start, end);
    final route = routeResponse.routes[0];

    final List<LatLng> points =
        Poly.Polyline.Decode(encodedString: route.geometry, precision: 6)
            .decodedCoords
            .map((List<double> e) => LatLng(e[0], e[1]))
            .toList();

    mapBloc.add(OnDrawRoute(
      points,
      route.distance,
      route.duration,
      result.name,
    ));

    Navigator.of(context).pop();

    context.read<SearchBloc>().add(OnAddHistory(result));
  }
}
