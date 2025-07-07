import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'digifit_card_exercise_details_state.dart';

final digifitCardExerciseDetailsControllerProvider = StateNotifierProvider.autoDispose<
    CardExerciseDetailsController, DigifitCardExerciseDetailsState>(
  (ref) => CardExerciseDetailsController(ref: ref),
);

class CardExerciseDetailsController
    extends StateNotifier<DigifitCardExerciseDetailsState> {
  final Ref ref;

  CardExerciseDetailsController({required this.ref})
      : super(DigifitCardExerciseDetailsState.initial());

  void updateCheckIconVisibility(bool isVisible) {
    state = state.copyWith(isCheckIconVisible: isVisible);
  }

  void updateIconBackgroundVisibility(bool iconBackgroundVisibility) {
    state = state.copyWith(isIconBackgroundVisible: iconBackgroundVisibility);
  }
}
