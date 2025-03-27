import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/search/search_screen_state.dart';

final searchScreenProvider =
StateNotifierProvider.autoDispose<SearchScreenProvider, SearchScreenState>(
        (ref) => SearchScreenProvider());

class SearchScreenProvider extends StateNotifier<SearchScreenState> {
  SearchScreenProvider() : super(SearchScreenState.empty());
}
