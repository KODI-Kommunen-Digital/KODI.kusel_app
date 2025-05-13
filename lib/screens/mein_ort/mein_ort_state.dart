import 'package:domain/model/response_model/mein_ort/mein_ort_response_model.dart';

class MeinOrtState {
  final bool isLoading;
  final int highlightCount;
  final List<Municipality> municipalityList;
  final String description;

  MeinOrtState(this.isLoading, this.highlightCount, this.description,
      this.municipalityList);

  factory MeinOrtState.empty() {
    return MeinOrtState(false, 0, "", []);
  }

  MeinOrtState copyWith(
      {bool? isLoading,
      int? highlightCount,
      String? description,
      List<Municipality>? municipalityList}) {
    return MeinOrtState(
        isLoading ?? this.isLoading,
        highlightCount ?? this.highlightCount,
        description ?? this.description,
        municipalityList ?? this.municipalityList);
  }
}
