import 'package:core/base_model.dart';

class DigifitExerciseDetailsRequestModel
    extends BaseModel<DigifitExerciseDetailsRequestModel> {
  final String location;
  final int equipmentId;
  final String translate;

  DigifitExerciseDetailsRequestModel({
    required this.location,
    required this.equipmentId,
    required this.translate,
  });

  @override
  DigifitExerciseDetailsRequestModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseDetailsRequestModel(
      location: json['name'] ?? '',
      equipmentId: json['id'] ?? 0,
      translate: json['translate'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': location,
      'id': equipmentId,
      'translate': translate,
    };
  }
}
