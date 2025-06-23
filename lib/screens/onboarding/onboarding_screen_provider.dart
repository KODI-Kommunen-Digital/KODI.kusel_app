import 'dart:async';
import 'dart:convert';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/request_model/city_details/get_city_details_request_model.dart';
import 'package:domain/model/request_model/edit_user_detail/edit_user_detail_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Demographics_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Interests_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_type_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';
import 'package:domain/model/response_model/edit_user_detail/edit_user_detail_response_model.dart';
import 'package:domain/model/response_model/get_interests/get_interests_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_complete_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_details_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_demographics_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_interests_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_type_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/city_details/get_city_details_usecase.dart';
import 'package:domain/usecase/edit_user_detail/edit_user_detail_usecase.dart';
import 'package:domain/usecase/get_interests/get_interests_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_complete_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_detail_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_demographics_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_interests_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_type_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_state.dart';

import '../../common_widgets/get_current_location.dart';

final onboardingScreenProvider = StateNotifierProvider.autoDispose<
        OnboardingScreenController, OnboardingScreenState>(
    (ref) => OnboardingScreenController(
        onboardingUserTypeUseCase: ref.read(onboardingUserTypeUseCaseProvider),
        onboardingUserDemographicsUseCase:
            ref.read(onboardingUserDemographicsUseCaseProvider),
        onboardingUserInterestsUseCase:
            ref.read(onboardingUserInterestsUseCaseProvider),
        getCityDetailsUseCase: ref.read(getCityDetailsUseCaseProvider),
        getInterestsUseCase: ref.read(getInterestsUseCaseProvider),
        onboardingCompleteUseCase: ref.read(onboardingCompleteUseCaseProvider),
        onboardingDetailsUseCase: ref.read(onboardingDetailsUseCaseProvider),
        tokenStatus: ref.read(tokenStatusProvider),
        refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier),
        editUserDetailUseCase: ref.read(editUserDetailUseCaseProvider)));

class OnboardingScreenController extends StateNotifier<OnboardingScreenState> {
  OnboardingScreenController(
      {required this.onboardingUserTypeUseCase,
      required this.onboardingUserDemographicsUseCase,
      required this.onboardingUserInterestsUseCase,
      required this.getCityDetailsUseCase,
      required this.getInterestsUseCase,
      required this.onboardingCompleteUseCase,
      required this.onboardingDetailsUseCase,
      required this.tokenStatus,
      required this.refreshTokenUseCase,
      required this.sharedPreferenceHelper,
      required this.signInStatusController,
      required this.editUserDetailUseCase})
      : super(OnboardingScreenState.empty());
  OnboardingUserTypeUseCase onboardingUserTypeUseCase;
  OnboardingUserDemographicsUseCase onboardingUserDemographicsUseCase;
  OnboardingUserInterestsUseCase onboardingUserInterestsUseCase;
  GetCityDetailsUseCase getCityDetailsUseCase;
  GetInterestsUseCase getInterestsUseCase;
  OnboardingCompleteUseCase onboardingCompleteUseCase;
  OnboardingDetailsUseCase onboardingDetailsUseCase;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  PageController pageController = PageController();
  TextEditingController yourLocationEditingController = TextEditingController();
  GlobalKey<FormState> onboardingNameFormKey = GlobalKey<FormState>();
  SignInStatusController signInStatusController;
  EditUserDetailUseCase editUserDetailUseCase;

  Future<void> initialCall() async {
    state = state.copyWith(isLoading: true);
    isLoggedIn();
    initializerPageController();
    await Future.wait([
      updateCurrentCity(),
      fetchCities(),
      getInterests(),
    ]);
    state = state.copyWith(isLoading: false);
  }

  void initializerPageController() {
    pageController = PageController(
      initialPage: state.selectedPageIndex,
    );
  }

  void updateErrorMsgStatus(bool value) {
    state = state.copyWith(isErrorMsgVisible: value);
  }

