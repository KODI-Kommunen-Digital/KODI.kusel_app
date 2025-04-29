import 'dart:convert';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/listings/search_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/listings_model/search_listings_response_model.dart';
import 'package:domain/usecase/search/search_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/search/search_screen_state.dart';

final searchScreenProvider =
    StateNotifierProvider.autoDispose<SearchScreenProvider, SearchScreenState>(
        (ref) => SearchScreenProvider(
            searchUseCase: ref.read(searchUseCaseProvider),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class SearchScreenProvider extends StateNotifier<SearchScreenState> {
  SearchScreenProvider(
      {required this.searchUseCase, required this.sharedPreferenceHelper})
      : super(SearchScreenState.empty());

  SearchUseCase searchUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;

  Future<List<Listing>> searchList({
    required String searchText,
    required void Function() success,
    required void Function(String message) error,
  }) async {
    try {
      SearchRequestModel searchRequestModel =
          SearchRequestModel(searchQuery: searchText);
      SearchListingsResponseModel searchListingsResponseModel =
          SearchListingsResponseModel();

      final result = await searchUseCase.call(
          searchRequestModel, searchListingsResponseModel);
      return result.fold(
        (l) {
          error(l.toString());
          return <Listing>[];
        },
        (r) {
          final listings = (r as SearchListingsResponseModel).data;
          success();
          return listings ?? <Listing>[];
        },
      );
    } catch (e) {
      error(e.toString());
      return <Listing>[];
    }
  }

  loadSavedListings() {
    final jsonString = sharedPreferenceHelper.getString(searchListKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    final savedList = jsonDecode(jsonString);
    state = state.copyWith(
        searchedList: (savedList as List).map((e) => Listing.fromJson(e)).toList());
    print(state.searchedList.length);

  }
}
