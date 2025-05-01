class FeedbackScreenState {
  String title;
  String description;
  bool loading;

  FeedbackScreenState(this.title, this.description, this.loading);

  factory FeedbackScreenState.empty() {
    return FeedbackScreenState('', '', false);
  }

  FeedbackScreenState copyWith(
      {String? title, String? description, bool? loading}) {
    return FeedbackScreenState(title ?? this.title,
        description ?? this.description, loading ?? this.loading);
  }
}
