import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:routes_app/models/search_response.dart';
import 'package:routes_app/models/search_result.dart';
import 'package:routes_app/services/route_service.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  // Note: Use to change the value of searchFieldLabel
  // @override
  // final String searchFieldLabel;
  final RouteService _routeService;
  final LatLng lastLocation;
  final List<SearchResult> history;

  SearchDestination(this.lastLocation, this.history)
      : this._routeService = RouteService();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => this.query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => this.close(context, SearchResult(canceled: true)),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return this._buildSugestionsResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.isEmpty) {
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Manual location'),
            onTap: () {
              this.close(
                  context,
                  SearchResult(
                    canceled: false,
                    manual: true,
                  ));
            },
          ),
          ...this
              .history
              .map((SearchResult e) => ListTile(
                    leading: Icon(Icons.history),
                    title: Text(e.name),
                    subtitle: Text(e.description),
                    onTap: () => this.close(context, e),
                  ))
              .toList(),
        ],
      );
    }
    return this._buildSugestionsResult();
  }

  Widget _buildSugestionsResult() {
    if (this.query.isEmpty) {
      return Container();
    }

    this
        ._routeService
        .getSugestionsByQuery(this.query.trim(), this.lastLocation);

    return StreamBuilder(
      stream: this._routeService.sugestionsStream,
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final List<Feature> places = snapshot.data.features;

        if (places.isEmpty) {
          return ListTile(
            title: Text('No results for: ${this.query}'),
          );
        }

        return ListView.separated(
          itemCount: places.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (_, int index) {
            final Feature place = places[index];
            return ListTile(
              leading: Icon(Icons.place),
              title: Text(place.text),
              subtitle: Text(place.placeName),
              onTap: () {
                this.close(
                    context,
                    SearchResult(
                      canceled: false,
                      manual: false,
                      location: LatLng(place.center[1], place.center[0]),
                      name: place.text,
                      description: place.placeName,
                    ));
              },
            );
          },
        );
      },
    );
  }
}
