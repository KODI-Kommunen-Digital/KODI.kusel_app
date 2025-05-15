import 'package:domain/model/empty_request.dart';
import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';
import 'package:domain/model/response_model/municipality/municipality_response_model.dart';
import 'package:domain/model/request_model/municipality/municipility_request_model.dart';

import 'package:domain/model/response_model/mein_ort/mein_ort_response_model.dart';
import 'package:domain/usecase/mein_ort/mein_ort_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/mein_ort/mein_ort_state.dart';

import 'package:domain/usecase/municipality/municipality_usecase.dart';

final meinOrtProvider = StateNotifierProvider<MeinOrtProvider, MeinOrtState>(
    (ref) => MeinOrtProvider(
        meinOrtUseCase: ref.read(meinOrtUseCaseProvider),
        municipalityUseCase: ref.read(municipalityUseCaseProvider)));

class MeinOrtProvider extends StateNotifier<MeinOrtState> {
  MeinOrtUseCase meinOrtUseCase;
  MunicipalityUseCase municipalityUseCase;

  MeinOrtProvider(
      {required this.meinOrtUseCase, required this.municipalityUseCase})
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
}
