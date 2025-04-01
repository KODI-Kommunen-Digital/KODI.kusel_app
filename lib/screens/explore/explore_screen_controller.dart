import 'package:domain/model/empty_request.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/usecase/explore/explore_categories_usecase.dart';
import 'package:domain/model/response_model/categories_model/get_all_categories_response_model.dart';
import 'package:kusel/screens/explore/explore_screen_state.dart';

final exploreScreenProvider = StateNotifierProvider.autoDispose<
        ExploreScreenController, ExploreScreenState>(
    (ref) => ExploreScreenController(
        exploreCategoriesUseCase: ref.read(exploreCategoriesUseCaseProvider)));

class ExploreScreenController extends StateNotifier<ExploreScreenState> {
  ExploreCategoriesUseCase exploreCategoriesUseCase;

  ExploreScreenController({required this.exploreCategoriesUseCase})
      : super(ExploreScreenState.empty());

  Future<void> getCategories() async {
    try {
      state = state.copyWith(loading: true, error: "");

      EmptyRequest emptyRequest = EmptyRequest();

      GetAllCategoriesResponseModel getAllCategoriesResponseModel =
          GetAllCategoriesResponseModel();
      final result = await exploreCategoriesUseCase.call(
          emptyRequest, getAllCategoriesResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(loading: false, error: l.toString());
        },
        (r) {
          var categories = (r as GetAllCategoriesResponseModel).data;
          state = state.copyWith(exploreCategories: categories, loading: false);
        },
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }
}
