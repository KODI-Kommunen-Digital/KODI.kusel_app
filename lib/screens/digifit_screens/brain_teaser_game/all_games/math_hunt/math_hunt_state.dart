import 'package:domain/model/response_model/digifit/brain_teaser_game/math_hunt_response_model.dart';

class BrainTeaserGameMathHuntState {
  final bool isLoading;
  final String? errorMessage;
  final MathHuntDataModel? mathHuntDataModel;

  BrainTeaserGameMathHuntState({
    required this.isLoading,
    required this.errorMessage,
    required this.mathHuntDataModel,
  });

  factory BrainTeaserGameMathHuntState.empty() {
    return BrainTeaserGameMathHuntState(
      isLoading: false,
      errorMessage: null,
      mathHuntDataModel: null,
    );
  }

  BrainTeaserGameMathHuntState copyWith({
    bool? isLoading,
    String? errorMessage,
    MathHuntDataModel? mathHuntDataModel,
  }) {
    return BrainTeaserGameMathHuntState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      mathHuntDataModel: mathHuntDataModel ?? this.mathHuntDataModel,
    );
  }
}