  void updateOnboardingType(OnBoardingType onBoardingType) {
    final isResidentSelected = onBoardingType == OnBoardingType.resident;
    final alreadySelected =
        isResidentSelected ? state.isResident : state.isTourist;

    state = state.copyWith(
      isResident: isResidentSelected ? !alreadySelected : false,
      isTourist: !isResidentSelected ? !alreadySelected : false,
    );
  }

  Future<void> updateCurrentCity() async {
    String? userCurrentCity = await fetchCity();
    state = state.copyWith(userCurrentCity: userCurrentCity);
  }

  void updateOnboardingFamilyType(OnBoardingFamilyType onBoardingFamilyType) {
    bool alreadySelected;
    switch (onBoardingFamilyType) {
      case OnBoardingFamilyType.single:
        alreadySelected = state.isSingle;
        break;
      case OnBoardingFamilyType.withTwo:
        alreadySelected = state.isForTwo;
        break;
      case OnBoardingFamilyType.withMyFamily:
        alreadySelected = state.isWithFamily;
        break;
    }

    state = state.copyWith(
      isSingle: onBoardingFamilyType == OnBoardingFamilyType.single
          ? !alreadySelected
          : false,
      isForTwo: onBoardingFamilyType == OnBoardingFamilyType.withTwo
          ? !alreadySelected
          : false,
      isWithFamily: onBoardingFamilyType == OnBoardingFamilyType.withMyFamily
          ? !alreadySelected
          : false,
    );
  }

  void updateUserType(String value) {
    state = state.copyWith(resident: value);
  }

