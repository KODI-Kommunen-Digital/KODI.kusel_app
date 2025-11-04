import 'package:domain/model/request_model/digitfit_fav/digifit_fav_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_fav_response_model.dart';
import 'package:flutter/material.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/digifit_screens/digifit_fav_screen/digifit_fav_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/usecase/digifit/digifit_fav_usecase.dart';

import '../../../providers/digifit_equipment_fav_provider.dart';

final digifitFavControllerProvider = StateNotifierProvider.autoDispose<
    DigifitFavController,
    DigifitFavScreenState>(
        (ref) =>
        DigifitFavController(
            digifitFavUseCase: ref.read(digifitFavUseCaseProvider),
            localeManagerController: ref.read(localeManagerProvider.notifier),
            digifitEquipmentFav: ref.read(digifitEquipmentFavProvider)));

class DigifitFavController extends StateNotifier<DigifitFavScreenState> {
  DigifitFavUseCase digifitFavUseCase;
  LocaleManagerController localeManagerController;

  final DigifitEquipmentFav digifitEquipmentFav;

  DigifitFavController({required this.digifitFavUseCase,
    required this.localeManagerController,
    required this.digifitEquipmentFav})
      : super(DigifitFavScreenState.empty());

  getDigifitFavList() async {
    try {
      state = state.copyWith(isLoading: true);

      Locale currentLocale = localeManagerController.getSelectedLocale();

      final translate =
          "${currentLocale.languageCode}-${currentLocale.countryCode}";
      DigifitFavRequestModel requestModel =
      DigifitFavRequestModel(translate: translate);

      DigifitFavResponseModel responseModel = DigifitFavResponseModel();

      final res = await digifitFavUseCase.call(requestModel, responseModel);

      res.fold((l) {
        debugPrint('digifit fav exception: $l');
        state = state.copyWith(isLoading: false);
      }, (r) {
        final res = r as DigifitFavResponseModel;

        if (res.data != null) {
          state = state.copyWith(equipmentList: res.data, isLoading: false);
          return;
        }

        state = state.copyWith(isLoading: false);
      });
    } catch (e) {
      debugPrint('digifit fav exception: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  changeFav(DigifitEquipmentFavParams params) async {
    try {
       await digifitEquipmentFav.changeEquipmentFavStatus(
          onFavStatusChange:(status,params)async{
            await getDigifitFavList();
          } , params: params);
    } catch (e) {
      debugPrint('change fav exception : $e');
    }
  }
}
