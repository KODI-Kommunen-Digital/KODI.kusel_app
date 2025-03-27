import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/auth/signup/signup_state.dart';

final signUpScreenProvider =
StateNotifierProvider.autoDispose<SignUpController, SignUpState>(
        (ref) => SignUpController());


class SignUpController extends StateNotifier<SignUpState> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController userNameTextEditingController = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey();
  SignUpController() : super(SignUpState.empty());
}
