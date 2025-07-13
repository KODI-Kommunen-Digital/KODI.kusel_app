import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_information_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_cache_data_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:kusel/database/boxes.dart';
import 'package:kusel/database/digifit_cache_data/digifit_cache_data_state.dart';
import 'package:kusel/database/digifit_cache_data/hive_data_keys.dart';
import 'package:kusel/database/hive_box.dart';
import 'package:domain/usecase/digifit/digifit_cache_data_usecase.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/providers/refresh_token_provider.dart';

final digifitCacheDataProvider = StateNotifierProvider<
        DigifitCacheDataController, DigifitCacheDataState>(
    (ref) => DigifitCacheDataController(
        hiveBoxFunctionHelper: ref.read(hiveBoxFunctionProvider),
        digifitCacheDataUseCase: ref.read(digifitCacheDataUseCaseProvider),
        refreshTokenProvider: ref.read(refreshTokenProvider),
        tokenStatus: ref.read(tokenStatusProvider),
        localeManagerController: ref.read(localeManagerProvider.notifier)));

class DigifitCacheDataController extends StateNotifier<DigifitCacheDataState> {
  final HiveBoxFunction hiveBoxFunctionHelper;
  final DigifitCacheDataUseCase digifitCacheDataUseCase;
  final RefreshTokenProvider refreshTokenProvider;
  final TokenStatus tokenStatus;
  final LocaleManagerController localeManagerController;

  DigifitCacheDataController(
      {required this.hiveBoxFunctionHelper,
      required this.digifitCacheDataUseCase,
      required this.refreshTokenProvider,
      required this.tokenStatus,
      required this.localeManagerController})
      : super(DigifitCacheDataState.empty());

  Future<void> fetchDigifitDataFromNetwork() async {
    try {
      state = state.copyWith(isLoading: true);

      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () {
              _fetchDigifitDataFromNetwork();
            });
      } else {
        // If the token is not expired, we can proceed with the request
        _fetchDigifitDataFromNetwork();
      }
    } catch (e) {
      debugPrint('[DigifitCacheDataController] Fetch Exception: $e');
    }
  }

  Future<void> _fetchDigifitDataFromNetwork() async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      DigifitInformationRequestModel digifitInformationRequestModel =
          DigifitInformationRequestModel(
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      DigifitCacheDataResponseModel digifitCacheDataResponseModel =
          DigifitCacheDataResponseModel();

      final result = await digifitCacheDataUseCase.call(
          digifitInformationRequestModel, digifitCacheDataResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: l.toString(),
          );
          debugPrint(
              '[DigifitInformationController] Fetch Error: ${l.toString()}');
        },
        (r) async {
          var response = (r as DigifitCacheDataResponseModel);
          state = state.copyWith(
              isLoading: false, digifitCacheDataResponseModel: response);
          await saveCacheData(state.digifitCacheDataResponseModel);
        },
      );
    } catch (error) {
      debugPrint('[DigifitInformationController] Fetch fold Exception: $error');
    }
  }

  Future<bool> isDigifitCacheDataAvailable() async {
    bool isDigifitCacheDataAvailable = false;
    if (!hiveBoxFunctionHelper.isBoxOpen(BoxesName.digifitCacheData.name)) {
      await hiveBoxFunctionHelper.openBox(BoxesName.digifitCacheData.name);
    }
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitCacheData.name);
    if (box != null) {
      isDigifitCacheDataAvailable = await hiveBoxFunctionHelper.containsKey(
          box, digifitCacheDataKey);
    }
    state = state.copyWith(isCacheDataAvailable: isDigifitCacheDataAvailable);
    return isDigifitCacheDataAvailable;
  }

  Future<void> saveCacheData(
      DigifitCacheDataResponseModel? digifitCacheDataResponseModel) async {
    if (!hiveBoxFunctionHelper.isBoxOpen(BoxesName.digifitCacheData.name)) {
      await hiveBoxFunctionHelper.openBox(BoxesName.digifitCacheData.name);
    }
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitCacheData.name);
    if (box != null) {
      await hiveBoxFunctionHelper.putValue(
          box, digifitCacheDataKey, digifitCacheDataResponseModel);
      state = state.copyWith(isCacheDataAvailable: true);
    }
  }

  Future<DigifitCacheDataResponseModel?> getCacheData() async {
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitCacheData.name);
    DigifitCacheDataResponseModel digifitCacheDataResponseModel =
        box?.get(digifitCacheDataKey);
    return digifitCacheDataResponseModel;
  }

  Future<void> removeCacheData() async {
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitCacheData.name);
    if (box != null) {
      await hiveBoxFunctionHelper.clearBox(box);
    }
  }
}
