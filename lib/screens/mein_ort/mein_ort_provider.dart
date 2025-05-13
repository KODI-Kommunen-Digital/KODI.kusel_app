import 'package:domain/model/empty_request.dart';
import 'package:domain/model/response_model/mein_ort/mein_ort_response_model.dart';
import 'package:domain/usecase/mein_ort/mein_ort_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/mein_ort/mein_ort_state.dart';

final meinOrtProvider = StateNotifierProvider<MeinOrtProvider, MeinOrtState>(
    (ref) => MeinOrtProvider(
          meinOrtUseCase: ref.read(meinOrtUseCaseProvider),
        ));

class MeinOrtProvider extends StateNotifier<MeinOrtState> {
  MeinOrtUseCase meinOrtUseCase;

  MeinOrtProvider({required this.meinOrtUseCase}) : super(MeinOrtState.empty());

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
            // cityName : result.data?.name,
            // cityId : result.data?.id.toString(),
            // imageUrl : result.data?.image,
            // description : result.data?.description ,
            // address : result.data?.address,
            // latitude : double.parse(result.data?.latitude ?? ''),
            // longitude : double.parse(result.data?.longitude ?? ''),
            // phoneNumber : result.data?.phone,
            // email : result.data?.email,
            // openUntil : result.data?.openUntil,
            // websiteUrl: result.data?.websiteUrl,
            // onlineServiceList : result.data?.onlineServices,
            // municipalitiesList : result.data?.municipalities,
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
