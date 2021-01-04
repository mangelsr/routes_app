part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class OnManualMarkerActivation extends SearchEvent {}

class OnManualMarkerDeactivation extends SearchEvent {}

class OnAddHistory extends SearchEvent {
  final SearchResult searchResult;
  OnAddHistory(this.searchResult);
}
