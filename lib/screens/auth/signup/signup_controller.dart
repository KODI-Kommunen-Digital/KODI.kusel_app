import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/auth/signup/signup_state.dart';

final signUpScreenProvider =
    StateNotifierProvider.autoDispose<SignUpController, SignUpState>(
        (ref) => SignUpController());

class SignUpController extends StateNotifier<SignUpState> {

  SignUpController() : super(SignUpState.empty()) ;


}
