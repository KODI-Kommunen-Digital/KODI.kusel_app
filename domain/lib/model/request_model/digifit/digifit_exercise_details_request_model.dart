import 'package:core/base_model.dart';

class DigifitExerciseDetailsRequestModel
    extends BaseModel<DigifitExerciseDetailsRequestModel> {
  final String location;
  final int equipmentId;

  DigifitExerciseDetailsRequestModel({
    required this.location,
    required this.equipmentId,
  });

  @override
  DigifitExerciseDetailsRequestModel fromJson(Map<String, dynamic> json) {
    return DigifitExerciseDetailsRequestModel(
      location: json['name'] ?? '',
      equipmentId: json['id'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': location,
      'id': equipmentId,
    };
  }
}
