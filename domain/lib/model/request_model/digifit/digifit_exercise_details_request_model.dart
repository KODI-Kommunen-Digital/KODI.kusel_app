import 'package:core/base_model.dart';

class DigifitExerciseDetailsRequestModel
    extends BaseModel<DigifitExerciseDetailsRequestModel> {
  final int locationId;
  final int equipmentId;
  final String translate;

  DigifitExerciseDetailsRequestModel({
    required this.locationId,
    required this.equipmentId,
    required this.translate,
  });

  @override
  DigifitExerciseDetailsRequestModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseDetailsRequestModel(
      locationId: json['locationId'] ?? '',
      equipmentId: json['id'] ?? 0,
      translate: json['translate'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'locationId': locationId,
      'id': equipmentId,
      'translate': translate,
    };
  }
}
