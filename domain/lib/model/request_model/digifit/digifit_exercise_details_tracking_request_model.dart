import 'package:core/base_model.dart';

class DigifitExerciseDetailsTrackingRequestModel
    extends BaseModel<DigifitExerciseDetailsTrackingRequestModel> {
  final int equipmentId;
  final int locationId;
  final int setNumber;
  final int reps;

  DigifitExerciseDetailsTrackingRequestModel({
    this.equipmentId = 0,
    this.locationId = 0,
    this.setNumber = 0,
    this.reps = 0,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'equipmentId': equipmentId,
      'locationId': locationId,
      'setNumber': setNumber,
      'reps': reps,
    };
  }

  @override
  DigifitExerciseDetailsTrackingRequestModel fromJson(
      Map<String, dynamic> json) {
    return DigifitExerciseDetailsTrackingRequestModel(
      equipmentId: json['equipmentId'] ?? 0,
      locationId: json['locationId'] ?? 0,
      setNumber: json['setNumber'] ?? 0,
      reps: json['reps'] ?? 0,
    );
  }
}
