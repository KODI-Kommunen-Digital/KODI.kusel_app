import 'dart:async';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/response_model/get_interests/get_interests_response_model.dart';
import 'package:domain/usecase/get_interests/get_interests_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_interests_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_state.dart';
import 'package:domain/usecase/onboarding/onboarding_user_type_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_demographics_usecase.dart';
import 'package:domain/model/request_model/city_details/get_city_details_request_model.dart';
import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';
import 'package:domain/usecase/city_details/get_city_details_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_complete_usecase.dart';
import 'dart:convert';

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
        onboardingCompleteUseCase:
            ref.read(onboardingCompleteUseCaseProvider),
      tokenStatus: ref.read(tokenStatusProvider),
      refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
      sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)
    )
);

class OnboardingScreenController extends StateNotifier<OnboardingScreenState> {
  OnboardingScreenController(
      {required this.onboardingUserTypeUseCase,
      required this.onboardingUserDemographicsUseCase,
      required this.onboardingUserInterestsUseCase,
      required this.getCityDetailsUseCase,
      required this.getInterestsUseCase,
        required this.onboardingCompleteUseCase,
        required this.tokenStatus,
        required this.refreshTokenUseCase,
        required this.sharedPreferenceHelper
      })
      : super(OnboardingScreenState.empty());
  OnboardingUserTypeUseCase onboardingUserTypeUseCase;
  OnboardingUserDemographicsUseCase onboardingUserDemographicsUseCase;
  OnboardingUserInterestsUseCase onboardingUserInterestsUseCase;
  GetCityDetailsUseCase getCityDetailsUseCase;
  GetInterestsUseCase getInterestsUseCase;
  OnboardingCompleteUseCase onboardingCompleteUseCase;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  PageController pageController = PageController();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController yourLocationEditingController = TextEditingController();
  GlobalKey<FormState> onboardingNameFormKey = GlobalKey<FormState>();

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

        final cityDetailsMap = <int, String>{};

