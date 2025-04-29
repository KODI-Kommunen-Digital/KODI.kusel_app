class SignInStatusState {
  bool isSignupButtonVisible;

  SignInStatusState(this.isSignupButtonVisible);

  factory SignInStatusState.empty() {
    return SignInStatusState(true);
  }

  SignInStatusState copyWith({
    bool? isSignupButtonVisible,
  }) {
    return SignInStatusState(
        isSignupButtonVisible ?? this.isSignupButtonVisible);
  }
}
