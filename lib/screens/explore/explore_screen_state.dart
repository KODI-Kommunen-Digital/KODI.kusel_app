import 'package:domain/model/response_model/categories_model/get_all_categories_response_model.dart';

class ExploreScreenState {
  bool? loading;
  String? error;
  String? status;
  final List<Category> exploreCategories;

  ExploreScreenState(
      {required this.exploreCategories,
        required this.status,
        this.error,
        this.loading});

  factory ExploreScreenState.empty() {
    return ExploreScreenState(
        exploreCategories: [], status: "", loading: false, error: "");
  }

  ExploreScreenState copyWith(
      {String? status,
        List<Category>? exploreCategories,
        bool? loading,
        String? error}) {
    return ExploreScreenState(
        status: status ?? this.status,
        loading: loading ?? this.loading,
        error: error ?? this.error,
        exploreCategories: exploreCategories ?? this.exploreCategories);
  }
}
