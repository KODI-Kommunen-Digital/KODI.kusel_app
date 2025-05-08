import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/explore/explore_state.dart';

final exploreControllerProvider =
StateNotifierProvider.autoDispose<ExploreController, ExploreState>(
        (ref) => ExploreController());

class ExploreController extends StateNotifier<ExploreState> {
  ExploreController() : super(ExploreState.empty());

  initialCall({required List<String> exploreTypeList, required List<
      String> exploreTypeListImage})async {
    state = state.copyWith(exploreTypeList: exploreTypeList,
        exploreTypeListImages: exploreTypeListImage);
  }

}
