import 'package:domain/model/response_model/categories_model/get_all_categories_response_model.dart';

class ExploreScreenState {
  String status;
  final List<Category> exploreCategories;

  ExploreScreenState({required this.exploreCategories, required this.status});

  factory ExploreScreenState.empty() {
    return ExploreScreenState(exploreCategories: [], status: "");
  }

  ExploreScreenState copyWith(
      {String? status, List<Category>? exploreCategories}) {
    return ExploreScreenState(
        status: this.status, exploreCategories: exploreCategories ?? this.exploreCategories);
  }
}
