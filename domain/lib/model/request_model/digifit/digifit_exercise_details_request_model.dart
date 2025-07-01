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
      location: json['location'] ?? '',
      equipmentId: json['equipmentId'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'equipmentId': equipmentId,
    };
  }
}
