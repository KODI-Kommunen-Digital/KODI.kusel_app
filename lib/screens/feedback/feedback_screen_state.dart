class FeedbackScreenState {
  String title;
  String description;
  bool isChecked;
  bool loading;

  FeedbackScreenState(
      this.title, this.description, this.isChecked, this.loading);

  factory FeedbackScreenState.empty() {
    return FeedbackScreenState('', '', false, false);
  }

  FeedbackScreenState copyWith(
      {String? title, String? description, bool? isChecked, bool? loading}) {
    return FeedbackScreenState(
        title ?? this.title,
        description ?? this.description,
        isChecked ?? this.isChecked,
        loading ?? this.loading);
  }
}
