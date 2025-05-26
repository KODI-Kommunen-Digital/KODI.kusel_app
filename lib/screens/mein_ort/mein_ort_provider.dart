import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/response_model/mein_ort/mein_ort_response_model.dart';
import 'package:domain/usecase/mein_ort/mein_ort_usecase.dart';
import 'package:domain/usecase/municipality/municipality_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/mein_ort/mein_ort_state.dart';

final meinOrtProvider = StateNotifierProvider<MeinOrtProvider, MeinOrtState>(
    (ref) => MeinOrtProvider(
        meinOrtUseCase: ref.read(meinOrtUseCaseProvider),
        municipalityUseCase: ref.read(municipalityUseCaseProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier)));

class MeinOrtProvider extends StateNotifier<MeinOrtState> {
  MeinOrtUseCase meinOrtUseCase;
  MunicipalityUseCase municipalityUseCase;
  SignInStatusController signInStatusController;

  MeinOrtProvider(
      {required this.meinOrtUseCase,
      required this.municipalityUseCase,
      required this.signInStatusController})
      : super(MeinOrtState.empty());

  updateCardIndex(int index) {
    state = state.copyWith(highlightCount: index);
  }

  Future<void> getMeinOrtDetails() async {
    try {
      state = state.copyWith(isLoading: true);

      EmptyRequest requestModel = EmptyRequest();

      MeinOrtResponseModel responseModel = MeinOrtResponseModel();

      final response = await meinOrtUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint("Mein ort fold exception = ${l.toString()}");
      }, (r) {
        final result = r as MeinOrtResponseModel;
        if (result.data != null) {
          state = state.copyWith(
            municipalityList: result.data,
            isLoading: false,
          );
        }
      });
    } catch (e) {
      debugPrint("Mein Ort exception = $e");
    }
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isUserLoggedIn: status);
  }

  void setIsFavoriteCity(bool isFavorite, int? id) {
    for (var municipality in state.municipalityList) {
      if (municipality.id == id) {
        municipality.isFavorite = isFavorite;
      }
      for(var city in municipality.topFiveCities ?? []) {
        if (city.id == id) {
        city.isFavorite = isFavorite;
      }
      }
    }
    state = state.copyWith(municipalityList: state.municipalityList);
  }
}
