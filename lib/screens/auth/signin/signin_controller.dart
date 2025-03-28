import 'package:domain/model/request_model/sigin/signin_request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/auth/signin/signin_state.dart';
import 'package:domain/usecase/sigin/sigin_usecase.dart';
import 'package:domain/model/response_model/sigin_model/sigin_response_model.dart';

final signInScreenProvider =
    StateNotifierProvider.autoDispose<SignInController, SignInState>(
        (ref) => SignInController(signInUseCase: ref.read(signInUseCaseProvider)));

class SignInController extends StateNotifier<SignInState> {

  SignInUseCase signInUseCase;

  SignInController({required this.signInUseCase}) : super(SignInState.empty());

  updateShowPassword(bool value) {
    state = state.copyWith(showPassword: value);
  }

  Future<void> sigInUser()
  async{
    try{

      SignInRequestModel sigInRequestModel = SignInRequestModel();

      SignInResponseModel signInResponseModel = SignInResponseModel();

      final result = await signInUseCase.call(sigInRequestModel, signInResponseModel);


    }catch(error)
    {

    }
  }
}
