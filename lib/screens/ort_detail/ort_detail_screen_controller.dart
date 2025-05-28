import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/ort_detail/ort_detail_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/ort_detail/ort_detail_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/ort_detail/ort_detail_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_state.dart';

final ortDetailScreenControllerProvider = StateNotifierProvider.autoDispose<
        OrtDetailScreenController, OrtDetailScreenState>(
    (ref) => OrtDetailScreenController(
        ortDetailUseCase: ref.read(ortDetailUseCaseProvider),
        signInStatusController: ref.watch(signInStatusProvider.notifier),
      sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
      tokenStatus: ref.read(tokenStatusProvider),
      refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider)
    ));

class OrtDetailScreenController extends StateNotifier<OrtDetailScreenState> {
  OrtDetailUseCase ortDetailUseCase;
  SignInStatusController signInStatusController;
  SharedPreferenceHelper sharedPreferenceHelper;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;

  OrtDetailScreenController(
      {required this.ortDetailUseCase,
      required this.signInStatusController,
      required this.sharedPreferenceHelper,
      required this.tokenStatus,
      required this.refreshTokenUseCase})
      : super(OrtDetailScreenState.copyWith());

  Future<void> getOrtDetail({required String ortId}) async {
    try {
      state = state.copyWith(isLoading: true);

      state = state.copyWith(isLoading: true);

      final response = tokenStatus.isAccessTokenExpired();

      if (response) {
        final userId = sharedPreferenceHelper.getInt(userIdKey);
        RefreshTokenRequestModel requestModel =
        RefreshTokenRequestModel(userId: userId?.toString() ?? "");
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

        final refreshResponse =
        await refreshTokenUseCase.call(requestModel, responseModel);

        bool refreshSuccess = await refreshResponse.fold(
              (left) {
            debugPrint('refresh token add fav city fold exception : $left');
            return false;
          },
              (right) async {
            final res = right as RefreshTokenResponseModel;
            sharedPreferenceHelper.setString(
                tokenKey, res.data?.accessToken ?? "");
            sharedPreferenceHelper.setString(
                refreshTokenKey, res.data?.refreshToken ?? "");
            return true;
          },
        );

        if (!refreshSuccess) {
          state = state.copyWith(isLoading: false);
          return;
        }
      }

      OrtDetailRequestModel requestModel = OrtDetailRequestModel(ortId: ortId);
      OrtDetailResponseModel responseModel = OrtDetailResponseModel();

      final detailResponse = await ortDetailUseCase.call(requestModel, responseModel);

      detailResponse.fold((l) {
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

  void setIsFavoriteCity(bool isFavorite) {
    final ortDetailDataModel = state.ortDetailDataModel;
    if (ortDetailDataModel != null && ortDetailDataModel.isFavorite != null) {
      ortDetailDataModel.isFavorite = isFavorite;
      state = state.copyWith(ortDetailDataModel: ortDetailDataModel);
    }
  }
}