        if (response.data != null) {
          for (var city in response.data!) {
            if (city.id != null && city.name != null) {
              cityDetailsMap[city.id!] = city.name!;
            }
          }
        }
        state = state.copyWith(
            residenceList: cityDetailsMap.values.toList(),
            cityDetailsMap: cityDetailsMap);
      });
    } catch (error) {
      debugPrint('get city details exception : $error');
    }
  }

  Future<void> submitUserType() async {
    if(state.isTourist || state.isResident) {
      String userType = state.isResident ? "citizen" : "tourist";

      Map<String, dynamic>? userInfo = getMapFromSharedPref() as Map<String, dynamic>?;
      Map<String, dynamic> updatedUserInfo = {
        "userType": userType,
      };
      if(userInfo!=null){
        userInfo.addAll(updatedUserInfo);
        storeMapInSharedPref(userInfo);
      } else {
        storeMapInSharedPref(updatedUserInfo);
      }

      // try {
      //   state = state.copyWith(loading: true);
      //   final response = tokenStatus.isAccessTokenExpired();
      //   if(response){
      //     final userId = sharedPreferenceHelper.getInt(userIdKey);
      //     RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
      //     RefreshTokenRequestModel requestModel =
      //     RefreshTokenRequestModel(userId: userId?.toString() ?? "");
      //     final result =
      //     await refreshTokenUseCase.call(requestModel, responseModel);
      //     result.fold((l) {
      //       state = state.copyWith(loading: false);
      //     }, (right) async {
      //       final res = right as RefreshTokenResponseModel;
      //       sharedPreferenceHelper.setString(
      //           tokenKey, res.data?.accessToken ?? "");
      //       sharedPreferenceHelper.setString(
      //           refreshTokenKey, res.data?.refreshToken ?? "");
      //
      //       OnboardingUserTypeRequestModel onboardingUserTypeRequestModel =
      //       OnboardingUserTypeRequestModel(userType: userType);
      //       OnboardingUserTypeResponseModel onboardingUserTypeResponseModel =
      //       OnboardingUserTypeResponseModel();
      //       final r = await onboardingUserTypeUseCase.call(
      //           onboardingUserTypeRequestModel, onboardingUserTypeResponseModel);
      //       r.fold((l) {
      //         debugPrint('update onboarding user type fold exception : $l');
      //       }, (r) async {
      //         final result = r as OnboardingUserTypeResponseModel;
      //       });
      //     });
      //   } else {
      //
      //     OnboardingUserTypeRequestModel onboardingUserTypeRequestModel =
      //     OnboardingUserTypeRequestModel(userType: userType);
      //     OnboardingUserTypeResponseModel onboardingUserTypeResponseModel =
      //     OnboardingUserTypeResponseModel();
      //     final r = await onboardingUserTypeUseCase.call(
      //         onboardingUserTypeRequestModel, onboardingUserTypeResponseModel);
      //     r.fold((l) {
      //       debugPrint('update onboarding user type fold exception : $l');
      //     }, (r) async {
      //       final result = r as OnboardingUserTypeResponseModel;
      //     });
      //   }
      // } catch (error) {
      //   debugPrint('update onboarding user type exception : $error');
      // }
    }
  }

  Future<void> submitUserDemographics()  async {
    if(isAllOptionFieldsCompleted()){
      String maritalStatus = state.isSingle
          ? "alone"
          : state.isForTwo
          ? "married"
          : "with_family";
      String accommodationPreference = state.isWithDog ? "dog" : "low_barrier";
      String cityName = state.resident ?? '';
      int cityId = getCityIdByName(state.cityDetailsMap, cityName) ?? 0;
      Map<String, dynamic>? userInfo = getMapFromSharedPref() as Map<String, dynamic>?;
      Map<String, dynamic> updatedUserInfo = {
        "name" : state.userName,
        "userDemographics": maritalStatus,
        "accommodationPreference" : accommodationPreference,
      };
      if(userInfo!=null){
        userInfo.addAll(updatedUserInfo);
        storeMapInSharedPref(userInfo);
      } else {
        storeMapInSharedPref(updatedUserInfo);
      }

      userInfo = getMapFromSharedPref() as Map<String, dynamic>?;
      if(userInfo!=null){
        print("Onboarding data - ${userInfo}");
      } else {
        print("Onboarding data is null - ${userInfo}");
      }

      // final userMap = await getMapFromSharedPref();
      // if (userMap != null) {
      //   print("User name: ${userMap['name']}");
      // }
      // Todo - Need to do API call
      // try {
      //   final response = tokenStatus.isAccessTokenExpired();
      //
      //   if(response){
      //     final userId = sharedPreferenceHelper.getInt(userIdKey);
      //     RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
      //     RefreshTokenRequestModel requestModel =
      //     RefreshTokenRequestModel(userId: userId?.toString() ?? "");
      //     final result =
      //     await refreshTokenUseCase.call(requestModel, responseModel);
      //     result.fold((l) {
      //       state = state.copyWith(loading: false);
      //     }, (right) async {
      //       final res = right as RefreshTokenResponseModel;
      //       sharedPreferenceHelper.setString(
      //           tokenKey, res.data?.accessToken ?? "");
      //       sharedPreferenceHelper.setString(
      //           refreshTokenKey, res.data?.refreshToken ?? "");
      //       OnboardingUserDemographicsRequestModel
      //       onboardingUserDemographicsRequestModel =
      //       OnboardingUserDemographicsRequestModel(
      //           maritalStatus: maritalStatus,
      //           accommodationPreference: accommodationPreference,
      //           cityId: cityId);
      //       OnboardingUserDemographicsResponseModel
      //       onboardingUserDemographicsResponseModel =
      //       OnboardingUserDemographicsResponseModel();
      //       final r = await onboardingUserDemographicsUseCase.call(
      //           onboardingUserDemographicsRequestModel,
      //           onboardingUserDemographicsResponseModel);
      //       r.fold((l) {
      //         debugPrint('update onboarding user demographics fold exception : $l');
      //       }, (r) async {
      //         final result = r as OnboardingUserDemographicsResponseModel;
      //       });
      //     });
      //   } else {
      //     OnboardingUserDemographicsRequestModel
      //     onboardingUserDemographicsRequestModel =
      //     OnboardingUserDemographicsRequestModel(
      //         maritalStatus: maritalStatus,
      //         accommodationPreference: accommodationPreference,
      //         cityId: cityId);
      //     OnboardingUserDemographicsResponseModel
      //     onboardingUserDemographicsResponseModel =
      //     OnboardingUserDemographicsResponseModel();
      //     final r = await onboardingUserDemographicsUseCase.call(
      //         onboardingUserDemographicsRequestModel,
      //         onboardingUserDemographicsResponseModel);
      //     r.fold((l) {
      //       debugPrint('update onboarding user demographics fold exception : $l');
      //     }, (r) async {
      //       final result = r as OnboardingUserDemographicsResponseModel;
      //     });
      //   }
      // } catch (error) {
      //   debugPrint('update onboarding user demographics exception : $error');
      // }
    }
  }

  Future<void> submitUserInterests() async {
    try {
      Map<int, bool> interestSMap = state.interestsMap;
      List<int> interestIds = interestSMap.entries
          .where((interest) => interest.value)
          .map((interest) => interest.key)
          .toList();
      String interestString = interestIds.join(',');

      Map<String, dynamic>? userInfo = getMapFromSharedPref() as Map<String, dynamic>?;
      Map<String, dynamic> updatedUserInfo = {
        "interestString": interestString,
      };
      if(userInfo!=null){
        userInfo.addAll(updatedUserInfo);
        storeMapInSharedPref(userInfo);
      } else {
        storeMapInSharedPref(updatedUserInfo);
      }

      final response = tokenStatus.isAccessTokenExpired();
      // if(response){
      //   final userId = sharedPreferenceHelper.getInt(userIdKey);
      //   RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
      //   RefreshTokenRequestModel requestModel =
      //   RefreshTokenRequestModel(userId: userId?.toString() ?? "");
      //   final result =
      //   await refreshTokenUseCase.call(requestModel, responseModel);
      //   result.fold((l) {
      //     state = state.copyWith(loading: false);
      //   }, (right) async {
      //     final res = right as RefreshTokenResponseModel;
      //     sharedPreferenceHelper.setString(
      //         tokenKey, res.data?.accessToken ?? "");
      //     sharedPreferenceHelper.setString(
      //         refreshTokenKey, res.data?.refreshToken ?? "");
      //
      //     OnboardingUserInterestsRequestModel onboardingUserInterestsRequestModel =
      //     OnboardingUserInterestsRequestModel(interestIds: interestIds);
      //     OnboardingUserInterestsResponseModel
      //     onboardingUserInterestsResponseModel =
      //     OnboardingUserInterestsResponseModel();
      //     final r = await onboardingUserInterestsUseCase.call(
      //         onboardingUserInterestsRequestModel,
      //         onboardingUserInterestsResponseModel);
      //     r.fold((l) {
      //       debugPrint('update onboarding user interests fold exception : $l');
      //     }, (r) async {
      //       final result = r as OnboardingUserInterestsResponseModel;
      //     });
      //   });
      // } else {
      //   OnboardingUserInterestsRequestModel onboardingUserInterestsRequestModel =
      //   OnboardingUserInterestsRequestModel(interestIds: interestIds);
      //   OnboardingUserInterestsResponseModel
      //   onboardingUserInterestsResponseModel =
      //   OnboardingUserInterestsResponseModel();
      //   final r = await onboardingUserInterestsUseCase.call(
      //       onboardingUserInterestsRequestModel,
      //       onboardingUserInterestsResponseModel);
      //   r.fold((l) {
      //     debugPrint('update onboarding user interests fold exception : $l');
      //   }, (r) async {
      //     final result = r as OnboardingUserInterestsResponseModel;
      //   });
      // }
    } catch (error) {
      debugPrint('update onboarding user interests exception : $error');
    }
  }

  Future<void> updateOnboardingSuccess() async {
    sharedPreferenceHelper.setString(onboardingKey, "true");
    //Todo - Stopped API Call
    // try{
    //   final response = tokenStatus.isAccessTokenExpired();
    //   if(response){
    //     final userId = sharedPreferenceHelper.getInt(userIdKey);
    //     RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
    //     RefreshTokenRequestModel requestModel =
    //     RefreshTokenRequestModel(userId: userId?.toString() ?? "");
    //     final result =
    //     await refreshTokenUseCase.call(requestModel, responseModel);
    //     result.fold((l) {
    //       state = state.copyWith(loading: false);
    //     }, (right) async {
    //       final res = right as RefreshTokenResponseModel;
    //       sharedPreferenceHelper.setString(
    //           tokenKey, res.data?.accessToken ?? "");
    //       sharedPreferenceHelper.setString(
    //           refreshTokenKey, res.data?.refreshToken ?? "");
    //       EmptyRequest requestModel = EmptyRequest();
    //       OnboardingCompleteResponseModel responseModel = OnboardingCompleteResponseModel();
    //       final r = await onboardingCompleteUseCase.call(requestModel, responseModel);
    //       r.fold((l) {
    //         debugPrint('onboarding complete fold exception : $l');
    //       }, (r) async {
    //         final result = r as OnboardingCompleteResponseModel;
    //       });
    //     });
    //   } else {
    //     EmptyRequest requestModel = EmptyRequest();
    //     OnboardingCompleteResponseModel responseModel = OnboardingCompleteResponseModel();
    //     final r = await onboardingCompleteUseCase.call(requestModel, responseModel);
    //     r.fold((l) {
    //       debugPrint('onboarding complete fold exception : $l');
    //     }, (r) async {
    //       final result = r as OnboardingCompleteResponseModel;
    //     });
    //   }
    // } catch(error){
    //   debugPrint('onboarding complete exception : $error');
    // }
  }

  bool isAllOptionFieldsCompleted() {
    bool martialStatusFilled =
    (!state.isSingle && !state.isForTwo && !state.isWithFamily);
    bool cityFilled = state.resident == null;
    return martialStatusFilled || cityFilled;
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
    await updateOnboardingSuccess();
    Future.delayed(const Duration(seconds: 2), () {
      callBack();
    });
  }

  Future<void> getInterests() async {
    try {
      state = state.copyWith(loading: true);

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
        state = state.copyWith(loading: false, interests: interests);
      });
    } catch (error) {
      debugPrint('get interests exception : $error');
      state = state.copyWith(loading: false);
    }
  }

  void updateInterestMap(int? id) {
    if(id!=null){
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

  Future<void> storeMapInSharedPref(Map<String, dynamic> data) async {
    final jsonString = jsonEncode(data);
    await sharedPreferenceHelper.setString(onboardingDataKey, jsonString);
  }

  Future<Map<String, dynamic>?> getMapFromSharedPref() async {
    final jsonString = sharedPreferenceHelper.getString(onboardingDataKey);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }
}

enum OnBoardingType { resident, tourist }

enum OnBoardingFamilyType { single, withTwo, withMyFamily }

enum OnBoardingCompanionType { withDog, barrierearm }
