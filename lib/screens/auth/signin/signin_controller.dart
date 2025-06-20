import 'dart:convert';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Demographics_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Interests_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_type_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/request_model/sigin/signin_request_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_complete_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_details_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_demographics_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_interests_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_type_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/model/response_model/sigin_model/sigin_response_model.dart';
import 'package:domain/usecase/onboarding/onboarding_complete_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_demographics_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_interests_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_type_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:domain/usecase/sigin/sigin_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/auth/signin/signin_state.dart';

final signInScreenProvider =
    StateNotifierProvider.autoDispose<SignInController, SignInState>((ref) =>
        SignInController(
            signInUseCase: ref.read(signInUseCaseProvider),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
          tokenStatus: ref.read(tokenStatusProvider),
          refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
          onboardingUserTypeUseCase: ref.read(onboardingUserTypeUseCaseProvider),
            onboardingUserDemographicsUseCase: ref.read(onboardingUserDemographicsUseCaseProvider),
            onboardingUserInterestsUseCase: ref.read(onboardingUserInterestsUseCaseProvider),
            onboardingCompleteUseCase: ref.read(onboardingCompleteUseCaseProvider)
        ));

class SignInController extends StateNotifier<SignInState> {
  SignInUseCase signInUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;
  OnboardingUserTypeUseCase onboardingUserTypeUseCase;
  OnboardingUserDemographicsUseCase onboardingUserDemographicsUseCase;
  OnboardingUserInterestsUseCase onboardingUserInterestsUseCase;
  OnboardingCompleteUseCase onboardingCompleteUseCase;

  SignInController(
      {required this.signInUseCase,
      required this.sharedPreferenceHelper,
      required this.tokenStatus,
      required this.refreshTokenUseCase,
      required this.onboardingUserTypeUseCase,
      required this.onboardingUserDemographicsUseCase,
      required this.onboardingUserInterestsUseCase,
      required this.onboardingCompleteUseCase
      })
      : super(SignInState.empty());

  updateShowPassword(bool value) {
    state = state.copyWith(showPassword: value);
  }

  Future<void> sigInUser(
      {required String userName,
      required String password,
      required void Function() success,
      required void Function(String message) error}) async {
    try {
      state = state.copyWith(showLoading: true);
      SignInRequestModel sigInRequestModel =
          SignInRequestModel(username: userName, password: password);

      SignInResponseModel signInResponseModel = SignInResponseModel();

      final result =
          await signInUseCase.call(sigInRequestModel, signInResponseModel);

      result.fold((l) {
        state = state.copyWith(showLoading: false);
        error(l.toString());
        debugPrint('sign in user fold Exception = $l');
      }, (r) {
        state = state.copyWith(showLoading: false);
        final response = (r as SignInResponseModel);

        if (response.data != null) {
          final userId = response.data?.userId ?? 0;
          final token = response.data?.accessToken ?? "";
          final refreshToken = response.data?.refreshToken ?? "";
          final isOnboardingComplete = response.data?.isOnBoarded ?? false;

          sharedPreferenceHelper.setString(refreshTokenKey, refreshToken);
          sharedPreferenceHelper.setString(tokenKey, token);
          sharedPreferenceHelper.setInt(userIdKey, userId);
          sharedPreferenceHelper.setString(
              onboardingKey, isOnboardingComplete.toString());
          success();
        }
      });
    } catch (error) {
      state = state.copyWith(showLoading: false);
      debugPrint(' Exception = $error');
    }
  }

  Future<bool> isOnboardingDone() async {
    String onBoardingStatus =
        sharedPreferenceHelper.getString(onboardingKey) ?? "false";
    bool isOnBoarded = onBoardingStatus == 'true';
    if(!isOnBoarded && isOnboardingCacheAvailable()){
      await syncOnboardingDataWithNetwork();
      isOnBoarded = true;
    }
    return isOnBoarded;
  }

