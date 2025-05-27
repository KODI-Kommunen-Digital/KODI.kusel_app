import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/model/request_model/ort_detail/ort_detail_request_model.dart';
import 'package:domain/model/response_model/ort_detail/ort_detail_response_model.dart';
import 'package:domain/usecase/ort_detail/ort_detail_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_state.dart';

final ortDetailScreenControllerProvider = StateNotifierProvider.autoDispose<
        OrtDetailScreenController, OrtDetailScreenState>(
    (ref) => OrtDetailScreenController(
        ortDetailUseCase: ref.read(ortDetailUseCaseProvider),
        signInStatusController: ref.watch(signInStatusProvider.notifier)));

class OrtDetailScreenController extends StateNotifier<OrtDetailScreenState> {
  OrtDetailUseCase ortDetailUseCase;
  SignInStatusController signInStatusController;

  OrtDetailScreenController(
      {required this.ortDetailUseCase, required this.signInStatusController})
      : super(OrtDetailScreenState.copyWith());

  Future<void> getOrtDetail({required String ortId}) async {
    try {
      state = state.copyWith(isLoading: true);

      OrtDetailRequestModel requestModel = OrtDetailRequestModel(ortId: ortId);
      OrtDetailResponseModel responseModel = OrtDetailResponseModel();

      final result = await ortDetailUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get ort detail fold exception = ${l.toString()}');
        state = state.copyWith(isLoading: false);
      }, (r) {
        final res = r as OrtDetailResponseModel;

        state = state.copyWith(ortDetailDataModel: res.data, isLoading: false);
      });
    } catch (e) {
      debugPrint("get ort detail exception = $e");
      state = state.copyWith(isLoading: false);
    }
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isUserLoggedIn: status);
  }

  void updateOnFav(bool status) {
    final value = state.ortDetailDataModel;
    if (value != null && value.isFavorite != null) {
      value.isFavorite = status;
      state = state.copyWith(ortDetailDataModel: value);
    }
  }
}