  Future<void> fetchCities() async {
    try {
      GetCityDetailsRequestModel requestModel =
          GetCityDetailsRequestModel(hasForum: false);
      GetCityDetailsResponseModel responseModel = GetCityDetailsResponseModel();
      final result =
          await getCityDetailsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get city details fold exception : $l');
      }, (r) async {
        final response = r as GetCityDetailsResponseModel;
        if (response.data != null) {
          final cityDetailsMap = <int, String>{};
          for (var city in response.data!) {
            if (city.id != null && city.name != null) {
              cityDetailsMap[city.id!] = city.name!;
            }
          }
          state = state.copyWith(
              residenceList: cityDetailsMap.values.toList(),
              cityDetailsMap: cityDetailsMap);
        }
      });
    } catch (error) {
      debugPrint('get city details exception : $error');
    }
  }

  Future<void> submitUserType() async {
    if (state.isTourist || state.isResident) {
      String userType = state.isResident ? "citizen" : "tourist";
      try {
        state = state.copyWith(loading: true);
        final response = tokenStatus.isAccessTokenExpired();
        if (response) {
          final userId = sharedPreferenceHelper.getInt(userIdKey);
          RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
          RefreshTokenRequestModel requestModel =
              RefreshTokenRequestModel(userId: userId?.toString() ?? "");
          final result =
              await refreshTokenUseCase.call(requestModel, responseModel);
          result.fold((l) {
            state = state.copyWith(loading: false);
          }, (right) async {
            final res = right as RefreshTokenResponseModel;
            sharedPreferenceHelper.setString(
                tokenKey, res.data?.accessToken ?? "");
            sharedPreferenceHelper.setString(
                refreshTokenKey, res.data?.refreshToken ?? "");

            OnboardingUserTypeRequestModel onboardingUserTypeRequestModel =
                OnboardingUserTypeRequestModel(userType: userType);
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
          });
        } else {
          OnboardingUserTypeRequestModel onboardingUserTypeRequestModel =
              OnboardingUserTypeRequestModel(userType: userType);
          OnboardingUserTypeResponseModel onboardingUserTypeResponseModel =
              OnboardingUserTypeResponseModel();
          final r = await onboardingUserTypeUseCase.call(
              onboardingUserTypeRequestModel, onboardingUserTypeResponseModel);
          r.fold((l) {
            debugPrint('update onboarding user type fold exception : $l');
          }, (r) async {
            final result = r as OnboardingUserTypeResponseModel;
          });
        }
      } catch (error) {
        debugPrint('update onboarding user type exception : $error');
      }
    }
  }

  Future<void> submitUserDemographics() async {
    String maritalStatus = state.isSingle
        ? "alone"
        : state.isForTwo
            ? "married"
            : "with_family";
    final accommodationPreference = <String>[
      if (state.isWithDog) "dog",
      if (state.isBarrierearm) "low_barrier",
    ];
    String cityName = state.resident ?? '';
    int cityId = getCityIdByName(state.cityDetailsMap, cityName) ?? 0;

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
          state = state.copyWith(loading: false);
        }, (right) async {
          final res = right as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");
          OnboardingUserDemographicsRequestModel
              onboardingUserDemographicsRequestModel =
              OnboardingUserDemographicsRequestModel(
                  maritalStatus: maritalStatus,
                  accommodationPreference: accommodationPreference,
                  cityId: cityId);
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
        });
      } else {
        OnboardingUserDemographicsRequestModel
            onboardingUserDemographicsRequestModel =
            OnboardingUserDemographicsRequestModel(
                maritalStatus: maritalStatus,
                accommodationPreference: accommodationPreference,
                cityId: cityId);
        OnboardingUserDemographicsResponseModel
            onboardingUserDemographicsResponseModel =
            OnboardingUserDemographicsResponseModel();
        final r = await onboardingUserDemographicsUseCase.call(
            onboardingUserDemographicsRequestModel,
            onboardingUserDemographicsResponseModel);
        r.fold((l) {
          debugPrint('update onboarding user demographics fold exception : $l');
        }, (r) async {
          final result = r as OnboardingUserDemographicsResponseModel;
        });
      }
    } catch (error) {
      debugPrint('update onboarding user demographics exception : $error');
    }
  }

  Future<void> submitUserInterests() async {
    try {
      Map<int, bool> interestSMap = state.interestsMap;
      List<int> interestIds = interestSMap.entries
          .where((interest) => interest.value)
          .map((interest) => interest.key)
          .toList();

      final response = tokenStatus.isAccessTokenExpired();
      if (response) {
        final userId = sharedPreferenceHelper.getInt(userIdKey);
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
        RefreshTokenRequestModel requestModel =
            RefreshTokenRequestModel(userId: userId?.toString() ?? "");
        final result =
            await refreshTokenUseCase.call(requestModel, responseModel);
        result.fold((l) {
          state = state.copyWith(loading: false);
        }, (right) async {
          final res = right as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");

          OnboardingUserInterestsRequestModel
              onboardingUserInterestsRequestModel =
              OnboardingUserInterestsRequestModel(interestIds: interestIds);
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
        });
      } else {
        OnboardingUserInterestsRequestModel
            onboardingUserInterestsRequestModel =
            OnboardingUserInterestsRequestModel(interestIds: interestIds);
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
    } catch (error) {
      debugPrint('update onboarding user interests exception : $error');
    }
  }

  Future<void> updateOnboardingSuccess() async {
    sharedPreferenceHelper.setBool(onboardingKey, true);
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
          state = state.copyWith(loading: false);
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

  bool isAllOptionFieldsCompleted() {
    bool martialStatusFilled =
        (!state.isSingle && !state.isForTwo && !state.isWithFamily);
    return martialStatusFilled;
  }

  void updateCompanionType(OnBoardingCompanionType onBoardingCompanionType) {
    switch (onBoardingCompanionType) {
      case OnBoardingCompanionType.withDog:
        state = state.copyWith(isWithDog: !state.isWithDog);
        break;
      case OnBoardingCompanionType.barrierearm:
        state = state.copyWith(isBarrierearm: !state.isBarrierearm);
        break;
    }
  }

  int? getCityIdByName(Map<int, String> cityMap, String cityName) {
    for (var entry in cityMap.entries) {
      if (entry.value == cityName) {
        return entry.key;
      }
    }
    return null;
  }

  void nextPage() {
    if (pageController.hasClients) {
      final nextPage = state.selectedPageIndex + 1;
      if (nextPage < 5) {
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void onBackPress() {
    if (pageController.hasClients) {
      final previousPage = state.selectedPageIndex - 1;
      if (previousPage >= 0) {
        pageController.animateToPage(
          previousPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void onSkipPress(VoidCallback onLastSkipPress) {
    if (!pageController.hasClients) return;
    final currentPage = state.selectedPageIndex;
    final nextPage = currentPage + 1;
    if (currentPage == 4) {
      onLastSkipPress();
    } else if (currentPage == 2) {
      pageController.animateToPage(
        nextPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else if (nextPage < 5) {
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void updateSelectedPageIndex(int index) {
    state = state.copyWith(selectedPageIndex: index);
  }

  Future<void> startLoadingTimer(Function() callBack) async {
    if (state.isLoggedIn) {
      await updateOnboardingSuccess();
    } else {
      saveCacheOnboardingData();
    }
    Future.delayed(const Duration(seconds: 2), () {
      callBack();
    });
  }

  Future<void> saveCacheOnboardingData() async {
    Map<int, bool> interestSMap = state.interestsMap;
    List<int> interestIds = interestSMap.entries
        .where((interest) => interest.value)
        .map((interest) => interest.key)
        .toList();

    String? userType;
    if (state.isTourist || state.isResident) {
      userType = state.isResident ? "citizen" : "tourist";
    }

    String maritalStatus = state.isSingle
        ? "alone"
        : state.isForTwo
            ? "married"
            : "with_family";
    final accommodationPreference = <String>[
      if (state.isWithDog) "dog",
      if (state.isBarrierearm) "low_barrier",
    ];
    String cityName = state.resident ?? '';
    int cityId = getCityIdByName(state.cityDetailsMap, cityName) ?? 0;

    OnboardingData onboardingData = OnboardingData(
        userType: userType,
        cityId: cityId,
        maritalStatus: maritalStatus,
        accommodationPreference: accommodationPreference,
        interests: interestIds,
        onBoarded: 1);
    sharedPreferenceHelper.saveObject(onboardingCacheKey, onboardingData);
  }

  Future<void> getInterests() async {
    try {
      EmptyRequest requestModel = EmptyRequest();
      GetInterestsResponseModel responseModel = GetInterestsResponseModel();
      final result =
          await getInterestsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get interests fold exception : $l');
      }, (r) async {
        final response = r as GetInterestsResponseModel;
        List<Interest>? interests = response.data;
        Map<int, bool> interestMap;
        if (interests != null) {
          interestMap = {
            for (var interest in interests)
              if (interest.id != null) interest.id!: false
          };
          state = state.copyWith(interestsMap: interestMap);
        }
        state = state.copyWith(interests: interests);
      });
    } catch (error) {
      debugPrint('get interests exception : $error');
    }
  }

  Future<void> getOnboardingDetails() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = tokenStatus.isAccessTokenExpired();
      debugPrint('Is token valid = $response');

      if (response) {
        final userId = sharedPreferenceHelper.getInt(userIdKey);
        RefreshTokenRequestModel requestModel =
            RefreshTokenRequestModel(userId: userId?.toString() ?? "");
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

        final refreshResponse =
            await refreshTokenUseCase.call(requestModel, responseModel);

        bool refreshSuccess = await refreshResponse.fold(
          (left) {
            debugPrint(
                'refresh token onboarding details fold exception : $left');
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

      EmptyRequest requestModel = EmptyRequest();
      OnboardingDetailsResponseModel responseModel =
          OnboardingDetailsResponseModel();
      final result =
          await onboardingDetailsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get onboarding details fold exception : $l');
      }, (r) async {
        final response = r as OnboardingDetailsResponseModel;
        if (response.data != null) {
          state =
              state.copyWith(onboardingData: response.data, isLoading: false);
          initializeOnboardingData();
        }
      });
    } catch (error) {
      debugPrint('get onboarding details exception : $error');
    }
  }

  void initializeOnboardingData() {
    // Update Name
    final userFistName = sharedPreferenceHelper.getString(userFirstNameKey);
    state = state.copyWith(userFirstName: userFistName);

    final onboardingData = state.onboardingData;
    if (onboardingData == null) return;

    // Handle user type
    state = onboardingData.userType == "tourist"
        ? state.copyWith(isTourist: true)
        : state.copyWith(isResident: true);

    // Handle marital status
    state = switch (onboardingData.maritalStatus) {
      "alone" => state.copyWith(isSingle: true),
      "married" => state.copyWith(isForTwo: true),
      _ => state.copyWith(isWithFamily: true),
    };

    // Handle accommodation preferences
    final accommodationPrefs = onboardingData.accommodationPreference ?? [];
    state = state.copyWith(
      isWithDog: accommodationPrefs.contains("dog"),
      isBarrierearm: accommodationPrefs.contains("low_barrier"),
    );

    // Updating city
    final cityDetailsMap = state.cityDetailsMap;
    String? city = cityDetailsMap[onboardingData.cityId];
    state = state.copyWith(resident: city);

    // Handle interests map
    final interestIdList = onboardingData.interests;

    for (final id in interestIdList ?? []) {
      updateInterestMap(id);
    }
  }

  void updateInterestMap(int? id) {
    if (id != null) {
      Map<int, bool> interestsMap = state.interestsMap;
      bool isSelected = interestsMap[id] ?? false;
      bool updatedIsSelectedValue = false;
      if (!isSelected) {
        updatedIsSelectedValue = true;
      }
      interestsMap[id] = updatedIsSelectedValue;
      state = state.copyWith(interestsMap: interestsMap);
    }
  }

  bool isOnboardingDone() {
    bool onBoardingStatus =
        sharedPreferenceHelper.getBool(onboardingKey) ?? false;
    bool isOnBoarded = onBoardingStatus == true;
    return isOnBoarded;
  }

  bool isOfflineOnboardingDone() {
    bool onBoardingStatus =
        sharedPreferenceHelper.getString(onboardingCacheKey) != null;
    return onBoardingStatus;
  }

  Future<void> isLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isLoggedIn: status);
  }

  void getOnboardingOfflineData() {
    final jsonOnboardingDataString = sharedPreferenceHelper
        .getString(onboardingCacheKey); // gets raw JSON string
    final Map<String, dynamic> jsonMap = jsonDecode(jsonOnboardingDataString!);
    final onboardingData = OnboardingData.fromJson(jsonMap);
    final userFistName = sharedPreferenceHelper.getString(userFirstNameKey);
    state = state.copyWith(
        onboardingData: onboardingData,
        userFirstName: userFistName,
        isLoading: false);
    initializeOnboardingData();
  }

  void updateFirstName(String value) {
    sharedPreferenceHelper.setString(userFirstNameKey, value);
    state = state.copyWith(userFirstName: value);
  }

  Future<void> editUserName(
      {required void Function() onSuccess,
      required void Function(String msg) onError}) async {
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
          debugPrint(
              'refresh token edit profile details fold exception : $left');
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
        state = state.copyWith(loading: false);
        return;
      }
    }

    EditUserDetailRequestModel editUserDetailRequestModel =
        EditUserDetailRequestModel();

    editUserDetailRequestModel.firstname = state.userFirstName;

    try {
      EditUserDetailsResponseModel editUserDetailsResponseModel =
          EditUserDetailsResponseModel();
      final result = await editUserDetailUseCase.call(
          editUserDetailRequestModel, editUserDetailsResponseModel);
      result.fold((l) {
        debugPrint(l.toString());
        onError(l.toString());
      }, (r) async {
        var resData = (r as EditUserDetailsResponseModel).status;
        debugPrint("Edit Api Result : $resData");

        onSuccess();
        debugPrint("Edit API Success");
      });
    } catch (error) {
      debugPrint(error.toString());
      onError("API Error - ${error.toString()}");
    }
  }
}

enum OnBoardingType { resident, tourist }

enum OnBoardingFamilyType { single, withTwo, withMyFamily }

enum OnBoardingCompanionType { withDog, barrierearm }
