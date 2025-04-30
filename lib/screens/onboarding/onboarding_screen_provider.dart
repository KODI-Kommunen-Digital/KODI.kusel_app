import 'dart:async';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Demographics_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Interests_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_type_request_model.dart';
import 'package:domain/model/response_model/get_interests/get_interests_response_model.dart';
import 'package:domain/usecase/get_interests/get_interests_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_interests_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_state.dart';
import 'package:domain/usecase/onboarding/onboarding_user_type_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_demographics_usecase.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_type_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_demographics_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_interests_response_model.dart';
import 'package:domain/model/request_model/city_details/get_city_details_request_model.dart';
import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';
import 'package:domain/usecase/city_details/get_city_details_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_complete_usecase.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_complete_response_model.dart';

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
            ref.read(onboardingCompleteUseCaseProvider))
);

class OnboardingScreenController extends StateNotifier<OnboardingScreenState> {
  OnboardingScreenController(
      {required this.onboardingUserTypeUseCase,
      required this.onboardingUserDemographicsUseCase,
      required this.onboardingUserInterestsUseCase,
      required this.getCityDetailsUseCase,
      required this.getInterestsUseCase,
        required this.onboardingCompleteUseCase
      })
      : super(OnboardingScreenState.empty());
  OnboardingUserTypeUseCase onboardingUserTypeUseCase;
  OnboardingUserDemographicsUseCase onboardingUserDemographicsUseCase;
  OnboardingUserInterestsUseCase onboardingUserInterestsUseCase;
  GetCityDetailsUseCase getCityDetailsUseCase;
  GetInterestsUseCase getInterestsUseCase;
  OnboardingCompleteUseCase onboardingCompleteUseCase;
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

  Future<void> updateOnboardingDetails(
      {required void Function() success}) async {

    if(!state.isTourist && !state.isResident) {
      try {
        String userType = state.isResident ? "citizen" : "tourist";
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
      } catch (error) {
        debugPrint('update onboarding user type exception : $error');
      }
    }

    if(isAllOptionFieldsCompleted()){
      try {
        String maritalStatus = state.isSingle
            ? "alone"
            : state.isForTwo
            ? "married"
            : "with_family";
        String accommodationPreference = state.isWithDog ? "dog" : "low_barrier";
        String cityName = state.resident ?? '';
        int cityId = getCityIdByName(state.cityDetailsMap, cityName) ?? 0;

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
          success();
        });
      } catch (error) {
        debugPrint('update onboarding user demographics exception : $error');
      }
    }

    try {
      Map<int, bool> interestSMap = state.interestsMap;
      List<int> interestIds = interestSMap.entries
          .where((interest) => interest.value)
          .map((interest) => interest.key)
          .toList();
      OnboardingUserInterestsRequestModel onboardingUserInterestsRequestModel =
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
        success();
      });
    } catch (error) {
      debugPrint('update onboarding user interests exception : $error');
    }
  }

  Future<void> updateOnboardingSuccess() async {
    try{
      EmptyRequest requestModel = EmptyRequest();
      OnboardingCompleteResponseModel responseModel = OnboardingCompleteResponseModel();
      final r = await onboardingCompleteUseCase.call(requestModel, responseModel);
      r.fold((l) {
        debugPrint('onboarding complete fold exception : $l');
      }, (r) async {
        final result = r as OnboardingCompleteResponseModel;
      });
    } catch(error){
      debugPrint('onboarding complete exception : $error');
    }
  }

  bool isAllOptionFieldsCompleted() {
    bool martialStatusFilled =
    (!state.isSingle && !state.isForTwo && !state.isWithFamily);

    bool accommodationPreferenceFilled =
    (!state.isWithDog && !state.isBarrierearm);
    bool cityFilled = state.resident == null;
    return martialStatusFilled || accommodationPreferenceFilled || cityFilled;
  }

  void updateCompanionType(OnBoardingCompanionType onBoardingCompanionType) {
    final isWithDogSelected =
        onBoardingCompanionType == OnBoardingCompanionType.withDog;
    final alreadySelected =
        isWithDogSelected ? state.isWithDog : state.isBarrierearm;

    state = state.copyWith(
      isWithDog: isWithDogSelected ? !alreadySelected : false,
      isBarrierearm: !isWithDogSelected ? !alreadySelected : false,
    );
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
    await updateOnboardingDetails(success: () {
      updateOnboardingSuccess();
    });
    Future.delayed(const Duration(seconds: 5), () {
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
}

enum OnBoardingType { resident, tourist }

enum OnBoardingFamilyType { single, withTwo, withMyFamily }

enum OnBoardingCompanionType { withDog, barrierearm }
