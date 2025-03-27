class SignInState {
  bool showPassword;

  SignInState(this.showPassword);

  factory SignInState.empty() {
    return SignInState(false);
  }

  SignInState copyWith({bool? showPassword}) {
    return SignInState(showPassword ?? this.showPassword);
  }
}
