class SignUpState {
  bool showPassword;

  SignUpState(this.showPassword);

  factory SignUpState.empty() {
    return SignUpState(false);
  }

  SignUpState copyWith({bool? showPassword}) {
    return SignUpState(showPassword ?? this.showPassword);
  }
}
