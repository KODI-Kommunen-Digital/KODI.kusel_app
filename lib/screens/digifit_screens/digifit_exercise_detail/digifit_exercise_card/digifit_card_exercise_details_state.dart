class DigifitCardExerciseDetailsState {
  final bool isLoading;
  final bool isCheckIconVisible;
  final bool isIconBackgroundVisible;

  DigifitCardExerciseDetailsState({
    required this.isLoading,
    required this.isCheckIconVisible,
    required this.isIconBackgroundVisible,
  });

  factory DigifitCardExerciseDetailsState.initial() {
    return DigifitCardExerciseDetailsState(
      isLoading: false,
      isCheckIconVisible: false,
      isIconBackgroundVisible: false,
    );
  }

  DigifitCardExerciseDetailsState copyWith({
    bool? isLoading,
    bool? isCheckIconVisible,
    bool? isIconBackgroundVisible,
  }) {
    return DigifitCardExerciseDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isCheckIconVisible: isCheckIconVisible ?? this.isCheckIconVisible,
      isIconBackgroundVisible:
          isIconBackgroundVisible ?? this.isIconBackgroundVisible,
    );
  }
}
