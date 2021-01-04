part of 'search_bloc.dart';

@immutable
class SearchState {
  final bool manualSelection;
  final List<SearchResult> history;

  SearchState({
    this.manualSelection = false,
    List<SearchResult> history,
  }) : this.history = (history == null) ? [] : history;

  SearchState copyWith({bool manualSelection, List<SearchResult> history}) =>
      SearchState(
        manualSelection: manualSelection ?? this.manualSelection,
        history: history ?? this.history,
      );
}
