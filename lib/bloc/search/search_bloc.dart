import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:routes_app/models/search_result.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is OnManualMarkerActivation) {
      yield state.copyWith(manualSelection: true);
    } else if (event is OnManualMarkerDeactivation) {
      yield state.copyWith(manualSelection: false);
    } else if (event is OnAddHistory) {
      final bool exist = state.history.any(
          (SearchResult element) => element.name == event.searchResult.name);
      if (!exist) {
        yield state.copyWith(history: [...state.history, event.searchResult]);
      }
    }
  }
}