  Future<void> syncOnboardingDataWithNetwork() async {
    state = state.copyWith(showLoading: true);
    final jsonOnboardingDataString = sharedPreferenceHelper.getString(onboardingCacheKey); // gets raw JSON string
    if (jsonOnboardingDataString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonOnboardingDataString);
      final onboardingData = OnboardingData.fromJson(jsonMap);

      try {
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
              debugPrint('refresh token municipality detail fold exception : $left');
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
            // state = state.copyWith(isLoading: false);
            return;
          }
        }
        updateOnboardingUserType(onboardingData);
        updateOnboardingUserDemographics(onboardingData);
        updateOnboardingUserInterests(onboardingData);
        updateOnboardingSuccess();
        state = state.copyWith(showLoading: false);
      } catch (error) {
        debugPrint('update onboarding user type exception : $error');
      }

    }
  }

  Future<void> updateOnboardingUserType(OnboardingData onboardingData) async {
    OnboardingUserTypeRequestModel onboardingUserTypeRequestModel =
    OnboardingUserTypeRequestModel(userType: onboardingData.userType);
    OnboardingUserTypeResponseModel onboardingUserTypeResponseModel =
    OnboardingUserTypeResponseModel();
    final r = await onboardingUserTypeUseCase.call(
        onboardingUserTypeRequestModel,
        onboardingUserTypeResponseModel);
    r.fold((l) {
      debugPrint('update onboarding user type fold exception : $l');
    }, (r) async {
      final result = r as OnboardingUserTypeResponseModel;
    });
  }

  Future<void> updateOnboardingUserDemographics(OnboardingData onboardingData) async {
    OnboardingUserDemographicsRequestModel
    onboardingUserDemographicsRequestModel =
    OnboardingUserDemographicsRequestModel(
        maritalStatus: onboardingData.maritalStatus,
        accommodationPreference: onboardingData.accommodationPreference,
        cityId: onboardingData.cityId);
    OnboardingUserDemographicsResponseModel
    onboardingUserDemographicsResponseModel =
    OnboardingUserDemographicsResponseModel();
    final r = await onboardingUserDemographicsUseCase.call(
        onboardingUserDemographicsRequestModel,
        onboardingUserDemographicsResponseModel);
    r.fold((l) {
      debugPrint(
          'update onboarding user demographics fold exception : $l');
    }, (r) async {
      final result = r as OnboardingUserDemographicsResponseModel;
    });
  }

  Future<void> updateOnboardingUserInterests(OnboardingData onboardingData) async {
    OnboardingUserInterestsRequestModel
    onboardingUserInterestsRequestModel =
    OnboardingUserInterestsRequestModel(interestIds: onboardingData.interests);
    OnboardingUserInterestsResponseModel
    onboardingUserInterestsResponseModel =
    OnboardingUserInterestsResponseModel();
    final r = await onboardingUserInterestsUseCase.call(
        onboardingUserInterestsRequestModel,
        onboardingUserInterestsResponseModel);
    r.fold((l) {
      debugPrint('update onboarding user interests fold exception : $l');
    }, (r) async {
      final result = r as OnboardingUserInterestsResponseModel;
    });
  }

  Future<void> updateOnboardingSuccess() async {
    sharedPreferenceHelper.setString(onboardingKey, "true");
    try {
      final response = tokenStatus.isAccessTokenExpired();
      if (response) {
        final userId = sharedPreferenceHelper.getInt(userIdKey);
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
        RefreshTokenRequestModel requestModel =
        RefreshTokenRequestModel(userId: userId?.toString() ?? "");
        final result =
        await refreshTokenUseCase.call(requestModel, responseModel);
        result.fold((l) {
          // state = state.copyWith(loading: false);
        }, (right) async {
          final res = right as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");
          EmptyRequest requestModel = EmptyRequest();
          OnboardingCompleteResponseModel responseModel =
          OnboardingCompleteResponseModel();
          final r =
          await onboardingCompleteUseCase.call(requestModel, responseModel);
          r.fold((l) {
            debugPrint('onboarding complete fold exception : $l');
          }, (r) async {
            final result = r as OnboardingCompleteResponseModel;
          });
        });
      } else {
        EmptyRequest requestModel = EmptyRequest();
        OnboardingCompleteResponseModel responseModel =
        OnboardingCompleteResponseModel();
        final r =
        await onboardingCompleteUseCase.call(requestModel, responseModel);
        r.fold((l) {
          debugPrint('onboarding complete fold exception : $l');
        }, (r) async {
          final result = r as OnboardingCompleteResponseModel;
        });
      }
    } catch (error) {
      debugPrint('onboarding complete exception : $error');
    }
  }


  bool isOnboardingCacheAvailable() {
    bool value = sharedPreferenceHelper.getString(onboardingCacheKey)!=null;
    return value;
  }
}
